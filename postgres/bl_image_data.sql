-- Drop table

-- DROP TABLE bl.bl_image_data;

CREATE TABLE bl.bl_image_data (
	img_name varchar(200) NOT NULL, -- this column holds the img_name of the received images.
	img_hash varchar(200) NULL, -- this column holds the hash values of the images.
	img_path varchar(500) NULL, -- this column holds the img_path from where the images are loaded.
	img_typ_id varchar(1) NULL, -- this column holds the img_typ_id values of the images. thumbnail or illustrations
	img_data bytea NULL, -- this column holds the blob of the images.
	img_callout_hash varchar(200) NULL, -- this column holds the hash of the callout xml values.
	img_callout_path varchar(500) NULL, -- this column holds the img_callout_path values.
	img_callout_data text NULL, -- this column holds the image caloout xml data values.
	attribute1 varchar(200) NOT NULL, -- this column holds the type of images values.thumbnail or illustrations
	row_create_ts timestamptz NULL DEFAULT now(), -- date/time the row was inserted.
	row_create_user_id varchar NULL DEFAULT CURRENT_USER, -- date/time the row was last updated.
	row_last_update_ts timestamptz NULL, -- user who first created this row
	row_last_update_user_id varchar NULL, -- user who last updated this row
	row_create_pe_session int4 NULL, -- Publishing execution session that first created this row.
	row_last_update_pe_session int4 NULL, -- Publishing execution session that last updated this row
	attribute2 varchar(200) NOT NULL,
	CONSTRAINT pk_bl_image_data PRIMARY KEY (img_name, attribute1, attribute2)
);
COMMENT ON TABLE bl.bl_image_data IS 'this table contains the nissan image blob data.';

-- Column comments

COMMENT ON COLUMN bl.bl_image_data.img_name IS 'this column holds the img_name of the received images.';
COMMENT ON COLUMN bl.bl_image_data.img_hash IS 'this column holds the hash values of the images.';
COMMENT ON COLUMN bl.bl_image_data.img_path IS 'this column holds the img_path from where the images are loaded.';
COMMENT ON COLUMN bl.bl_image_data.img_typ_id IS 'this column holds the img_typ_id values of the images. thumbnail or illustrations';
COMMENT ON COLUMN bl.bl_image_data.img_data IS 'this column holds the blob of the images.';
COMMENT ON COLUMN bl.bl_image_data.img_callout_hash IS 'this column holds the hash of the callout xml values.';
COMMENT ON COLUMN bl.bl_image_data.img_callout_path IS 'this column holds the img_callout_path values.';
COMMENT ON COLUMN bl.bl_image_data.img_callout_data IS 'this column holds the image caloout xml data values.';
COMMENT ON COLUMN bl.bl_image_data.attribute1 IS 'this column holds the type of images values.thumbnail or illustrations';
COMMENT ON COLUMN bl.bl_image_data.row_create_ts IS 'date/time the row was inserted.';
COMMENT ON COLUMN bl.bl_image_data.row_create_user_id IS 'date/time the row was last updated.';
COMMENT ON COLUMN bl.bl_image_data.row_last_update_ts IS 'user who first created this row';
COMMENT ON COLUMN bl.bl_image_data.row_last_update_user_id IS 'user who last updated this row';
COMMENT ON COLUMN bl.bl_image_data.row_create_pe_session IS 'Publishing execution session that first created this row.';
COMMENT ON COLUMN bl.bl_image_data.row_last_update_pe_session IS 'Publishing execution session that last updated this row';

-- Permissions

ALTER TABLE bl.bl_image_data OWNER TO bl;
GRANT ALL ON TABLE bl.bl_image_data TO bl;
GRANT ALL ON TABLE bl.bl_image_data TO pub_work;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE bl.bl_image_data TO pub_work_app;
GRANT SELECT ON TABLE bl.bl_image_data TO fnc_personal_account_rl;
GRANT SELECT ON TABLE bl.bl_image_data TO fnc_support_adhoc_rl;
