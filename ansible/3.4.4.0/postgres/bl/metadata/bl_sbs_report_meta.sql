DELETE FROM bl.bl_sbs_report_meta WHERE report_name='rpt_downloaded_feeds';
DELETE FROM bl.bl_sbs_report_meta WHERE report_name='rpt_nis_vin_no_mapping';
DELETE FROM bl.bl_sbs_report_meta WHERE report_name='rpt_nis_app_threshold';
DELETE FROM bl.bl_sbs_report_meta WHERE report_name='rpt_unmapped_illust_image';
DELETE FROM bl.bl_sbs_report_meta WHERE report_name='rpt_nis_bl_large_images';
DELETE FROM bl.bl_sbs_report_meta WHERE report_name='rpt_nis_images_incremental_xy';
DELETE FROM bl.bl_sbs_report_meta WHERE report_name='rpt_nis_image_not_processed';
DELETE FROM bl.bl_sbs_report_meta WHERE report_name='rpt_missing_svg_images';
DELETE FROM bl.bl_sbs_report_meta WHERE report_name='rpt_mandatory_feed_files_not_received';
DELETE FROM bl.bl_sbs_report_meta WHERE report_name='rpt_nis_part_item_range';


INSERT INTO bl.bl_sbs_report_meta (report_group, report_name, report_status, report_subject, report_body, report_filename, report_query, report_max_rows, report_data_multilingual, report_publish_flag, report_details, header_required, report_date_required, report_count_threshold, rpt_transaction_config, rdvt_flag) VALUES('downloaded_feeds_report', 'rpt_downloaded_feeds', 'D', 'Downloaded Feeds Report', 'Hello Team,Please find the attached Downloaded Feeds Report from the PUB App Server.If you have any questions or need further details, please let us know.Regards,Nissan Publishing Team', 'rpt_downloaded_feeds.csv', '/******************************************************************************
REPORT_NAME:       DOWNLOADED_FEEDS_REPORT
PURPOSE:    For list of feeds downloaded and not downloaded in the current run for weekly feeds
REVISIONS:
Ver        Date        Author             Description
---------  ----------  ----------------   ------------------------------------
1          30-11-2023  Nitish K Mishra    This report contains list of feeds downloaded and not downloaded in the current run for weekly feeds.
2          12-02-2025  Nitish K Mishra    Remove the usage of pub_admin tables from report query, instead used its views. 
3          13-01-2026  Nitish K Mishra    Add SVG Image Download Process in Report
******************************************************************************/
WITH LAST_PUB_RUN_DATE AS
(
 SELECT CASE WHEN MAX(datarcpt_t_rcrd_updt_ts) > MAX(datarcpt_t_rcrd_create_ts) 
  THEN MAX(datarcpt_t_rcrd_updt_ts) 
  ELSE MAX(datarcpt_t_rcrd_create_ts)
  END AS LAST_PR_DT FROM  pub_admin.dr_datarcpt_file_v
),
LAST_DR_PER_DS AS
(
  SELECT *
  FROM
  (SELECT DATASRC_ID,
          DATARCPT_ID,
          parentcontainerid,
          datarcpt_t_rcrd_create_ts,
          datarcpt_t_rcrd_updt_ts,
          receiptstatus,
          datarcpt_orgnl_file_name,datarcpt_loadplan_status_code
   FROM pub_admin.dr_datarcpt_file_v WHERE datarcpt_orgnl_file_name NOT LIKE ''%!%'' 
   AND datarcpt_t_rcrd_create_ts::date > (SELECT LAST_PR_DT::date - 1 FROM LAST_PUB_RUN_DATE)
  )a
),
 report_data as(
select rr.* from(
with recursive DR_ERRORS (DATASRC_ID,DATARCPT_ID,parentcontainerid, datarcpt_orgnl_file_name,receiptstatus ,datarcpt_loadplan_status_code, lev) AS
  (
    SELECT DATASRC_ID,
          DATARCPT_ID,
          parentcontainerid,
          datarcpt_orgnl_file_name,
          receiptstatus,
          datarcpt_loadplan_status_code,
          1 as lev
          FROM LAST_DR_PER_DS
    WHERE parentcontainerid is null
  UNION ALL
    SELECT e.DATASRC_ID,
          e.DATARCPT_ID,
          e.parentcontainerid,
          e.datarcpt_orgnl_file_name,
          e.receiptstatus,
          e.datarcpt_loadplan_status_code, 
          lev+1 as lev
    FROM   DR_ERRORS r, LAST_DR_PER_DS e
    WHERE  r.DATARCPT_ID = e.parentcontainerid
  ) search depth first by DATARCPT_ID set seq
  select oc.*, 
         case 
           when lead ( lev, 1, 1 ) over ( order by seq ) <= lev then ''LEAF''
         end is_leaf from DR_ERRORS oc
  )rr
   )
   SELECT DISTINCT DS.DATASRC_NM as data_source_name,
  DR.datarcpt_orgnl_file_name as original_file_name,
  case when DR.receiptstatus=''Completed'' then ''Downloaded'' 
  else DR.receiptstatus end as status,b.mandatory_feed
FROM PUB_ADMIN.dr_datarcpt_file_v DS, report_data DR, bl.bl_sbs_feed_master b
WHERE DS.DATASRC_ID       = DR.DATASRC_ID
and ds.DATASRC_NM = b.download_data_source_name
--AND DS.DO_NOT_PROCESS_IND = ''N''
AND UPPER(DS.DATASRC_NM) LIKE ''%DOWNLOAD%''
AND dr.datarcpt_orgnl_file_name NOT LIKE ''%.doc''
--AND is_leaf is not null
and DR.receiptstatus=''Completed''
and UPPER(DS.DATASRC_NM) in(
	''DOWNLOAD_NNA_PRICE'',
	''DOWNLOAD_NNA_SUPERSN'',
	''DOWNLOAD_NNA_SERVFILE'',
	''DOWNLOAD_NNA_PARTS'',
	''DOWNLOAD_NML_CD1_FEED'',
	''DOWNLOAD_NML_CD2_FEED'',
	''DOWNLOAD_NML_CD3_FEED'',
	''DOWNLOAD_NML_CD4_FEED'',
	''DOWNLOAD_NML_CD5_FEED'',
	''DOWNLOAD_NML_CD6_FEED'',
	''DOWNLOAD_NML_CD7_FEED'',
	''DOWNLOAD_SYNONYMS_FEED'',
	''DOWNLOAD_VA_PARTS_FEED'',
	''DOWNLOAD_ILLUSTRATION_CHANGE_EXCEL'',
	''DOWNLOAD_NNA_ILLUST_MASTER_EXCEL'',
	''DOWNLOAD_ATTACHMENT_GI'',
	''DOWNLOAD_ATTACHMENT_PRICEBOOK'',
	''DOWNLOAD_NIS_ILLUSTRATION_IMAGE_VC'',
	''DOWNLOAD_NIS_SVG_IMAGE_ZIP'',
	''DOWNLOAD_MODEL_IMAGE'',
	''DOWNLOAD_CHAPTER_IMAGE'',
	''DOWNLOAD_GROUPSECTION_FEED'',
	''DOWNLOAD_SBS_ILLUST_EXCEL''
	)
union all
select distinct a.download_data_source_name as DATA_SOURCE_NAME,null as ORIGINAL_FILE_NAME,''Not Received'' as STATUS,b.mandatory_feed
from 
(
	select distinct download_data_source_name
	from bl.bl_sbs_feed_master
	where download_data_source_name in(
	''DOWNLOAD_NNA_PRICE'',
	''DOWNLOAD_NNA_SUPERSN'',
	''DOWNLOAD_NNA_SERVFILE'',
	''DOWNLOAD_NNA_PARTS'',
	''DOWNLOAD_NML_CD1_FEED'',
	''DOWNLOAD_NML_CD2_FEED'',
	''DOWNLOAD_NML_CD3_FEED'',
	''DOWNLOAD_NML_CD4_FEED'',
	''DOWNLOAD_NML_CD5_FEED'',
	''DOWNLOAD_NML_CD6_FEED'',
	''DOWNLOAD_NML_CD7_FEED'',
	''DOWNLOAD_SYNONYMS_FEED'',
	''DOWNLOAD_VA_PARTS_FEED'',
	''DOWNLOAD_ILLUSTRATION_CHANGE_EXCEL'',
	''DOWNLOAD_NNA_ILLUST_MASTER_EXCEL'',
	''DOWNLOAD_ATTACHMENT_GI'',
	''DOWNLOAD_ATTACHMENT_PRICEBOOK'',
	''DOWNLOAD_NIS_ILLUSTRATION_IMAGE_VC'',
	''DOWNLOAD_NIS_SVG_IMAGE_ZIP'',
	''DOWNLOAD_MODEL_IMAGE'',
	''DOWNLOAD_CHAPTER_IMAGE'',
	''DOWNLOAD_GROUPSECTION_FEED'',
	''DOWNLOAD_SBS_ILLUST_EXCEL''
	)
	except
	SELECT DISTINCT DS.DATASRC_NM
	FROM PUB_ADMIN.dr_datarcpt_file_v DS, report_data DR
	WHERE DS.DATASRC_ID       = DR.DATASRC_ID
	--AND DS.DO_NOT_PROCESS_IND = ''N''
	AND UPPER(DS.DATASRC_NM) LIKE ''%DOWNLOAD%''
	AND dr.datarcpt_orgnl_file_name NOT LIKE ''%.doc''
	--AND is_leaf is not null
	and UPPER(DS.DATASRC_NM) in(
	''DOWNLOAD_NNA_PRICE'',
	''DOWNLOAD_NNA_SUPERSN'',
	''DOWNLOAD_NNA_SERVFILE'',
	''DOWNLOAD_NNA_PARTS'',
	''DOWNLOAD_NML_CD1_FEED'',
	''DOWNLOAD_NML_CD2_FEED'',
	''DOWNLOAD_NML_CD3_FEED'',
	''DOWNLOAD_NML_CD4_FEED'',
	''DOWNLOAD_NML_CD5_FEED'',
	''DOWNLOAD_NML_CD6_FEED'',
	''DOWNLOAD_NML_CD7_FEED'',
	''DOWNLOAD_SYNONYMS_FEED'',
	''DOWNLOAD_VA_PARTS_FEED'',
	''DOWNLOAD_ILLUSTRATION_CHANGE_EXCEL'',
	''DOWNLOAD_NNA_ILLUST_MASTER_EXCEL'',
	''DOWNLOAD_ATTACHMENT_GI'',
	''DOWNLOAD_ATTACHMENT_PRICEBOOK'',
	''DOWNLOAD_NIS_ILLUSTRATION_IMAGE_VC'',
	''DOWNLOAD_NIS_SVG_IMAGE_ZIP'',
	''DOWNLOAD_MODEL_IMAGE'',
	''DOWNLOAD_CHAPTER_IMAGE'',
	''DOWNLOAD_GROUPSECTION_FEED'',
	''DOWNLOAD_SBS_ILLUST_EXCEL''
	)
)a
inner join bl.bl_sbs_feed_master b
on (a.download_data_source_name = b.download_data_source_name)
ORDER BY 3,1', 2000, 'N', 'Y', NULL, 'Y', 'Y', 0, NULL, 'N');
INSERT INTO bl.bl_sbs_report_meta (report_group, report_name, report_status, report_subject, report_body, report_filename, report_query, report_max_rows, report_data_multilingual, report_publish_flag, report_details, header_required, report_date_required, report_count_threshold, rpt_transaction_config, rdvt_flag) VALUES('work_reports', 'rpt_nis_vin_no_mapping', 'D', 'WRK report : Vins unmapped report', 'Report shows VINs not mapped to any catalog', 'rpt_nis_vin_no_mapping.csv', ' WITH bl_vin_data 
   AS(
    SELECT DISTINCT vin.stop_mark,
           vin.vin_type,
           vin.serial_number,
           vin.model_prefix,
           vin.model_base,
           vin.model_suffix,
           vin.prod_year,
           vin.prod_month,
           vin.prod_day,
           vin.trim_color,
           vin.body_color,
           vin.plant_code,
           vin.scrap_year,
           vin.scrap_motnh,
           vin.settle_symbol,
           vin.mdl_base,
           vin.trial_veh_code,
           vin.maint_code,
           vin.veh_spec,
           vin.spec_seq,
           vin.not_narrow_dn_code,
           vin.aj_code,
           vin.country_code,
           vin.destination,
           vin.oversea_mode_symbol,
           vin.filler
     FROM bl.bl_f31x1340_vin vin
     where prod_year::int > 2017
	 --JOIN bl.bl_sbs_vincheck vincheck
     --ON SUBSTR(vin.vin_type,1,3) = vincheck.mfg_identifier
     --AND CONCAT(SUBSTR(vin.vin_type,vincheck.pos_1::integer,1),SUBSTR(vin.vin_type,vincheck.pos_2::integer,1)) = vincheck.check_string
     ),	  
  bl_vin 
	AS (
	SELECT vin.stop_mark,
           vin.vin_type,
           vin.serial_number,
           vin.model_prefix,
           vin.model_base,
           vin.model_suffix,
           vin.prod_year,
           vin.prod_month,
           vin.prod_day,
           vin.trim_color,
           vin.body_color,
           vin.plant_code,
           vin.scrap_year,
           vin.scrap_motnh,
           vin.settle_symbol,
           vin.mdl_base,
           vin.trial_veh_code,
           vin.maint_code,
           vin.veh_spec,
           vin.spec_seq,
           vin.not_narrow_dn_code,
           vin.aj_code,
           vin.country_code,
           vin.destination,
           vin.oversea_mode_symbol,
           vin.filler
    FROM bl_vin_data vin
    JOIN bl.bl_f31db157_min MIN
    ON CONCAT(vin.model_prefix,vin.model_base,vin.model_suffix) = MIN.eighteen_digit_model_code
	INNER JOIN bl.bl_sbs_catalog cat
	ON MIN.catalog_model = cat.model
    WHERE cat.status = ''Y''	
       )
      SELECT 
	         vin_type,
	         serial_number 
	   FROM  bl_vin 
	   WHERE prod_year IS NOT NULL
      EXCEPT
      SELECT vin_type,
	        serial_number 
	  FROM pub_work.vin_catalog_map_w;', NULL, 'N', 'Y', NULL, 'Y', 'Y', 0, NULL, 'Y');
INSERT INTO bl.bl_sbs_report_meta (report_group, report_name, report_status, report_subject, report_body, report_filename, report_query, report_max_rows, report_data_multilingual, report_publish_flag, report_details, header_required, report_date_required, report_count_threshold, rpt_transaction_config, rdvt_flag) VALUES('ctrg_reports', 'rpt_nis_app_threshold', 'D', 'CTRG report : App thresholds report', 'Report showing count breaching app thresholds', 'rpt_nis_app_threshold.csv', 'select *
from  (
					SELECT th.report_name,
					       th.warning_th warning_threshold,
					       th.critical_th critical_threshold,
					       cnt current_max_value, 
					       CASE WHEN  cnt >=   th.critical_th 
									THEN ''CRITICAL: STOP and Check with DEV Team immidiately ''
					            WHEN  cnt >=   th.warning_th and cnt <   th.critical_th 
									THEN ''WARNING: Check with DEV team''
					            WHEN  cnt <   th.warning_th 
									THEN ''NO ACTION NEEDED''
					       END AS  RECOMMENDED_ACTION        
						FROM (
					            SELECT MAX(no_of_chapters) cnt
					            FROM (
					                   SELECT catalog_id, Count(1) no_of_chapters 
					                   FROM   CTRG.CHAPTER 
					                   GROUP  BY CATALOG_ID
					                  )ch_cnt      
					             )MAX_CNT, 
					          BL.BL_SBS_CAPPS_THRESHOLDS TH 
					WHERE th.report_name = ''CHAPTER_PER_CATALOG''     
					UNION ALL
					/* PAGE_PER_CHAPTER */
					SELECT th.report_name,
					       th.warning_th warning_threshold,
					       th.critical_th critical_threshold,
					       cnt current_max_value, 
					            (
					            CASE WHEN  cnt >=   th.critical_th THEN ''CRITICAL: STOP and Check with DEV Team immidiately ''
					                 WHEN  cnt >=   th.warning_th and cnt <   th.critical_th THEN ''WARNING: Check with DEV team''
					                 WHEN  cnt <    th.warning_th THEN ''NO ACTION NEEDED''
					             END
					             )
					            AS  RECOMMENDED_ACTION        
					FROM   (
					            SELECT MAX(no_of_pages) cnt
					            FROM  (            
					                        SELECT chapter_id,Count(1) no_of_pages
					                        FROM   ctrg.chapter_page_x 
					                        GROUP  BY chapter_id
					                        )cnt
					              )max_cnt, 
					            BL.BL_SBS_CAPPS_THRESHOLDS TH 
					WHERE th.report_name = ''PAGE_PER_CHAPTER''       
					UNION ALL
					/* PART_ITEM_PER_PAGE_PER_IMAGE */
					SELECT th.report_name,
					       th.warning_th warning_threshold,
					       th.critical_th critical_threshold,
					       cnt current_max_value, 
					            (
					            CASE WHEN  cnt >=   th.critical_th THEN ''CRITICAL: STOP and Check with DEV Team immidiately ''
					                 WHEN  cnt >=   th.warning_th and cnt <   th.critical_th THEN ''WARNING: Check with DEV team''
					                 WHEN  cnt <    th.warning_th THEN ''NO ACTION NEEDED''
					             END
					             )
					            AS  RECOMMENDED_ACTION        
					FROM   (
					                SELECT MAX(no_of_parts) cnt 
					                FROM   ( 
					                                select page_id, image_id, count(part_item_id) no_of_parts 
													from ctrg.page_image_part_item_x
													group by page_id,image_id
					                              )cnt
					            )mx_cnt, 
					           BL.BL_SBS_CAPPS_THRESHOLDS TH 
					WHERE th.report_name = ''PART_ITEM_PER_PAGE_PER_IMAGE''       
					UNION ALL
					/* IMAGE_SIZE */
					SELECT th.report_name,
					       th.warning_th warning_threshold,
					       th.critical_th critical_threshold,
					       cnt current_max_value, 
					            (
					            CASE WHEN  cnt >=   th.critical_th THEN ''CRITICAL: STOP and Check with DEV Team immidiately ''
					                 WHEN  cnt >=   th.warning_th and cnt <   th.critical_th THEN ''WARNING: Check with DEV team''
					                 WHEN  cnt <    th.warning_th THEN ''NO ACTION NEEDED''
					             END
					             )
					            AS  RECOMMENDED_ACTION        
					FROM   (
					                SELECT MAX(IMG_SIZE) cnt 
					                FROM   ( 
					                            SELECT  ROUND (LENGTH(image_data)::numeric / 1048576, 2)        IMG_SIZE 
					                            FROM   ctrg.image_blob, 
					                                    ctrg.image 
					                            WHERE  image_blob.image_id = image.image_id
					                              )cnt
					            )mx_cnt, 
					           BL.BL_SBS_CAPPS_THRESHOLDS TH 
					WHERE th.report_name = ''IMAGE_SIZE''     
					UNION ALL
					/* PART_SUPERSESSION */ 
					SELECT th.report_name,
					       th.warning_th warning_threshold,
					       th.critical_th critical_threshold,
					       cnt current_max_value, 
					            (
					            CASE WHEN  cnt >=   th.critical_th THEN ''CRITICAL: STOP and Check with DEV Team immidiately ''
					                 WHEN  cnt >=   th.warning_th and cnt <   th.critical_th THEN ''WARNING: Check with DEV team''
					                 WHEN  cnt <    th.warning_th THEN ''NO ACTION NEEDED''
					             END
					             )
					            AS  RECOMMENDED_ACTION        
					FROM   (
					            SELECT Max(no_of_parts) cnt 
					            FROM   (
					                        select price_book_id, part_id,  COUNT(1) no_of_parts
					                        from    ctrg.part_supersession
					                        where  part_supersession_type = 1  
					                        group by price_book_id, part_id
					                         )cnt
					            )mx_cnt, 
					           BL.BL_SBS_CAPPS_THRESHOLDS TH 
					WHERE th.report_name = ''PART_SUPERSESSION_CHAIN''       
					UNION ALL
					/* PART_HISTORY */
					SELECT th.report_name,
					       th.warning_th warning_threshold,
					       th.critical_th critical_threshold,
					       cnt current_max_value, 
					            (
					            CASE WHEN  cnt >=   th.critical_th THEN ''CRITICAL: STOP and Check with DEV Team immidiately ''
					                 WHEN  cnt >=   th.warning_th and cnt <   th.critical_th THEN ''WARNING: Check with DEV team''
					                 WHEN  cnt <    th.warning_th THEN ''NO ACTION NEEDED''
					             END
					             )
					            AS  RECOMMENDED_ACTION        
					FROM   (
					            SELECT Max(no_of_parts) cnt 
					            FROM   (
					                        select price_book_id, part_id,  COUNT(1) no_of_parts
					                        from    ctrg.part_supersession
					                        where  part_supersession_type = 2  
					                        group by price_book_id, part_id
					                         )cnt
					            )mx_cnt, 
					           BL.BL_SBS_CAPPS_THRESHOLDS TH 
					WHERE th.report_name = ''PART_HISTORY_CHAIN''       
					UNION ALL
					/*PART_FILTER_EXPRESSION_LENGTH */
					SELECT th.report_name,
					       th.warning_th warning_threshold,
					       th.critical_th critical_threshold,
					       cnt current_max_value, 
					            (
					            CASE WHEN  cnt >=   th.critical_th THEN ''CRITICAL: STOP and Check with DEV Team immidiately ''
					                    WHEN  cnt >=   th.warning_th and cnt <   th.critical_th THEN ''WARNING: Check with DEV team''
					                    WHEN  cnt <   th.warning_th THEN ''NO ACTION NEEDED''
					             END
					             )
					            AS  RECOMMENDED_ACTION        
					FROM   (
					            SELECT MAX(filter_exp_length) cnt
					            FROM (
					                        SELECT length(ai.ae_fe) filter_exp_length 
					                        FROM   ctrg.part_item pi,
					                                    ctrg.ae_ids ai
					                        WHERE pi.row_ae_id = ai.ae_id            
					                       )cnt
									)mx_cnt, 
					         BL.BL_SBS_CAPPS_THRESHOLDS TH 
					WHERE th.report_name = ''PART_FILTER_EXPRESSION_LENGTH''     
					UNION ALL
					/* FILTER_ITEM_PER_PART_ITEM */
					SELECT th.report_name,
					       th.warning_th warning_threshold,
					       th.critical_th critical_threshold,
					       cnt current_max_value, 
					            (
					            CASE WHEN  cnt >=   th.critical_th THEN ''CRITICAL: STOP and Check with DEV Team immidiately ''
					                    WHEN  cnt >=   th.warning_th and cnt <   th.critical_th THEN ''WARNING: Check with DEV team''
					                    WHEN  cnt <   th.warning_th THEN ''NO ACTION NEEDED''
					             END
					             )
					            AS  RECOMMENDED_ACTION        
					FROM   (
					            SELECT Max(filter_item_count) cnt 
					            FROM   (SELECT part_item_id,catalog_id,Count(1) filter_item_count 
					                        FROM   ctrg.part_item_filter_x 
					                        GROUP  BY part_item_id,catalog_id
					                         )cnt
					            )mx_cnt, 
					          BL.BL_SBS_CAPPS_THRESHOLDS  TH 
					WHERE th.report_name = ''FILTER_ITEM_PER_PART_ITEM''       
					UNION ALL
					/* FILTER_ITEM_PER_PAGE */
					SELECT th.report_name,
					       th.warning_th warning_threshold,
					       th.critical_th critical_threshold,
					       cnt current_max_value, 
					            (
					            CASE WHEN  cnt >=   th.critical_th THEN ''CRITICAL: STOP and Check with DEV Team immidiately ''
					                    WHEN  cnt >=   th.warning_th and cnt <   th.critical_th THEN ''WARNING: Check with DEV team''
					                    WHEN  cnt <   th.warning_th THEN ''NO ACTION NEEDED''
					             END
					             )
					            AS  RECOMMENDED_ACTION        
					FROM   (
					            SELECT Max(filter_item_count) cnt 
					            FROM   (SELECT page_id, Count(1) filter_item_count 
					                        FROM   ctrg_support.page_filter_x 
					                        GROUP  BY page_id
					                         )cnt
					            )mx_cnt, 
					          BL.BL_SBS_CAPPS_THRESHOLDS  TH 
					WHERE th.report_name = ''FILTER_ITEM_PER_PAGE''       
					UNION ALL
					/* FILTER_ITEM_PER_CHAPTER */ 
					SELECT th.report_name,
					       th.warning_th warning_threshold,
					       th.critical_th critical_threshold,
					       cnt current_max_value, 
					            (
					            CASE WHEN  cnt >=   th.critical_th THEN ''CRITICAL: STOP and Check with DEV Team immidiately ''
					                    WHEN  cnt >=   th.warning_th and cnt <   th.critical_th THEN ''WARNING: Check with DEV team''
					                    WHEN  cnt <   th.warning_th THEN ''NO ACTION NEEDED''
					             END
					             )
					            AS  RECOMMENDED_ACTION        
					FROM   (
					            SELECT Max(filter_item_count) cnt 
					            FROM   (SELECT chapter_id,Count(1) filter_item_count 
					                        FROM   ctrg_support.chapter_filter_x 
					                        GROUP  BY chapter_id
					                         )cnt
					            )mx_cnt, 
					           BL.BL_SBS_CAPPS_THRESHOLDS TH 
					WHERE th.report_name = ''FILTER_ITEM_PER_CHAPTER''       
					UNION ALL
					/* FILTER_ITEM_PER_EQUIPMENT */ 
					SELECT th.report_name,
					       th.warning_th warning_threshold,
					       th.critical_th critical_threshold,
					       cnt current_max_value, 
					            (
					            CASE WHEN  cnt >=   th.critical_th THEN ''CRITICAL: STOP and Check with DEV Team immidiately ''
					                    WHEN  cnt >=   th.warning_th and cnt <   th.critical_th THEN ''WARNING: Check with DEV team''
					                    WHEN  cnt <   th.warning_th THEN ''NO ACTION NEEDED''
					             END
					             )
					            AS  RECOMMENDED_ACTION        
					FROM   (
					            SELECT Max(filter_item_count) cnt 
					            FROM   (
					                        SELECT    (SELECT Count(1) filter_item_count 
					                                        FROM   ctrg.equipment_filter_x ef
					                                       WHERE  ef.equipment_id = e.equipment_id
					                                       )
					                                       +
					                                        (SELECT Count(1) filter_item_count 
					                                        FROM   ctrg.equipment_nav_filter_x ef
					                                       WHERE  ef.equipment_id = e.equipment_id
					                                       ) filter_item_count
					                        FROM   ctrg.equipment e
					                         )cnt
					            )mx_cnt, 
					           BL.BL_SBS_CAPPS_THRESHOLDS TH 
					WHERE th.report_name = ''FILTER_ITEM_PER_EQUIPMENT'' 
					)
where recommended_action is not NULL		
and   recommended_action  <> ''NO ACTION NEEDED''', NULL, 'N', 'Y', '', 'Y', 'Y', 0, NULL, 'Y');
INSERT INTO bl.bl_sbs_report_meta (report_group, report_name, report_status, report_subject, report_body, report_filename, report_query, report_max_rows, report_data_multilingual, report_publish_flag, report_details, header_required, report_date_required, report_count_threshold, rpt_transaction_config, rdvt_flag) VALUES('bl_reports', 'rpt_unmapped_illust_image', 'D', 'BL report : Unmapped Illustration Image Report', 'Report shows Illustration Image which does not mapped with any catalog', 'rpt_unmapped_illust_image.csv', 'with illust_data as (
	select bsi.catalog,bsi.sec_num, bsi.img_name     
	FROM  bl.bl_sbs_illust bsi   
	UNION all 
	SELECT model as catalog,sec as sec_num,ill_no as image_name
	FROM  bl.bl_illustration_change           
	UNION 
	SELECT model as catalog,CONCAT(sec,sec_dif) sec_num,illust_no as image_name
	FROM   bl.bl_nna_illust_master 
),
image_data as (
select bi.img_name,bi.img_hash,bi.img_path,bi.img_type
FROM  pub_work.curr_run_image_data_w bi
WHERE bi.img_type in(''illustration'',''svg_illustration'') and right(img_name,2) <>''_t''
),
unmapped_image as (
select id.img_name from image_data id 
inner join bl.bl_image_data bi on id.img_name=bi.img_name
except 
select img_name from illust_data
)select unimg.img_name,
case when currunimg.img_type=''svg_illustration'' then ''SVG''
     when currunimg.img_type=''illustration'' then ''TIF''
	 else currunimg.img_type end as img_type
/*
      <SBS_PROLOG>
      * Project:  NISSAN DATA PUBLISHING
      * Purpose:  This report gives image name which does not mapped with any catalog
      *
      * PL/SQL Objects Used:
      *    <Object Type> - <Schema  Owner> - <Object Name>
      ===========================================================
      Revision History
      Ref #  Date           Revisor      Comment
      1		 03-Sep-2024    NKM 		 Initial version.
	  2.     20-Jan-2026    NKM          Update Image Reports to Support SVG Images(NSPUB-1433)
      ===========================================================
      Revisor
      *   [initials]    [Full Name]
      *   	NKM			 Nitish Kumar Mishra
      ===========================================================
      </SBS_PROLOG>
      <SBS_SRCTAB owner="BL" name="BL_IMAGE_DATA" />
	  <SBS_SRCTAB owner="BL" name="BL_SBS_ILLUST" />
	  <SBS_SRCTAB owner="BL" name="BL_ILLUSTRATION_CHANGE" />
	  <SBS_SRCTAB owner="BL" name="BL_NNA_ILLUST_MASTER" />
	  <SBS_SRCTAB owner="WORK" name="PRE_BL_IMAGE_DATA_W" />
      ********************************************************
	*/
	 
from unmapped_image unimg inner join curr_run_image_data_w currunimg 
on unimg.img_name=currunimg.img_name', NULL, 'N', 'Y', NULL, 'Y', 'Y', 0, NULL, 'Y');
INSERT INTO bl.bl_sbs_report_meta (report_group, report_name, report_status, report_subject, report_body, report_filename, report_query, report_max_rows, report_data_multilingual, report_publish_flag, report_details, header_required, report_date_required, report_count_threshold, rpt_transaction_config, rdvt_flag) VALUES('nis_bl_large_images', 'rpt_nis_bl_large_images', 'D', 'Nissan large Image report at bl level', 'Please find report of Nissan large Images at bl level.Description: This report is used to get list of Nissan large Images at bl level.Thanks, Publishing Team', 'rpt_nis_bl_large_images.csv', 'SELECT 
/**
    * <SBS_PROLOG>
    * PROJECT:  NISSAN DATA PUBLISHING
    * PURPOSE:  THIS VIEW IS USED TO LIST THE IMAGES WHICH has Size more than 2 mb.
    *
    * PL/SQL OBJECTS USED:
    *    <OBJECT TYPE> - <SCHEMA  OWNER> - <OBJECT NAME>
    *===========================================================
    * REVISION HISTORY
    * REF #  DATE          REVISOR      COMMENT
    * 1      25-07-23      NKM          Initial Revision
	* 2      20-Jan-2026   NKM          Update Image Reports to Support SVG Images(NSPUB-1433)
    *===========================================================
    * Revisor
    *   [initials]    [Full Name]
    *   NKM            Nitish Kumar Mishra
    *===========================================================
    * </SBS_PROLOG>
    * <SBS_SRCTAB owner="PUB_WORK" name="CURR_RUN_IMAGE_DATA_W" />
    * <SBS_DESTTAB OWNER="" NAME="" />
    * <SBS_PRCGRP name="" seq=""/>
    * Insert all other tag comments that are relevant
*/
pbidw.img_name, 
case when pbidw.img_type=''svg_illustration'' then ''SVG''
     when pbidw.img_type=''illustration'' then ''TIF''
	 else pbidw.img_type end as img_type, 
length(pbidw.img_data)/1024 as file_size_in_kb
FROM pub_work.curr_run_image_data_w pbidw
where round(length(pbidw.img_data)/1024) >
(select bsmh.en_us::integer from bl.bl_sbs_meta_header bsmh where bsmh.group_name = ''IMAGE_FILE_SIZE_THRESHOLD'')
and img_type not in(''pdf_gi'',''pricebook'')', NULL, 'N', 'Y', 'This report is used to get list of NISSAN large Images at bl level', 'Y', 'Y', 0, NULL, 'Y');
INSERT INTO bl.bl_sbs_report_meta (report_group, report_name, report_status, report_subject, report_body, report_filename, report_query, report_max_rows, report_data_multilingual, report_publish_flag, report_details, header_required, report_date_required, report_count_threshold, rpt_transaction_config, rdvt_flag) VALUES('prerequisite_reports', 'rpt_nis_images_incremental_xy', 'D', 'Image callout report : Image callout report for incremental images', 'Report is to identified callout which are avilable in text and not in image xml and callout which are avilable in image xml and not in text (for incremental images)', 'rpt_nis_images_incremental_xy.csv', 'with n1 as 
            (SELECT REPLACE(rid.img_callout_data,''xmlns="http://sbs.snapon.com/imageData"'','''')::xml AS source_xml,
                   rid.img_name,rid.img_type               
             FROM pub_work.curr_run_image_data_w rid
             INNER JOIN bl.bl_image_data bid 
             ON rid.img_name = bid.img_name 
             WHERE rid.img_type in (''illustration'',''svg_illustration'')
             AND rid.img_hash IS NOT NULL
             AND rid.img_callout_hash IS NOT NULL
             AND RIGHT(rid.Img_Name,2) <> ''_t''
			 ),
image_callout as (SELECT DISTINCT imv.catalog as model_ser_code
			            ,imv.sec_num 
                        ,unnest(xpath(''/imageData/callouts/callout/@label'', n1.source_xml))::varchar AS callout
                        ,n1.img_name,n1.img_type					
                  FROM n1
                  INNER JOIN pub_work.image_w_v imv
	              ON n1.img_name = imv.img_name
				  ),
 text_callout as  (
				    select distinct cl.code as mdl_ser_code ,ltrim(pg.code,''0'') sec_num, pi.callout,i.code as img_name,b.img_type
					from ctrg.image i
					inner join n1 b 
					on i.code=b.img_name
					inner join ctrg.page_image_part_item_x pix 
					on i.image_id=pix.image_id 
					inner join ctrg.part_item pi 
					on pix.part_item_id=pi.part_item_id
					inner join ctrg.page pg on pix.page_id=pg.page_id
					inner join ctrg.catalog cl 
					on cl.catalog_id=pi.catalog_id
					),
Images as (SELECT  im.catalog as mdl_ser_code,
				                  im.sec_num as sec_num,
								 im.img_name,pw.img_type
								  --string_agg(DISTINCT im.img_name, '','' ORDER BY im.img_name) as img_name
					             FROM pub_work.image_w_v im 
					             inner join n1 pw 
					             on pw.img_name=im.img_name
					            -- GROUP BY im.catalog,
					                 --   im.sec_num
		    )
SELECT h.catalog_page,
  ''"''|| REGEXP_REPLACE(h.callout, ''"'', ''""'',''g'') ||''"'' as callout,
  ''"''|| REGEXP_REPLACE(h.img_name, ''"'', ''""'',''g'') ||''"'' as img_name,
  h.description,
  h.report_type	,case wheN h.img_type =''svg_illustration''  then ''SVG'' 
                      wheN h.img_type =''illustration''  then ''TIF'' end as IMG_TYPE
FROM (  SELECT CONCAT(p.mdl_ser_code,''-'',p.sec_num) AS catalog_page,
  p.callout,
  P.img_name,
  p.description,
  p.report_type,p.img_type
  from (SELECT b.mdl_ser_code,
		 b.sec_num,
		 string_agg(DISTINCT b.callout, '','' ORDER BY b.callout) as callout,
		 im.img_name,b.img_type,
		 ''Illustration Key Numbers In The Text But Not In The Image'' AS description,
		 ''Y'' AS report_type
	FROM (SELECT tc.mdl_ser_code as mdl_ser_code,
				 tc.sec_num as sec_num,
				 tc.callout as callout,
				 tc.img_type
			FROM text_callout tc
			INNER JOIN pub_work.image_w_v imv
			ON tc.mdl_ser_code = imv.catalog
			AND tc.sec_num = imv.sec_num
			INNER JOIN pub_work.curr_run_image_data_w rid
			ON imv.img_name = rid.img_name
			EXCEPT
		   SELECT a.mdl_ser_code,
				  a.sec_num,
				  a.callout,a.img_type
			 FROM (SELECT DISTINCT ic.model_ser_code as mdl_ser_code,
						  ic.sec_num,
						  ic.callout,ic.img_type				                  
					 FROM image_callout ic
				  )a)b
   INNER JOIN Images im 
   ON im.mdl_ser_code = b.mdl_ser_code
   AND im.sec_num = b.sec_num
   GROUP BY b.mdl_ser_code,
			b.sec_num,
			im.img_name,b.img_type)p
		UNION ALL		 
SELECT CONCAT(g.mdl_ser_code,''-'',g.sec_num) as catalog_page,
		 g.callout,
		 g.img_name,
		 g.description,
		 g.report_type,g.img_type
	 FROM    (SELECT d.mdl_ser_code,
				d.sec_num,
				string_agg(DISTINCT d.callout, '','' ORDER BY d.callout) as callout,
				d.img_name,d.img_type,
				''Illustration Key Numbers In The Image But Not In The Text'' AS description,
				''X'' AS report_type
		 FROM (SELECT b.mdl_ser_code,
				b.sec_num,
				b.callout,
				b.img_name,b.img_type						
		  FROM (SELECT DISTINCT a.mdl_ser_code,
					   a.sec_num,
					   a.callout,
					   a.img_name,a.img_type
				 FROM 
					 (SELECT DISTINCT ic.model_ser_code as mdl_ser_code,
							 ic.sec_num,
							 ic.callout,
							 ic.img_name,ic.img_type										 
					   FROM image_callout ic
					  )a                                            						                                                                           
					WHERE EXISTS (SELECT 1 
								  FROM text_callout tc
								  WHERE tc.mdl_ser_code = a.mdl_ser_code
								  AND tc.sec_num = a.sec_num)
					  AND EXISTS (SELECT 1
								  FROM bl.bl_sbs_section bss                      
								  WHERE bss.mdl_ser_code = a.mdl_ser_code
								  AND bss.sec_num = a.sec_num))b
		   EXCEPT 
		   SELECT b.mdl_ser_code,
				  b.sec_num,
				  b.callout,
				  b.img_name,b.img_type					  
		   FROM                                                                                 
		   (SELECT tc.mdl_ser_code as mdl_ser_code,
				  tc.sec_num as sec_num,
				  tc.callout as callout,
				  imv.img_name,tc.img_type
			FROM text_callout tc
			INNER JOIN pub_work.image_w_v imv
			ON tc.mdl_ser_code = imv.catalog
			AND tc.sec_num = imv.sec_num
			)B
			)d
			GROUP BY d.mdl_ser_code,
					 d.sec_num,
					 d.img_name,d.img_type)g where not EXISTS (select 1 from text_callout b where g.mdl_ser_code=b.mdl_ser_code
					 and g.callout=b.callout))h
ORDER BY h.report_type,
			         h.img_name,
			         h.catalog_page', NULL, 'N', 'Y', NULL, 'Y', 'Y', 0, NULL, 'N');

INSERT INTO bl.bl_sbs_report_meta (report_group, report_name, report_status, report_subject, report_body, report_filename, report_query, report_max_rows, report_data_multilingual, report_publish_flag, report_details, header_required, report_date_required, report_count_threshold, rpt_transaction_config, rdvt_flag) VALUES('nis_image_not_processed', 'rpt_nis_image_not_processed', 'D', 'Image not Processed report', 'Please find report for Images not Processed attached.Description: This report is used to get list of images which is not processed.Thanks, Publishing Team', 'rpt_nis_image_not_processed.csv', 'select 
/**
    * <SBS_PROLOG>
    * PROJECT:  NISSAN DATA PUBLISHING
    * PURPOSE:  THIS VIEW IS USED TO LIST THE IMAGES WHICH WERE RECEIVED FROM OEM BUT WERE NOT PROCESSED.
    *
    * PL/SQL OBJECTS USED:
    *    <OBJECT TYPE> - <SCHEMA  OWNER> - <OBJECT NAME>
    *===========================================================
    * REVISION HISTORY
    * REF #  DATE          REVISOR      COMMENT
    * 1      25-07-23      NKM          Initial Revision
	* 2      20-Jan-2026   NKM          Update Image Reports to Support SVG Images(NSPUB-1433)
	* 3      01-05-2026    NKM          NSPUB-1488
    *===========================================================
    * Revisor
    *   [initials]    [Full Name]
    *   NKM            Nitish Kumar Mishra
    *===========================================================
    * </SBS_PROLOG>
    * <SBS_SRCTAB owner="PUB_WORK" name="PRE_BL_IMAGES_TO_PROCESS_W" />
    * <SBS_SRCTAB owner="PUB_WORK" name="PRE_BL_IMAGE_DATA_W" />
    * <SBS_DESTTAB OWNER="" NAME="" />
    * <SBS_PRCGRP name="" seq=""/>
    * Insert all other tag comments that are relevant
*/
''="''||Img_Name||''"'' Img_Name, 
CASE 
    WHEN img_type = ''illustration'' THEN ''="'' || ''TIF'' || ''"''
    WHEN img_type = ''svg_illustration'' THEN ''="'' || ''SVG'' || ''"''
	WHEN img_type = ''chapter'' THEN ''="'' || ''GROUP'' || ''"''
	WHEN img_type = ''model'' THEN ''="'' || ''MODEL'' || ''"''
	WHEN img_type = ''pdf_gi'' THEN ''="'' || ''GI'' || ''"''
    ELSE ''="'' || img_type || ''"''
END AS "img_type"
from (
SELECT
    CASE
        WHEN img_type = ''pdf_gi''
            THEN REPLACE(SPLIT_PART(img_name, ''.'', 1), ''_US'', '''')
        ELSE
            SPLIT_PART(img_name, ''.'', 1)
    END AS img_name,
    img_type
FROM pub_work.curr_run_source_image_w
except 
(
Select Img.Img_Name As Img_Name,img.img_type
From pub_work.curr_run_image_data_w Img
Inner Join pub_work.curr_run_image_data_w Img2 
On Img2.Img_Name = Img.Img_Name||''_t'' And Img2.Img_Name Like ''%_t''
Inner Join pub_work.curr_run_image_data_w Img3 
On Img3.Img_Name = Img.Img_Name and Img3.Img_Name not Like ''%_t'' and img3.img_callout_hash is not null
And Trim(Img.img_type) in (''illustration'',''svg_illustration'')
union all 
Select substring(img_name,1,length(img_name)-(strpos(reverse(img_name),''_''))) as Img_Name,Img_Type
From curr_run_image_data_w
Where Trim(Img_Type) = ''chapter''
union all 
Select substring(img_name,1,length(img_name)-(strpos(reverse(img_name),''_''))) as Img_Name,Img_Type
From curr_run_image_data_w
Where Trim(Img_Type) = ''model''
union all 
Select split_part(img_name,''.'',1)as Img_Name,Img_Type
From pub_work.curr_run_image_data_w
Where Trim(Img_Type) In (''pdf_gi'',''pricebook'')
))d where img_name <> ''*''', NULL, 'N', 'Y', 'This report is used to get list of images not processed', 'Y', 'Y', 0, NULL, 'Y');

INSERT INTO bl.bl_sbs_report_meta (report_group, report_name, report_status, report_subject, report_body, report_filename, report_query, report_max_rows, report_data_multilingual, report_publish_flag, report_details, header_required, report_date_required, report_count_threshold, rpt_transaction_config, rdvt_flag) VALUES('bl_reports', 'rpt_missing_svg_images', 'D', 'Missing SVG Image', 'Report shows missing SVG image names', 'rpt_missing_svg_images.csv', 'with svg_img_rcvd as (
				select split_part(img_name,''.'',1)as img_name from curr_run_source_image_w 
				where img_type=''svg_illustration'' 
					),
nna_illust_img as (
				select illust_no as img_name,model,concat(sec,sec_dif)as section,filename 
				from pre_bl_nna_illust_master_w 
				 ),
missing_svg as (
			select img_name from nna_illust_img
			except 
			select img_name from svg_img_rcvd
				)
select
 ms.img_name,
 nna.model,
 nna.section,
 nna.filename,
 ''This SVG illustration has not been received. Please notify NNA.'' AS action_needed
 from missing_svg ms 
 inner join nna_illust_img nna 
 on ms.img_name=nna.img_name
 order by 2,3', 2000, 'N', 'Y', NULL, 'Y', 'Y', 0, NULL, 'Y');
INSERT INTO bl.bl_sbs_report_meta (report_group, report_name, report_status, report_subject, report_body, report_filename, report_query, report_max_rows, report_data_multilingual, report_publish_flag, report_details, header_required, report_date_required, report_count_threshold, rpt_transaction_config, rdvt_flag) VALUES('downloaded_feeds_report', 'rpt_mandatory_feed_files_not_received', 'D', 'MANDATORY_FEED_FILES_NOT_RECEIVED', 'Hello Team,Please find the attached report for MANDATORY_FEED_FILES_NOT_RECEIVED.This report provides details of feed files which is mandatory feed but not received in current month', 'MANDATORY_FEED_FILES_NOT_RECEIVED.CSV', 'WITH LAST_PUB_RUN_DATE AS
(
 SELECT CASE WHEN MAX(datarcpt_t_rcrd_updt_ts) > MAX(datarcpt_t_rcrd_create_ts) 
  THEN MAX(datarcpt_t_rcrd_updt_ts) 
  ELSE MAX(datarcpt_t_rcrd_create_ts)
  END AS LAST_PR_DT FROM  pub_admin.dr_datarcpt_file_v
),
LAST_DR_PER_DS AS
(
  SELECT *
  FROM
  (SELECT DATASRC_ID,
          DATARCPT_ID,
          parentcontainerid,
          datarcpt_t_rcrd_create_ts,
          datarcpt_t_rcrd_updt_ts,
          receiptstatus,
          datarcpt_orgnl_file_name,datarcpt_loadplan_status_code
   FROM pub_admin.dr_datarcpt_file_v WHERE datarcpt_orgnl_file_name NOT LIKE ''%!%'' 
   AND datarcpt_t_rcrd_create_ts::date > (SELECT LAST_PR_DT::date - 1 FROM LAST_PUB_RUN_DATE)
  )a
),
 report_data as(
select rr.* from(
with recursive DR_ERRORS (DATASRC_ID,DATARCPT_ID,parentcontainerid, datarcpt_orgnl_file_name,receiptstatus ,datarcpt_loadplan_status_code, lev) AS
  (
    SELECT DATASRC_ID,
          DATARCPT_ID,
          parentcontainerid,
          datarcpt_orgnl_file_name,
          receiptstatus,
          datarcpt_loadplan_status_code,
          1 as lev
          FROM LAST_DR_PER_DS
    WHERE parentcontainerid is null
  UNION ALL
    SELECT e.DATASRC_ID,
          e.DATARCPT_ID,
          e.parentcontainerid,
          e.datarcpt_orgnl_file_name,
          e.receiptstatus,
          e.datarcpt_loadplan_status_code, 
          lev+1 as lev
    FROM   DR_ERRORS r, LAST_DR_PER_DS e
    WHERE  r.DATARCPT_ID = e.parentcontainerid
  ) search depth first by DATARCPT_ID set seq
  select oc.*, 
         case 
           when lead ( lev, 1, 1 ) over ( order by seq ) <= lev then ''LEAF''
         end is_leaf from DR_ERRORS oc
  )rr
   )
   select distinct a.download_data_source_name as DATA_SOURCE_NAME,''This Feed is mandtory which is not dowloaded at EPO,please check'' as action_needed
   from
(
	select download_data_source_name
	from bl.bl_sbs_feed_master where mandatory_feed=''Y''
	except
	SELECT DISTINCT DS.DATASRC_NM
	FROM PUB_ADMIN.dr_datarcpt_file_v DS, report_data DR
	WHERE DS.DATASRC_ID       = DR.DATASRC_ID
	AND UPPER(DS.DATASRC_NM) LIKE ''%DOWNLOAD_%''
	AND dr.datarcpt_orgnl_file_name NOT LIKE ''%.doc''
)a
inner join bl.bl_sbs_feed_master b
on (a.download_data_source_name = b.download_data_source_name)
ORDER BY 1', 2000, 'N', 'Y', NULL, 'Y', 'Y', 0, NULL, 'Y');
INSERT INTO bl.bl_sbs_report_meta (report_group, report_name, report_status, report_subject, report_body, report_filename, report_query, report_max_rows, report_data_multilingual, report_publish_flag, report_details, header_required, report_date_required, report_count_threshold, rpt_transaction_config, rdvt_flag) VALUES('ctrg_reports', 'rpt_nis_part_item_range', 'D', 'CTRG report : Part item range report', 'Report shows no of page per image count, based on part item count range', 'rpt_nis_part_item_range_per_page_per_image.csv', 'WITH N1 AS (SELECT pp.page_id,
                   pp.image_id,
                   COUNT(1) AS cnt
            FROM  ctrg.page_image_part_item_x pp
            INNER JOIN ctrg.part_item pi
            ON PI.part_item_id = pp.part_item_id
            --INNER JOIN ctrg.page_image_x pix         
		    --ON pix.page_id = pp.page_id         
		    --INNER JOIN callout c         
		    --ON c.image_id = pix.image_id         
			--AND c.part_item_id = pi.part_item_id
            GROUP BY pp.page_id,
                     pp.image_id)
       SELECT /**
           * <SBS_PROLOG>
           * Project:  Nissan Cornerstone Snap-on EPC 5
           * Purpose:  This View is used to shows no of page per image count, based on part item count range.
           *
           * PL/SQL Objects Used:
           *   <Object Type> - <Schema Owner> - <Object Name>
           *===========================================================
           * Revision History
           *   Ref #  Date          Revisor      Comment
	       *   1      20-JUN-2023   PR          Code updated according to postgres
           *===========================================================
           * Revisor   PR          PAWAN RAJAK                
           *===========================================================
           * </SBS_PROLOG>
           * <SBS_SRCTAB  owner="CTRG" name="PAGE" />
           * <SBS_PRCGRP name="OPERATIONS" seq=" "/>
           */ 
		      start_range as pi_count_start_range,
              end_range as pi_count_end_range,
              no_of_instances as no_of_instances_per_page_per_image
        FROM (
        	 /*SELECT ''200'' AS start_range,
                     ''500'' AS end_range,
                     COUNT(1) AS no_of_instances
               FROM (SELECT page_id,
                            image_id,
                            cnt
                     FROM  N1 
					 )a
               WHERE cnt >= 200
               AND cnt <= 500
              UNION ALL
              SELECT ''501''  AS start_range,
                     ''1000'' AS end_range,
                     COUNT(1) AS no_of_instances
               FROM (SELECT page_id,
                            image_id,
                            cnt
                     FROM  N1 
					 )a
              WHERE cnt >= 501
			  AND cnt <= 1000
             UNION ALL
             SELECT ''1001'' AS start_range,
                    ''1500'' AS end_range,
                    COUNT(1) AS no_of_instances
              FROM (SELECT page_id,
                           image_id,
                           cnt
                     FROM  N1 
					 )a
              WHERE cnt >= 1001
              AND cnt <= 1500
             UNION ALL
             SELECT ''1501'' AS start_range,
                    ''2000'' AS end_range,
                    COUNT(1) AS no_of_instances
              FROM  (SELECT page_id,
                            image_id,
                            cnt
                     FROM  N1 
					 )a
                WHERE cnt >= 1501
                AND cnt <= 2000
             UNION ALL
             SELECT ''2001'' AS start_range,
                    ''2500'' AS end_range,
                    COUNT(1) AS no_of_instances
              FROM  (SELECT page_id,
                            image_id,
                            cnt
                     FROM  N1 
					 )a
            WHERE cnt >= 2001
            AND cnt <= 2500      
           UNION ALL
             SELECT ''2501'' AS start_range,
                    ''3000'' AS end_range,
                    COUNT(1) AS no_of_instances
             FROM  (SELECT page_id,
                           image_id,
                           cnt
                     FROM  N1 
					 )a
               WHERE cnt >= 2501
               AND cnt <= 3000       
          UNION ALL
          SELECT ''3001'' AS start_range,
                 ''3500'' AS end_range,
                 COUNT(1) AS no_of_instances
            FROM (SELECT page_id,
                         image_id,
                         cnt
                   FROM  N1 
					 )a
            WHERE cnt >= 3001
            AND cnt  <= 3500    
            UNION ALL
            SELECT ''3501'' AS start_range,
                   ''4000'' AS end_range,
                   COUNT(1) AS no_of_instances
              FROM  (SELECT page_id,
                           image_id,
                           cnt
                     FROM  N1 
					 )a
               WHERE cnt >= 3501
               AND cnt <= 4000			   
         UNION ALL
         */
         SELECT ''4001'' AS start_range,
                ''4500'' AS end_range,
                COUNT(1) AS no_of_instances
           FROM (SELECT page_id,
                        image_id,
                        cnt
                  FROM  N1 
					 )a
          WHERE cnt >= 4001
          AND cnt <= 4500		  
         UNION ALL
          SELECT ''4501'' AS start_range,
                 ''5000'' AS end_range,
                 COUNT(1) AS no_of_instances
            FROM (SELECT page_id,
                        image_id,
                        cnt
                  FROM  N1 
					 )a
            WHERE cnt >= 4501
             AND cnt <= 5000
         UNION ALL
          SELECT ''5001'' AS start_range,
                 '''' AS end_range,
                 COUNT(1) AS no_of_instances
            FROM (SELECT page_id,
                        image_id,
                        cnt
                  FROM  N1 
					 )a
            WHERE cnt >= 5001
	        )g
	       where  no_of_instances > 0
		   ORDER BY LPAD(start_range,5,''0'')
', NULL, 'N', 'Y', '', 'Y', 'Y', 0, NULL, 'Y');



update bl.bl_sbs_report_meta
set   report_publish_flag = 'N'
where report_name in (
					'rpt_nis_vin_no_min',
					'rpt_nis_new_vin_check',
					'rpt_nis_new_partitems_filters',
					'rpt_nis_metadeta_filters',
					'rpt_nis_partitemnopart',
					'rpt_nis_equip_no_thmbnls',
					'rpt_nis_partitemnopage',
					'rpt_nis_noimageblob'
					);
									
update bl.bl_sbs_report_meta bsrm 
set   report_group = 'prerequisite_reports'
where  report_name in (
						'rpt_nis_missing_sections',
						'rpt_image_to_process',
						'rpt_nis_images_incremental_xy'
						);	

update bl.bl_sbs_report_meta 
set report_name='rpt_nis_page_without_illust' 
where report_name='rpt_nis_thumbimage';




update bl.bl_sbs_report_meta
set   rdvt_flag = 'Y'
where report_name in (	'rpt_missing_svg_images',
						'rpt_unmapped_illust_image',
						'rpt_nf_partitems_filters',
						'rpt_nis_missing_spec_seq',
						'rpt_nis_part_item_range',
						'rpt_nis_app_threshold',
						'rpt_nis_page_without_illust',
						'PRC_VLD_ILPGPINOCL_RPT',
						'PRC_VLD_NOIMGBLOB_RPT',
						'PRC_VLD_ORPHAN_PG_RPT',
						'PRC_VLD_NOEQTHM_RPT',
						'PRC_VLD_MSSNGCLOT_RPT',
						'PRC_VLD_PRTITMNOPG_RPT',
						'PRC_VLD_ORPHANIMG_RPT',
						'PRC_VLD_PRTITMNOPT_RPT',
						'PRC_VLD_ORPHANCAT_RPT',
						'PRC_VLD_NOPGTHMBNL_RPT',
						'rpt_mandatory_feed_files_not_received',
						'rpt_zero_byte_feed_files_received',
						'lvt_lucene_verification_report',
						'rpt_nis_bl_large_images',
						'rpt_nis_image_not_processed',
						'rdvt_bl_threshold_breach_report',
						'rdvt_ctrg_threshold_breach_report',
						'rpt_nis_vin_appl_overlap',
						'rpt_nis_vin_no_mapping',
						'rpt_nis_chapter_without_image'
					);