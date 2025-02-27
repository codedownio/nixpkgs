{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
}:

let
  minorVersion = "4.29";
  patchVersion = "0";

in
stdenv.mkDerivation rec {
  pname = "selenium-server";
  version = "${minorVersion}.${patchVersion}";

  src = fetchurl {
    url = "https://github.com/SeleniumHQ/selenium/releases/download/selenium-${version}/selenium-server-${version}.jar";
    hash = "sha256-og3RlPbRU7Mj5F+QJ1cU3klbXSLxWH4ZcNjgphHBkMU=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    mkdir -p $out/share/lib/${pname}-${version}
    cp $src $out/share/lib/${pname}-${version}/${pname}-${version}.jar
    makeWrapper ${jre}/bin/java $out/bin/selenium-server
  '';

  meta = with lib; {
    homepage = "https://www.selenium.dev";
    description = "A browser automation framework and ecosystem";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [
      thomasjm
    ];
    mainProgram = "selenium-server";
    platforms = platforms.all;
  };
}
