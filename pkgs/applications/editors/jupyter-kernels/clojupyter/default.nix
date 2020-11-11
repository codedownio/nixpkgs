{ stdenv, fetchFromGitHub, leiningen, clojure, git, makeWrapper, jdk, jre, strip-nondeterminism }:

stdenv.mkDerivation rec {
  pname = "clojupyter";
  version = "0.3.2";

  outputHash = "136r6mr231d9wk86q1795wjcd1kw234f8j298c8pfyf4h262sywj";
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";

  src = fetchFromGitHub {
    owner = "clojupyter";
    repo = "clojupyter";
    rev = "49b9a41baf7ab284944892ea40939e5e53e6c38e";
    sha256 = "1wphc7h74qlm9bcv5f95qhq1rq9gmcm5hvjblb01vffx996vr6jz";
  };

  configurePhase = "export HOME=$TMP";

  buildInputs = [ leiningen jdk clojure git strip-nondeterminism makeWrapper ];

  uberjar = "target/${pname}-${version}-standalone.jar";

  buildPhase = ''
    lein uberjar

    echo "Before strip-nondeterminism:"
    sha256sum "$uberjar"

    ${strip-nondeterminism}/bin/strip-nondeterminism -t jar "$uberjar"

    echo "After strip-nondeterminism:"
    sha256sum "$uberjar"
  '';

  installPhase = ''
    mkdir -p $out/share/clojupyter
    cp "$uberjar" $out/share/clojupyter
  '';

  # doCheck = false;

  meta = with stdenv.lib; {
    description = "A Jupyter kernel for Clojure";
    homepage = https://github.com/clojupyter/clojupyter;
    license = licenses.mit;
    maintainers = [ maintainers.thomasjm ];
    platforms = jre.meta.platforms;
  };
}
