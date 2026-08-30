CREATE TABLE IF NOT EXISTS pub_work.curr_run_image_data_w (
	img_name varchar(4000) NULL, -- The name of image.
	img_hash varchar(4000) NULL, -- The hash of image.
	img_path varchar(4000) NULL, -- The path of image.
	img_data bytea NULL, -- The blob information of image.
	img_callout_hash varchar(4000) NULL, -- The hash of callout.
	img_callout_path varchar(4000) NULL, -- The path of callout.
	img_callout_data text NULL, -- The clob information of callout.
	img_type varchar(4000) NULL, -- The type of image.
	img_format varchar(4000) NULL, -- The format of image.
	row_create_ts timestamptz NULL DEFAULT CURRENT_TIMESTAMP, -- Date/time the row was inserted.
	row_create_user_id varchar NULL DEFAULT CURRENT_USER, -- User who first created this row
	row_last_update_ts timestamptz NULL, -- Date/time the row was last updated.
	row_last_update_user_id varchar NULL, -- User who last updated this row
	row_create_pe_session int4 NULL, -- PE session number which first created this row
	row_last_update_pe_session int4 NULL -- PE session number which last updated this row
);

-- Column comments

COMMENT ON COLUMN pub_work.curr_run_image_data_w.img_name IS 'The name of image.';
COMMENT ON COLUMN pub_work.curr_run_image_data_w.img_hash IS 'The hash of image.';
COMMENT ON COLUMN pub_work.curr_run_image_data_w.img_path IS 'The path of image.';
COMMENT ON COLUMN pub_work.curr_run_image_data_w.img_data IS 'The blob information of image.';
COMMENT ON COLUMN pub_work.curr_run_image_data_w.img_callout_hash IS 'The hash of callout.';
COMMENT ON COLUMN pub_work.curr_run_image_data_w.img_callout_path IS 'The path of callout.';
COMMENT ON COLUMN pub_work.curr_run_image_data_w.img_callout_data IS 'The clob information of callout.';
COMMENT ON COLUMN pub_work.curr_run_image_data_w.img_type IS 'The type of image.';
COMMENT ON COLUMN pub_work.curr_run_image_data_w.img_format IS 'The format of image.';
COMMENT ON COLUMN pub_work.curr_run_image_data_w.row_create_ts IS 'Date/time the row was inserted.';
COMMENT ON COLUMN pub_work.curr_run_image_data_w.row_create_user_id IS 'User who first created this row';
COMMENT ON COLUMN pub_work.curr_run_image_data_w.row_last_update_ts IS 'Date/time the row was last updated.';
COMMENT ON COLUMN pub_work.curr_run_image_data_w.row_last_update_user_id IS 'User who last updated this row';
COMMENT ON COLUMN pub_work.curr_run_image_data_w.row_create_pe_session IS 'PE session number which first created this row';
COMMENT ON COLUMN pub_work.curr_run_image_data_w.row_last_update_pe_session IS 'PE session number which last updated this row';


