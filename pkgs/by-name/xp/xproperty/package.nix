{
  cmake,
  doctest,
  fetchFromGitHub,
  lib,
  nix-update-script,
  nlohmann_json,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xproperty";

  # The latest is 0.13, but it drops the CRTP from xobserved (`xobserved<D>`
  # becomes plain `xobserved`). The only consumers that follow that change are
  # xwidgets 0.30+, which need xeus 6.x, so keep 0.12 until xeus is bumped.
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "jupyter-xeus";
    repo = "xproperty";
    tag = finalAttrs.version;
    hash = "sha256-FCv6gG8hqJ6hJ/y9+aCEkxTdtPCC3gXStoKAgkHOgXQ=";
  };

  nativeBuildInputs = [ cmake ];

  nativeCheckInputs = [ doctest ];

  # Header-only, and xpropertyConfig.cmake does find_dependency(nlohmann_json).
  propagatedBuildInputs = [ nlohmann_json ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  # The test suite has no add_test(), only a custom target that runs the binary.
  checkTarget = "xtest";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C++ properties and observer pattern";
    homepage = "https://github.com/jupyter-xeus/xproperty";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ thomasjm ];
    platforms = lib.platforms.all;
  };
})
