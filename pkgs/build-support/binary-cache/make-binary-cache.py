import argparse
import base64
from functools import partial
import json
from multiprocessing import Pool
from nacl.signing import SigningKey
from nacl.encoding import RawEncoder
import os
from pathlib import Path
import subprocess


def dropPrefix(path, nixPrefix):
    return path[len(nixPrefix + "/") :]


def processItem(
    item, nixPrefix, outDir, compression, compressionCommand, compressionExtension, signaturePrivateKey
):
    narInfoHash = dropPrefix(item["path"], nixPrefix).split("-")[0]

    narFile = outDir / "nar" / f"{narInfoHash}{compressionExtension}"
    with open(narFile, "wb") as f:
        subprocess.run(
            f"nix-store --dump {item['path']} {compressionCommand}",
            stdout=f,
            shell=True,
            check=True,
        )

    fileHash = (
        subprocess.run(
            ["nix-hash", "--base32", "--type", "sha256", "--flat", narFile],
            capture_output=True,
            check=True,
        )
        .stdout.decode()
        .strip()
    )
    fileSize = os.path.getsize(narFile)

    finalNarFileName = Path("nar") / f"{fileHash}{compressionExtension}"
    os.rename(narFile, outDir / finalNarFileName)

    with open(outDir / f"{narInfoHash}.narinfo", "wt") as f:
        f.write(f"StorePath: {item['path']}\n")
        f.write(f"URL: {finalNarFileName}\n")
        f.write(f"Compression: {compression}\n")
        f.write(f"FileHash: sha256:{fileHash}\n")
        f.write(f"FileSize: {fileSize}\n")
        f.write(f"NarHash: {item['narHash']}\n")
        f.write(f"NarSize: {item['narSize']}\n")
        f.write(
            f"References: {' '.join(dropPrefix(ref, nixPrefix) for ref in item['references'])}\n"
        )

        if signaturePrivateKey:
            keyName, keyBase64 = signaturePrivateKey.split(':', 1)
            keyBytes = base64.b64decode(keyBase64)
            keySeed = keyBytes[:32]
            pubKey = keyBytes[32:]

            signingKey = SigningKey(keySeed, encoder=RawEncoder)
            # See https://github.com/NixOS/nix/blob/d904921eecbc17662fef67e8162bd3c7d1a54ce0/src/perl/lib/Nix/Manifest.pm#L231-L246
            contentToSign = "1;" + ";".join([
                item['path'],
                item['narHash'],
                str(item['narSize']),
                ','.join(dropPrefix(ref, nixPrefix) for ref in item['references']),
            ])
            print("contentToSign", contentToSign)
            signature = signingKey.sign(contentToSign.encode("utf-8")).signature
            print("Got signature", base64.b64encode(signature).decode('utf-8'))
            f.write(f"Sig: {keyName}:{base64.b64encode(signature).decode('utf-8')}\n")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--compression", choices=["none", "xz", "zstd"])
    parser.add_argument("--signature-private-key")
    args = parser.parse_args()

    compressionCommand = {
        "none": "",
        "xz": "| xz -c",
        "zstd": "| zstd",
    }[args.compression]

    compressionExtension = {
        "none": "",
        "xz": ".xz",
        "zstd": ".zst",
    }[args.compression]

    outDir = Path(os.environ["out"])
    nixPrefix = os.environ["NIX_STORE"]
    numWorkers = int(os.environ.get("NIX_BUILD_CORES", "4"))

    with open(os.environ["NIX_ATTRS_JSON_FILE"], "r") as f:
        closures = json.load(f)["closure"]

    os.makedirs(outDir / "nar", exist_ok=True)

    with open(outDir / "nix-cache-info", "w") as f:
        f.write(f"StoreDir: {nixPrefix}\n")

    with Pool(processes=numWorkers) as pool:
        worker = partial(
            processItem,
            nixPrefix=nixPrefix,
            outDir=outDir,
            compression=args.compression,
            compressionCommand=compressionCommand,
            compressionExtension=compressionExtension,
            signaturePrivateKey=json.loads(args.signature_private_key),
        )
        pool.map(worker, closures)


if __name__ == "__main__":
    main()
