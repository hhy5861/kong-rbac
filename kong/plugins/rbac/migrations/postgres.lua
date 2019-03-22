return {
  {
    name = "2019-03-06-111650_init_rbac",
    up = [[
      CREATE TABLE IF NOT EXISTS rbac_resources (
        "id" uuid PRIMARY KEY,
        "service_id" uuid REFERENCES services (id) ON DELETE CASCADE,
        "route_id" uuid REFERENCES routes (id) ON DELETE CASCADE,
        "method" varchar(255),
        "upstream_path" varchar(255),
        "description" varchar(255),
        visibility varchar(15) default('protected'),
        created_at timestamp without time zone default (CURRENT_TIMESTAMP(0) at time zone 'utc'),
        UNIQUE(service_id, route_id, method, upstream_path)
      );

      CREATE INDEX IF NOT EXISTS "rbac_resources_service_id_idx" ON "rbac_resources" ("service_id");
      CREATE INDEX IF NOT EXISTS "rbac_resources_route_id_idx"   ON "rbac_resources" ("route_id");

      CREATE TABLE IF NOT EXISTS rbac_roles (
        "id" uuid PRIMARY KEY,
        consumer_id uuid REFERENCES consumers (id) ON DELETE CASCADE,
        "name" varchar(50) NOT NULL UNIQUE,
        "disabled" boolean NOT NULL,
        "description" varchar(255),
        created_at timestamp without time zone default (CURRENT_TIMESTAMP(0) at time zone 'utc')
      );

      CREATE TABLE IF NOT EXISTS rbac_role_resources (
        "id" uuid PRIMARY KEY,
        role_id uuid REFERENCES rbac_roles (id) ON DELETE CASCADE,
        resource_id uuid REFERENCES rbac_resources (id) ON DELETE CASCADE,
        UNIQUE(role_id, resource_id)
      );

      CREATE TABLE IF NOT EXISTS rbac_role_consumers (
        "id" uuid PRIMARY KEY,
        consumer_id uuid REFERENCES consumers (id) ON DELETE CASCADE,
        role_id uuid REFERENCES rbac_roles (id) ON DELETE CASCADE,
        UNIQUE(consumer_id, role_id)
      );
    ]],
    down = [[
      DROP TABLE rbac_role_resources;
      DROP TABLE rbac_role_consumers;
      DROP TABLE rbac_resources;
      DROP TABLE rbac_roles;
    ]]
  },
  {
    name = "2018-05-22-182310_rbac_credentials",
    up = [[
      CREATE TABLE IF NOT EXISTS rbac_credentials(
        id uuid,
        consumer_id uuid REFERENCES consumers (id) ON DELETE CASCADE,
        key text UNIQUE,
        created_at timestamp without time zone default (CURRENT_TIMESTAMP(0) at time zone 'utc'),
        expired_at timestamp without time zone,
        PRIMARY KEY (id)
      );

      DO $$
      BEGIN
        IF (SELECT to_regclass('rbac_key_idx')) IS NULL THEN
          CREATE INDEX rbac_key_idx ON rbac_credentials(key);
        END IF;
        IF (SELECT to_regclass('rbac_consumer_idx')) IS NULL THEN
          CREATE INDEX rbac_consumer_idx ON rbac_credentials(consumer_id);
        END IF;
      END$$;
    ]],
    down = [[
       DROP TABLE rbac_credentials;
    ]]
  }
}
