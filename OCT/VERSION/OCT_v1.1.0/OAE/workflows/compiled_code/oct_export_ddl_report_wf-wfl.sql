do
$workflowcontext$
declare
    /* Export Version 1.7.2
    Exported on:   2025-04-24 03:15:41-04
    From Database: frd_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   oct_export_ddl_report_wf.wfl
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
perform af_repo.fk_add_context('oct_export_ddl_report_wf'::varchar,'W'::varchar, 180::smallint, '(1.8.0.0)This workflow used to export DDL from DB and send them on email.'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 21::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 22::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 23::integer, 'set'::varchar, ':tag_domain|~|Reports'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_domain = "Reports"'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 24::integer, 'load'::varchar, ':exception_handler_email|~|select pub_admin.get_parameter(''OCT'')::jsonb->>''email_to'' AS email_to'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    load :exception_handler_email = "select pub_admin.get_parameter(''OCT'')::jsonb->>''email_to'' AS email_to"'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 25::integer, 'load'::varchar, ':is_schema_check|~|select case when (''&&schema_name&&'' =''ALL'' or ''&&schema_name&&''='''') then ''NO CHECK'' else ''CHECK'' end'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    load :is_schema_check = "select case when (''&&schema_name&&'' =''ALL'' or ''&&schema_name&&''='''') then ''NO CHECK'' else ''CHECK'' end"'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 26::integer, 'load'::varchar, ':is_object_type_check|~|select case when (''&&object_type&&'' =''ALL'' or ''&&object_type&&''='''') then ''NO CHECK'' else ''CHECK'' end'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '    load :is_object_type_check = "select case when (''&&object_type&&'' =''ALL'' or ''&&object_type&&''='''') then ''NO CHECK'' else ''CHECK'' end"'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 27::integer, 'load'::varchar, ':is_object_name_check|~|select case when (''&&object_name&&'' =''ALL'' or ''&&object_name&&'' ='''') then ''NO CHECK'' else ''CHECK'' end'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '    load :is_object_name_check="select case when (''&&object_name&&'' =''ALL'' or ''&&object_name&&'' ='''') then ''NO CHECK'' else ''CHECK'' end"'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 28::integer, 'parallel'::varchar, 'main_80|~|main_130|~|main_180'::varchar, 'main_230'::varchar, ''::varchar, ''::varchar, '    parallel # checks '::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 29::integer, 'serial'::varchar, 'main_90'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        serial #Check if schema is valid'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 30::integer, 'if'::varchar, 'is_schema_check == "CHECK"'::varchar, 'main_100'::varchar, 'Done'::varchar, ''::varchar, '            if is_schema_check == "CHECK"'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 31::integer, 'load'::varchar, ':is_valid_schema|~|select (length(''&&schema_name&&'') - length(replace(''&&schema_name&&'','','','''')))::int'::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '                load :is_valid_schema ="select (length(''&&schema_name&&'') - length(replace(''&&schema_name&&'','','','''')))::int"'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 32::integer, 'if'::varchar, 'is_valid_schema > 0'::varchar, 'main_120'::varchar, 'Done'::varchar, ''::varchar, '                if is_valid_schema > 0'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 33::integer, 'message'::varchar, 'E|~|Passing multiple schema from input parameter is not supported. To execute WF for multiple Schema, Please update the schema_ddl value of OCT parameter accordingly in pba_param_t table'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '                    message E "Passing multiple schema from input parameter is not supported. To execute WF for multiple Schema, Please update the schema_ddl value of OCT parameter accordingly in pba_param_t table"	'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 34::integer, 'serial'::varchar, 'main_140'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        serial #Check if object_type is valid'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 35::integer, 'if'::varchar, 'is_object_type_check=="CHECK"'::varchar, 'main_150'::varchar, 'Done'::varchar, ''::varchar, '            if is_object_type_check=="CHECK"'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 36::integer, 'load'::varchar, ':is_valid_object_type|~|select (length(''&&object_type&&'') - length(replace(''&&object_type&&'','','','''')))::int'::varchar, 'main_160'::varchar, ''::varchar, ''::varchar, '                load :is_valid_object_type ="select (length(''&&object_type&&'') - length(replace(''&&object_type&&'','','','''')))::int"'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 37::integer, 'if'::varchar, 'is_valid_object_type > 0'::varchar, 'main_170'::varchar, 'Done'::varchar, ''::varchar, '                if is_valid_object_type > 0'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_170'::varchar, 38::integer, 'message'::varchar, 'E|~|Passing multiple object_type from input parameter is not supported. To execute WF for multiple object_type, Please update the ddl_type value of OCT parameter accordingly in pba_param_t table'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '                    message E "Passing multiple object_type from input parameter is not supported. To execute WF for multiple object_type, Please update the ddl_type value of OCT parameter accordingly in pba_param_t table"	'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_180'::varchar, 39::integer, 'serial'::varchar, 'main_190'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        serial #Check if multiple object_name has been passed'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_190'::varchar, 40::integer, 'if'::varchar, 'is_object_name_check=="CHECK"'::varchar, 'main_200'::varchar, 'Done'::varchar, ''::varchar, '            if is_object_name_check=="CHECK"'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_200'::varchar, 41::integer, 'load'::varchar, ':is_valid_object|~|select (length(''&&object_name&&'') - length(replace(''&&object_name&&'','','','''')))::int'::varchar, 'main_210'::varchar, ''::varchar, ''::varchar, '                load :is_valid_object ="select (length(''&&object_name&&'') - length(replace(''&&object_name&&'','','','''')))::int"'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_210'::varchar, 42::integer, 'if'::varchar, 'is_valid_object > 0'::varchar, 'main_220'::varchar, 'Done'::varchar, ''::varchar, '                if is_valid_object > 0'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_220'::varchar, 43::integer, 'message'::varchar, 'W|~|Passing multiple objects from input parameter is not supported. You can pass either one valid object name or ALL(To export all objects based on schema_name and object_type)'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '                    message W "Passing multiple objects from input parameter is not supported. You can pass either one valid object name or ALL(To export all objects based on schema_name and object_type)"	'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_230'::varchar, 44::integer, 'serial'::varchar, 'main_240'::varchar, 'main_270'::varchar, ''::varchar, ''::varchar, '    serial #Fetch Media DB Objects'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_240'::varchar, 45::integer, 'load'::varchar, ':chk_media_exists|~|select count(property) from ctrg_support.sbs_property where common_tool_name = ''POSTGRESQL_EXTRACT'' and property_key = ''TARGET_USER'''::varchar, 'main_250'::varchar, ''::varchar, ''::varchar, '        load :chk_media_exists = "select count(property) from ctrg_support.sbs_property where common_tool_name = ''POSTGRESQL_EXTRACT'' and property_key = ''TARGET_USER''"'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_250'::varchar, 46::integer, 'if'::varchar, 'chk_media_exists > 0'::varchar, 'main_260'::varchar, 'Done'::varchar, ''::varchar, '        if chk_media_exists > 0 #check whether OEM has MEDIA or not'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_260'::varchar, 47::integer, 'execute'::varchar, 'oct_export_media_database_objects_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            execute oct_export_media_database_objects_wf #Export Media database CTRG version'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_270'::varchar, 48::integer, 'serial'::varchar, 'main_280'::varchar, 'main_320'::varchar, ''::varchar, ''::varchar, '    serial #DDL Export'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_280'::varchar, 49::integer, 'load'::varchar, ':p_in_schema_name|~|select upper(''&&schema_name&&'')'::varchar, 'main_290'::varchar, ''::varchar, ''::varchar, '        load :p_in_schema_name = "select upper(''&&schema_name&&'')"'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_290'::varchar, 50::integer, 'load'::varchar, ':p_in_object_type|~|select upper(''&&object_type&&'')'::varchar, 'main_300'::varchar, ''::varchar, ''::varchar, '        load :p_in_object_type ="select upper(''&&object_type&&'')"'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_300'::varchar, 51::integer, 'load'::varchar, ':p_in_object_name|~|select lower(''&&object_name&&'')'::varchar, 'main_310'::varchar, ''::varchar, ''::varchar, '        load :p_in_object_name = "select lower(''&&object_name&&'')"'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_310'::varchar, 52::integer, 'report'::varchar, 'oct_ddl_export|~|:p_in_schema_name, :p_in_object_type, :p_in_object_name'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        report oct_ddl_export(:p_in_schema_name, :p_in_object_type, :p_in_object_name)'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_320'::varchar, 53::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_option('parameters'::varchar, 'parameters'::varchar, '{"schema_name": "ALL", "object_type": "<select class=\\"pc_select\\"><option>ALL</option><option>CONTEXT_OPTIONS</option><option>FUNCTION</option><option>GRANTS</option><option>META_TABLE</option><option>PARTITION_NAME</option><option>PROCEDURE</option><option>SCHEMA_SIZE</option><option>TABLE</option><option>VIEW</option><option>WORKFLOW</option></select>", "object_name": "ALL"}'::varchar, 'oct_export_ddl_report_wf'::varchar, 'W'::varchar, 1::integer);
perform af_repo.af_compiler_insert('oct_export_ddl_report_wf.wfl', $q$# This workflow used to export DDL from DB and send them on email.
oct_export_ddl_report_wf(schema_name=ALL,object_type=[ALL:CONTEXT_OPTIONS:FUNCTION:GRANTS:META_TABLE:PARTITION_NAME:PROCEDURE:SCHEMA_SIZE:TABLE:VIEW:WORKFLOW],object_name=ALL) : This workflow used to export DDL from DB and send them on email.
# Project:  FORD
#
# Name: oct_export_ddl_report_wf.wfl
#
# Purpose:This workflow used to export DDL from DB and send them on email.
#
#===========================================================
# Revision History
#   Ref   Date          Revisor      Comment
#   1     03-Mar-2024    BK          Initial Version
#	2	  26-Jul-2024	 RT			 Input parameter correction
#	3	  21-Apr-2025	 SA			 [FDNGPUB-2235] - Addition of media ctrg version export to bl_sbs_meta_header table
#===========================================================
# Revisor
# [Initials]		[Full Name]
# BK				BIPIN KUMAR
# RT				Richa Thakur
#===========================================================
	output_version
	output_options
	set :tag_domain = "Reports"
	load :exception_handler_email = "select pub_admin.get_parameter('OCT')::jsonb->>'email_to' AS email_to"
	load :is_schema_check = "select case when ('&&schema_name&&' ='ALL' or '&&schema_name&&'='') then 'NO CHECK' else 'CHECK' end"
	load :is_object_type_check = "select case when ('&&object_type&&' ='ALL' or '&&object_type&&'='') then 'NO CHECK' else 'CHECK' end"
	load :is_object_name_check="select case when ('&&object_name&&' ='ALL' or '&&object_name&&' ='') then 'NO CHECK' else 'CHECK' end"
	parallel # checks 
		serial #Check if schema is valid
			if is_schema_check == "CHECK"
				load :is_valid_schema ="select (length('&&schema_name&&') - length(replace('&&schema_name&&',',','')))::int"
				if is_valid_schema > 0
					message E "Passing multiple schema from input parameter is not supported. To execute WF for multiple Schema, Please update the schema_ddl value of OCT parameter accordingly in pba_param_t table"	
		serial #Check if object_type is valid
			if is_object_type_check=="CHECK"
				load :is_valid_object_type ="select (length('&&object_type&&') - length(replace('&&object_type&&',',','')))::int"
				if is_valid_object_type > 0
					message E "Passing multiple object_type from input parameter is not supported. To execute WF for multiple object_type, Please update the ddl_type value of OCT parameter accordingly in pba_param_t table"	
		serial #Check if multiple object_name has been passed
			if is_object_name_check=="CHECK"
				load :is_valid_object ="select (length('&&object_name&&') - length(replace('&&object_name&&',',','')))::int"
				if is_valid_object > 0
					message W "Passing multiple objects from input parameter is not supported. You can pass either one valid object name or ALL(To export all objects based on schema_name and object_type)"	
	serial #Fetch Media DB Objects
		load :chk_media_exists = "select count(property) from ctrg_support.sbs_property where common_tool_name = 'POSTGRESQL_EXTRACT' and property_key = 'TARGET_USER'"
		if chk_media_exists > 0 #check whether OEM has MEDIA or not
			execute oct_export_media_database_objects_wf #Export Media database CTRG version
	serial #DDL Export
		load :p_in_schema_name = "select upper('&&schema_name&&')"
		load :p_in_object_type ="select upper('&&object_type&&')"
		load :p_in_object_name = "select lower('&&object_name&&')"
		report oct_ddl_export(:p_in_schema_name, :p_in_object_type, :p_in_object_name)
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  oct_export_ddl_report_wf.wfl
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
