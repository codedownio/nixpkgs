{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gophernotes";
  version = "0-unstable-2023-11-03";

  src = fetchFromGitHub {
    owner = "gopherdata";
    repo = "gophernotes";
    rev = "55142043d19696ba037e3e93f9ec6c7f8436e82d";
    hash = "sha256-+crqbsZce2xVbXgb6pyXzpP/5eACkWG2T76TUsL1hKA=";
  };

  vendorHash = "sha256-atXnOGesbNtZ/XxlyXOXcGlZNl4D3svCRchdoylWhdQ=";

  # The vendored golang.org/x/tools v0.14.0 uses unsafe hacks in
  # internal/tokeninternal that are incompatible with Go 1.26+.
  # That package was removed from newer x/tools entirely.
  # Replace it with a minimal Go 1.21+ compatible version.
  preBuild = ''
    chmod -R u+w vendor/golang.org/x/tools/internal/tokeninternal
    cat > vendor/golang.org/x/tools/internal/tokeninternal/tokeninternal.go << 'PATCH'
    package tokeninternal

    import (
      "go/token"
    )

    func GetLines(file *token.File) []int {
      return file.Lines()
    }

    func AddExistingFiles(fset *token.FileSet, files []*token.File) {
      panic("tokeninternal.AddExistingFiles is not supported with Go 1.26+")
    }
    PATCH
  '';

  meta = {
    description = "Go kernel for Jupyter notebooks";
    homepage = "https://github.com/gopherdata/gophernotes";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.costrouc ];
    mainProgram = "gophernotes";
  };
})
