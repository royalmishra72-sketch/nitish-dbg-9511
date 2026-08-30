INSERT INTO pub_admin.pba_param_t (param_nm, param_value_txt, param_dsc) 
VALUES('DOWNLOAD_NIS_SVG_IMAGE_ZIP_LAST_TIMESTAMP', '20260101123901', 'SVG Image Zip files with timestamps less than or equal to the last timestamp value')ON CONFLICT DO NOTHING;

analyze verbose pub_admin.pba_param_t;
