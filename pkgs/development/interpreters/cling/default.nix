{ clangStdenv,
  python,
  fetchFromGitHub,
  libffi,
  git,
  cmake,
  zlib,
  fetchgit,
  makeWrapper,
  runCommand,
  llvmPackages_5,
  callPackage,

  # Provide flags to Cling to prevent it from looking for system include paths,
  # and pass it the paths to glibc and the LLVM C++
  isolate ? true,

  # Produce a "standalone" version of Cling, suitable for running as an executable.
  # If set to false, the output will include extra files for using Cling as a library.
  standalone ? false
}:

let
  # For using cling as a library (i.e. with xeus-cling)
  clingFull = clangStdenv.mkDerivation rec {
    name = "cling";

    src = fetchgit {
      url = "http://root.cern.ch/git/clang.git";

      # This commit has the tag cling-0.7 so we use it, even though cpt.py
      # tries to use refs/tags/cling-patches-rrelease_50
      rev = "354b25b5d915ff3b1946479ad07f3f2768ea1621";
      branchName = "cling-patches";

      sha256 = "181xfci1r9bs8r9grj9wbgi95sy85dj2nc6ggw9yjlhx94d0412y";
      leaveDotGit = true;
      deepClone = true;
    };

    configurePhase = ''
      echo "add_llvm_external_project(cling)" >> tools/CMakeLists.txt
    '';

    clingSrc = fetchgit {
      url = "https://github.com/root-project/cling.git";
      rev = "70163975eee5a76b45a1ca4016bfafebc9b57e07";
      sha256 = "1zwnpxbqk6c0694sdmcxymivnpfc7hl2by6411n6vjxinavlpqz4";
    };

    buildInputs = [python git cmake libffi llvmPackages_5.llvm makeWrapper zlib];

    buildPhase = ''
      cp -r ${clingSrc} ./tools/cling
      mkdir dist
      mkdir build
      cd build

      # Note that -DCLING_INCLUDE_TESTS=ON causes the cling/tools targets to be built;
      # see cling/tools/CMakeLists.txt
      cmake .. \
        -DCMAKE_INSTALL_PREFIX=$out \
        -DCMAKE_BUILD_TYPE=Release \
        "-DLLVM_TARGETS_TO_BUILD=host;NVPTX" \
        -DLLVM_ENABLE_RTTI=ON \
        -DCLING_INCLUDE_TESTS=ON

      make -j8
    '';
  };

  # For using Cling as a standalone executable
  # (contains only the files in cling/tools/packaging/dist-files.txt)
  clingStandalone = runCommand "cling-standalone" {} ''
    cd ${clingFull}

    mkdir -p $out/bin
    cp -r bin/cling $out/bin

    mkdir -p $out/lib
    cp -r lib/clang $out/lib

    cp -r include $out

    mkdir -p $out/share
    cp -r share/cling $out/share
  '';

  baseCling = if standalone then clingStandalone else clingFull;

in

if isolate then
  runCommand (if standalone then "cling-standalone-isolated" else "cling-full-isolated") {
    buildInputs = [makeWrapper];
  } ''
    makeWrapper ${baseCling}/bin/cling $out/bin/cling \
      --add-flags "${clangStdenv.lib.concatStringsSep " " (callPackage ./flags.nix {cling = baseCling;})}"
  ''
else
  baseCling
