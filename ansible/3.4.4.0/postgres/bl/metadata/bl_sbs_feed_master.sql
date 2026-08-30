INSERT INTO bl.bl_sbs_feed_master (download_data_source_name, description, mandatory_feed) 
VALUES('DOWNLOAD_NIS_SVG_IMAGE_ZIP', 'This will Download SVG image file from Internal sftp to epo location.', 'Y')ON CONFLICT DO NOTHING;

analyze verbose bl.bl_sbs_feed_master;