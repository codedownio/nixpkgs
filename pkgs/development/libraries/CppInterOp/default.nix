{ lib
, cmake
, fetchFromGitHub
, git
, gtest
, llvmPackages_17
, ncurses
, stdenv
, zlib
}:

let
  # llvmSrcPatched = stdenv.mkDerivation rec {
  #   pname = "llvm-src-patched";
  #   version = "release-17.x";

  #   src = fetchFromGitHub {
  #     owner = "root-project";
  #     repo = "llvm-project";
  #     # release/17.x branch
  #     rev = "6009708b4367171ccdbf4b5905cb6a803753fe18";
  #     sha256 = "sha256-8MEDLLhocshmxoEBRSKlJ/GzJ8nfuzQ8qn0X/vLA+ag=";
  #   };

  #   patches = [
  #     ./clang17-1-NewOperator.patch
  #   ];

  #   buildPhase = ''
  #     echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAA
  #     exit 1
  #   '';

  #   dontInstall = true;
  #   dontCheck = true;
  #   dontFixup = true;
  # };

  llvmPackages = llvmPackages_17.override {
    # llvm = llvmPackages_17.llvm.override {
    #   patches = llvmPackages_17.llvm.patches ++ [
    #     ./clang17-1-NewOperator.patch
    #   ];
    # };

    # libclang = llvmPackages_17.libclang.override {
    #   patches = llvmPackages_17.libclang.patches ++ [
    #     ./clang17-1-NewOperator.patch
    #   ];
    # };
  };

in

stdenv.mkDerivation rec {
  pname = "CppInterOp";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "compiler-research";
    repo = "CppInterOp";
    rev = "v${version}";
    sha256 = "sha256-6A5NOr66ENgTpGzWeDbG+S3W4iwVMY7EyI/Oks6W5wk=";
  };
  # src = /home/tom/tools/CppInterOp;

  patches = [
    ./no-download-gtest.patch
  ];

  # preBuild = ''
  #   echo "GOT LLVM SRC: ${llvmSrcPatched}"
  # '';

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DUSE_CLING=Off"
    "-DUSE_REPL=ON"
    "-DLLVM_DIR=${llvmPackages.llvm.dev}/lib/cmake/llvm"
    "-DClang_DIR=${llvmPackages.libclang.dev}/lib/cmake/clang"
  ];

  nativeBuildInputs = [
    cmake
    git
    gtest
    ncurses
    zlib
  ];

  meta = with lib; {
    description = "A Clang-based C++ Interoperability Library";
    homepage = "https://github.com/compiler-research/CppInterOp";
    maintainers = with maintainers; [ thomasjm ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
