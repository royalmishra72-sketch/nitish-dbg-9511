update bl.bl_sbs_report_failures
	set primary_owner='OPERATION ENGINEER'
	where report_name in 
	('rpt_nis_thumbimage',
	'rpt_unmapped_illust_image',
	'rpt_zero_byte_feed_files_received',
	'rpt_mandatory_feed_files_not_received',
	'rpt_missing_svg_images'	,
	'rpt_nis_image_not_processed'
	);