drop view if exists price_book_v;

CREATE or REPLACE VIEW pub_work.price_book_v as 
   WITH doi
        AS ( /** <SBS_RULE> THIS CLAUSE WILL FETCH DATA ORIGIN ID, THIS WILL BE THE ID OF DATA ORIGIN NAMED 'NIS|ALL', FROM TABLE 'DATA_ORIGIN' </SBS_RULE>*/
            SELECT dod.data_origin_id as data_origin_id
              FROM ctrg_support.data_origin dod
             WHERE dod.dur_uk = 'NIS|ALL'
			),
        br
        AS ( /** <SBS_RULE> THIS CLAUSE WILL FETCH 'BUSINESS_REGION_ID' HAVING DUR_UK 'US', FROM TABLE 'BUSINESS_REGION'</SBS_RULE> **/
            SELECT b.business_region_id
              FROM ctrg.business_region b
             --WHERE b.dur_uk = 'ALL'
			 WHERE b.dur_uk = 'US'
			),
        ds
        AS ( /** <SBS_RULE> THIS CLAUSE WILL FETCH 'SECURED_ID' FROM TABLE 'DATA SOURCE'</SBS_RULE> **/
            SELECT ds.secured_id
              FROM ctrg_support.data_source ds
             WHERE ds.name = 'NIS|PRICE|US'
		   ),
		cd
        AS ( /** <SBS_RULE> THIS CLAUSE WILL FETCH 'CURRENCY_CODE' & 'CURRENCY' FROM TABLE 'CURRENCY_MASTER'</SBS_RULE> **/
            SELECT cm.currency_code,currency 
              FROM ctrg_support.currency_master cm
             WHERE cm.currency_code = 'USD'
		   ),
        dt
        AS ( /** <SBS_RULE> THIS CLAUSE WILL FETCH 'DISPLAY_TYPE_ID'</SBS_RULE> **/
            SELECT 1 as display_type_id
             /* FROM ctrg_support.currency_master cm
             WHERE cm.currency_code = 'USD'*/
		   ),
		default_value
        AS ( /** <SBS_RULE> THIS CLAUSE WILL FETCH 'DUR_UK_ID' FROM TABLE 'PRICE_BOOK_DICT_KEY_IDS'</SBS_RULE> **/
            SELECT pbd.dur_uk_id
              FROM ctrg_support.price_book_dict_key_ids pbd
             WHERE pbd.dur_uk = '*'
		   ),
        bl_sbs
        AS (SELECT element_code 
              /*<SBS_RULE> ELEMENT_CODE ,ELEMENT_DESC selected for group_name='PRICE_BOOK_DICT' for BL_SBS_META_HEADER</SBS_RULE>*/
              FROM bl.bl_sbs_meta_header
             WHERE group_name = 'PRICE_BOOK_DICT'
			),
		dataset
        AS (SELECT property 
              /*<SBS_RULE> PROPERTY FOR PROPERTY_KEY = 'DATASET_ID' for DATASET_PROPERTY</SBS_RULE>*/
              FROM ctrg.dataset_property dp
             WHERE property_key = 'DATASET_ID' 
			)
		   
   SELECT /**
          * <SBS_PROLOG>
          * PROJECT:  NISSAN DATA PUBLISHING
          * PURPOSE:  THIS VIEW IS USED IN THE POPULATION OF THE PRICE BOOK TABLE.
          *
          * PL/SQL OBJECTS USED:
          *   <OBJECT TYPE> - <SCHEMA OWNER> - <OBJECT NAME>
          *===========================================================
          * REVISION HISTORY
          *   REF #  DATE          REVISOR      COMMENT
          *   1      02-09-2015    NS          INITIAL REVISION
		  *   2      03-05-2023    PR          VIEW UPDATED ACCORDING TO POSTGRES.
		  *   3      20-07-2023    PR          NISPUB - 595 update mentioned view and change business_region to 'US' from 'ALL'
          *===========================================================
          * REVISOR
          *   NS            NISHANT SONI
		  *   PR            PAWAN RAJAK
          *===========================================================
          * </SBS_PROLOG>
          * <SBS_SRCTAB  owner="CTRG" name="BUSINESS_REGION"/>
          * <SBS_SRCTAB  owner="CTRG_SUPPORT" name="DATA_ORIGIN"/>
		  * <SBS_SRCTAB  owner="CTRG_SUPPORT" name="DATA_SOURCE"/>
		  * <SBS_SRCTAB  owner="CTRG_SUPPORT" name="CURRENCY_MASTER"/>
		  * <SBS_SRCTAB  owner="CTRG_SUPPORT" name="PRICE_BOOK_DICT_KEY_IDS"/>
          * <SBS_PRCGRP name="LOAD_UPPER_NAVIGATION" seq="2"/>
          */
          /** <SBS_RULE> PRICE_BOOK_ID is passed as NULL as KEY_TO_ID function is handled by ODI KM.  </SBS_RULE> **/
          ds.secured_id as price_book_id,	
          br.business_region_id as business_region_id,	
          bl_sbs.element_code as dur_uk,
          cd.currency_code as currency_code,
          cd.currency as currency_name,
		  0 as priority,		  
          0 as price_book_type,		  
          coalesce (pbdk.dur_uk_id,dv.dur_uk_id) as price_book_dict_id,
          null as code,
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
          null as parent_price_book_id,
          null::timestamp as applies_date,
          null::timestamp as expires_date,
          doi.data_origin_id as data_origin_id,
          null as property,
		  null as checksum_property,
		  0::boolean as archivable_ind, 
		  1::boolean as valid_for_media_ind,
          0::boolean as has_part_supersession,
          0::boolean as has_alternate,
          0::boolean as has_kit,
          0::boolean as has_part_history,
          dt.display_type_id as display_type,
		  dat.property as dataset_id 		  
   FROM doi
   CROSS JOIN br
   CROSS JOIN ds
   CROSS JOIN cd
   CROSS JOIN dt
   CROSS JOIN bl_sbs
   CROSS JOIN default_value dv
   CROSS JOIN dataset dat
   LEFT JOIN ctrg_support.price_book_dict_key_ids pbdk
   ON pbdk.dur_uk = bl_sbs.element_code;