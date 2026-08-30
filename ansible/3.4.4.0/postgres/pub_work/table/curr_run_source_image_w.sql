CREATE TABLE IF NOT EXISTS pub_work.curr_run_source_image_w
   (
    img_name  varchar(2000),
	img_type varchar(200),
    row_create_ts timestamp with time zone default current_timestamp,
    row_create_user_id varchar default current_user,	
    row_last_update_ts timestamp with time zone,  
    row_last_update_user_id varchar, 
    row_create_pe_session integer, 
    row_last_update_pe_session integer
   );

COMMENT ON COLUMN curr_run_source_image_w.img_name IS 'The name of the image received for processing.';
COMMENT ON COLUMN curr_run_source_image_w.img_type IS 'The name of the image type for processing.';
COMMENT ON TABLE  curr_run_source_image_w  IS 'This Table used for the image processing';
