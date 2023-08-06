{ stdenv
, callPackage
, ghc
, ihaskell
, makeWrapper
, runCommand
}:

# To test:
# $(nix-build -E 'with import <nixpkgs> {}; jupyter.override { definitions = { ihaskell = ihaskell.definition; }; }')/bin/jupyter-notebook

let
  kernel = callPackage ./kernel.nix {
    python3Packages = python3.pkgs;
  };

in

rec {
  definition = {
    displayName = "IHaskell";
    argv = [
      "${ihaskell}/bin/ihaskell"
      "kernel"
      "{connection_file}"
      "-l" "${ghc.out}/lib/${ghc.meta.name}"
      "--html-code-wrapper-class" "cm-s-hite"
      "--html-code-token-prefix" ""
      "+RTS" "-M3g" "-N2" "-RTS"
    ];
    codemirror_mode = "haskell";
    logo32 = null;
    logo64 = null;
  };
}
