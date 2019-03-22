local responses = require "kong.tools.responses"
local singletons = require "kong.singletons"
local pl_stringx = require "pl.stringx"
local _ = require "lodash"
local rbac_constants = require "kong.plugins.rbac.constants"

local function load_consumer_resources(consumer_id)
  local cache = singletons.cache
  local dao = singletons.dao

  local role_cache_key = dao.rbac_role_consumers:cache_key(consumer_id)
  local roles, err = cache:get(role_cache_key, nil, (function(id)
    return dao.rbac_role_consumers:find_all({ consumer_id = id })
  end), consumer_id)

  if err then
    return responses.send_HTTP_INTERNAL_SERVER_ERROR(err)
  end

  if table.getn(roles) < 1 then
    return {}
  end

  local resources = {}
  _.forEach(roles, (function(role)
    local role_resource_cache_key = dao.rbac_role_resources:cache_key(role.role_id)
    local role_resources, role_resource_err = cache:get(role_resource_cache_key, nil, (function(role_id)
      return dao.rbac_role_resources:find_all({ role_id = role_id })
    end), role.role_id)

    if role_resource_err then
      return responses.send_HTTP_INTERNAL_SERVER_ERROR(role_resource_err)
    end
    
    resources = _.union(resources, role_resources)
  end))
  
  return resources
end

local function get_root_consumers()
  local root_consumers = os.getenv('KONG_RBAC_ROOT_CONSUMERS')
  if root_consumers then
    return pl_stringx.split(root_consumers, ',')
  end
  return {}
end

local function get_public_resources(service_id, route_id)
  local cache = singletons.cache
  local dao = singletons.dao

  local visibility = "public"
  local resources_public_cache_key = dao.rbac_resources:cache_key(service_id..route_id..visibility)
  local resources_public, err = cache:get(resources_public_cache_key, nil, (function(id)
    return dao.rbac_resources:find_all({ service_id = service_id, route_id = route_id,  visibility = visibility })
  end), service_id, route_id)

  return resources_public, err
end

local function filter_method_any(method)
  local methods = {}
  local HTTP_METHODS = { 'get', 'post', 'put', 'patch', 'delete', 'trace', 'connect', 'options', 'head' }
  if (method == 'ANY' or method == 'ALL') then
    methods = HTTP_METHODS
  else
    methods = { method }
  end

  return methods
end

local function refresh_expired(conf, id)
  if not conf.expired then
    conf.expired = 1800
  end

  local expired = (os.time()+ conf.expired + rbac_constants.HEADERS.KONG_EXPIRED) * 1000
  singletons.dao.rbac_credentials:update({
    id = id
  }, {
    expired_at = expired
  })
end

return {
  load_consumer_resources = load_consumer_resources,
  get_root_consumers = get_root_consumers,
  get_public_resources = get_public_resources,
  filter_method_any = filter_method_any,
  refresh_expired = refresh_expired
}
