
from collections import defaultdict
import copy
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import toml
import util
import yaml


registry_path = Path(sys.argv[1])
desired_packages_path = Path(sys.argv[2])
package_overrides = json.loads(sys.argv[3])
dependencies_path = Path(sys.argv[4])
out_path = Path(sys.argv[5])

with open(desired_packages_path, "r") as f:
  desired_packages = yaml.safe_load(f) or []

uuid_to_versions = defaultdict(list)
for pkg in desired_packages:
    uuid_to_versions[pkg["uuid"]].append(pkg["version"])

with open(dependencies_path, "r") as f:
  uuid_to_store_path = yaml.safe_load(f)

os.makedirs(out_path)

extraUuids = [
  "123dc426-2d89-5057-bbad-38513e3affd8", # SymEngine
  "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549", # FileIO
  "a93c6f00-e57d-5684-b7b6-d8193f3e46c0", # DataFrames
  "08abe8d2-0d0c-5749-adfa-8a2ac140af0d", # PrettyTables
  "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c", # Mods
  "324d7699-5711-5eae-9e2f-1d82baa6b597", # Measurements
  "69666777-d1a9-59fb-9406-91d4454c9d45", # Unitful
  "d7dd28d6-a5e6-559c-9131-7eb760cdacc5", # Requires
  "f269a46b-ccf7-5d73-abea-4c690281aa53", # Adapt
  "2dfb63ee-cc39-5dd5-95bd-886bf059d720", # Logging
  "842dd82b-1e85-43dc-bf29-5d0ee9dffc48", # Serialization
  "59287772-0a20-5a39-b81b-1366585eb4c0", # Random
  "187b0558-2788-49d3-abe0-74a17ed4e7c9", # Test
  "90137ffa-7385-5640-81b9-e52037218182", # Distributed
  "9a8bc11e-79be-5b39-94d7-1ccc349a1a85", # InteractiveUtils
  "4e289a0a-7415-4d19-859d-a7e5c4648b56", # Pkg
  "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4", # Dates
  "41ab1584-1d38-5bbf-9106-f11c6c58b48f", # Printf
  "3428059b-622b-5399-b16f-d347a77089a4", # Statistics
  "5ba52731-8f18-5e0d-9241-30f10d1ec561", # Tracking
  "3587e190-3f89-42d0-90ee-14403ec27112", # SymbolicInference
  "9e28174c-4ba2-5203-b857-d8d62c4213ee", # SymEngine
  "30578b45-9adc-5946-b283-645ec420af67", # SymbolicUtils
  "d8c32880-2388-543b-8c61-d9f865259254", # Symbolics
  "45858cf5-a6b0-47a3-bbea-62219f50df47",
  "6fe1bfb0-de20-5000-8ca7-80f57d26f881",
  "46d2c3a1-f734-5fdb-9937-b9b9aeba4221",
  "8f5d6c58-4d21-5cfd-889c-e3ad7ee6a615",
  "276daf66-3868-5448-9aa4-cd146d93841b",
  "91c51154-3ec4-41a3-a24f-3f23e20d615c",
  "7073ff75-c697-5162-941a-fcdaad2a7d2a",
  "a09fc81d-aa75-5fe9-8630-4744c3626534",
  "8f4d0f93-b110-5947-807f-2305c1781a2d",
  "4c88cf16-eb10-579e-8560-4a9242c79595",
  "7a1cc6ca-52ef-59f5-83cd-3a7055c09341",
  "c2297ded-f4af-51ae-bb23-16f91089e4e1",
  "856f044c-d86e-5d09-b602-aeab76dc8ba7",
  "1317d2d5-d96f-522e-a858-c73665f53c3e",
  "621f4979-c628-5d54-868e-fcf4e3e8185c",
  "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0",
  "f5851436-0d7a-5f13-b9de-f02708fd171a",
  "efe28fd5-8261-553b-a9e1-b2916fc3738e",
  "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f",
  "79e6a3ab-5dfb-504d-930d-738a2a938a0e",
  "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a",
  "c817782e-172a-44cc-b673-b171935fbb9e",
  "8197267c-284f-5f27-9208-e0e47529a953",
  "da5c29d0-fa7d-589e-88eb-ea29b0a81949",
  "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9",
  "aedffcd0-7271-4cad-89d0-dc628f76c6d3",
  "46192b85-c4d5-4398-a991-12ede77f4527",
  "45b445bb-4962-46a0-9369-b4df9d0f772e",
  "4889d778-9329-5762-9fec-0578a5d30366",
  "fa961155-64e5-5f13-b03f-caf6b980ea82",
  "76a88914-d11a-5bdc-97e0-2f5a05c973a2",
  "aae01518-5342-5314-be14-df237901396f",
  "4c555306-a7a7-4459-81d9-ec55ddd5c99a",
  "a3b82374-2e81-5b9e-98ce-41277c0e4c87",
  "7057c7e9-c182-5462-911a-8362d720325c",
  "78c3b35d-d492-501b-9361-3d52fe80e533",
  "6add18c4-b38d-439d-96f6-d6bc489c04c5",
  "4ee394cb-3365-5eb0-8335-949819d2adfc",
  "9b13fd28-a010-5f03-acff-a1bbcff69959",
  "5c1252a2-5f33-56bf-86c9-59e7332b4326",
  "5ae413db-bbd1-5e63-b57d-d24a61df00f5",
  "655565e8-fb53-5cb3-b0cd-aec1ca0647ea",
  "411431e0-e8b7-467b-b5e0-f676ba4f2910",
  "c8e1da08-722c-5040-9ed9-7db0dc04731e",
  "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173",
  "a51ab1cf-af8e-5615-a023-bc2c838bba6b",
  "1e83bf80-4336-4d27-bf5d-d5a4f845583c",
  "bd369af6-aec1-5ad0-b16a-f7cc5008161c",
  "30b0a656-2188-435a-8636-2ec0e6a096e2",
  "c8c2cc18-de81-4e68-b407-38a3a0c0491f",
  "e2d170a0-9d28-54be-80f0-106bbe20a464",
  "76eceee3-57b5-4d4a-8e66-0e911cebbf60",
  "b85f4697-e234-5449-a836-ec8e2f98b302",
  "354b36f9-a18e-4713-926e-db85100087ba",
  "66db9d55-30c0-4569-8b51-7e840670fc0c",
  "73a701b4-84e1-5df0-88ff-1968ee2ee8dc",
  "ffab5731-97b5-5995-9138-79e8c1846df0",
  "8f1865be-045e-5c20-9c9f-bfbfb0764568",
  "a9144af2-ca23-56d9-984f-0d03f7b5ccf8",
  "a2bd30eb-e257-5431-a919-1863eab51364",
  "31f734f8-188a-4ce0-8406-c8a06bd891cd",
  "d1185830-fcd6-423d-90d6-eec64667417b",
  "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f",
  "2ee39098-c373-598a-b85f-a56591580800",
  "e2ed5e7c-b2de-5872-ae92-c73ca462fb04",
  "731186ca-8d62-57ce-b412-fbd966d074cd",
  "0c68f7d7-f131-5f86-a1c3-88cf8149b2d7",
  "7e506255-f358-4e82-b7e4-beb19740aa63",
  "700de1a5-db45-46bc-99cf-38207098b444",
  "929cbde3-209d-540e-8aea-75f648917ca0",
  "ab4f0b2a-ad5b-11e8-123f-65d77653426b",
  "102ac46a-7ee4-5c85-9060-abc95bfdeaa3",
  "d8a4904e-b15c-11e9-3269-09a3773c0cb0",
  "e88e6eb3-aa80-5325-afca-941959d7151f",
  "872c559c-99b0-510c-b3b7-b6c96a88d5cd",
  "02a925ec-e4fe-4b08-9a7e-0d78e3d38ccd",
  "a6bfbf70-4841-5cb9-aa18-3a8ad3c413ee",
  "c52e3926-4ff0-5f6e-af25-54175e0327b1",
  "98e50ef6-434e-11e9-1051-2b60c6c9e899",
  "a2a6695c-b41b-5b7d-aed9-dbfdeacea5d7",
  "0f1e0344-ec1d-5b48-a673-e5cf874b6c29",
  "e89f7d12-3494-54d1-8411-f7d8b9ae1f27",
  "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2",
  "b4f34e82-e78d-54a5-968a-f98e89d6e8f7",
  "7869d1d1-7146-5819-86e3-90919afe41df",
  "70703baa-626e-46a2-a12c-08ffd08c73b4",
  "a80b9123-70ca-4bc0-993e-6e3bcb318db6",
  "1af6417a-86b4-443c-805f-a4643ffb695f",
  "bf4720bc-e11a-5d0c-854e-bdca1663c893",
  "fa939f87-e72e-5be4-a000-7fc836dbe307",
  "0987c9cc-fe09-11e8-30f0-b96dd679fdca",
  "476501e8-09a2-5ece-8869-fb82de89a1fa",
  "21efa798-c60a-11e8-04d3-e1a92915a26a",
  "5078a376-72f3-5289-bfd5-ec5146d43c02",
  "5ced341a-0733-55b8-9ab6-a4889d929147",
  "ea10d353-3f73-51f8-a26c-33c1cb351aa5",
  "9fb69e20-1954-56bb-a84f-559cc56a8ff7",
  "b99e7846-7c00-51b0-8f62-c81ae34c0232",
  "082447d4-558c-5d27-93f4-14fc19e9eca2",
  "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
  ]

for uuid in extraUuids:
  if uuid in package_overrides:
    continue

  uuid_to_versions[uuid] = None

registry = toml.load(registry_path / "Registry.toml")
registry["packages"] = {k: v for k, v in registry["packages"].items() if k in uuid_to_versions or k in extraUuids}

for (uuid, versions) in uuid_to_versions.items():
  if uuid in package_overrides:
    info = package_overrides[uuid]

    # Make a registry entry based on the info from the package override
    path = Path(info["name"][0].upper()) / Path(info["name"])
    registry["packages"][uuid] = {
      "name": info["name"],
      "path": str(path),
    }

    os.makedirs(out_path / path)

    # Read the Project.yaml from the src
    project = toml.load(Path(info["src"]) / "Project.toml")

    # Generate all the registry files
    with open(out_path / path / Path("Compat.toml"), "w") as f:
      f.write('["%s"]\n' % info["version"])
      # Write nothing in Compat.toml, because we've already resolved everything
    with open(out_path / path / Path("Deps.toml"), "w") as f:
      f.write('["%s"]\n' % info["version"])
      if "deps" in project:
        toml.dump(project["deps"], f)
    with open(out_path / path / Path("Versions.toml"), "w") as f:
      f.write('["%s"]\n' % info["version"])
      f.write('git-tree-sha1 = "%s"\n' % info["treehash"])
    with open(out_path / path / Path("Package.toml"), "w") as f:
      toml.dump({
        "name": info["name"],
        "uuid": uuid,
        "repo": "file://" + info["src"],
      }, f)

  elif uuid in registry["packages"]:
    registry_info = registry["packages"][uuid]
    name = registry_info["name"]
    path = registry_info["path"]

    os.makedirs(out_path / path)

    # Copy some files to the minimal repo unchanged
    for f in ["Compat.toml", "Deps.toml", "WeakCompat.toml", "WeakDeps.toml"]:
      if (registry_path / path / f).exists():
        shutil.copy2(registry_path / path / f, out_path / path)

    # Copy the Versions.toml file, trimming down to the versions we care about.
    # In the case where versions=None, this is a weak dep, and we keep all versions.
    all_versions = toml.load(registry_path / path / "Versions.toml")
    versions_to_keep = {k: v for k, v in all_versions.items() if k in versions} if versions != None else all_versions
    for k, v in versions_to_keep.items():
      del v["nix-sha256"]
    with open(out_path / path / "Versions.toml", "w") as f:
      toml.dump(versions_to_keep, f)

    if versions is None:
      # This is a weak dep; just grab the whole Package.toml
      shutil.copy2(registry_path / path / "Package.toml", out_path / path / "Package.toml")
    elif uuid in uuid_to_store_path:
      # Fill in the local store path for the repo
      package_toml = toml.load(registry_path / path / "Package.toml")
      package_toml["repo"] = "file://" + uuid_to_store_path[uuid]
      with open(out_path / path / "Package.toml", "w") as f:
        toml.dump(package_toml, f)

with open(out_path / "Registry.toml", "w") as f:
    toml.dump(registry, f)
