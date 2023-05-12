
import TOML: parsefile

uuid_to_info_toml = ARGS[1]
out = ARGS[2]

include("indexpackage.jl")

uuid_to_info = parsefile(uuid_to_info_toml)

for (uuid, info) in uuid_to_info
  exit_code = SymbolServer.index_package(info["name"], info["version"], uuid, info["treehash"])
  println(exit_code)
end

mkpath(out)
