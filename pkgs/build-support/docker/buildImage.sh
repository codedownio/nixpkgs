
eval "$initialCommand"

# Print tar contents:
# 1: Interpreted as relative to the root directory
# 2: With no trailing slashes on directories
# This is useful for ensuring that the output matches the
# values generated by the "find" command
ls_tar() {
  for f in $(tar -tf $1 | xargs realpath -ms --relative-to=.); do
    if [[ "$f" != "." ]]; then
      echo "/$f"
    fi
  done
}

mkdir -p $out/image
touch baseFiles
if [[ -n "$fromImage" ]]; then
  echo "Linking base image layers ($fromImage)"
  for baseLayer in $(find $fromImage/image/ ! -path $fromImage/image/ -maxdepth 1 -type d -exec basename {} \;); do
    echo "Got layer: $baseLayer"
    ln -s $fromImage/image/$baseLayer $out/image/$baseLayer
  done
  cp $fromImage/image/repositories $out/image/repositories

  chmod a+w $out/image

  cat $fromImage/image/manifest.json  | jq -r '.[0].Layers | .[]' > layer-list

  if [[ -z "$fromImageName" ]]; then
    fromImageName=$(jshon -k < $out/image/repositories|head -n1)
  fi
  if [[ -z "$fromImageTag" ]]; then
    fromImageTag=$(jshon -e $fromImageName -k < $out/image/repositories | head -n1)
  fi
  parentID=$(jshon -e $fromImageName -e $fromImageTag -u < $out/image/repositories)

  echo "Gathering base files"
  for l in $out/image/*/layer.tar; do
    ls_tar $l >> baseFiles
  done
else
  touch layer-list
fi

chmod -R ug+rw $out/image

mkdir temp
cp ${layer}/* temp/
chmod ug+w temp/*

for dep in $(cat $layerClosure); do
  find $dep >> layerFiles
done

echo "Adding layer..."
# Record the contents of the tarball with ls_tar.
ls_tar temp/layer.tar >> baseFiles

# Append nix/store directory to the layer so that when the layer is loaded in the
# image /nix/store has read permissions for non-root users.
# nix/store is added only if the layer has /nix/store paths in it.
if [ $(wc -l < $layerClosure) -gt 1 ] && [ $(grep -c -e "^/nix/store$" baseFiles) -eq 0 ]; then
  mkdir -p nix/store
  chmod -R 555 nix
  echo "./nix" >> layerFiles
  echo "./nix/store" >> layerFiles
fi

# Get the files in the new layer which were *not* present in
# the old layer, and record them as newFiles.
comm <(sort -n baseFiles|uniq) \
     <(sort -n layerFiles|uniq|grep -v ${layer}) -1 -3 > newFiles
# Append the new files to the layer.
tar -rpf temp/layer.tar --hard-dereference --sort=name --mtime="@$SOURCE_DATE_EPOCH" \
    --owner=0 --group=0 --no-recursion --files-from newFiles

echo "Adding meta..."

# If we have a parentID, add it to the json metadata.
if [[ -n "$parentID" ]]; then
  cat temp/json | jshon -s "$parentID" -i parent > tmpjson
  mv tmpjson temp/json
fi

# Take the sha256 sum of the generated json and use it as the layer ID.
# Compute the size and add it to the json under the 'Size' field.
layerID=$(sha256sum temp/json|cut -d ' ' -f 1)
size=$(stat --printf="%s" temp/layer.tar)
cat temp/json | jshon -s "$layerID" -i id -n $size -i Size > tmpjson
mv tmpjson temp/json

# Use the temp folder we've been working on to create a new image.
mv temp $out/image/$layerID

# Add the new layer ID to the beginning of the layer list
(
  # originally this used `sed -i "1i$layerID" layer-list`, but
  # would fail if layer-list was completely empty.
  echo "$layerID/layer.tar"
  cat layer-list
) | sponge layer-list

# Create image json and image manifest
imageJson=$(cat ${baseJson} | jq ". + {\"rootfs\": {\"diff_ids\": [], \"type\": \"layers\"}}")
manifestJson=$(jq -n "[{\"RepoTags\":[\"$imageName:$imageTag\"]}]")

for layerTar in $(tac ./layer-list); do
  echo "Summing layer $layerTar"
  layerChecksum=$(sha256sum $out/image/$layerTar | cut -d ' ' -f1)
  imageJson=$(echo "$imageJson" | jq ".history |= [{\"created\": \"$(jq -r .created ${baseJson})\"}] + .")
  imageJson=$(echo "$imageJson" | jq ".rootfs.diff_ids |= [\"sha256:$layerChecksum\"] + .")
  manifestJson=$(echo "$manifestJson" | jq ".[0].Layers |= [\"$layerTar\"] + .")
done

imageJsonChecksum=$(echo "$imageJson" | sha256sum | cut -d ' ' -f1)
echo "$imageJson" > "$out/image/$imageJsonChecksum.json"
manifestJson=$(echo "$manifestJson" | jq ".[0].Config = \"$imageJsonChecksum.json\"")
echo "$manifestJson" > $out/image/manifest.json

# Store the json under the name image/repositories.
jshon -n object \
      -n object -s "$layerID" -i "$imageTag" \
      -i "$imageName" > $out/image/repositories

# Make the image read-only.
chmod -R a-w $out/image

echo "Finished."
