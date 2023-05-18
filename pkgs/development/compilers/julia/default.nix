{ callPackage
, fetchFromGitHub
, runCommand
}:

let
  juliaWithPackages = callPackage ../../julia-modules {};

  wrapJulia = julia: julia.overrideAttrs (oldAttrs: {
    passthru = (oldAttrs.passthru or {}) // {
      withPackages = juliaWithPackages.override { inherit julia; };

      # For preindexing SymbolServer.jl symbols
      symbolIndices = packageNames: callPackage ../../julia-modules/indexing {
        julia = (juliaWithPackages.override {
          packageOverrides = {
            # Specially modified version of SymbolServer, which improved API and performance
            "SymbolServer" = fetchFromGitHub {
              owner = "codedownio";
              repo = "SymbolServer.jl";
              rev = "cfe81ec7830e6d8881191b3af7b35f143e4cd3eb";
              sha256 = "YCefldfibbFl2TKwtvqNEwn1CFyCMWXWjZ47e6Nhh3w=";
            };
          };
        }) (packageNames ++ ["SymbolServer"]);
      };
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
