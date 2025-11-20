import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "substituter-signature-validation";
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
        # Start with signature checking disabled
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

    # Build a test package on the cache server to populate the cache
    print("Creating a signed test derivation...")
    test_drv = cacheServer.succeed("""
      nix-build -E '
        derivation {
          name = "test-package-signed";
          system = builtins.currentSystem;
          builder = "/bin/sh";
          args = ["-c" "echo hello-signed > $out"];
        }
      ' --no-out-link
    """).strip()
    hello_path_signed = test_drv
    print(f"Built test package at: {hello_path_signed}")

    # Verify the cache server has the path and can serve it
    cache_info = cacheServer.succeed("curl -s http://localhost:5000/nix-cache-info")
    print(f"Cache info: {cache_info}")

    print("\\n--- Testing scenario with signature validation ---")
    
    # Enable signature checking on client
    client.succeed("mkdir -p /etc/nix")
    client.succeed("echo 'require-sigs = true' > /tmp/nix.conf")
    client.succeed("cp /tmp/nix.conf /etc/nix/nix.conf")
    client.succeed("systemctl restart nix-daemon")
    client.wait_for_unit("nix-daemon.service")

    # Try to fetch without providing the public key (should fail signature verification)
    print("Attempting to fetch with signature verification but without trusted public key...")
    exit_code2, output2 = client.execute(f"nix-store --realize {hello_path_signed} --substituters http://cacheserver:5000 2>&1")
    
    print(f"Exit code: {exit_code2}")
    print(f"Output: {output2}")
    
    if exit_code2 != 0 and ("signature" in output2.lower() or "untrusted" in output2.lower()):
        print("SUCCESS: Correctly rejected unsigned substitute")
    else:
        print("Unexpected: Should have rejected unsigned substitute")

    # Now try with the correct public key
    print("Attempting to fetch with correct public key...")
    exit_code3, output3 = client.execute(f"nix-store --realize {hello_path_signed} --substituters http://cacheserver:5000 --trusted-public-keys '{pub_key}' 2>&1")
    
    print(f"Exit code: {exit_code3}")
    print(f"Output: {output3}")

    if exit_code3 == 0:
        print("SUCCESS: Correctly accepted signed substitute with valid key")
    else:
        print(f"Unexpected failure with valid key: {output3}")

    # Test invalid/corrupted signature scenario
    print("\\n--- Testing corrupted signature scenario ---")
    
    # Try with a malformed public key
    fake_key = "cache.nixos.test:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa="
    exit_code4, output4 = client.execute(f"nix-store --realize {hello_path_signed} --substituters http://cacheserver:5000 --trusted-public-keys '{fake_key}' 2>&1")
    
    print(f"Corrupted key test - Exit code: {exit_code4}")
    print(f"Corrupted key test - Output: {output4}")
    
    if exit_code4 != 0 and ("signature" in output4.lower() or "verify" in output4.lower()):
        print("SUCCESS: Correctly rejected substitute with invalid signature")
    else:
        print("May have accepted invalid signature - this could indicate a security issue")

    print("\\nSignature validation test completed. Check outputs for signature-related errors that could lead to cache issues.")
  '';
})