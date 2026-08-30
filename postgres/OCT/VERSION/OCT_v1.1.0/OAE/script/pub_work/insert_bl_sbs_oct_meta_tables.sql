-- [FDNGPUB-2235] - Script to add BL table bl_sbs_oct_meta_tables for comparison
insert into bl.bl_sbs_oct_meta_tables (schema_name,table_name,exclude_columns,to_be_compare) values ('bl','bl_sbs_oct_meta_header',NULL,'Y') on conflict (schema_name, table_name) do nothing;
