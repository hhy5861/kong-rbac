package = "kong-plugin-rbac"

local pluginName = 'rbac'

supported_platforms = {"linux", "macosx"}
source = {
  -- these are initially not required to make it work
  url = "git://github.com/hhy5861/kong-rbac",
  tag = "2.1.1"
}
version = source.tag .. "-1"

description = {
  summary = "Kong-rbac is a rbac plugin for Kong",
  homepage = "https://github.com/hhy5861/kong-rbac",
  license = "Apache-2.0"
}

dependencies = {
  "router == 2.1-0",
  "lodash == 0.02-0"
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins."..pluginName..".api"] = "kong/plugins/"..pluginName.."/api.lua",
    ["kong.plugins."..pluginName..".constants"] = "kong/plugins/"..pluginName.."/constants.lua",
    ["kong.plugins."..pluginName..".daos"] = "kong/plugins/"..pluginName.."/daos.lua",
    ["kong.plugins."..pluginName..".functions"] = "kong/plugins/"..pluginName.."/functions.lua",
    ["kong.plugins."..pluginName..".schema"] = "kong/plugins/"..pluginName.."/schema.lua",
    ["kong.plugins."..pluginName..".handler"] = "kong/plugins/"..pluginName.."/handler.lua",
    ["kong.plugins."..pluginName..".migrations.cassandra"] = "kong/plugins/"..pluginName.."/migrations/cassandra.lua",
    ["kong.plugins."..pluginName..".migrations.postgres"] = "kong/plugins/"..pluginName.."/migrations/postgres.lua"
  }
}
