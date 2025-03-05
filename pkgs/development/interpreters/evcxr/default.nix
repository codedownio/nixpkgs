{
  cargo,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  rustPlatform,
  lib,
  stdenv,
  gcc,
  cmake,
  libiconv,
  CoreServices,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "evcxr";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "evcxr";
    repo = "evcxr";
    rev = "v${version}";
    sha256 = "sha256-8PjZFWUH76QrA8EI9Cx0sBCzocvSmnp84VD7Nv9QMc8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-hE/O6lHC0o+nrN4vaQ155Nn2gZscpfsZ6o7IDi/IEjI=";

  RUST_SRC_PATH = "${rustPlatform.rustLibSrc}";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    cmake
  ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    CoreServices
    Security
  ];

  # postPatch = ''
  #   substituteInPlace evcxr_jupyter/Cargo.toml \
  #     --replace-fail "[package]" ''$'cargo-features = ["edition2024"]\n[package]'

  #   substituteInPlace evcxr_runtime/Cargo.toml \
  #     --replace-fail "[package]" ''$'cargo-features = ["edition2024"]\n[package]'

  #   substituteInPlace evcxr_repl/Cargo.toml \
  #     --replace-fail "[package]" ''$'cargo-features = ["edition2024"]\n[package]'

  #   substituteInPlace evcxr/Cargo.toml \
  #     --replace-fail "[package]" ''$'cargo-features = ["edition2024"]\n[package]'

  #   substituteInPlace runtimes/evcxr_image/Cargo.toml \
  #     --replace-fail "[package]" ''$'cargo-features = ["edition2024"]\n[package]'

  #   substituteInPlace print_performance_info/Cargo.toml \
  #     --replace-fail "[package]" ''$'cargo-features = ["edition2024"]\n[package]'
  # '';

  # buildFeatures = ["edition2024"];

  cargoFlags = [
    "-Z" "unstable-options"
    "-Z" "allow-features=edition2024"
  ];

  cargoBuildFlags = [
    "-Z" "allow-features=edition2024"
  ];

  checkFlags = [
    # test broken with rust 1.69:
    # * https://github.com/evcxr/evcxr/issues/294
    # * https://github.com/NixOS/nixpkgs/issues/229524
    "--skip=check_for_errors"
  ];

  postInstall =
    let
      wrap = exe: ''
        wrapProgram $out/bin/${exe} \
          --prefix PATH : ${
            lib.makeBinPath [
              cargo
              gcc
            ]
          } \
          --set-default RUST_SRC_PATH "$RUST_SRC_PATH"
      '';
    in
    ''
      ${wrap "evcxr"}
      ${wrap "evcxr_jupyter"}
      rm $out/bin/testing_runtime
    '';

  meta = with lib; {
    description = "Evaluation context for Rust";
    homepage = "https://github.com/google/evcxr";
    license = licenses.asl20;
    maintainers = with maintainers; [
      protoben
      ma27
    ];
    mainProgram = "evcxr";
  };
}
