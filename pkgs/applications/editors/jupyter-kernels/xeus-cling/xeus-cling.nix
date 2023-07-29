{ lib
, callPackage
, cmake
, fetchFromGitHub
, gcc
, git
, llvmPackages_9

, argparse
, cling
, cppzmq
, libuuid
, ncurses
, openssl
, pugixml
, xeus
, xeus-zmq
, xtl
, zeromq
, zlib
}:

llvmPackages_9.stdenv.mkDerivation rec {
  pname = "xeus-cling";
  version = "0.15.3";

  # src = fetchFromGitHub {
  #   owner = "QuantStack";
  #   repo = "xeus-cling";
  #   rev = "${version}";
  #   hash = "sha256-OfZU+z+p3/a36GntusBfwfFu3ssJW4Fu7SV3SMCoo1I=";
  # };

  src = /home/tom/tools/xeus-cling;

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    argparse
    cling.unwrapped
    cppzmq
    libuuid
    llvmPackages_9.llvm
    ncurses
    openssl
    pugixml
    xeus
    xeus-zmq
    xtl
    zeromq
    zlib
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Debug"
  ];

  dontStrip = true;

  meta = {
    description = "Jupyter kernel for the C++ programming language";
    homepage = "https://github.com/jupyter-xeus/xeus-cling";
    maintainers = with lib.maintainers; [ thomasjm ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
  };
}
