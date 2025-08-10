
from collections import defaultdict
import json
from pathlib import Path
import sys
import toml
import yaml


registry_path = Path(sys.argv[1])
desired_packages_path = Path(sys.argv[2])
package_overrides = json.loads(sys.argv[3])
dependencies_path = Path(sys.argv[4])
out_path = Path(sys.argv[5])

with open(desired_packages_path, "r") as f:
  desired_packages = yaml.safe_load(f) or []

with open(dependencies_path, "r") as f:
  uuid_to_store_path = yaml.safe_load(f)

result = {
  "deps": defaultdict(list)
}

for pkg in desired_packages:
  path = uuid_to_store_path.get(pkg["uuid"], None)

  if pkg["uuid"] in package_overrides:
    info = package_overrides[uuid]
    path = Path(info["name"][0].upper()) / Path(info["name"])
    result["deps"][info["name"]].append({
      "uuid": pkg["uuid"],
      # "deps": pkg["deps"],
      "path": path,
    })
  elif path:
    project_toml = toml.load(Path(path) / "Project.toml")

    deps = []
    weak_deps = project_toml.get("weakdeps", {})

    if "deps" in project_toml:
      # Build up deps for the manifest, excluding weak deps
      weak_deps_uuids = weak_deps.values()
      for (dep_name, dep_uuid) in project_toml["deps"].items():
        if not (dep_uuid in weak_deps_uuids):
          deps.append(dep_name)

    result["deps"][pkg["name"]].append({
      "version": pkg["version"],
      "uuid": pkg["uuid"],
      "deps": deps or None,
      "weakdeps": weak_deps or None,
      "extensions": project_toml.get("extensions", {}) or None,
      "path": path,
    })
  else:
    # This should be a stdlib package. TODO: check?
    result["deps"][pkg["name"]].append({
      "version": pkg["version"],
      "uuid": pkg["uuid"],
      "deps": pkg["deps"]
    })

with open(out_path, "w") as f:
  f.write('julia_version = "1.10.0"\n')
  f.write('manifest_format = "2.0"\n\n')
  toml.dump(result, f)
