import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "substituter-cache-invalidation";

  nodes = {
    cacheServer = { pkgs, ... }: {
      imports = [ ../modules/installer/cd-dvd/channel.nix ];

      environment.systemPackages = with pkgs; [
        nix-serve
        openssl
      ];

      nix.package = pkgs.nixVersions.nix_2_11;

      # Configure nix-serve to act as a binary cache
      services.nix-serve = {
        enable = true;
        port = 5000;
        # package = pkgs.nix-serve-ng;
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

    client = { pkgs, ... }: {
      imports = [ ../modules/installer/cd-dvd/channel.nix ];

      environment.systemPackages = with pkgs; [
        curl
        openssl
      ];

      nix.package = pkgs.nixVersions.nix_2_11;

      nix.extraOptions = ''
        experimental-features = nix-command
        # Initially allow unsigned substitutes for testing
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
    print("Creating a simple test derivation...")
    # Create a simple derivation to test with
    test_drv = cacheServer.succeed("""
      nix-build -E '
        derivation {
          name = "test-package";
          system = builtins.currentSystem;
          builder = "/bin/sh";
          args = ["-c" "echo hello > $out"];
        }
      ' --no-out-link
    """).strip()
    hello_path = test_drv
    print(f"Built test package at: {hello_path}")

    # Verify the cache server has the path and can serve it
    cache_info = cacheServer.succeed("curl -s http://localhost:5000/nix-cache-info")
    print(f"Cache info: {cache_info}")

    # Get the store path hash for narinfo lookup
    store_hash = hello_path.split("/")[3].split("-")[0]
    narinfo_url = f"http://cacheserver:5000/{store_hash}.narinfo"

    # Test that client can fetch from cache server initially
    print("Testing initial substitution from cache server...")
    client.succeed(f"nix-store --realize {hello_path} --substituters http://cacheserver:5000 --trusted-substituters http://cacheserver:5000")

    # Verify the path exists on client
    client.succeed(f"test -e {hello_path}")
    print("Initial substitution successful")

    # Now simulate the problematic scenario:
    # 1. Delete the path from both machines
    print("Deleting hello path from both machines...")
    client.succeed(f"nix-store --delete {hello_path}")
    cacheServer.succeed(f"nix-store --delete {hello_path}")

    # Verify deletion
    client.fail(f"test -e {hello_path}")
    cacheServer.fail(f"test -e {hello_path}")

    # 2. Try to realize the path again on client - this should trigger the issue
    print("Attempting to realize deleted path - this may trigger the 'unexpected end-of-file' error...")

    # This should fail, but we want to catch the specific error
    exit_code, output = client.execute(f"nix-store --realize {hello_path} --substituters http://cacheserver:5000 --trusted-substituters http://cacheserver:5000 2>&1")

    print(f"Exit code: {exit_code}")
    print(f"Output: {output}")

    # Check if we get the expected error
    if "unexpected end-of-file" in output:
        print("SUCCESS: Reproduced the 'unexpected end-of-file' error!")
    elif "path is not available" in output or "substituter failed" in output:
        print("Got expected substituter failure, but not the specific end-of-file error")
    else:
        print("Unexpected result - the path may have been fetched successfully or failed differently")
  '';
})
