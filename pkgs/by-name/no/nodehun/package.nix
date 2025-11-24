{
  buildNpmPackage,
  cctools,
  fetchFromGitHub,
  lib,
  node-gyp,
  nodejs,
  python3,
  stdenv,
}:

buildNpmPackage {
  pname = "nodehun";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "Wulf";
    repo = "nodehun";
    rev = "63ab4e441b0864f0bf2fb257a108d9b029a7ae9e";
    hash = "sha256-gIKkPvQn310dl6JNonmNHsfO5/DEUzEhpMBla4zS4CY=";
  };

  npmDepsHash = "sha256-Dju67cL5/Q5TcStvON5Kfx9rDX61ClhBwIXVacWDnUc=";
  nativeBuildInputs = [
    node-gyp
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools ];

  postInstall = ''
    # Only keep the necessary parts of build/Release to reduce closure size
    cd $out/lib/node_modules/nodehun
    mv build build_old
    mkdir build
    cp -r build_old/Release build/
    rm -rf build_old
    rm -rf build/Release/.deps

    # Remove a development script to eliminate runtime dependency on node
    rm node_modules/node-addon-api/tools/conversion.js

    # Remove dangling symlinks
    rm -rf $out/lib/node_modules/nodehun/node_modules/.bin
  '';

  doInstallCheck = true;
  nativeCheckInputs = [ nodejs ];
  postInstallCheck = ''
    # Smoke check: require() works
    export NODE_PATH=$out/lib/node_modules
    echo 'require("nodehun")' | node -
  '';

  disallowedReferences = [ nodejs ];

  meta = with lib; {
    description = "Hunspell binding for NodeJS that exposes as much of Hunspell as possible and also adds new features";
    homepage = "https://github.com/Wulf/nodehun";
    license = licenses.mit;
    maintainers = [ maintainers.thomasjm ];
  };
}
