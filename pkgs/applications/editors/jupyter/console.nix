# Jupyter console with the given kernel definitions

{ python3
, jupyter-kernel
, lib
}:

let
  mkConsole = {
    definitions ? jupyter-kernel.default
    , kernel ? null
  }:
    let
      jupyterPath = (jupyter-kernel.create { inherit definitions; });
    in
      (python3.buildEnv.override {
        extraLibs = [python3.pkgs.jupyter_console];
        makeWrapperArgs = [
          "--set" "JUPYTER_PATH" "${jupyterPath}"
        ] ++ lib.optionals (kernel != null) [
          "--add-flags" "--kernel"
          "--add-flags" kernel
        ];
      }).overrideAttrs (oldAttrs: {
        # To facilitate running nix run .#jupyter-console
        pname = "jupyter-console";
      });

in

{
  # Build a console derivation with an arbitrary set of definitions, and an optional kernel to use.
  # If the kernel argument is not supplied, Jupyter console will pick a kernel to run from the ones
  # available on the system.
  inherit mkConsole;

  # An ergonomic way to start a console with a single kernel.
  withSingleKernel = definition:
    mkConsole {
      definitions = lib.listToAttrs [(lib.nameValuePair definition.language definition)];
      kernel = definition.language;
    };
}
