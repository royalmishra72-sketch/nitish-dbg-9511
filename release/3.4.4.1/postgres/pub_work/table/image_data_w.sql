  CREATE TABLE IF NOT EXISTS pub_work.image_data_w 
       ( img_name varchar(200), 
	     img_hash varchar(200), 
	     img_path varchar(500), 
	     img_typ_id varchar(1), 
	     img_data bytea, 
	     img_callout_hash varchar(200), 
	     img_callout_path varchar(500), 
	     img_callout_data text, 
	     attribute1 varchar(200), 
	     attribute2 varchar(200),
	     row_create_ts timestamptz NULL DEFAULT now(),
         row_create_user_id varchar NULL DEFAULT CURRENT_USER,
         row_last_update_ts timestamptz NULL,
         row_last_update_user_id varchar NULL,
         row_create_pe_session int4 NULL,
         row_last_update_pe_session int4 NULL,
	     CONSTRAINT pk_image_data_w primary key (img_name, attribute1)
		);
		
   COMMENT ON COLUMN pub_work.image_data_w.img_name is 'this column holds the img_name of the received images.';
   COMMENT ON COLUMN pub_work.image_data_w.img_hash is 'this column holds the hash values of the images.';
   COMMENT ON COLUMN pub_work.image_data_w.img_path is 'this column holds the img_path from where the images are loaded.';
   COMMENT ON COLUMN pub_work.image_data_w.img_typ_id is 'this column holds the img_typ_id values of the images. thumbnail or illustrations';
   COMMENT ON COLUMN pub_work.image_data_w.img_data is 'this column holds the blob of the images.';
   COMMENT ON COLUMN pub_work.image_data_w.img_callout_hash is 'this column holds the hash of the callout xml values.';
   COMMENT ON COLUMN pub_work.image_data_w.img_callout_path is 'this column holds the img_callout_path values.';
   COMMENT ON COLUMN pub_work.image_data_w.img_callout_data is 'this column holds the image caloout xml data values.';
   COMMENT ON COLUMN pub_work.image_data_w.attribute1 is 'this column holds the type of images values.thumbnail or illustrations';
   COMMENT ON COLUMN pub_work.image_data_w.attribute2 is 'this column holds image type TIFF or SVG';
   COMMENT ON COLUMN pub_work.image_data_w.row_create_ts is 'date/time the row was inserted.';
   COMMENT ON COLUMN pub_work.image_data_w.row_create_user_id is 'date/time the row was last updated.';
   COMMENT ON COLUMN pub_work.image_data_w.row_last_update_ts is 'user who first created this row';
   COMMENT ON COLUMN pub_work.image_data_w.row_last_update_user_id is 'user who last updated this row';
   COMMENT ON COLUMN pub_work.image_data_w.row_create_pe_session is 'Publishing execution session that first created this row.';
   COMMENT ON COLUMN pub_work.image_data_w.row_last_update_pe_session is 'Publishing execution session that last updated this row';
   COMMENT ON TABLE pub_work.image_data_w  is 'this work table contains Unique image blob data.';
   
   

  
  
	
	
	