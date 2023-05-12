{ callPackage
, lib
, python3
, runCommand

, indexTransitiveDependencies ? true
}:

packageNames:

let
  julia = callPackage ../. {
    precompile = true;
    makeTransitiveDependenciesImportable = true;
  } (packageNames ++ ["SymbolServer"]);

  # juliaSymbolServer = callPackage ../. {} ["SymbolServer"];

  symbolStoreNix = runCommand "julia-indexes.nix" { buildInputs = [(python3.withPackages (ps: with ps; [toml pyyaml]))]; } ''
    indexpackage=$(find ${julia.projectAndDepot}/depot/packages/SymbolServer -name indexpackage.jl)
    symbolServerSource=$(dirname "$indexpackage")

    python ${./index_packages.py} \
      "${julia.dependencyUuidToInfoYaml}" \
      '${lib.generators.toJSON {} packageNames}' \
      '${lib.generators.toJSON {} indexTransitiveDependencies}' \
      "${julia}/bin/julia" \
      "$symbolServerSource" \
      "$out"
  '';

  uuidToSymbolStore = callPackage symbolStoreNix {
    inherit julia;
    indexpackage = ./indexpackage.jl;
  };

  combinedStore = runCommand "julia-combined-store" { buildInputs = [(python3.withPackages (ps: with ps; [toml]))]; } ''
    python ${./combine_indices.py} \
      "${uuidToSymbolStore}" \
      "$out"
  '';

in

combinedStore
