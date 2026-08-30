delete from pub_admin.pba_param_t where param_nm='OCT';
insert into pub_admin.pba_param_t(param_nm,param_value_txt,param_dsc)
select 
'OCT',
'{
	 "schema_ddl": "'||string_agg(distinct upper(schemaname),',' order by upper(schemaname))||',BL_APP,PUB_ADMIN_APP,PUB_WORK_APP",
	 "ddl_type": "CONTEXT_OPTIONS,FUNCTION,GRANTS,META_TABLE,PARTITION_NAME,PROCEDURE,SCHEMA_SIZE,TABLE,VIEW,WORKFLOW",
	 "email_to": "nitish.k.mishra@snapon.com,chandan.bhatia@snapon.com",
	 "skip_file_ls":"##############",
	 "skip_folder_ls":"NGDataReceipt,NGDataReceiptShell,NGDataReceiptJava,NGDataReceiptConfig",
	 "skip_file_patterns":"##############",
	 "hash_comparable_file_pattern":".jar,.pyc",
	 "root_directory":"'||root.get_parameter||trim(script.get_parameter,'/')||'",
	 "script_destination":"'||root.get_parameter||script.get_parameter||'OCT/",
	 "oct_version":"1.0.0"
}',
'OCT Prameters in JSON Format'
from pg_catalog.pg_tables 
cross join (select pub_admin.get_parameter('PBAEnvRootPath')) root
cross join (select pub_admin.get_parameter('PATH_COMMON_SCRIPT')) script
where upper(schemaname) in ('AF_REPO','BL','CTRG','CTRG_SUPPORT','HOSTING_SUPPORT','PUB_ADMIN','PUB_WORK','SBS_UTIL','SSCTRG')
or  schemaname like 'trg_ds_%'
group by root.get_parameter,script.get_parameter;

Analyse verbose pub_admin.pba_param_t ;