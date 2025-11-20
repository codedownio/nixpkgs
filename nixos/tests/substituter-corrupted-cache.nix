import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "substituter-corrupted-cache";
  meta.maintainers = with lib.maintainers; [ ];

  nodes = {
    # Machine B acts as the binary cache server
    cacheServer = { pkgs, ... }: {
      imports = [ ../modules/installer/cd-dvd/channel.nix ];
      
      environment.systemPackages = with pkgs; [
        nix-serve
        openssl
      ];

      # Configure nix-serve to act as a binary cache
      services.nix-serve = {
        enable = true;
        port = 5000;
        package = pkgs.nix-serve-ng;
        secretKeyFile = "/var/cache-key.sec";
      };

      networking.firewall.allowedTCPPorts = [ 5000 ];

      nix.extraOptions = ''
        experimental-features = nix-command
        secret-key-files = /var/cache-key.sec
      '';

      # Generate signing keys on startup
      systemd.services.generate-cache-keys = {
        description = "Generate cache signing keys";
        wantedBy = [ "multi-user.target" ];
        before = [ "nix-serve.service" ];
        script = ''
          if [ ! -f /var/cache-key.sec ]; then
            ${pkgs.nix}/bin/nix-store --generate-binary-cache-key cache.nixos.test /var/cache-key.sec /var/cache-key.pub
          fi
        '';
        serviceConfig.Type = "oneshot";
      };
    };

    # Machine A acts as the client that fetches from the cache
    client = { pkgs, ... }: {
      imports = [ ../modules/installer/cd-dvd/channel.nix ];
      
      environment.systemPackages = with pkgs; [
        curl
        openssl
      ];

      nix.extraOptions = ''
        experimental-features = nix-command
        # Disable signature checking for testing
        require-sigs = false
      '';

      networking.extraHosts = ''
        192.168.1.2 cacheserver
      '';
    };
  };

  testScript = ''
    # Start both machines
    start_all()

    # Wait for machines to be ready
    cacheServer.wait_for_unit("multi-user.target")
    client.wait_for_unit("multi-user.target")

    # Wait for nix-serve to be ready on cache server
    cacheServer.wait_for_unit("nix-serve.service")
    cacheServer.wait_for_open_port(5000)

    # Get the public key from cache server for later use
    pub_key = cacheServer.succeed("cat /var/cache-key.pub").strip()
    print(f"Cache server public key: {pub_key}")

    print("\\n--- Testing corrupted cache state scenarios ---")
    
    # Build a test package on the cache server
    print("Creating test package...")
    test_drv = cacheServer.succeed("""
      nix-build -E '
        derivation {
          name = "test-package-corrupt";
          system = builtins.currentSystem;
          builder = "/bin/sh";
          args = ["-c" "echo hello-corrupt > $out"];
        }
      ' --no-out-link
    """).strip()
    hello_path = test_drv
    print(f"Built test package at: {hello_path}")

    # Verify it can be served initially
    client.succeed(f"nix-store --realize {hello_path} --substituters http://cacheserver:5000 --trusted-substituters http://cacheserver:5000")
    client.succeed(f"test -e {hello_path}")
    print("Initial fetch successful")

    # Now simulate cache corruption scenario 1: Delete the store path but leave metadata
    print("\\n--- Scenario 1: Store path deleted but cache metadata remains ---")
    
    # Delete only from the cache server's store, but nix-serve metadata may still exist
    cacheServer.succeed(f"nix-store --delete {hello_path}")
    
    # Clear client's cache to force fresh lookup
    client.succeed("rm -rf /root/.cache/nix")
    client.succeed(f"nix-store --delete {hello_path}")
    
    # Try to fetch again - should expose metadata/content inconsistency
    print("Attempting to fetch after server-side deletion...")
    exit_code1, output1 = client.execute(f"nix-store --realize {hello_path} --substituters http://cacheserver:5000 --trusted-substituters http://cacheserver:5000 2>&1")
    
    print(f"Exit code: {exit_code1}")
    print(f"Output: {output1}")
    
    if "unexpected end-of-file" in output1 or "nar" in output1.lower() and "not exist" in output1:
        print("SUCCESS: Reproduced cache corruption issue!")
    elif "failed" in output1:
        print("Got cache failure - this demonstrates the metadata/content inconsistency")
    else:
        print("Unexpected result for corrupted cache test")

    # Scenario 2: Partial file corruption
    print("\\n--- Scenario 2: Testing partial file/network interruption simulation ---")
    
    # Rebuild the package
    test_drv2 = cacheServer.succeed("""
      nix-build -E '
        derivation {
          name = "test-package-partial";
          system = builtins.currentSystem;
          builder = "/bin/sh";
          args = ["-c" "echo hello-partial > $out"];
        }
      ' --no-out-link
    """).strip()
    hello_path2 = test_drv2
    
    # First successful fetch
    client.succeed(f"nix-store --realize {hello_path2} --substituters http://cacheserver:5000 --trusted-substituters http://cacheserver:5000")
    client.succeed(f"nix-store --delete {hello_path2}")
    
    # Simulate network interruption by stopping nix-serve temporarily
    print("Simulating network interruption during fetch...")
    cacheServer.succeed("systemctl stop nix-serve")
    
    # Try to fetch while service is down
    exit_code2, output2 = client.execute(f"timeout 10s nix-store --realize {hello_path2} --substituters http://cacheserver:5000 --trusted-substituters http://cacheserver:5000 2>&1")
    
    print(f"Network interruption test - Exit code: {exit_code2}")
    print(f"Network interruption test - Output: {output2}")
    
    if "connection refused" in output2.lower() or "timeout" in output2.lower() or "failed" in output2:
        print("Expected failure due to service interruption")
    else:
        print("Unexpected behavior during network interruption")
    
    # Restart service
    cacheServer.succeed("systemctl start nix-serve")
    cacheServer.wait_for_open_port(5000)
    
    # Test if cached failure state persists (potential for end-of-file issues)
    print("Testing fetch after service recovery...")
    exit_code3, output3 = client.execute(f"nix-store --realize {hello_path2} --substituters http://cacheserver:5000 --trusted-substituters http://cacheserver:5000 2>&1")
    
    print(f"Recovery test - Exit code: {exit_code3}")
    print(f"Recovery test - Output: {output3}")
    
    if "unexpected end-of-file" in output3:
        print("SUCCESS: Reproduced 'unexpected end-of-file' error after network recovery!")
    elif exit_code3 == 0:
        print("Successfully recovered - no cached failure state")
    else:
        print("Got different error after recovery")

    print("\\nCorrupted cache test completed. Look for 'unexpected end-of-file' errors or cache inconsistency issues.")
  '';
})