----[FDNGPUB-2337] Use pub_admin views to export the table data 

update bl.bl_sbs_oct_meta_tables set table_name ='aat_app_access_types_v' where table_name ='aat_app_access_types_t';
update bl.bl_sbs_oct_meta_tables set table_name ='dr_datasrc_v' where table_name ='dr_datasrc_t';
update bl.bl_sbs_oct_meta_tables set table_name ='dr_datasrclctn_v' where table_name ='dr_datasrclctn_t';


-- Setting this table's to_be_compare as N due to reason that select grant has been revoked from pub_work & we do not have the corresponding view
update  bl.bl_sbs_oct_meta_tables
set to_be_compare ='N'
where schema_name ='pub_admin' and table_name in ('dr_prvdr_t','pba_param_t');
