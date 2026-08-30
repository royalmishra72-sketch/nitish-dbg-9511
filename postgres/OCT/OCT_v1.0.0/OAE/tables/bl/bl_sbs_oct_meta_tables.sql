DROP TABLE IF EXISTS bl.bl_sbs_oct_meta_tables;

CREATE TABLE IF NOT EXISTS bl.bl_sbs_oct_meta_tables
(
    schema_name character varying(50) NOT NULL,
    table_name character varying(50) NOT NULL,
	exclude_columns text,
    to_be_compare character(1) NOT NULL DEFAULT 'Y'::bpchar,
    CONSTRAINT bl_sbs_oct_meta_tables_pkey PRIMARY KEY (schema_name, table_name)
);

GRANT ALL ON TABLE bl.bl_sbs_oct_meta_tables TO pub_work;

COMMENT ON COLUMN bl.bl_sbs_oct_meta_tables.schema_name
    IS 'Name of schema';

COMMENT ON COLUMN bl.bl_sbs_oct_meta_tables.table_name
    IS 'Meta table name';

COMMENT ON COLUMN bl.bl_sbs_oct_meta_tables.exclude_columns
    IS 'List of column which needs to be excluded from comparison';
	
COMMENT ON COLUMN bl.bl_sbs_oct_meta_tables.to_be_compare
    IS 'Y: meta data to be compared, N: meta data not to be compared';