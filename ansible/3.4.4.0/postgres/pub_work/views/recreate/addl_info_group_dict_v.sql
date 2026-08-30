drop view if exists addl_info_group_dict_v;

CREATE or REPLACE VIEW addl_info_group_dict_v as WITH DOI
        AS ( /** <SBS_RULE> THIS CLAUSE WILL FETCH DATA ORIGIN ID, THIS WILL BE THE ID OF DATA ORIGIN NAMED 'NIS|ALL', FROM TABLE 'DATA_ORIGIN' .</SBS_RULE>*/
            SELECT DOD.DATA_ORIGIN_ID AS DATA_ORIGIN_ID
              FROM ctrg_support.DATA_ORIGIN DOD
             WHERE DOD.DUR_UK = 'NIS|ALL'),
        ADDGRP
        AS ( /* <SBS_RULE> THIS CLAUSE WILL FETCH DATA ELEMENT DESC.THIS WILL BE THE NAME OF GROUP, HAVING GROUP_NAME VALUE 'ADDITIONAL_GROUP', FROM TABLE 'BL_SBS_META_HEADER' .</SBS_RULE>*/
            SELECT DISTINCT ELEMENT_DESC, ELEMENT_CODE, SORT_SEQ , en_us
              FROM BL.BL_SBS_META_HEADER
             WHERE GROUP_NAME = 'ADDITIONAL_GROUP')
   SELECT /*
          * <SBS_PROLOG>
          * Project:  NISSAN DATA PUBLISHING
          * Purpose:  This view is used in the population of the ADDL_INFO_GROUP_DICT table
          * PL/SQL Objects Used:
          *   <Object Type> - <Schema Owner> - <Object Name>
          *===========================================================
          * Revision History
          *   Ref #  Date          Revisor      Comment
          *   1      23-07-2015    SD          Initial revision
		  *   2      28-04-2023    PR          PAWAN RAJAK
          *===========================================================
          * Revisor
          *   SD                SUMAN DESMUKH
		  *   PR                PAWAN RAJAK
          *===========================================================
          * </SBS_PROLOG>
          * <SBS_SRCTAB owner="BL" name="BL_SBS_META_HEADER" />
          * <SBS_SRCTAB owner="CTRG_SUPPORT" name="DATA_ORIGIN" />
          * <SBS_DESTTAB owner="CTRG" name="ADDL_INFO_GROUP_DICT" />
          * <SBS_PRCGRP name="" seq=""/>
          */
           ADDGRP.ELEMENT_CODE AS dur_uk,
		  'en_US'::TEXT AS base_lang_locale_code,
		  ADDGRP.SORT_SEQ AS sort_seq,
		  NULL AS bg_bg, 
          NULL AS cs_cz, 
          NULL AS da_dk,
          NULL AS de_at, 
          NULL AS de_ch,
          NULL AS de_de,
          NULL AS el_gr,
          NULL AS en_gb,
		  ADDGRP.en_us AS en_us,
		  NULL AS es_es,
          NULL AS et_ee,
          NULL AS es_mx,
          NULL AS fi_fi,
          NULL AS fr_ca,
          NULL AS fr_fr,
          NULL AS hr_hr,
          NULL AS hi_in,
          NULL AS hu_hu,
          NULL AS it_it,
          NULL AS ja_jp,
          NULL AS ko_kr,
          NULL AS lt_lt,
          NULL AS lv_lv,
          NULL AS nl_be,
          NULL AS nl_nl,
          NULL AS no_no,
          NULL AS pl_pl,
          NULL AS pt_br,
          NULL AS pt_pt,
          NULL AS ro_ro,
          NULL AS ru_ru,
          NULL AS sk_sk,
          NULL AS sl_si,
          NULL AS sv_se,
          NULL AS th_th,
          NULL AS tr_tr,
          NULL AS uk_ua,
          NULL AS vi_vn,
          NULL AS zh_cn,
          NULL AS zh_hk,
          NULL AS zh_tw,
          NULL AS zz_zz,
          NULL AS non_translatable,
		  NULL AS secured_id
     FROM DOI
     CROSS JOIN ADDGRP
	 UNION ALL
	 SELECT '*'::TEXT AS dur_uk,
	        '*'::TEXT AS base_lang_locale_code,
			NULL AS sort_seq,
		    NULL AS bg_bg, 
            NULL AS cs_cz, 
            NULL AS da_dk,
            NULL AS de_at, 
            NULL AS de_ch,
            NULL AS de_de,
            NULL AS el_gr,
            NULL AS en_gb,
		    NULL AS en_us,
		    NULL AS es_es,
            NULL AS et_ee,
            NULL AS es_mx,
            NULL AS fi_fi,
            NULL AS fr_ca,
            NULL AS fr_fr,
            NULL AS hr_hr,
            NULL AS hi_in,
            NULL AS hu_hu,
            NULL AS it_it,
            NULL AS ja_jp,
            NULL AS ko_kr,
            NULL AS lt_lt,
            NULL AS lv_lv,
            NULL AS nl_be,
            NULL AS nl_nl,
            NULL AS no_no,
            NULL AS pl_pl,
            NULL AS pt_br,
            NULL AS pt_pt,
            NULL AS ro_ro,
            NULL AS ru_ru,
            NULL AS sk_sk,
            NULL AS sl_si,
            NULL AS sv_se,
            NULL AS th_th,
            NULL AS tr_tr,
            NULL AS uk_ua,
            NULL AS vi_vn,
            NULL AS zh_cn,
            NULL AS zh_hk,
            NULL AS zh_tw,
            NULL AS zz_zz,
            NULL AS non_translatable,
		    NULL AS secured_id;