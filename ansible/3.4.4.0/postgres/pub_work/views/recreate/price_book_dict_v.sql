drop view if exists price_book_dict_v;
CREATE or REPLACE VIEW pub_work.price_book_dict_v as 
   WITH doi
   
   
        AS (SELECT dod.data_origin_id
              /*<SBS_RULE> Single value NIS|ALL will be used for all DATA_ORIGIN_ID </SBS_RULE>*/
              FROM ctrg_support.data_origin dod
             WHERE dod.dur_uk = 'NIS|ALL'
			),
        bus_region
        AS (SELECT business_region_id
              /*<SBS_RULE> BUSINESS_REGION_ID selected for DUR_UK='ALL' for ALL NIS catalogs</SBS_RULE>*/
              FROM ctrg.business_region
             WHERE dur_uk = 'ALL'
			)
		SELECT DISTINCT /*******************************************************
                   <SBS_PROLOG>
                   * Project:   NISSAN DATA PUBLISHING
                   * Purpose:  THIS VIEW IS USED TO POPULATE THE PRICE BOOK DICT TABLE.
                   *
                   * PL/SQL Objects Used:
                   *    <Object Type> - <Schema  Owner> - <Object Name>
                   ===========================================================
                   Revision History
                   Ref #  Date          Revisor      Comment
                   [ref]  DD-MON-YYYY   [Initials]   [comment]
                   1     02-09-2015      NS           Initial version
				   2     02-05-2023      PR           View updated according to postgres
                   ===========================================================
                   Revisor
                   *   [initials]    [Full Name]
                   *   NS            NISHANT SONI
				   *   PR            PAWAN RAJAK
                   ===========================================================
                   </SBS_PROLOG>
                   <SBS_SRCTAB owner="CTRG_SUPPORT" name="DATA_ORIGIN" />
                   <SBS_SRCTAB owner="CTRG" name="BUSINESS_REGION" />
                   <SBS_PRCGRP name="LOAD_UPPER_NAVIGATION" seq="5"/>
                   Insert all other tag comments that are relevant
                   *********************************************************/			   
				   bsmh.element_code::text AS dur_uk,
                   'en_US' as base_lang_locale_code,
                   bsmh.bg_bg as bg_bg,
                   bsmh.cs_cz as cs_cz,
                   bsmh.da_dk as da_dk,
                   bsmh.de_at as de_at,
                   bsmh.de_ch as de_ch,
                   bsmh.de_de as de_de,
                   bsmh.el_gr as el_gr,
                   bsmh.en_gb as en_gb,
                   bsmh.en_us as en_us,
                   bsmh.es_es as es_es,
                   bsmh.et_ee as et_ee,
                   bsmh.es_mx as es_mx,
                   bsmh.fi_fi as fi_fi,
                   bsmh.fr_ca as fr_ca,
                   bsmh.fr_fr as fr_fr,
                   bsmh.hr_hr as hr_hr,
                   bsmh.hi_in as hi_in,
                   bsmh.hu_hu as hu_hu,
                   bsmh.it_it as it_it,
                   bsmh.ja_jp as ja_jp,
                   bsmh.ko_kr as ko_kr,
                   bsmh.lt_lt as lt_lt,
                   bsmh.lv_lv as lv_lv,
                   bsmh.nl_be as nl_be,
                   bsmh.nl_nl as nl_nl,
                   bsmh.no_no as no_no,
                   bsmh.pl_pl as pl_pl,
                   bsmh.pt_br as pt_br,
                   bsmh.pt_pt as pt_pt,
                   bsmh.ro_ro as ro_ro,
                   bsmh.ru_ru as ru_ru,
                   bsmh.sk_sk as sk_sk,
                   bsmh.sl_si as sl_si,
                   bsmh.sv_se as sv_se,
                   bsmh.th_th as th_th,
                   bsmh.tr_tr as tr_tr,
                   bsmh.uk_ua as uk_ua,
                   bsmh.vi_vn as vi_vn,
                   bsmh.zh_cn as zh_cn,
                   bsmh.zh_hk as zh_hk,
                   bsmh.zh_tw as zh_tw,
                   bsmh.zz_zz as zz_zz,
                   null as non_translatable,
                   0::boolean as archivable_ind,
                   1::boolean as valid_for_media_ind
		     FROM  bl.bl_sbs_meta_header bsmh
			 CROSS JOIN doi
			 CROSS JOIN bus_region
             WHERE bsmh.group_name = 'PRICE_BOOK_DICT'		 
		     UNION ALL
		     SELECT '*' as dur_uk,
                    '*' as base_lang_locale_code,
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
                   null as non_translatable,
                   0::boolean as archivable_ind,
                   1::boolean as valid_for_media_ind;