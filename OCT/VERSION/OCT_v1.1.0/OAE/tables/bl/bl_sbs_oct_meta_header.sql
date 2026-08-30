--[FDNGPUB-2235] - New BL Tale to store Data fetched by OCT for comparison.
CREATE TABLE IF NOT EXISTS bl.bl_sbs_oct_meta_header (
	group_name varchar(250) NOT NULL,
	code varchar(250) NOT NULL,
	Value varchar(2000),
	description text NULL,
	flex1 varchar(250) NULL,
	flex2 varchar(250) NULL,
	flex3 varchar(250) NULL,
	flex4 varchar(250) NULL,
	flex5 varchar(250) NULL,
	flex6 varchar(250) NULL,
	flex7 varchar(250) NULL,
	flex8 varchar(250) NULL,
	flex9 varchar(250) NULL,
	flex10 varchar(250) NULL,
	row_create_ts timestamptz NULL DEFAULT now(),
	row_create_user_id varchar NULL DEFAULT CURRENT_USER,
	row_last_update_ts timestamptz NULL,
	row_last_update_user_id varchar NULL,
	row_create_pe_session int4 NULL,
	row_last_update_pe_session int4 NULL,
	CONSTRAINT bl_sbs_oct_meta_header_pkey PRIMARY KEY (group_name,code)
);

-- Column comments

COMMENT ON COLUMN bl.bl_sbs_oct_meta_header.group_name IS 'Use to store the group of the entry belongs to';
COMMENT ON COLUMN bl.bl_sbs_oct_meta_header.code IS 'Use to store the Actual name or key of the data, unique value';
COMMENT ON COLUMN bl.bl_sbs_oct_meta_header.value IS 'Use to store the value of the entry';
COMMENT ON COLUMN bl.bl_sbs_oct_meta_header.description IS 'Use to store the description of the data';
COMMENT ON COLUMN bl.bl_sbs_oct_meta_header.flex1 IS 'A column that is available for use by publishing processes only (not extracted for any product). A common use is to hold components of the compound DUR_UK in separate columns.';
COMMENT ON COLUMN bl.bl_sbs_oct_meta_header.flex2 IS 'A column that is available for use by publishing processes only (not extracted for any product). A common use is to hold components of the compound DUR_UK in separate columns.';
COMMENT ON COLUMN bl.bl_sbs_oct_meta_header.flex3 IS 'A column that is available for use by publishing processes only (not extracted for any product). A common use is to hold components of the compound DUR_UK in separate columns.';
COMMENT ON COLUMN bl.bl_sbs_oct_meta_header.flex4 IS 'A column that is available for use by publishing processes only (not extracted for any product). A common use is to hold components of the compound DUR_UK in separate columns.';
COMMENT ON COLUMN bl.bl_sbs_oct_meta_header.flex5 IS 'A column that is available for use by publishing processes only (not extracted for any product). A common use is to hold components of the compound DUR_UK in separate columns.';
COMMENT ON COLUMN bl.bl_sbs_oct_meta_header.flex6 IS 'A column that is available for use by publishing processes only (not extracted for any product). A common use is to hold components of the compound DUR_UK in separate columns.';
COMMENT ON COLUMN bl.bl_sbs_oct_meta_header.flex7 IS 'A column that is available for use by publishing processes only (not extracted for any product). A common use is to hold components of the compound DUR_UK in separate columns.';
COMMENT ON COLUMN bl.bl_sbs_oct_meta_header.flex8 IS 'A column that is available for use by publishing processes only (not extracted for any product). A common use is to hold components of the compound DUR_UK in separate columns.';
COMMENT ON COLUMN bl.bl_sbs_oct_meta_header.flex9 IS 'A column that is available for use by publishing processes only (not extracted for any product). A common use is to hold components of the compound DUR_UK in separate columns.';
COMMENT ON COLUMN bl.bl_sbs_oct_meta_header.flex10 IS 'A column that is available for use by publishing processes only (not extracted for any product). A common use is to hold components of the compound DUR_UK in separate columns.';
COMMENT ON COLUMN bl.bl_sbs_oct_meta_header.row_create_ts IS 'Date/time the row was inserted.';
COMMENT ON COLUMN bl.bl_sbs_oct_meta_header.row_create_user_id IS 'User who first created this row';
COMMENT ON COLUMN bl.bl_sbs_oct_meta_header.row_last_update_ts IS 'Date/time the row was last updated.';
COMMENT ON COLUMN bl.bl_sbs_oct_meta_header.row_last_update_user_id IS 'User who last updated this row';
COMMENT ON COLUMN bl.bl_sbs_oct_meta_header.row_create_pe_session IS 'Publishing execution session that first created this row.';
COMMENT ON COLUMN bl.bl_sbs_oct_meta_header.row_last_update_pe_session IS 'Publishing execution session that last updated this row';

--- Permission to pub_work
GRANT ALL ON TABLE bl.bl_sbs_oct_meta_header TO pub_work;