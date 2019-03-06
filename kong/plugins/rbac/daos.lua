local utils = require "kong.tools.utils"

local RESOURCE_SCHEMA = {
  primary_key = { "id" },
  table = "rbac_resources",
  cache_key = { "api_id" },
  fields = {
    id = { type = "id", dao_insert_value = true },
    api_id = { type = "uuid", required = true, foreign = "apis:id" },
    method = { type = "string", required = true },
    upstream_path = { type = "string", required = true },
    description = { type = "string", required = true },
    visibility = { type = "string", required = false, default = "protected" },
    created_at = { type = "timestamp", dao_insert_value = true }
  },
}

local ROLE_SCHEMA = {
  primary_key = { "id" },
  table = "rbac_roles",
  cache_key = { "id" },
  fields = {
    id = { type = "id", dao_insert_value = true },
    name = { type = "string", required = true, unique = true },
    description = { type = "string", required = false },
    created_at = { type = "timestamp", dao_insert_value = true }
  }
}

local ROLE_RESOURCE_SCHEMA = {
  primary_key = { "id" },
  table = "rbac_role_resources",
  cache_key = { "role_id" },
  fields = {
    id = { type = "id", dao_insert_value = true },
    role_id = { type = "string", required = true, foreign = "rbac_roles:id" },
    resource_id = { type = "string", required = true, foreign = "rbac_resources:id" }
  }
}

local ROLE_CONSUMER_SCHEMA = {
  primary_key = { "id" },
  table = "rbac_role_consumers",
  cache_key = { "consumer_id" },
  fields = {
    id = { type = "id", dao_insert_value = true },
    role_id = { type = "string", required = true, foreign = "rbac_roles:id" },
    consumer_id = { type = "string", required = true, foreign = "consumers:id" }
  }
}

local CREDENTIAL_SCHEMA = {
  primary_key = { "id" },
  table = "rbac_credentials",
  cache_key = { "key" },
  fields = {
    id = { type = "id", dao_insert_value = true },
    created_at = { type = "timestamp", immutable = true, dao_insert_value = true },
    expired_at = { type = "timestamp" },
    consumer_id = { type = "id", required = true, foreign = "consumers:id" },
    key = { type = "string", required = false, unique = true, default = utils.random_string }
  },
}

return {
  rbac_resources = RESOURCE_SCHEMA,
  rbac_roles = ROLE_SCHEMA,
  rbac_role_resources = ROLE_RESOURCE_SCHEMA,
  rbac_role_consumers = ROLE_CONSUMER_SCHEMA,
  rbac_credentials = CREDENTIAL_SCHEMA
}
