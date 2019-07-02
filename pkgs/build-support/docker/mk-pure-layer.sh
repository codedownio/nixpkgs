mkdir layer
if [[ -n "$contents" ]]; then
  echo "Adding contents..."
  for item in $contents; do
    echo "Adding $item"
    rsync $rsyncFlags -R --chown=${uid}:${gid} $item/ layer/

    # For every executable file in the contents, add a symlink in /bin/
    if [ -e $item/bin ]; then
        mkdir -p layer/bin
        current_dir=$(pwd)
        # Note the -mindepth 1 test, which ensure we don't get the $item/bin directory
        # (since directories can be executable)
        find $item/bin/ -mindepth 1 -executable -execdir ln -s $item/bin/{} $current_dir/layer/bin/{} \;
    fi
  done
else
  echo "No contents to add to layer."
fi

chmod ug+w layer

if [[ -n $extraCommands ]]; then
  (cd layer; eval "$extraCommands")
fi

# Tar up the layer and throw it into 'layer.tar'.
echo "Packing layer..."
mkdir $out
tar -C layer --hard-dereference --xform s:'^./':: --sort=name --mtime="@$SOURCE_DATE_EPOCH" -cf $out/layer.tar .

# Compute a checksum of the tarball.
echo "Computing layer checksum..."
tarhash=$(tarsum < $out/layer.tar)

# Add a 'checksum' field to the JSON, with the value set to the
# checksum of the tarball.
cat ${baseJson} | jshon -s "$tarhash" -i checksum > $out/json

# Indicate to docker that we're using schema version 1.0.
echo -n "1.0" > $out/VERSION

echo "Finished building layer '${name}'"
