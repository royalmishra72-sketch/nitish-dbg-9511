Delete from bl.bl_sbs_report_meta where report_name in (
'rpt_image_to_process',
'rpt_nis_image_qa',
'rpt_nis_images_incremental_xy',
'rpt_unmapped_illust_image'
);


INSERT INTO bl.bl_sbs_report_meta (report_group, report_name, report_status, report_subject, report_body, report_filename, report_query, report_max_rows, report_data_multilingual, report_publish_flag, report_details, header_required, report_date_required, report_count_threshold, rpt_transaction_config, rdvt_flag) VALUES('work_reports', 'rpt_nis_image_qa', 'D', 'QA report : Image QA report', 'Report to identified image for different TEST_TYPE(NEW,REGRESSION,UPDATED)', 'rpt_nis_image_qa.csv', '
WITH 
  part_sec_data as
                 (
                   SELECT DISTINCT wp.mdl_ser_code,
				          wp.sec_num 
				   FROM  pub_work.merge_parts_w WP
                  ),
  image_data as 
               (
              SELECT bi.img_name,
                     bi.img_hash,
                     bi.img_path,
                     bi.img_callout_hash, 
                     bi.img_callout_path,
                     bi.attribute1
               FROM  pub_work.image_data_w bi
			   WHERE bi.attribute1 = ''NIS_ILLUSTRATIONS''
                ),
  image_data_h as 
               (
               /*
			  SELECT bi.img_name,
                     bi.img_hash,
                     bi.img_path,
                     bi.img_callout_hash, 
                     bi.img_callout_path,
                     bi.attribute1
               FROM  pub_work.bl_image_data_h bi 
			   WHERE bi.attribute1 = ''NIS_ILLUSTRATIONS''
			   */
				  SELECT bi.img_name,
	                     bi.img_hash,
	                     bi.img_path,
	                     bi.img_callout_hash, 
	                     bi.img_callout_path,
	                     bi.attribute1
				from   pub_work.bl_image_data_h bi
				where  attribute2 in (''SVG'') 
				and    attribute1 in(''NIS_ILLUSTRATIONS'')
				and 	Img_Name in (select illust_no from pub_work.bl_nna_illust_master_h)
				union all 
				  SELECT t.img_name,
	                     t.img_hash,
	                     t.img_path,
	                     t.img_callout_hash, 
	                     t.img_callout_path,
	                     t.attribute1
				from   pub_work.bl_image_data_h t
				where  t.attribute2 in (''TIF'') 
				and    t.attribute1 in(''NIS_ILLUSTRATIONS'')
				and    not exists (
								   select 1 
								   from   pub_work.bl_image_data_h s
								   where  t.img_name = s.img_name 
								   and    t.attribute1 = s.attribute1
								   and    s.attribute2 in (''SVG'') 
								   and    t.Img_Name in (select illust_no from pub_work.bl_nna_illust_master_h )
									)
			   ),
  nis_img_latest as
         ( /** <SBS_RULE> THIS CLAUSE WILL FETCH IMAGE INFOMATION FOR THE IMAGES PRESENT IN BL_IMAGE_DATA.</SBS_RULE> **/
            SELECT DISTINCT catalog,
                   chapter_code,
				   chapter_desc,
                   page_code,
                   page_desc,
                   image_name,
                   img_hash,
                   img_path,
                   img_callout_hash, 
                   img_callout_path,
                   attribute1
              FROM (SELECT DISTINCT bs.mdl_ser_code as catalog,
                           bs.grp_num as chapter_code,
						   bs.group_desc as chapter_desc,
                           bs.sec_num as page_code,
                           bs.sec_desc as page_desc,
                           bi.img_name as image_name,
                           bi.img_hash,
                           bi.img_path,
                           bi.img_callout_hash, 
                           bi.img_callout_path,
                           bi.attribute1
                     FROM  image_data bi 
					 INNER JOIN pub_work.image_w_v iwv 
					 ON bi.img_name = iwv.img_name					 
                     INNER JOIN bl.bl_sbs_section bs
					 ON iwv.catalog = bs.mdl_ser_code
					 AND iwv.sec_num = BS.SEC_NUM                           
                     INNER JOIN part_sec_data WP 
                     ON bs.mdl_ser_code = wp.mdl_ser_code 
					 AND bs.sec_num = wp.sec_num                             					 
                   ) b
             ) ,             
   nis_img_history
        AS ( /** <SBS_RULE> THIS CLAUSE WILL FETCH IMAGE INFOMATION FOR THE IMAGES PRESENT IN BL_IMAGE_DATA_H.</SBS_RULE> **/
            SELECT DISTINCT catalog,
                   chapter_code,
				   chapter_desc,
                   page_code,
                   page_desc,
                   image_name,
                   img_hash,
                   img_path,
                   img_callout_hash, 
                   img_callout_path,
                   attribute1
             FROM (SELECT DISTINCT bs.mdl_ser_code as catalog,
			               bs.grp_num as chapter_code,
						   bs.group_desc as chapter_desc,
                           bs.sec_num as page_code,
                           bs.sec_desc as page_desc,
                           bi.img_name as image_name,
                           bi.img_hash,
                           bi.img_path,
                           bi.img_callout_hash, 
                           bi.img_callout_path,
                           bi.attribute1
                     FROM  image_data_h bi 
					 INNER JOIN pub_work.image_w_v iwv 
					 ON bi.img_name = iwv.img_name					 
                     INNER JOIN pub_work.bl_sbs_section_h bs
					 ON iwv.catalog = bs.mdl_ser_code
					 AND iwv.sec_num = BS.SEC_NUM                           
                     INNER JOIN part_sec_data WP 
                     ON bs.mdl_ser_code = wp.mdl_ser_code 
					 AND bs.sec_num = wp.sec_num 
				  )b
           ),
        new_img
        AS (  /*<SBS_RULE> THIS CLAUSE WILL FETCH 4 IMAGES THAT ARE NEWLY ADDED IN BL_IMAGE_DATA.</SBS_RULE> */
            SELECT b.catalog,
			      (SELECT model_desc FROM bl.bl_sbs_catalog c WHERE b.catalog = c.model) as catalog_desc,
                  (SELECT CONCAT(from_date,''-'',to_date) FROM bl.bl_sbs_catalog c WHERE b.catalog = c.model) as year,				  
				   b.chapter_code,
				   b.chapter_desc,
				   b.page_code,
				   b.page_desc,
				   b.image_name,
				   b.test_type,
				   b.pass_or_fail
			 FROM  (SELECT catalog,
                           chapter_code,
						   chapter_desc,
                           page_code,
                           page_desc,
                           image_name,
                           ''NEW'' as test_type,
                           null as pass_or_fail,
				           row_number() OVER (order by random()) as r_dom
                     FROM (SELECT catalog,
					              chapter_code,
                                  chapter_desc,
                                  page_code,
                                  page_desc,
                                  image_name
                             FROM nis_img_latest
                            EXCEPT
                            SELECT catalog,
                                   chapter_code,
                                   chapter_desc,
                                   page_code,
                                   page_desc,
                                   image_name
                              FROM nis_img_history
						  )c
					)b				 
             WHERE b.r_dom <= 4               
			  ) ,
		updated_img
        AS (  --<SBS_RULE> THIS CLAUSE WILL FETCH 4 IMAGES THAT ARE UPDATED IN BL_IMAGE_DATA </SBS_RULE> 
            SELECT p.catalog,
			       (SELECT model_desc FROM bl.bl_sbs_catalog c WHERE p.catalog = c.model) as catalog_desc,
			       (SELECT concat(from_date,''-'',to_date) FROM pub_work.bl_sbs_catalog_h c WHERE p.catalog = c.model) as year,
				   p.chapter_code,
				   p.chapter_desc,
				   p.page_code,
				   p.page_desc,
				   p.image_name,
				   p.test_type,
				   p.pass_or_fail
			FROM (SELECT catalog,			       
                         chapter_code,
						 chapter_desc,
                         page_code,
                         page_desc,
                         image_name,
                         ''UPDATED'' AS test_type,
                         null as pass_or_fail,
				         row_number() OVER (order by random()) as r_dom
                   FROM (SELECT a.image_name,
                                a.img_hash,
                                a.img_path,
                                a.img_callout_hash,
                                a.img_callout_path,
                                a.attribute1,
                                a.catalog,
                                a.chapter_code,
								a.chapter_desc,
                                a.page_code,
                                a.page_desc
                          FROM nis_img_latest a
                          INNER JOIN nis_img_history b
                          ON a.image_name = b.image_name
                          WHERE A.IMG_HASH <> B.IMG_HASH
                          OR a.img_path <> b.img_path
                          OR a.img_callout_hash <> b.img_callout_hash
                          OR a.img_callout_path <> b.img_callout_path
                          OR a.attribute1 <> b.attribute1
						 )l
				)p
            WHERE p.r_dom <= 4
              ),			  
			  common_img
        AS ( /** <SBS_RULE> THIS CLAUSE WILL FETCH 4 IMAGES THAT UNCHANGED RECORDS IN BL_IMAGE_DATA</SBS_RULE> **/
            SELECT l.catalog,
			       (SELECT model_desc FROM bl.bl_sbs_catalog c WHERE l.catalog = c.model) as catalog_desc,
                   (SELECT concat(from_date,''-'',to_date) FROM bl.bl_sbs_catalog c WHERE l.catalog = c.model) as year,
				   l.chapter_code,
				   l.chapter_desc,
				   l.page_code,
				   l.page_desc,
				   l.image_name,
				   l.test_type,
				   l.pass_or_fail
			 FROM  (SELECT catalog,
                           chapter_code,
						   chapter_desc,
                           page_code,
                           page_desc,
                           image_name,
                           ''REGRESSION'' as test_type,
                           null as pass_or_fail,
					       row_number() OVER (order by random()) as r_dom
                      FROM (SELECT image_name,
                                   img_hash,
                                   img_path,
                                   img_callout_hash,
                                   img_callout_path,
                                   attribute1,
                                   catalog,
                                   chapter_code,
								   chapter_desc,
                                   page_code,
                                   page_desc
                             FROM nis_img_latest
                           INTERSECT
                           SELECT image_name,
                                  img_hash,
                                  img_path,
                                  img_callout_hash,
                                  img_callout_path,
                                  attribute1,
                                  catalog,
                                  chapter_code,
								  chapter_desc,
                                  page_code,
                                  page_desc
                             FROM nis_img_history
							)k
					)l					  
               WHERE l.r_dom <= 4
					  )
			 /*
         * <SBS_PROLOG>
         * Project:  NISSAN DATA PUBLISHING
         * Purpose:  This view is used in the population of the report for CHAPTER without thumbnails table.
         *
         * PL/SQL Objects Used:
         *   <Object Type> - <Schema Owner> - <Object Name>
         *===========================================================
         * Revision History
         *   Ref #  Date         Revisor      Comment
         *   1      11/03/2016   DM          Initial revision
		 *   2      12/06/2023   PR          View updated to postgres
		 *   3      17/10/2023   PR          Update image code
		 *   4      04/08/2026   CB          used image_data_w instead of bl_image_data. image_data_h also updated.   
         *===========================================================
         * Revisor
         *   DM            DIVYA MITTAL
		 *   PR            PAWAN RAJAK
		 *   CB            CHANDAN BHATIA
         *===========================================================
         * </SBS_PROLOG>
         *<SBS_SRCTAB owner="BL" name="BL_SBS_SECTION" />
         *<SBS_SRCTAB owner="PUB_WORK" name="BL_IMAGE_DATA_H" />
         *<SBS_SRCTAB owner="PUB_WORK" name="IMAGE_DATA_W" />
         * <SBS_SRCTAB  owner="PUB_WORK" name="MERGE_PARTS_W" />
         * <SBS_SRCTAB  owner="BL" name="BL_SBS_GROUP_IMAGE" />
         */
     SELECT	 year,
	        ''="''|| REGEXP_REPLACE(catalog_code, ''"'', ''""'',''g'') ||''"'' as catalog_code,
	        ''"''|| REGEXP_REPLACE(catalog_desc, ''"'', ''""'',''g'') ||''"'' as catalog_desc,            
			''="''|| REGEXP_REPLACE(chapter_code, ''"'', ''""'',''g'') ||''"'' as chapter_code,
			''"''|| REGEXP_REPLACE(chapter_desc, ''"'', ''""'',''g'') ||''"'' as chapter_desc,
			''="''|| REGEXP_REPLACE(page_code, ''"'', ''""'',''g'') ||''"'' as page_code,
			''"''|| REGEXP_REPLACE(page_desc, ''"'', ''""'',''g'') ||''"'' as page_desc,
            image_name as image_name,
            test_type
            --pass_or_fail
       FROM( SELECT year,
	                catalog as catalog_code,
	                catalog_desc as catalog_desc,                   
                    chapter_code as chapter_code,
					chapter_desc as chapter_desc,
                    page_code as page_code,
                    page_desc as page_desc,
                    image_name as image_name,
                    test_type,
                    pass_or_fail
               FROM (SELECT year,
			                catalog,
			                catalog_desc,                           
                            chapter_code,
							chapter_desc,
                            page_code,
                            page_desc,
                            image_name,
                            test_type,
                            pass_or_fail
                     FROM NEW_IMG 
                     UNION ALL 
                     SELECT year,
					        catalog,
			                catalog_desc,                            
                            chapter_code,
							chapter_desc,
                            page_code,
                            page_desc,
                            image_name,
                            test_type,
                            pass_or_fail
                       FROM updated_img
                      UNION ALL
                      SELECT year,
					         catalog,
			                 catalog_desc,                            
                             chapter_code,
							 chapter_desc, 
                             page_code,
                             page_desc,
                             image_name,
                             test_type,
                             pass_or_fail
                        FROM common_img)b
             )u
	 ORDER BY test_type', NULL, 'N', 'Y', '', 'Y', 'Y', 0, NULL, 'N');
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
select id.img_name 
from image_data id 
/*inner join bl.bl_image_data bi on id.img_name=bi.img_name*/
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
	  3.     5-Aug-2026     CB           join to bl_image_data removed as it is not needed. 
      ===========================================================
      Revisor
      *   [initials]    [Full Name]
      *   	NKM			 Nitish Kumar Mishra
      *     CB           Chandan Bhatia
      ===========================================================
      </SBS_PROLOG>
      <SBS_SRCTAB owner="BL" name="BL_SBS_ILLUST" />
	  <SBS_SRCTAB owner="BL" name="BL_ILLUSTRATION_CHANGE" />
	  <SBS_SRCTAB owner="BL" name="BL_NNA_ILLUST_MASTER" />
	  <SBS_SRCTAB owner="WORK" name="PRE_BL_IMAGE_DATA_W" />
      ********************************************************
	*/	 
from unmapped_image unimg inner join curr_run_image_data_w currunimg 
on unimg.img_name=currunimg.img_name
', NULL, 'N', 'Y', NULL, 'Y', 'Y', 0, NULL, 'Y');
INSERT INTO bl.bl_sbs_report_meta (report_group, report_name, report_status, report_subject, report_body, report_filename, report_query, report_max_rows, report_data_multilingual, report_publish_flag, report_details, header_required, report_date_required, report_count_threshold, rpt_transaction_config, rdvt_flag) VALUES('prerequisite_reports', 'rpt_image_to_process', 'D', 'Image to Process in current publishing cycle', 'Hello Team,Nissan catalog image sync process completed successfully.Actions done:- Catalog images synced- Missing images identifiedPlease load these images in the current publishing cycle.Regards,Nissan Publishing Team', 'rpt_image_to_process.csv', 'WITH all_pdf_received AS (
    -- All received PDFs
    SELECT  
        REPLACE(datarcpt_orgnl_file_name, ''_US.pdf'', '''') AS catalog,
        to_char(
            to_date(replace(datarcpt_rltv_drctry_path_name, ''/'', ''''), ''YYMMDD''),
            ''YYYYMM''
        )::numeric AS rcvd_date
    FROM pub_admin.dr_datarcpt_file_v
    WHERE datasrc_nm = ''DOWNLOAD_CATALOG_PDF''
),
curr_cat_pdfs AS (
    -- Only catalogs having PDF in current month
    select *
		from   all_pdf_received p
		where  p.catalog in ( /* only current catalogs*/
							select catalog
							from   all_pdf_received
							where  rcvd_date = to_char(CURRENT_DATE,''YYYYMM'')::numeric				  
							)
    )
,
all_images AS (
    -- All images
    SELECT  
        model AS catalog,
        to_char(row_create_ts,''YYYYMM'')::numeric AS rcvd_date,
        illust_no,
        concat(sec, sec_dif) AS section
    FROM bl.bl_nna_illust_master
    UNION ALL
    SELECT  
        model AS catalog,
        to_char(row_create_ts,''YYYYMM'')::numeric AS rcvd_date,
        ill_no AS illust_no,
        sec AS section
    FROM bl.bl_illustration_change
),
images_filtered AS (
    -- Only images of catalogs rcvd in current month
    SELECT i.*
    FROM all_images i
    JOIN curr_cat_pdfs p
        ON i.catalog = p.catalog
)
,images_to_be_published AS (
    SELECT 
        iwe.catalog,
        iwe.illust_no,
        iwe.section
    FROM images_filtered iwe
    LEFT JOIN (select img_name, 
    				  max(row_last_update_ts) as row_last_update_ts,
    				  max(row_create_ts) as row_create_ts
    			from bl.bl_image_data d
       			where attribute1 = ''NIS_ILLUSTRATIONS''
       			group by img_name
    			) d
        ON d.img_name = iwe.illust_no
    WHERE 
        -- Missing image in target
        d.img_name IS NULL
        OR to_char(coalesce(d.row_last_update_ts, d.row_create_ts),''YYYYMM'')::numeric < iwe.rcvd_date
)
SELECT distinct 
    catalog AS model,
    illust_no AS illust_name,
    section
FROM images_to_be_published
ORDER BY model, section, illust_name', 2000, 'Y', 'Y', NULL, 'Y', 'Y', 0, NULL, 'N');
INSERT INTO bl.bl_sbs_report_meta (report_group, report_name, report_status, report_subject, report_body, report_filename, report_query, report_max_rows, report_data_multilingual, report_publish_flag, report_details, header_required, report_date_required, report_count_threshold, rpt_transaction_config, rdvt_flag) VALUES('prerequisite_reports', 'rpt_nis_images_incremental_xy', 'D', 'Image callout report : Image callout report for incremental images', 'Report is to identified callout which are avilable in text and not in image xml and callout which are avilable in image xml and not in text (for incremental images)', 'rpt_nis_images_incremental_xy.csv', 'with n1 as 
            (SELECT REPLACE(rid.img_callout_data,''xmlns="http://sbs.snapon.com/imageData"'','''')::xml AS source_xml,
                   rid.img_name,rid.img_type               
             FROM pub_work.curr_run_image_data_w rid
             INNER JOIN image_data_w bid 
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
