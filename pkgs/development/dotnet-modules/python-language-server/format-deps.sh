# Retrieve sha256 hashes for each dependency in and format fetchNuGet calls
echo "" > deps.nix
urlbase="https://www.nuget.org/api/v2/package"
cat << EOL
{ fetchurl }: let

  fetchNuGet = { name, version, sha256 }: fetchurl {
    inherit sha256;
    url = "$urlbase/\${name}/\${version}";
  };

in [
EOL
IFS=''
while read line; do
  name=$(echo $line | awk '{print $1}')
  version=$(echo $line | awk '{print $2}')
  sha256=$(nix-prefetch-url "$urlbase/$name/$version" 2>/dev/null)

  if [ -n "$sha256" ]; then
    cat << EOL

  (fetchNuGet {
    name = "$name";
    version = "$version";
    sha256 = "$sha256";
  })
EOL
  fi
done < $1
cat << EOL

]
EOL
