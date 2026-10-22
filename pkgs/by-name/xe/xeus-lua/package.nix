{
  cmake,
  cppzmq,
  fetchFromGitHub,
  lib,
  libuuid,
  lua5_4,
  nix-update-script,
  nlohmann_json,
  openssl,
  stdenv,
  versionCheckHook,
  xeus,
  xeus-zmq,
  xproperty,
  xtl,
  xwidgets,
  zeromq,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xeus-lua";

  # The latest is 0.9, but that requires xeus 6.x and xeus-zmq 4.x, which
  # Nixpkgs doesn't have yet.
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "jupyter-xeus";
    repo = "xeus-lua";
    tag = finalAttrs.version;
    hash = "sha256-HwYtcThbJd/jU0aQGZaef9qjryCiFr2iSiTXZBqDab0=";
  };

  # Both patches here go away when we upgrade to 0.9 (see above)
  patches = [
    ./xeus-zmq-1.3-header.patch
    ./no-double-execution.patch
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    cppzmq
    libuuid
    # Not `lua`: that is 5.5, which the sol2 copy vendored here does not support.
    lua5_4
    nlohmann_json
    openssl
    xeus
    xeus-zmq
    xproperty
    xtl
    xwidgets
    zeromq
  ];

  cmakeFlags = [
    (lib.cmakeBool "XLUA_WITH_XWIDGETS" true)
    # Off: xcanvas's widgets are drawn by the ipycanvas frontend, and the ipycanvas
    # in Nixpkgs ships no JupyterLab extension (only the classic-Notebook shim) and
    # is 0.14.3 where xcanvas asks for ^0.11.0 -- so nothing would render.
    (lib.cmakeBool "XLUA_WITH_XCANVAS" false)
    (lib.cmakeBool "XEUS_LUA_USE_LUAJIT" false)
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/xlua";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Jupyter kernel for the Lua programming language";
    homepage = "https://github.com/jupyter-xeus/xeus-lua";
    license = lib.licenses.bsd3;
    mainProgram = "xlua";
    maintainers = with lib.maintainers; [ thomasjm ];
    platforms = lib.platforms.unix;
  };
})
