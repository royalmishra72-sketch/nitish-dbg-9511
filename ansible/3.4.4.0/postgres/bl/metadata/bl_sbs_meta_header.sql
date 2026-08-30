delete from bl.bl_sbs_meta_header where group_name='REPORT_FOR_FAILURES';
INSERT INTO bl.bl_sbs_meta_header (group_name,element_code,element_desc,sort_seq,bg_bg,cs_cz,da_dk,de_at,de_ch,de_de,el_gr,en_gb,en_us,es_es,et_ee,es_mx,fi_fi,fr_ca,fr_fr,hr_hr,hi_in,hu_hu,it_it,ja_jp,ko_kr,lt_lt,lv_lv,nl_be,nl_nl,no_no,pl_pl,pt_br,pt_pt,ro_ro,ru_ru,sk_sk,sl_si,sv_se,th_th,tr_tr,uk_ua,vi_vn,zh_cn,zh_hk,zh_tw,zz_zz) VALUES
	 ('REPORT_FOR_FAILURES','Data Validation Report','Group for report configure for RDVT.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	 ('REPORT_FOR_FAILURES','RDVT','RDVT entry for Image check report',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);


update bl.bl_sbs_meta_header 
set element_code='PAUSE'
where group_name='REPORT_FAILURE_ACTION';