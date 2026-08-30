drop view if exists page_image_part_item_x_v;

CREATE or REPLACE VIEW pub_work.page_image_part_item_x_v as 
WITH
     img_data AS (SELECT iw.catalog as img_ser_code,
				         iw.sec_num as img_sec_num,	                     
					  -- split_part(bl.img_name, '-', 1) AS img_ser_code, 
                      -- split_part(bl.img_name, '-', 2) AS img_sec_num,
                         split_part(bl.img_name, '-', 3) AS img_nbr,
				         bl.img_callout_data,
					     concat(bl.img_name,'|',bl.attribute1) as  img_dur_uk
                   FROM  pub_work.image_data_w bl
				   INNER JOIN pub_work.image_w iw
				   ON bl.img_name = iw.img_name),
	no_img AS /** <SBS_RULE> THIS CLAUSE WILL FETCH 'IMAGE_DUR_UK'& IMAGE_DUR_ID' ON IMAGE_KEY_IDS THOSE HAVE 'NO_IMAGE|NIS_ILLUSTRATIONS'</SBS_RULE> **/
         (SELECT ikk.dur_uk, 
		         ikk.dur_uk_id
		   FROM ctrg_support.image_key_ids ikk
		   WHERE ikk.dur_uk = 'NO_IMAGE|NIS_ILLUSTRATIONS'
	     ),
	merge_parts_w AS (                                   
            SELECT mpw.mdl_ser_code,
                   mpw.sec_num,
				   mpw.callout,
				   mpw.part_item_dur_uk
			 FROM  pub_work.merge_parts_w mpw
            WHERE mpw.sec_num NOT IN ('000', '000A')
			         ),
	merge_parts_w2 AS (
         SELECT DISTINCT mpw2.mdl_ser_code,
                mpw2.sec_num,
                CASE
                     WHEN mpw2.sec_num::text = '000'::text THEN 0::text
                     WHEN mpw2.sec_num::text = '000A'::text THEN '0A'::text
                     ELSE ltrim(mpw2.sec_num::text, '0'::text)
                END AS sec_num_1,
                mpw2.callout,
                mpw2.part_item_dur_uk
           FROM merge_parts_w mpw2
           WHERE mpw2.sec_num IN ('000', '000A')
		               ),
    atty AS ( /** <SBS_RULE> THIS CLAUSE WILL CREATE 'IMAGE_DUR_UK', 'PART_ITEM_DUR_UK'</SBS_RULE> **/
           SELECT img_data.img_dur_uk,
                  merge_parts_w.part_item_dur_uk
           FROM  img_data
           JOIN merge_parts_w ON img_data.img_ser_code = merge_parts_w.mdl_ser_code::text 
		   AND  img_data.img_sec_num = ltrim(merge_parts_w.sec_num::text, '0'::text) 
		   AND  strpos(img_data.img_callout_data, concat('<callout label="'::text, merge_parts_w.callout, '">'::text)) > 0
		    ),
    atty2 AS ( /** <SBS_RULE> THIS CLAUSE WILL CREATE 'IMAGE_DUR_UK', 'PART_ITEM_DUR_UK'</SBS_RULE> **/
            SELECT img_data.img_dur_uk,
                   merge_parts_w2.part_item_dur_uk
              FROM img_data
              JOIN merge_parts_w2 ON img_data.img_ser_code = merge_parts_w2.mdl_ser_code::text 
			  AND img_data.img_sec_num = merge_parts_w2.sec_num_1 
			  AND strpos(img_data.img_callout_data, concat('<callout label="'::text, merge_parts_w2.callout, '">'::text)) > 0
			  ),
    page_img_part AS ( 
          SELECT DISTINCT cki.dur_uk_id as catalog_id,/** <SBS_RULE> CATALOG_DUR_UK IS TAKEN FROM PART_ITEM_W AND JOINED WITH CATALOG_KEY_IDS TABLE<SBS_RULE>**/		
			     pki.dur_uk_id as page_id,/** <SBS_RULE> PAGE_DUR_UK IS TAKEN FROM PAGE_W AND JOINED WITH PAGE_KEY_IDS TABLE<SBS_RULE>**/
		         COALESCE (iki.dur_uk_id,no_img.dur_uk_id)as image_id,
			     piki.dur_uk_id as part_item_id, /** <SBS_RULE> PART_ITEM_DUR_UK IS TAKEN FROM PART_ITEM_W AND JOINED WITH PART_ITEM_KEY_IDS TABLE <SBS_RULE>**/
			     piki.dur_uk as part_item_dur_uk,
		         piw.sort_seq as sort_seq,
		         piw.app_from_date::integer as p_range_from,/** <SBS_RULE> P_RANGE_FROM IS TAKEN FROM PART_ITEM_W <SBS_RULE>**/
		         piw.app_to_date::integer as p_range_to /** <SBS_RULE> P_RANGE_TO TAKEN FROM PART_ITEM_W <SBS_RULE>**/
		  FROM  part_item_w piw 
		  CROSS JOIN no_img   
		  INNER JOIN page_w dd ON (piw.catalog_dur_uk = dd.catalog_dur_uk AND piw.sec_num = dd.page_code)
		  INNER JOIN ctrg_support.catalog_key_ids cki ON cki.dur_uk = piw.catalog_dur_uk
		  INNER JOIN ctrg_support.page_key_ids pki ON pki.dur_uk = dd.page_dur_uk
		  INNER JOIN ctrg_support.part_item_key_ids piki ON piki.dur_uk = piw.part_item_dur_uk
		  INNER JOIN atty ON piw.part_item_dur_uk = atty.part_item_dur_uk 
		  INNER JOIN ctrg_support.image_key_ids iki ON iki.dur_uk::text = atty.img_dur_uk
		  UNION ALL
		  SELECT DISTINCT cki.dur_uk_id as catalog_id,/** <SBS_RULE> CATALOG_DUR_UK IS TAKEN FROM PART_ITEM_W AND JOINED WITH CATALOG_KEY_IDS TABLE<SBS_RULE>**/		
			     pki.dur_uk_id as page_id,/** <SBS_RULE> PAGE_DUR_UK IS TAKEN FROM PAGE_W AND JOINED WITH PAGE_KEY_IDS TABLE<SBS_RULE>**/
		         COALESCE (iki.dur_uk_id,no_img.dur_uk_id)as image_id,
			     piki.dur_uk_id as part_item_id, /** <SBS_RULE> PART_ITEM_DUR_UK IS TAKEN FROM PART_ITEM_W AND JOINED WITH PART_ITEM_KEY_IDS TABLE <SBS_RULE>**/
				 piki.dur_uk as part_item_dur_uk,
		         piw.sort_seq as sort_seq,
		         piw.app_from_date::integer as p_range_from,/** <SBS_RULE> P_RANGE_FROM IS TAKEN FROM PART_ITEM_W <SBS_RULE>**/
		         piw.app_to_date::integer as p_range_to /** <SBS_RULE> P_RANGE_TO TAKEN FROM PART_ITEM_W <SBS_RULE>**/
		   FROM  part_item_w piw 
		   CROSS JOIN no_img   
		   INNER JOIN page_w dd ON (piw.catalog_dur_uk = dd.catalog_dur_uk AND piw.sec_num = dd.page_code)
		   INNER JOIN ctrg_support.catalog_key_ids cki ON cki.dur_uk = piw.catalog_dur_uk
		   INNER JOIN ctrg_support.page_key_ids pki ON pki.dur_uk = dd.page_dur_uk
		   INNER JOIN ctrg_support.part_item_key_ids piki ON piki.dur_uk = piw.part_item_dur_uk
		   INNER JOIN atty2 ON piw.part_item_dur_uk = atty2.part_item_dur_uk 
		   INNER JOIN ctrg_support.image_key_ids iki ON iki.dur_uk::text = atty2.img_dur_uk
		               ),
	 diff AS (
	         SELECT part_item_dur_uk FROM pub_work.merge_parts_w
             EXCEPT
             SELECT part_item_dur_uk FROM page_img_part
			 ),	
     merge_parts_w3 
	 AS ( SELECT mpw3.mdl_ser_code,
                 mpw3.sec_num,
			     CASE WHEN mpw3.sec_num::text = '000'::text THEN 0::text
                      WHEN mpw3.sec_num::text = '000A'::text THEN '0A'::text
                      ELSE ltrim(mpw3.sec_num::text, '0'::text)
                 END AS sec_num_1,
                 d.part_item_dur_uk
		    FROM pub_work.merge_parts_w mpw3
		    JOIN DIFF d 
			ON d.part_item_dur_uk::text = mpw3.part_item_dur_uk::text
		),	 
	atty3 AS ( /** <SBS_RULE> THIS CLAUSE WILL CREATE 'IMAGE_DUR_UK', 'PART_ITEM_DUR_UK'</SBS_RULE> **/
         SELECT COALESCE (img.img_dur_uk,no_img.dur_uk) as img_dur_uk,
                mp3.part_item_dur_uk
           FROM merge_parts_w3 mp3
		   CROSS JOIN no_img
           LEFT JOIN img_data img 
		   ON (img.img_ser_code = mp3.mdl_ser_code AND img.img_sec_num = mp3.sec_num_1)
		   )
	SELECT DISTINCT/*
    * <sbs_prolog>
    * project:  nissan data publishing
    * purpose:  this view is used in the population of the page_image_part_item_x table.
    *
    * pl/sql objects used:
    *   <object type> - <schema owner> - <object name>
    *===========================================================
    * revision histor
    *   ref #  date         revisor      comment
    *   1      24-04-2023   pr          initial revision
	*   2      26-06-2023   pr          NSPUB-542: Modified code to join pub_work.image_w with bl.bl_image_data on behalf on img_name.
	*   3      04-08-2026   CB          Replaced bl.bl_image_data with image_data_w	
    *===========================================================
    * revisor
	*   pr            pawan rajak
    *   CB            Chandan Bhatia 
    *===========================================================
    * </sbs_prolog>
    * <sbs_srctab  owner="pub_work" name="part_item_w" />
    * <sbs_srctab  owner="pub_work" name="image_data_w" />
    * <sbs_desttab owner="pub_work" name="page_w" />-- 2903418----219289
	* <sbs_prcgrp name="load_lower_navigation" seq=""/>
    */
               cki.dur_uk_id as catalog_id,	/** <SBS_RULE> CATALOG_DUR_UK IS TAKEN FROM PART_ITEM_W AND JOINED WITH CATALOG_KEY_IDS TABLE<SBS_RULE>**/		
			   pki.dur_uk_id as page_id,      /** <SBS_RULE> PAGE_DUR_UK IS TAKEN FROM PAGE_W AND JOINED WITH PAGE_KEY_IDS TABLE<SBS_RULE>**/
	           coalesce (im.dur_uk_id,no_img.dur_uk_id)as image_id,
			   piki.dur_uk_id as part_item_id, /** <SBS_RULE> PART_ITEM_DUR_UK IS TAKEN FROM PART_ITEM_W AND JOINED WITH PART_ITEM_KEY_IDS TABLE <SBS_RULE>**/
		       piw.sort_seq as sort_seq, /** <SBS_RULE> SEQ VALUE IS TAKEN FROM PART_ITEM_W <SBS_RULE>**/
		       piw.app_from_date::integer as p_range_from,/** <SBS_RULE> P_RANGE_FROM IS TAKEN FROM PART_ITEM_W <SBS_RULE>**/
		       piw.app_to_date::integer as p_range_to,/** <SBS_RULE> P_RANGE_TO TAKEN FROM PART_ITEM_W <SBS_RULE>**/
		       null::integer as m_range_from,
               null::integer as m_range_to,
               null::integer as direct_filter_1,
               null::integer as direct_filter_2,
               null::integer as direct_filter_3,
               null::integer as direct_filter_4,
               null::integer as direct_filter_5
         FROM part_item_w piw
		 CROSS JOIN no_img
         JOIN page_w dd ON piw.catalog_dur_uk::text = dd.catalog_dur_uk::text AND piw.sec_num::text = dd.page_code::text
         JOIN ctrg_support.catalog_key_ids cki ON cki.dur_uk::text = piw.catalog_dur_uk::text
         JOIN ctrg_support.page_key_ids pki ON pki.dur_uk::text = dd.page_dur_uk::text
         JOIN ctrg_support.part_item_key_ids piki ON piki.dur_uk::text = piw.part_item_dur_uk::text
         JOIN atty3 ON atty3.part_item_dur_uk = piw.part_item_dur_uk 
         JOIN ctrg_support.image_key_ids im ON im.dur_uk = atty3.img_dur_uk
		 UNION ALL
		 SELECT DISTINCT pip.catalog_id,
		                 pip.page_id,
						 pip.image_id,
						 pip.part_item_id,
						 pip.sort_seq,
						 pip.p_range_from,
						 pip.p_range_to,
						 null::integer as m_range_from,
                         null::integer as m_range_to,
                         null::integer as direct_filter_1,
                         null::integer as direct_filter_2,
                         null::integer as direct_filter_3,
                         null::integer as direct_filter_4,
                         null::integer as direct_filter_5
          FROM page_img_part pip;