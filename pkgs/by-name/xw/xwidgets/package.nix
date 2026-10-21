{
  cmake,
  doctest,
  fetchFromGitHub,
  lib,
  libuuid,
  nix-update-script,
  nlohmann_json_schema_validator,
  stdenv,
  xeus,
  xproperty,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xwidgets";

  # The latest is 0.31, but 0.30 changed get_widget_target() to return a
  # `const xeus::xtarget*`, which only matches xeus 6.x's xcomm constructor.
  # 0.29.3 is the newest release that builds against the xeus 5.x in Nixpkgs.
  version = "0.29.3";

  src = fetchFromGitHub {
    owner = "jupyter-xeus";
    repo = "xwidgets";
    tag = finalAttrs.version;
    hash = "sha256-/sjeUjcjzXS/lUSFDD9zm7LkMJwnJAr5uYpCysEGVrQ=";
  };

  nativeBuildInputs = [ cmake ];

  # xeusConfig.cmake does find_dependency(LibUUID), which xeus does not propagate.
  buildInputs = [ libuuid ];

  nativeCheckInputs = [
    doctest
    nlohmann_json_schema_validator
  ];

  # Both are linked PUBLIC, and xwidgetsConfig.cmake find_dependency()s them.
  propagatedBuildInputs = [
    xeus
    xproperty
  ];

  cmakeFlags = [
    # The static library is over three times the size of the shared one.
    (lib.cmakeBool "XWIDGETS_BUILD_STATIC_LIBS" false)
    (lib.cmakeBool "XWIDGETS_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C++ backend for Jupyter interactive widgets";
    homepage = "https://github.com/jupyter-xeus/xwidgets";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ thomasjm ];
    platforms = lib.platforms.all;
  };
})
