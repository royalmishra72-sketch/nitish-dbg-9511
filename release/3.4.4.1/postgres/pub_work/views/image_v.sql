CREATE or REPLACE VIEW pub_work.image_v as 
 WITH 
   dod AS 
   ( /*<SBS_RULE> Single value NIS|ALL will be used for all DATA_ORIGIN_ID </SBS_RULE>*/
    SELECT dod.data_origin_id AS data_origin_id
    FROM ctrg_support.data_origin dod
    WHERE dod.dur_uk = 'NIS|ALL'
   ),
   bl_image_data_illust AS 
   (
    SELECT distinct img_name,
           attribute1,
           mdl_ser_code,
           sec_num
    FROM
        ( SELECT bid.img_name,
                 bid.attribute1,
				 iw.catalog as mdl_ser_code,
				 iw.sec_num	as sec_num		 				 
               /* split_part(Img_Name, '-', 1) as mdl_ser_code,
                CASE WHEN length(Img_Name) - length(REPLACE(Img_Name,'-','')) = 1
				     THEN split_part(Img_Name, '-', 2)
                     WHEN length(Img_Name) - length(REPLACE(Img_Name,'-','')) = 2
				     THEN split_part(Img_Name, '-', 2)
                END AS sec_num*/				
            FROM image_data_w bid
			INNER JOIN pub_work.image_w iw
			ON bid.img_name = iw.img_name
            WHERE attribute1 = 'NIS_ILLUSTRATIONS'
            AND TRIM(bid.img_name) IS NOT null
         )a
    ),
    bl_image_data_no_img AS 
	(
    SELECT img_name,
           attribute1
    FROM image_data_w
    WHERE img_name = 'NO_IMAGE'
    ),
	bl_image_model AS 
	(	
    SELECT attribute1,
           img_name
    FROM image_data_w
    WHERE attribute1 = 'NISSAN-MODEL'
    AND TRIM(img_name) IS NOT NULL
    ),
	bl_image_group AS 
	(
    SELECT attribute1,
           img_name
    FROM   image_data_w
    WHERE attribute1 = 'NISSAN-GROUP'
    AND TRIM(img_name) IS NOT NULL
    ),
	bl_sbs AS 
	(
     SELECT bl.mdl_ser_code,
		    CASE WHEN bl.sec_num = '000' THEN 0::text
                 WHEN bl.sec_num= '000A' THEN '0A'
                 ELSE ltrim(bl.sec_num::text, '0'::text)
				 END as sec_num              
     FROM bl.bl_sbs_section bl
    ),
	default_value AS
	( SELECT dur_uk_id
	  FROM ctrg_support.image_dict_key_ids imd
	  WHERE dur_uk = '*'
     )	
	SELECT /**
          * <SBS_PROLOG>
          * Project:  NISSAN DATA PUBLISHING
          * Purpose:  This view is used in the population of the IMAGE table.
          *
          * PL/SQL Objects Used:
          *   <Object Type> - <Schema Owner> - <Object Name>
          *===========================================================
          * Revision History
          *   Ref #  Date          Revisor      Comment
          *   1      27-07-2015    AB          Initial revision
          *   2      08-11-2019    AK          NSPUB-242: Modified code to directly pick img_name without any modification from BL for Model and Group.
		  *   3      29-05-2023    PR          View updated according to postgres
		  *   4      26-06-2023    PR          NSPUB-537: Modified code to join pub_work.image_w with bl.bl_image_data on behalf on img_name.
		  *   5      18-07-2023    CB          Join to image_dict_key_ids removed as default image_dict_id has been populated. 	
		  *   6      03-08-2026    CB          Replaced bl.bl_image_data with image_data_w	
          *===========================================================
          * Revisor
          *   AB            ABHINAV BANSAL
          *   AK            AMARDEEP KAUR
		  *   PR            PAWAN RAJAK
		  *   CB            Chandan Bhatia 
          *===========================================================
          * </SBS_PROLOG>
          * <SBS_SRCTAB  owner="CTRG_SUPPORT" name="Data_Origin"/>
		  * <SBS_SRCTAB  owner="PUB_WORK" name="IMAGE_DATA_W" /> 
          * <SBS_DESTTAB owner="CTRG" name="IMAGE" />
          * <SBS_PRCGRP name="LOAD_UPPER_NAVIGATION" seq="1"/>
          */
 --key_to_id('IMAGE',Mi.Img_Name
--ILLUSTRATIONS--
		distinct 
        CONCAT(mi.img_name,'|',mi.attribute1) as dur_uk,
		dd.dur_uk_id as image_dict_id,
	    mi.img_name as code, 
        null as flex1,
        null as flex2,
        null as flex3,
        null as flex4,
        null as flex5,
        null as flex6,
        null as flex7,
        null as flex8,
        null as flex9,
        null as flex10,
		null::integer as p_range_from,
        null::integer as p_range_to,
        null::integer as m_range_from,
        null::integer as m_range_to,
        dod.data_origin_id AS data_origin_id,
		null as uc_nk1,
        null as uc_nk2,
        null as uc_nk3,
        null as uc_nk4,
        null as direct_filter_1,
        null as direct_filter_2,
        null as direct_filter_3,
        null as direct_filter_4,
        null as direct_filter_5,
		0::boolean as archivable_ind,
        1::boolean as valid_for_media_ind,
        null::integer as row_ae_id
   FROM bl_image_data_illust mi
   CROSS JOIN dod
   CROSS JOIN default_value dd
   INNER JOIN bl_sbs bss 
   ON ( mi.mdl_ser_code = bss.mdl_ser_code
   AND mi.sec_num = bss.sec_num)
   UNION ALL
   --NO_IMAGE--
   SELECT CONCAT(mi.img_name,'|',mi.attribute1) as dur_uk,
          COALESCE(mdki.dur_uk_id,dd.dur_uk_id) as image_dict_id,
	      mi.img_name AS code,
          null as flex1,
          null as flex2,
          null as flex3,
          null as flex4,
          null as flex5,
          null as flex6,
          null as flex7,
          null as flex8,
          null as flex9,
          null as flex10,
		  null::integer as p_range_from,
          null::integer as p_range_to,
          null::integer as m_range_from,
          null::integer as m_range_to,
          dod.data_origin_id as data_origin_id,
		  null as uc_nk1,
          null as uc_nk2,
          null as uc_nk3,
          null as uc_nk4,
          null as direct_filter_1,
          null as direct_filter_2,
          null as direct_filter_3,
          null as direct_filter_4,
          null as direct_filter_5,
		  0::boolean as archivable_ind,
          1::boolean as valid_for_media_ind,
          null::integer as row_ae_id
    FROM bl_image_data_no_img mi
    CROSS JOIN dod
	CROSS JOIN default_value dd
	LEFT JOIN ctrg_support.image_dict_key_ids mdki
    ON mdki.dur_uk = CONCAT(mi.img_name,'|',mi.attribute1)
    UNION ALL
    --MODEL_IMAGES--
    SELECT CONCAT( mi.img_name,'|',mi.attribute1) as dur_uk,
           COALESCE(mdki.dur_uk_id,dd.dur_uk_id) as image_dict_id,
		   mi.img_name as code,
           null as flex1,
           null as flex2,
           null as flex3,
           null as flex4,
           null as flex5,
           null as flex6,
           null as flex7,
           null as flex8,
           null as flex9,
           null as flex10,
           null::integer as p_range_from,
           null::integer as p_range_to,
           null::integer as m_range_from,
           null::integer as m_range_to,
           dod.data_origin_id as data_origin_id,
		   null as uc_nk1,
           null as uc_nk2,
           null as uc_nk3,
           null as uc_nk4,
           null as direct_filter_1,
           null as direct_filter_2,
           null as direct_filter_3,
           null as direct_filter_4,
           null as direct_filter_5,
		   0::boolean as archivable_ind,
           1::boolean as valid_for_media_ind,
           null::integer as row_ae_id
     FROM bl_image_model mi
     CROSS JOIN dod
	 CROSS JOIN default_value dd
	 LEFT JOIN ctrg_support.image_dict_key_ids mdki
     ON mdki.dur_uk = CONCAT( mi.img_name,'|',mi.attribute1)
     UNION ALL
     --GROUP_IMAGES--
     SELECT CONCAT(gi.img_name,'|',gi.attribute1) as dur_uk,
            COALESCE(mdki.dur_uk_id,dd.dur_uk_id) as image_dict_id,
            gi.img_name as code,
			null as flex1,
            null as flex2,
            null as flex3,
            null as flex4,
            null as flex5,
            null as flex6,
            null as flex7,
            null as flex8,
            null as flex9,
            null as flex10,
            null::integer as p_range_from,
            null::integer as p_range_to,
            null::integer as m_range_from,
            null::integer as m_range_to,
            dod.data_origin_id as data_origin_id,
		    null as uc_nk1,
            null as uc_nk2,
            null as uc_nk3,
            null as uc_nk4,
            null as direct_filter_1,
            null as direct_filter_2,
            null as direct_filter_3,
            null as direct_filter_4,
            null as direct_filter_5,
		   0::boolean as archivable_ind,
           1::boolean as valid_for_media_ind,
           null::integer as row_ae_id
     FROM bl_image_group gi
     CROSS JOIN dod
	 CROSS JOIN default_value dd
	 LEFT JOIN ctrg_support.image_dict_key_ids mdki
     ON mdki.dur_uk = CONCAT(gi.img_name,'|',gi.attribute1); 
