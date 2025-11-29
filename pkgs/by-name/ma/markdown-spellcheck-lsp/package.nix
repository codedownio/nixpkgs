{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  hunspellDicts,
  makeWrapper,
  nodejs,
  nodehun,
  runCommand,
}:

let
  unwrapped = buildNpmPackage (finalAttrs: {
    pname = "markdown-spellcheck-lsp-unwrapped";
    version = "0.6.1";

    src = fetchFromGitHub {
      owner = "codedownio";
      repo = "markdown-spellcheck-lsp";
      tag = "v${finalAttrs.version}";
      hash = "sha256-V+MSfhRV1DbnHLL8iJrPzoTPwe3U+J+RUeCule+WejQ=";
    };

    nativeBuildInputs = [ makeWrapper ];

    npmDepsHash = "sha256-N5cXp5qpaH16Ums2TsXM7tA38Tjby0rGGa7hWDkHdlo=";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib

      echo 'var nodehun = require("nodehun");' > $out/lib/index.js
      cat dist/index.js >> $out/lib/index.js

      mkdir $out/bin
      makeWrapper ${nodejs}/bin/node $out/bin/markdown-spellcheck-lsp \
        --set NODE_PATH ${nodehun}/lib/node_modules \
        --add-flags $out/lib/index.js

      runHook postInstall
    '';

    meta = {
      description = "Language Protocol Server for running spellcheck on Markdown";
      homepage = "https://github.com/codedownio/markdown-spellcheck-lsp";
      changelog = "https://github.com/codedownio/markdown-spellcheck-lsp/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ thomasjm ];
      platforms = lib.platforms.all;
      mainProgram = "markdown-spellcheck-lsp";
    };
  });

in

runCommand "markdown-spellcheck-lsp" {
  inherit (unwrapped) meta;
  nativeBuildInputs = [ makeWrapper ];
  passthru = {
    inherit unwrapped;
  };
} ''
  mkdir -p $out/bin
  makeWrapper ${unwrapped}/bin/markdown-spellcheck-lsp $out/bin/markdown-spellcheck-lsp \
    --add-flags "--affix-file ${hunspellDicts.en-us}/share/hunspell/en_US.aff" \
    --add-flags "--dic-file ${hunspellDicts.en-us}/share/hunspell/en_US.dic" \
    --add-flags "--personal-dic-file .codedown/personal-dictionary.dat"
''
