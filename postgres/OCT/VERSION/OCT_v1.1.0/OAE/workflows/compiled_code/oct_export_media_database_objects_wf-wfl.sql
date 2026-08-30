do
$workflowcontext$
declare
    /* Export Version 1.7.2
    Exported on:   2025-04-24 02:18:29-04
    From Database: frd_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   oct_export_media_database_objects_wf.wfl
      p_user:        
    */
    installCount int;
    v_version TEXT;
    v_msg     TEXT;
    v_context TEXT;
    v_detail  TEXT;
    v_hint    TEXT;
    v_state   TEXT;
    v_tmp     varchar;
    v_ret     varchar;
    v_cnt     smallint;
    l_current_version varchar;
begin
    v_version := '1.7.2';
    -- Start Ref#2
    select version
      into l_current_version
      from af_repo.af_version AV
     where av.is_current = 1;
    if sbs_util.get_numeric_version(v_version) > sbs_util.get_numeric_version( l_current_version) then
      raise 'Can not import newer export(%) into older(%) AF version',v_version,l_current_version;
    end if;  
    -- End Ref#2
    v_ret := '';

do
$afcompiler$
begin
perform af_repo.fk_add_context('oct_export_media_database_objects_wf'::varchar,'W'::varchar, 90::smallint, '(1.8.0.0)This workflow is use to exports Media Database objects'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 18::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 19::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 20::integer, 'set'::varchar, ':tag_area|~|SD'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_area = "SD"'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 21::integer, 'set'::varchar, ':tag_other|~|OCT'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :tag_other = "OCT"'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 22::integer, 'load'::varchar, ':exception_handler_email|~|select pub_admin.get_parameter(''OCT'')::jsonb->>''email_to'' AS email_to'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    load :exception_handler_email = "select pub_admin.get_parameter(''OCT'')::jsonb->>''email_to'' AS email_to"'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 23::integer, 'serial'::varchar, 'main_60'::varchar, 'main_200'::varchar, ''::varchar, ''::varchar, '    serial #Fetch ctrg Version from Media Database'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 24::integer, 'load'::varchar, ':chk_media_exists|~|select count(property) from ctrg_support.sbs_property where common_tool_name = ''POSTGRESQL_EXTRACT'' and property_key = ''TARGET_USER'''::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '        load :chk_media_exists = "select count(property) from ctrg_support.sbs_property where common_tool_name = ''POSTGRESQL_EXTRACT'' and property_key = ''TARGET_USER''"'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 25::integer, 'if'::varchar, 'chk_media_exists > 0'::varchar, 'main_80'::varchar, 'main_190'::varchar, ''::varchar, '        if chk_media_exists > 0 #check whether OEM has MEDIA or not'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 26::integer, 'load'::varchar, ':v_dataset_ids|~|select string_agg(dataset_id,'','') as dataset_id from ctrg_support.sbs_schema_target_type_x'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '            load :v_dataset_ids = "select string_agg(dataset_id,'','') as dataset_id from ctrg_support.sbs_schema_target_type_x"'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 27::integer, 'foreach'::varchar, 'v_dataset_id|~|:v_dataset_ids|~|main_100'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            foreach :v_dataset_id in :v_dataset_ids #Fetch info for each dataset'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 28::integer, 'load'::varchar, ':v_db_identifier|~|select property from ctrg_support.sbs_property where common_tool_name = ''POSTGRESQL_EXTRACT'' and property_key = ''MEDIA_TRG_DB_IDENTIFIER'' and dataset_id=%s|~|:v_dataset_id'::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '                load :v_db_identifier = "select property from ctrg_support.sbs_property where common_tool_name = ''POSTGRESQL_EXTRACT'' and property_key = ''MEDIA_TRG_DB_IDENTIFIER'' and dataset_id=%s",:v_dataset_id'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 29::integer, 'load'::varchar, ':v_targ_user|~|select property from ctrg_support.sbs_property where common_tool_name = ''POSTGRESQL_EXTRACT'' and property_key = ''TARGET_USER'' and dataset_id=%s|~|:v_dataset_id'::varchar, 'main_120'::varchar, ''::varchar, ''::varchar, '                load :v_targ_user = "select property from ctrg_support.sbs_property where common_tool_name = ''POSTGRESQL_EXTRACT'' and property_key = ''TARGET_USER'' and dataset_id=%s",:v_dataset_id'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 30::integer, 'load'::varchar, ':v_schema_name|~|select upper(schema_name) from ctrg_support.sbs_schema_target_type_x where dataset_id =%s|~|:v_dataset_id'::varchar, 'main_130'::varchar, ''::varchar, ''::varchar, '                load :v_schema_name ="select upper(schema_name) from ctrg_support.sbs_schema_target_type_x where dataset_id =%s",:v_dataset_id'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 32::integer, 'set'::varchar, ':run_credentials|~|&&v_db_identifier&&,&&v_targ_user&&'::varchar, 'main_140'::varchar, ''::varchar, ''::varchar, '                set :run_credentials = "&&v_db_identifier&&,&&v_targ_user&&"'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 34::integer, 'run'::varchar, 'psql -t -c "select version from ctrg_version where is_current =1"'::varchar, 'main_150'::varchar, ''::varchar, ''::varchar, '                run psql -t -c "select version from ctrg_version where is_current =1"'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 35::integer, 'load'::varchar, ':curr_media_ctrg_version|~|select ''&&stdout&&'''::varchar, 'main_160'::varchar, ''::varchar, ''::varchar, '                load :curr_media_ctrg_version = select ''&&stdout&&'''::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 36::integer, 'sql'::varchar, 'delete from bl.bl_sbs_oct_meta_header where group_name =''MEDIA_DB_CTRG_VERSION'' and code=%s|~|:v_schema_name'::varchar, 'main_170'::varchar, ''::varchar, ''::varchar, '                sql "delete from bl.bl_sbs_oct_meta_header where group_name =''MEDIA_DB_CTRG_VERSION'' and code=%s",:v_schema_name'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_170'::varchar, 37::integer, 'sql'::varchar, 'insert into bl.bl_sbs_oct_meta_header (group_name,code,value,description) values (''MEDIA_DB_CTRG_VERSION'',''&&v_schema_name&&'',''&&curr_media_ctrg_version&&'',''OCT Tool entry to store current media Database ctrg version for comparison'')'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '                sql "insert into bl.bl_sbs_oct_meta_header (group_name,code,value,description) values (''MEDIA_DB_CTRG_VERSION'',''&&v_schema_name&&'',''&&curr_media_ctrg_version&&'',''OCT Tool entry to store current media Database ctrg version for comparison'')"'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_180'::varchar, 39::integer, 'else'::varchar, ''::varchar, 'main_190'::varchar, ''::varchar, ''::varchar, '        else'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_190'::varchar, 40::integer, 'message'::varchar, 'D|~|Seems No Media Database is available'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            message D "Seems No Media Database is available"'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_200'::varchar, 41::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.af_compiler_insert('oct_export_media_database_objects_wf.wfl', $q$# This workflow is use to exports Media Database objects
oct_export_media_database_objects_wf(retention=90): This workflow is use to exports Media Database objects
# Project: Ford NextGen DATA PUBLISHING
#
# Name: oct_export_media_database_objects_wf.wfl
#
# Purpose: This workflow is use to exports Media Database objects
#
#===========================================================
# Revision History
#   Ref    Date          Revisor      Comment
#   1      21-APR-2025   SA          FDNGPUB-2235 - Initial Version, to Fetch CTRG Version
#===========================================================
# Revisor
# [Initials]		[Full Name]
# SA                Sonu Aggarwal
#===========================================================
    output_version
    output_options
	set :tag_area = "SD"
	set :tag_other = "OCT"
	load :exception_handler_email = "select pub_admin.get_parameter('OCT')::jsonb->>'email_to' AS email_to"
	serial #Fetch ctrg Version from Media Database
		load :chk_media_exists = "select count(property) from ctrg_support.sbs_property where common_tool_name = 'POSTGRESQL_EXTRACT' and property_key = 'TARGET_USER'"
		if chk_media_exists > 0 #check whether OEM has MEDIA or not
			load :v_dataset_ids = "select string_agg(dataset_id,',') as dataset_id from ctrg_support.sbs_schema_target_type_x"
			foreach :v_dataset_id in :v_dataset_ids #Fetch info for each dataset
				load :v_db_identifier = "select property from ctrg_support.sbs_property where common_tool_name = 'POSTGRESQL_EXTRACT' and property_key = 'MEDIA_TRG_DB_IDENTIFIER' and dataset_id=%s",:v_dataset_id
				load :v_targ_user = "select property from ctrg_support.sbs_property where common_tool_name = 'POSTGRESQL_EXTRACT' and property_key = 'TARGET_USER' and dataset_id=%s",:v_dataset_id
				load :v_schema_name ="select upper(schema_name) from ctrg_support.sbs_schema_target_type_x where dataset_id =%s",:v_dataset_id
				# run_credentials tells the run command to provide the credentials for the media database.
				set :run_credentials = "&&v_db_identifier&&,&&v_targ_user&&"
				# This run command connects to the Media database, fetch the ctrg version.
				run psql -t -c "select version from ctrg_version where is_current =1"
				load :curr_media_ctrg_version = select '&&stdout&&'
				sql "delete from bl.bl_sbs_oct_meta_header where group_name ='MEDIA_DB_CTRG_VERSION' and code=%s",:v_schema_name
				sql "insert into bl.bl_sbs_oct_meta_header (group_name,code,value,description) values \\
				('MEDIA_DB_CTRG_VERSION','&&v_schema_name&&','&&curr_media_ctrg_version&&','OCT Tool entry to store current media Database ctrg version for comparison')"
		else
			message D "Seems No Media Database is available"
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  oct_export_media_database_objects_wf.wfl
  **
  */
raise notice '******************* SUCCESS!! Workflow import has completed. ****************************';
	
Exception 
		when others then 
		rollback;
		get stacked diagnostics
        v_state   = returned_sqlstate,
        v_msg     = message_text,
        v_detail  = pg_exception_detail,
        v_hint    = pg_exception_hint,
        v_context = pg_exception_context;

    raise notice E'Workflow import script ran into a problem. Exception details:
        state  : %
        message: %
        detail : %
        hint   : %
        context: %', v_state, v_msg, v_detail, v_hint, v_context;

end;
$workflowcontext$ LANGUAGE 'plpgsql';
