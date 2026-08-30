-- FDNGPUB-2208 script to update datasource as NOT_IN_USE
update dr_datasrc_t 
set datasrc_nm = concat('NOT_IN_USE-',datasrc_nm)
where datasrc_nm in ('OCT_DDL_LOADING_TIER1','OCT_DDL_LOADING_TIER2','OCT_SCRIPT_LOADING_TIER1','OCT_SCRIPT_LOADING_TIER2');

analyze verbose dr_datasrc_t;
