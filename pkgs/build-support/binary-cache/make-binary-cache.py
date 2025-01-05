
import argparse
from functools import partial
import json
from multiprocessing import Pool
import os
import subprocess


def dropPrefix(path, nixPrefix):
  return path[len(nixPrefix + "/"):]

def processItem(item, nixPrefix, outDir, compression, compressionCommand, compressionExtension):
  os.chdir(outDir)

  narInfoHash = dropPrefix(item["path"], nixPrefix).split("-")[0]

  compressedFile = "nar/" + narInfoHash + ".nar" + compressionExtension
  with open(compressedFile, "w") as f:
    subprocess.run(("nix-store --dump %s" % item["path"]) + " " + compressionCommand, stdout=f, shell=True)

  fileHash = subprocess.run(
    ["nix-hash", "--base32", "--type", "sha256", item["path"]],
    capture_output=True
  ).stdout.decode().strip()
  fileSize = os.path.getsize(compressedFile)

  finalCompressedFile = "nar/" + fileHash + ".nar" + compressionExtension
  os.rename(compressedFile, finalCompressedFile)

  with open(narInfoHash + ".narinfo", "w") as f:
    f.writelines((x + "\n" for x in [
      "StorePath: " + item["path"],
      "URL: " + finalCompressedFile,
      "Compression: " + compression,
      "FileHash: sha256:" + fileHash,
      "FileSize: " + str(fileSize),
      "NarHash: " + item["narHash"],
      "NarSize: " + str(item["narSize"]),
      "References: " + " ".join(dropPrefix(ref, nixPrefix) for ref in item["references"]),
    ]))

def main():
  parser = argparse.ArgumentParser()
  parser.add_argument("--num-workers", type=int, default=4, help="Number of worker processes")
  parser.add_argument("--compression", type=str, help="Name for the Compression field of the .narinfo")
  parser.add_argument("--compression-command", type=str, help="Command to run for compression")
  parser.add_argument("--compression-extension", type=str, help="Extension for compressed file")
  args = parser.parse_args()

  with open(os.environ["NIX_ATTRS_JSON_FILE"], "r") as f:
    closures = json.load(f)["closure"]

  outDir = os.environ["out"]
  nixPrefix = os.environ["NIX_STORE"]

  os.chdir(outDir)
  os.makedirs("nar", exist_ok=True)

  with open("nix-cache-info", "w") as f:
    f.write("StoreDir: " + nixPrefix + "\n")

  with Pool(processes=args.num_workers) as pool:
    worker = partial(
      processItem,
      nixPrefix=nixPrefix,
      outDir=outDir,
      compression=args.compression,
      compressionCommand=args.compression_command,
      compressionExtension=args.compression_extension
    )
    pool.map(worker, closures)

if __name__ == "__main__":
  main()
