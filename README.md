## KONG RBAC PLUGIN

This is a rbac plugin for kong CE.

## INSTALLATION

```
luarocks install --server=http://luarocks.org/manifests/hhy5861 kong-plugin-rbac
```

set environment
```
KONG_CUSTOM_PLUGINS=rbac
```

> If you have some custom plugins configured before, just concat them with comma.

## MANAGEMENT APIS

> NOTE: You have to use the kong's admin port to call management apis, default is 8001.


### Add resource

> **POST** /rbac/resources

```json
{
	"api_id": "api that resource belongs to",
	"method": "http method",
	"upstream_path": "upstream request path without query string",
	"description": "description"
}
```
NOTE: `api_id`, `method` and `upstream_path` must be unique.

### Update resources

Update a resources that you added before.

> **PUT** /rbac/resources

```json
{
	"id": "resource id",
	"api_id": "api that resource belongs to",
	"method": "http method",
	"upstream_path": "upstream request path without query string",
	"description": "description"
}
```
### Delete resource

> **DELETE** /rbac/resources/:resource_id

### Add role

Add a role to rbac system.

> **POST** /rbac/roles

```json
{
	"name": "role_name",
	"description": "description of this role"
}
```

### Update role

Update a role that you added before.

> **PUT** /rbac/roles
```json
{
	"id": "id of role",
	"name": "role_name",
	"description": "description for this role"
}
```

### List roles

> **GET** /rbac/roles

### Delete role

> **DELETE** /rbac/roles/:role_id_or_name

### Create  association between role and resources

> **POST** /rbac/roles/:role_name_or_id/resources
```json
{
	"resource_ids": [
		"resource_id1",
		"resource_id2"
	]
}
```

### Create  association between consumer and roles 

> **POST** "/consumers/:username_or_id/rbac-roles/"
```json
{
	"role_ids": [
		"role_id1",
		"role_id2"
	]
}
```
