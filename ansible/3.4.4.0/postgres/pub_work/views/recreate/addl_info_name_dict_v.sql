drop view if exists addl_info_name_dict_v;
CREATE or REPLACE VIEW pub_work.addl_info_name_dict_v AS 
WITH ADDNAME
        AS ( /* <SBS_RULE> THIS CLAUSE WILL FETCH DATA ELEMENT DESCRIPTION AND SEQUENCE</SBS_RULE>*/
              SELECT DISTINCT ELEMENT_DESC
              FROM BL.BL_SBS_META_HEADER
              WHERE GROUP_NAME = 'PART_ITEM'
              UNION
              SELECT ELEMENT_DESC
              FROM BL.BL_SBS_META_HEADER
              WHERE GROUP_NAME = 'VIN'
              UNION
              SELECT ELEMENT_DESC
              FROM BL.BL_SBS_META_HEADER
              WHERE GROUP_NAME = 'PART'
              UNION
              SELECT DISTINCT SPEC_CODE AS ELEMENT_DESC                                    
              FROM BL.BL_F31DB076_SPEC_DATA
              UNION
              SELECT DISTINCT SPEC_CODE AS ELEMENT_DESC                                       
              FROM PUB_WORK.SPEC_CODE_W),                                                     
       DOI
        AS ( /** <SBS_RULE> THIS CLAUSE WILL FETCH DATA ORIGIN ID, THIS WILL BE THE ID OF DATA ORIGIN NAMED 'NIS|ALL', FROM TABLE 'DATA_ORIGIN' .</SBS_RULE>*/
            SELECT DOD.DATA_ORIGIN_ID AS DATA_ORIGIN_ID
              FROM CTRG_SUPPORT.DATA_ORIGIN DOD
             WHERE DOD.DUR_UK = 'NIS|ALL')
	SELECT /*
          * <SBS_PROLOG>
          * Project:  NISSAN DATA PUBLISHING
          * Purpose:  This view is used in the population of the ADDL_INFO_NAME_DICT table
          * PL/SQL Objects Used:
          *   <Object Type> - <Schema Owner> - <Object Name>
          *===========================================================
          * Revision History
          *   Ref #  Date          Revisor      Comment
          *   1      23-07-2015    SD          Initial revision
		  *   2      29-04-2023    PR          View updated according to postgres
          *===========================================================
          * Revisor
          *   SD                SUMAN DESMUKH
		  *   PR                PAWAN RAJAK
          *===========================================================
          * </SBS_PROLOG>
          * <SBS_SRCTAB owner="BL" name="BL_SBS_META_HEADER" />
		  * <SBS_SRCTAB owner="BL" name="BL_F31DB076_SPEC_DATA" />
          * <SBS_SRCTAB owner="CTRG_SUPPORT" name="DATA_ORIGIN" />
		  * <SBS_SRCTAB owner="PUB_WOR" name="SPEC_CODE_W" />
          * <SBS_DESTTAB owner="CTRG" name="ADDL_INFO_NAME_DICT" />
          * <SBS_PRCGRP name="" seq=""/>
          */
		AD.ELEMENT_DESC::text as dur_uk,
        'en_US'::text as base_lang_locale_code,
        null as bg_bg,
        null as cs_cz,
        null as da_dk,
        null as de_at,
        null as de_ch,
        null as de_de,
        null as el_gr,
        null as en_gb,
        AD.ELEMENT_DESC::text as en_us,
        null as es_es,
        null as et_ee,
        null as es_mx,
        null as fi_fi,
        null as fr_ca,
        null as fr_fr,
        null as hr_hr,
        null as hi_in,
        null as hu_hu,
        null as it_it,
        null as ja_jp,
        null as ko_kr,
        null as lt_lt,
        null as lv_lv,
        null as nl_be,
        null as nl_nl,
        null as no_no,
        null as pl_pl,
        null as pt_br,
        null as pt_pt,
        null as ro_ro,
        null as ru_ru,
        null as sk_sk,
        null as sl_si,
        null as sv_se,
        null as th_th,
        null as tr_tr,
        null as uk_ua,
        null as vi_vn,
        null as zh_cn,
        null as zh_hk,
        null as zh_tw,
        null as zz_zz,
        null as non_translatable
    FROM ADDNAME AD
	CROSS JOIN DOI
	UNION ALL
	SELECT '*'::text as dur_uk,
           '*'::text as base_lang_locale_code,
           null as bg_bg,
           null as cs_cz,
           null as da_dk,
           null as de_at,
           null as de_ch,
           null as de_de,
           null as el_gr,
           null as en_gb,
           null as en_us,
           null as es_es,
           null as et_ee,
           null as es_mx,
           null as fi_fi,
           null as fr_ca,
           null as fr_fr,
           null as hr_hr,
           null as hi_in,
           null as hu_hu,
           null as it_it,
           null as ja_jp,
           null as ko_kr,
           null as lt_lt,
           null as lv_lv,
           null as nl_be,
           null as nl_nl,
           null as no_no,
           null as pl_pl,
           null as pt_br,
           null as pt_pt,
           null as ro_ro,
           null as ru_ru,
           null as sk_sk,
           null as sl_si,
           null as sv_se,
           null as th_th,
           null as tr_tr,
           null as uk_ua,
           null as vi_vn,
           null as zh_cn,
           null as zh_hk,
           null as zh_tw,
           null as zz_zz,
           null as non_translatable;
		   
		   