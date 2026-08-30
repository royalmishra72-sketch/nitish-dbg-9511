drop view if exists page_w_v;

CREATE or REPLACE VIEW pub_work.page_w_v
 as
 WITH model_code 
            AS ( /**<SBS_RULE> THIS CLAUSE WILL FETCH MDL_SER_CODE,GROUP_SEDC,GRP_NUM,SEC_NUM,
                                    SEC_DESC ON BL_SBS_SECTION AND MERGE_PARTS_W <SBS_RULE> **/
         SELECT DISTINCT b.mdl_ser_code,
                b.group_desc,
                b.grp_num,
                b.sec_num,
                b.sec_desc,
                CASE
                WHEN b.sec_num::text = '000'::text THEN 0::text
                WHEN b.sec_num::text = '000A'::text THEN '0A'::text
                ELSE ltrim(b.sec_num::text, '0'::text)
                END AS sec_num_1
           FROM bl.bl_sbs_section b
           JOIN merge_parts_w w 
		   ON b.mdl_ser_code::text = w.mdl_ser_code::text 
		   AND b.sec_num::text = w.sec_num::text 
		      ),
      mdate 
	   AS ( /**<SBS_RULE> THIS CLAUSE WILL FETCH P_RANGE_FROM ,P_RANGE_TO ON BL_SBS_SECTION <SBS_RULE> **/
            SELECT CONCAT(wmp.mdl_ser_code, '|', bss.group_desc, '|', wmp.sec_num) AS page_dur_uk,
                   MIN(wmp.app_from_date::text) AS p_range_from,
                   MAX(wmp.app_to_date::text) AS p_range_to
             FROM bl.bl_sbs_section bss
             JOIN merge_parts_w wmp ON bss.mdl_ser_code = wmp.mdl_ser_code  AND bss.sec_num = wmp.sec_num
            GROUP BY wmp.mdl_ser_code, bss.group_desc, wmp.sec_num 
			), 
      no_img 
	  AS ( /** <SBS_RULE> THIS CLAUSE WILL FETCH 'IMAGE_DUR_UK' ON BL_IMAGE_DATA THOSE HAVE 'NO_IMAGE|NIS_ILLUSTRATIONS'</SBS_RULE> **/
           SELECT CONCAT(w.img_name, '|', 'NIS_ILLUSTRATIONS') AS dur_uk
           FROM   pub_work.image_data_w w
           WHERE CONCAT(w.img_name, '|', 'NIS_ILLUSTRATIONS') = 'NO_IMAGE|NIS_ILLUSTRATIONS'  
		   ),		   
     img_data 
	 AS ( /** <SBS_RULE> THIS CLAUSE WILL FETCH 'IMAGE_DUR_UK' ON BL_IMAGE_DATA</SBS_RULE> **/
         SELECT CONCAT(bid.img_name, '|', 'NIS_ILLUSTRATIONS') AS imd_dur_key,
                bid.img_name,
				iw.catalog as img_ser_code,
				iw.sec_num as img_sec_num,				
              /* split_part(bid.img_name, '-', 1) AS img_ser_code,
                split_part(bid.img_name, '-', 2) AS img_sec_num,*/				
                --split_part(bid.img_name, '-', 3) AS img_nbr
                row_number() Over(partition by iw.catalog,iw.sec_num order by bid.img_name ) as img_nbr
          FROM  pub_work.image_data_w bid
		  INNER JOIN pub_work.image_w iw
		  ON bid.img_name = iw.img_name 
          WHERE bid.attribute1 = 'NIS_ILLUSTRATIONS'
		  ), 		  
     atty 
	 AS ( /** <SBS_RULE> THIS CLAUSE WILL CREATE 'PAGE_DUR_UK', 'IMAGE_DUR_UK'</SBS_RULE> **/
         SELECT CONCAT(md_1.mdl_ser_code, '|', md_1.group_desc, '|', md_1.sec_num) AS page_dur_uk,
                kii.imd_dur_key,
                kii.img_nbr
          FROM model_code md_1
          LEFT JOIN img_data kii 
		  ON md_1.mdl_ser_code::text = kii.img_ser_code 
		  AND md_1.sec_num_1 = kii.img_sec_num
        )
		SELECT DISTINCT/*
            * <SBS_PROLOG>
            * Project:  NISSAN DATA PUBLISHING
            * Purpose:  This view is used in the population of the PAGE_WORK table.
            *
            * PL/SQL Objects Used:
            *   <Object Type> - <Schema Owner> - <Object Name>
            *===========================================================
            * Revision History
            *   Ref #  Date         Revisor      Comment
			*   1      14-04-2023   PR          Initial revision
			*   2      26-06-2023    PR         NSPUB-539: Modified code to join pub_work.image_w with bl.bl_image_data on behalf on img_name.
			*   3      18-07-2023    CB         Sort seq logic updated. 
 		    *   4      04/08/2026    CB         Replaced bl.bl_image_data with image_data_w. 
            *===========================================================
            * Revisor
			*   PR            PAWAN RAJAK
			*   CB            Chandan Bhatia
            *===========================================================
            * </SBS_PROLOG>
            * <SBS_SRCTAB  owner="BL" name="BL_SBS_SECTION" />
			* <SBS_SRCTAB  owner="PUB_WORK" name="IMAGE_DATA_W" /> 
			* <SBS_SRCTAB  owner="PUB_WORK" name="MERGE_PARTS_W" />  
            */
                /** <SBS_RULE> CATALOG_DUR_UK ID IS TAKEN FROM MODEL_CODE <SBS_RULE>**/
                 md.mdl_ser_code AS catalog_dur_uk, 
                 /** <SBS_RULE> CHAPTER_DUR_UK ID IS TAKEN FROM MODEL_CODE<SBS_RULE>**/
		CONCAT(md.mdl_ser_code, '|', md.group_desc) AS chapter_dur_uk, 
		        /** <SBS_RULE> PAGE_DUR_UK IS TAKEN FROM MODEL_CODE IS CONCATENATING OF SOME COLUMNS<SBS_RULE>**/
        CONCAT(md.mdl_ser_code, '|', md.group_desc, '|', md.sec_num) AS page_dur_uk, 
		        /** <SBS_RULE> PAGE_DICT IS TAKEN FROM SEC_DESC OF MODEL_CODE<SBS_RULE>**/
               md.sec_desc AS page_dict, 
		       /** <SBS_RULE> PAGE_CODE IS TAKEN FROM SEC_NUM OF MODEL_CODE <SBS_RULE>**/
               md.sec_num AS page_code,
		      /** <SBS_RULE> MAKE PAGE_IMAGE_DUR_UK BY COALESCE OF 2 COLUMNS<SBS_RULE>**/
        COALESCE(att.imd_dur_key, ni.dur_uk) AS page_image_dur_uk,
		       /** <SBS_RULE> MAKE PAGE_SORT_SEQ<SBS_RULE>**/
        lpad(dense_rank() OVER (PARTITION BY md.mdl_ser_code, md.group_desc ORDER BY md.sec_num)::text, 10, '0'::text) AS page_sort_seq,
        /*
        CASE
            WHEN (( SELECT count(*) AS count
                    FROM regexp_matches(att.imd_dur_key, '-','g') regexp_matches(regexp_matches))) = 1 THEN lpad('1'::text, 10, '0'::text)
            WHEN (( SELECT count(*) AS count
                     FROM regexp_matches(att.imd_dur_key, '-','g') regexp_matches(regexp_matches))) = 2 THEN lpad(split_part(split_part(att.imd_dur_key, '|', 1), '-', 3), 10, '0')
            ELSE NULL::text
        END AS image_sort_seq,
        */
        lpad(att.img_nbr::text, 10, '0'::text) image_sort_seq,
		 /** <SBS_RULE P_RANGE_FROM TAKEN FROM MDATE <SBS_RULE>**/
        mdd.p_range_from,
	    /** <SBS_RULE P_RANGE_TO TAKEN FROM MDATE <SBS_RULE>**/
        mdd.p_range_to
   FROM model_code md
   JOIN mdate mdd ON concat(md.mdl_ser_code, '|', md.group_desc, '|', md.sec_num) = mdd.page_dur_uk
   JOIN atty att ON att.page_dur_uk = concat(md.mdl_ser_code, '|', md.group_desc, '|', md.sec_num)
   CROSS JOIN no_img ni;	
