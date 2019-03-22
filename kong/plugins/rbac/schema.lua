local utils = require "kong.tools.utils"
local singletons = require "kong.singletons"

local function default_key_names(t)
  if not t.key_names then
    return {"x-auth-token", "token", "Authorization"}
  end
end

local function check_keys(keys)
  for _, key in ipairs(keys) do
    local res, err = utils.validate_header_name(key, false)

    if not res then
      return false, "'" .. key .. "' is illegal: " .. err
    end
  end

  return true
end

local function check_user(anonymous)
  if anonymous == "" or utils.is_valid_uuid(anonymous) then
    return true
  end

  return false, "the anonymous user must be empty or a valid uuid"
end

local function check_consumers_exists(consumer_ids)
  for i, consumer_id in ipairs(consumer_ids) do
    local result, err = singletons.dao.consumers:find { id = consumer_id }
    if not result then
      return false, 'the root consumer' .. consumer_id .. ' is not exists.'
    end
  end
  return true
end
return {
  no_consumer = true,
  fields = {
    -- Describe your plugin's configuration's schema here.
    key_names = {
      required = true,
      type = "array",
      default = default_key_names,
      func = check_keys,
    },
    hide_credentials = {
      type = "boolean",
      default = false,
    },
    anonymous = {
      type = "string",
      default = "",
      func = check_user,
    },
    key_in_header = {
      type = "boolean",
      default = true,
    },
    key_in_query = {
      type = "boolean",
      default = false,
    },
    key_in_body = {
      type = "boolean",
      default = false,
    },
    run_on_preflight = {
      type = "boolean",
      default = true,
    },
    rbac_enabled = {
      type = "boolean",
      default = true,
    },
    expired = {
      type = "integer",
      default = 1800,
    }
  },
  self_check = function(schema, plugin_t, dao, is_updating)
    -- perform any custom verification
    return true
  end
}
