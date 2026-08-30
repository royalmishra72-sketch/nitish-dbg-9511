drop view if exists part_item_addl_info_w_v;

CREATE or REPLACE VIEW pub_work.part_item_addl_info_w_v
 AS
 with addvalue AS ( /* <SBS_RULE> THIS CLAUSE WILL FETCH DATA PART_ITEM_DUR_UK AND DUR_UK FOR ADDTIONAL INFO VALUE,FROM TABLE 'merge_parts_W','BL_SBS_SECTION' AND 'BL_SBS_META_HEADER' .</SBS_RULE>*/
         SELECT merge_parts_w.part_item_dur_uk,
                concat(( SELECT bl_sbs_meta_header.element_desc
                         FROM bl.bl_sbs_meta_header
                         WHERE bl_sbs_meta_header.group_name::text = 'PART_ITEM'::text 
						 AND bl_sbs_meta_header.element_code::text = 'NA'::text), '|', merge_parts_w.na_code) AS dur_uk,
			  merge_parts_w.mdl_ser_code               
         FROM merge_parts_w
         JOIN bl.bl_sbs_section ON merge_parts_w.mdl_ser_code::text = bl_sbs_section.mdl_ser_code::text 
		 AND merge_parts_w.sec_num::text = bl_sbs_section.sec_num::text
         WHERE merge_parts_w.na_code IS NOT NULL 
		 AND merge_parts_w.part_num IS NOT NULL
        UNION ALL
         SELECT merge_parts_w.part_item_dur_uk,
                concat(( SELECT bl_sbs_meta_header.element_desc
                         FROM bl.bl_sbs_meta_header
                         WHERE bl_sbs_meta_header.group_name::text = 'PART_ITEM'::text 
						 AND bl_sbs_meta_header.element_code::text = 'UNIT_PACK'::text), '|', merge_parts_w.unit_pack_p) AS dur_uk,
			   merge_parts_w.mdl_ser_code           
          FROM merge_parts_w
          JOIN bl.bl_sbs_section ON merge_parts_w.mdl_ser_code::text = bl_sbs_section.mdl_ser_code::text 
		  AND merge_parts_w.sec_num::text = bl_sbs_section.sec_num::text
          WHERE merge_parts_w.unit_pack_p IS NOT NULL AND merge_parts_w.part_num IS NOT NULL
         UNION ALL
         SELECT merge_parts_w.part_item_dur_uk,
                concat(( SELECT bl_sbs_meta_header.element_desc
                         FROM bl.bl_sbs_meta_header
                         WHERE bl_sbs_meta_header.group_name::text = 'PART_ITEM'::text 
						 AND bl_sbs_meta_header.element_code::text = 'AM_MA'::text), '|', merge_parts_w.new_alt_ica) AS dur_uk,
                merge_parts_w.mdl_ser_code
           FROM merge_parts_w
           JOIN bl.bl_sbs_section ON merge_parts_w.mdl_ser_code::text = bl_sbs_section.mdl_ser_code::text 
		   AND merge_parts_w.sec_num::text = bl_sbs_section.sec_num::text
          WHERE merge_parts_w.new_alt_ica IS NOT NULL AND merge_parts_w.part_num IS NOT NULL
        UNION ALL
         SELECT merge_parts_w.part_item_dur_uk,
                concat(( SELECT bl_sbs_meta_header.element_desc
                         FROM bl.bl_sbs_meta_header
                         WHERE bl_sbs_meta_header.group_name::text = 'PART_ITEM'::text 
						 AND bl_sbs_meta_header.element_code::text = 'ALT_NUM'::text), '|', merge_parts_w.new_alt_num) AS dur_uk,
                merge_parts_w.mdl_ser_code
           FROM merge_parts_w
           JOIN bl.bl_sbs_section ON merge_parts_w.mdl_ser_code::text = bl_sbs_section.mdl_ser_code::text AND merge_parts_w.sec_num::text = bl_sbs_section.sec_num::text
           WHERE merge_parts_w.new_alt_num IS NOT NULL
        UNION ALL
         SELECT merge_parts_w.part_item_dur_uk,
                 concat(( SELECT bl_sbs_meta_header.element_desc
                          FROM bl.bl_sbs_meta_header
                          WHERE bl_sbs_meta_header.group_name::text = 'PART_ITEM'::text 
						  AND bl_sbs_meta_header.element_code::text = 'ICA'::text), '|', merge_parts_w.fmr_alt_ica) AS dur_uk,
                merge_parts_w.mdl_ser_code
           FROM merge_parts_w
           JOIN bl.bl_sbs_section ON merge_parts_w.mdl_ser_code::text = bl_sbs_section.mdl_ser_code::text 
		   AND merge_parts_w.sec_num::text = bl_sbs_section.sec_num::text
          WHERE merge_parts_w.fmr_alt_ica IS NOT NULL AND merge_parts_w.part_num IS NOT NULL
        UNION ALL
         SELECT merge_parts_w.part_item_dur_uk,
                concat(( SELECT bl_sbs_meta_header.element_desc
                         FROM bl.bl_sbs_meta_header
                         WHERE bl_sbs_meta_header.group_name::text = 'PART_ITEM'::text 
						 AND bl_sbs_meta_header.element_code::text = 'FOR_PART_NUM'::text), '|', merge_parts_w.fmr_alt_num) AS dur_uk,
                merge_parts_w.mdl_ser_code
          FROM merge_parts_w
          JOIN bl.bl_sbs_section ON merge_parts_w.mdl_ser_code::text = bl_sbs_section.mdl_ser_code::text 
		  AND merge_parts_w.sec_num::text = bl_sbs_section.sec_num::text
          WHERE merge_parts_w.fmr_alt_num IS NOT NULL AND merge_parts_w.part_num IS NOT NULL
        UNION ALL
         SELECT merge_parts_w.part_item_dur_uk,
                concat(( SELECT bl_sbs_meta_header.element_desc
                         FROM bl.bl_sbs_meta_header
                         WHERE bl_sbs_meta_header.group_name::text = 'PART_ITEM'::text 
						 AND bl_sbs_meta_header.element_code::text = 'S'::text), '|', merge_parts_w.ord_symb) AS dur_uk,
                merge_parts_w.mdl_ser_code
           FROM merge_parts_w
           JOIN bl.bl_sbs_section ON merge_parts_w.mdl_ser_code::text = bl_sbs_section.mdl_ser_code::text 
		   AND merge_parts_w.sec_num::text = bl_sbs_section.sec_num::text
          WHERE merge_parts_w.ord_symb IS NOT NULL AND merge_parts_w.part_num IS NOT NULL
        UNION ALL
         SELECT merge_parts_w.part_item_dur_uk,
                concat(( SELECT replace(bl_sbs_meta_header.element_desc,' ','') as element_desc
                         FROM bl.bl_sbs_meta_header
                         WHERE bl_sbs_meta_header.group_name::text = 'PART_ITEM'::text 
						 AND bl_sbs_meta_header.element_code::text = 'APPL_MODEL'::text), '|', merge_parts_w.appl_model) AS dur_uk,
                merge_parts_w.mdl_ser_code
          FROM merge_parts_w
          JOIN bl.bl_sbs_section ON merge_parts_w.mdl_ser_code::text = bl_sbs_section.mdl_ser_code::text 
		  AND merge_parts_w.sec_num::text = bl_sbs_section.sec_num::text
          WHERE merge_parts_w.appl_model IS NOT NULL AND merge_parts_w.part_num IS NOT NULL
        UNION ALL
         SELECT merge_parts_w.part_item_dur_uk,
            concat(( SELECT bl_sbs_meta_header.element_desc
                     FROM bl.bl_sbs_meta_header
                     WHERE bl_sbs_meta_header.group_name::text = 'PART_ITEM'::text 
					 AND bl_sbs_meta_header.element_code::text = 'APPL_DATE'::text), '|', merge_parts_w.appl_date) AS dur_uk,
                merge_parts_w.mdl_ser_code
           FROM merge_parts_w
           JOIN bl.bl_sbs_section ON merge_parts_w.mdl_ser_code::text = bl_sbs_section.mdl_ser_code::text AND merge_parts_w.sec_num::text = bl_sbs_section.sec_num::text
          WHERE merge_parts_w.appl_date IS NOT NULL AND merge_parts_w.part_num IS NOT NULL
        UNION ALL
         SELECT merge_parts_w.part_item_dur_uk,
               concat(( SELECT bl_sbs_meta_header.element_desc
                        FROM bl.bl_sbs_meta_header
                        WHERE bl_sbs_meta_header.group_name::text = 'PART_ITEM'::text 
						AND bl_sbs_meta_header.element_code::text = 'Consult'::text), '|', 'Download') AS dur_uk,
                merge_parts_w.mdl_ser_code
           FROM merge_parts_w
           JOIN bl.bl_sbs_section ON merge_parts_w.mdl_ser_code::text = bl_sbs_section.mdl_ser_code::text 
		   AND merge_parts_w.sec_num::text = bl_sbs_section.sec_num::text
           JOIN bl.bl_sbs_consult_pnc ON bl_sbs_consult_pnc.pnc::text = merge_parts_w.callout::text
          WHERE merge_parts_w.appl_date IS NOT NULL AND merge_parts_w.part_num IS NOT NULL
        )
 SELECT /*
	  * <SBS_PROLOG>
	  * Project:  NISSAN DATA PUBLISHING
	  * Purpose:  This view is used in the population of the PART_ITEM_ADDL_INFO_W table
	  * PL/SQL Objects Used:
	  *   <Object Type> - <Schema Owner> - <Object Name>
	  *===========================================================
	  * Revision History
	  *   Ref #  Date          Revisor      Comment
	  *   1      24-07-2015    SD          Initial revision
      *   2      05-01-2017    SG          Code change for Consult part_item
	  *   3      02-05-2023    PR          View changes according to postgres
	  *   4      31-12-2025    NKM         Update dur_uk logic in part_item_addl_info_w_v to prevent load failure(NSPUB-1413)
	  *===========================================================
	  * Revisor
	  *   SD                SUMAN DESMUKH
      *   SG                SHAILESH GUPTA
	  *   PR                PAWAN RAJAK
	  *   NKM               Nitish K Mishra
	  *===========================================================
	  * </SBS_PROLOG>
	  * <SBS_SRCTAB owner="BL" name="BL_SBS_META_HEADER" />
	  * <SBS_SRCTAB owner="PUB_WORK" name="MERGE_PARTS_W" />
	  * <SBS_SRCTAB owner="BL" name="BL_SBS_SECTION" />
	  * <SBS_SRCTAB owner="CTRG_SUPPORT" name="DATA_ORIGIN" />
	  * <SBS_DESTTAB owner="PUB_WORK" name="PART_ITEM_ADDL_INFO_W" />
	  * <SBS_PRCGRP name="" seq=""/>
	  */
     addvalue.part_item_dur_uk,
    'PART_ITEM'::text AS addl_info_group_dict_dur_uk,
    bsm.element_desc AS addl_info_name_dict_dur_uk,
    addvalue.dur_uk AS addl_info_value_dict_dur_uk,
    split_part(addvalue.dur_uk, '|'::text, 2) AS addl_info_value_dict_en_us,
    addvalue.mdl_ser_code AS catalog_dur_uk,
    'COLUMN'::text AS addl_info_display_type,
    bsm.element_desc AS code,
    bsm.sort_seq
   FROM addvalue
   INNER JOIN bl.bl_sbs_meta_header bsm 
   ON split_part(addvalue.dur_uk, '|'::text, 1) = case when bsm.element_desc='Appl Model' then replace(bsm.element_desc,' ','')	
                                                            else bsm.element_desc 
															end ;