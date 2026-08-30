
-- DROP TABLE IF EXISTS pub_work.oct_ddl_tier2;

CREATE TABLE IF NOT EXISTS pub_work.oct_ddl_tier2
(
    schema_name character varying(50) NOT NULL,
    object_type character varying(50) NOT NULL,
    object_name text NOT NULL,
    definition text,
	row_create_ts timestamp with time zone,
    row_create_user_id character varying COLLATE pg_catalog."default",
    row_last_update_ts timestamp with time zone,
    row_last_update_user_id character varying COLLATE pg_catalog."default",
    row_create_pe_session integer,
    row_last_update_pe_session integer,
    CONSTRAINT oct_ddl_tier2_pkey PRIMARY KEY (schema_name, object_type, object_name)
);

ALTER TABLE IF EXISTS pub_work.oct_ddl_tier2
    OWNER to pub_work;

GRANT ALL ON TABLE pub_work.oct_ddl_tier2 TO pub_work;

COMMENT ON COLUMN pub_work.oct_ddl_tier2.schema_name
    IS 'Name of schema';

COMMENT ON COLUMN pub_work.oct_ddl_tier2.object_type
    IS 'Type of object';

COMMENT ON COLUMN pub_work.oct_ddl_tier2.object_name
    IS 'Name of object';

COMMENT ON COLUMN pub_work.oct_ddl_tier2.definition
    IS 'Definition of object';