{ cargo
, fetchFromGitHub
, git
, runCommand
, stdenv
}:

let
  index = stdenv.mkDerivation {
    pname = "crates.io-index";
    version = "b3649352c64264ccb543db2764c13173f50a299e";

    src = fetchFromGitHub {
      owner = "rust-lang";
      repo = "crates.io-index";
      rev = "b3649352c64264ccb543db2764c13173f50a299e";
      sha256 = "03mwlhjkhhbn3g27wi5vl195mvqm037w98nvx4pvfswm2svsyijd";
    };

    dontConfigure = true;

    buildInputs = [git];
    buildPhase = ''
      mkdir -p $out
      mv ./* $out/

      cd $out
      git init
      git add . -f
      git config user.email "julia2nix@localhost"
      git config user.name "julia2nix"
      git commit -m "Dummy commit"
    '';

    dontInstall = true;
    dontFixup = true;
  };

  cargoToml = ''
    [package]
    name = "rust_test"
    version = "0.1.0"
    edition = "2018"

    [dependencies]
    # rand = "0.8"
    rand = { version = "0.8", registry = "my-registry"}
  '';

in

runCommand "Cargo.lock" { buildInputs = [cargo]; } ''
  mkdir home
  export HOME=$(pwd)/home

  mkdir -p $HOME/.cargo
  echo "[registries]" >> $HOME/.cargo/config.toml
  echo "my-registry = { index = \"file://${index}\" }" >> $HOME/.cargo/config.toml

  echo "HERE IT IS:"
  cat $HOME/.cargo/config.toml

  mkdir src
  touch src/lib.rs

  echo '${cargoToml}' > ./Cargo.toml
  cat Cargo.toml
  cargo generate-lockfile

  mv Cargo.lock $out
''
