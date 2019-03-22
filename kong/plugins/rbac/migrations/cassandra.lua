--
-- Created by IntelliJ IDEA.
-- User: mike
-- Date: 2018/5/22
-- Time: 10:08 AM
-- To change this template use File | Settings | File Templates.
--

return {
  {
    name = "2019-03-06-111550_init_rbac",
    up = [[
      CREATE TABLE IF NOT EXISTS rbac_resources (
        id uuid,
        service_id uuid,
        route_id uuid,
        method text,
        upstream_path text,
        description text,
        visibility text,
        created_at timestamp,
        PRIMARY KEY (id)
      );

      CREATE TABLE IF NOT EXISTS rbac_roles (
        id uuid,
        consumer_id uuid,
        name text,
        disabled boolean,
        description text,
        created_at timestamp,
        PRIMARY KEY (id)
      );

      CREATE TABLE IF NOT EXISTS rbac_role_resources (
        id uuid,
        role_id uuid,
        resource_id uuid,
        PRIMARY KEY (id, role_id, resource_id)
      );

      CREATE TABLE IF NOT EXISTS rbac_role_consumers (
        id uuid,
        consumer_id uuid,
        role_id uuid,
        PRIMARY KEY (id, consumer_id, role_id)
      );
    ]],
    down = [[
      DROP TABLE rbac_role_resources;
      DROP TABLE rbac_role_consumers;
      DROP TABLE rbac_resources;
      DROP TABLE rbac_roles;
    ]],
  },
  {
    name = "2018-05-22-101000_rbac_credentials",
    up = [[
      CREATE TABLE IF NOT EXISTS rbac_credentials(
        id uuid,
        consumer_id uuid,
        key text,
        created_at timestamp,
        expired_at timestamp,
        PRIMARY KEY (id)
      );

      CREATE INDEX IF NOT EXISTS ON rbac_credentials(key);
      CREATE INDEX IF NOT EXISTS rbac_consumer_idx ON rbac_credentials(consumer_id);
    ]],
    down = [[
       DROP TABLE rbac_credentials;
    ]]
  }
}

