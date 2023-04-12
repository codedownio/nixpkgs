{ callPackage
, runCommand
}:

let
  juliaWithPackages = callPackage ../../julia-modules {};

  wrapJulia = julia: julia.overrideAttrs (oldAttrs: {
    passthru = (oldAttrs.passthru or {}) // {
      withPackages = juliaWithPackages.override { inherit julia; };

      # For preindexing SymbolServer.jl symbols
      symbolIndices = callPackage ../../julia-modules/indexing {};
      indexStdlib = runCommand "julia-index-stdlib" { buildInputs = [(juliaWithPackages ["SymbolServer"])]; } ''
        mkdir -p $out
        julia ${../../julia-modules/indexing/index-stdlib.jl}
      '';
    };
  });

in

{
  julia_16-bin = wrapJulia (callPackage ./1.6-bin.nix {});
  julia_18-bin = wrapJulia (callPackage ./1.8-bin.nix {});
  julia_18 = wrapJulia (callPackage ./1.8.nix {});
  julia_19 = wrapJulia (callPackage ./1.9.nix {});
}
