INSERT INTO bl.bl_sbs_pub_run_notification (process_name,user_email_list) VALUES
	 ('DEFAULT','chandan.bhatia@snapon.com,nitish.k.mishra@snapon.com')ON CONFLICT DO NOTHING;
	 
INSERT INTO bl.bl_sbs_pub_run_notification (process_name,user_email_list,subject,message) 
VALUES ('PREREQUISITE_WORKFLOW_STARTED','chandan.bhatia@snapon.com,nitish.k.mishra@snapon.com',
	  'Nissan - Prerequsite workflow has been initiated.','Nissan - Prerequsite workflow has been initiated')ON CONFLICT DO NOTHING;


INSERT INTO bl.bl_sbs_pub_run_notification (process_name, user_email_list, subject, message) 
VALUES('NISSAN_CATALOG_IMAGE_SYNC_PROCESS_START', 'chandan.bhatia@snapon.com,nitish.k.mishra@snapon.com', 'NISSAN_CATALOG_IMAGE_SYNC_PROCESS_START', 'Nissan - Catalog Image Sync Process has been initiated')ON CONFLICT DO NOTHING;
INSERT INTO bl.bl_sbs_pub_run_notification (process_name, user_email_list, subject, message) 
VALUES('NISSAN_CATALOG_IMAGE_SYNC_PROCESS_END', 'chandan.bhatia@snapon.com,nitish.k.mishra@snapon.com', 'NISSAN_CATALOG_IMAGE_SYNC_PROCESS_END', 'Nissan - Catalog Image Sync Process has been Completed.')ON CONFLICT DO NOTHING;


delete from bl.bl_sbs_pub_run_notification 
where process_name in ('NISSAN_IMAGE_DOWNLOAD_PROCESS_START','NISSAN_IMAGE_DOWNLOAD_PROCESS_END');