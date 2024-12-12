
import json
import os
import subprocess
import sys

disableCompression = json.loads(sys.argv[1])
narSuffix = ".nar" if disableCompression else ".nar.xz"

with open(os.environ["NIX_ATTRS_JSON_FILE"], "r") as f:
  closures = json.load(f)["closure"]

os.chdir(os.environ["out"])

nixPrefix = os.environ["NIX_STORE"] # Usually /nix/store

with open("nix-cache-info", "w") as f:
  f.write("StoreDir: " + nixPrefix + "\n")

def dropPrefix(path):
  return path[len(nixPrefix + "/"):]

for item in closures:
  narInfoHash = dropPrefix(item["path"]).split("-")[0]

  narFile = "nar/" + narInfoHash + narSuffix
  with open(narFile, "w") as f:
    command = "nix-store --dump %s" % item["path"]
    if not disableCompression:
      command += " | xz -c"
    subprocess.run(command, stdout=f, shell=True)

  fileHash = subprocess.run(["nix-hash", "--base32", "--type", "sha256", item["path"]], capture_output=True).stdout.decode().strip()
  fileSize = os.path.getsize(narFile)

  # Rename the .nar.xz file to its own hash to match "nix copy" behavior
  finalNarFile = "nar/" + fileHash + narSuffix
  os.rename(narFile, finalNarFile)

  with open(narInfoHash + ".narinfo", "w") as f:
    f.writelines((x + "\n" for x in [
      "StorePath: " + item["path"],
      "URL: " + finalNarFile,
      "Compression: xz",
      "FileHash: sha256:" + fileHash,
      "FileSize: " + str(fileSize),
      "NarHash: " + item["narHash"],
      "NarSize: " + str(item["narSize"]),
      "References: " + " ".join(dropPrefix(ref) for ref in item["references"]),
    ]))
