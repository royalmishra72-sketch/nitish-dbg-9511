do
$workflowcontext$
declare
    /* Export Version 1.7.2
    Exported on:   2025-09-29 04:10:36-04
    From Database: frd_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   oct_export_script_report_wf.wfl
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
perform af_repo.fk_add_context('oct_export_script_report_wf'::varchar,'W'::varchar, 180::smallint, '(1.8.0.0)This workflow use to export scripts from pba server.'::varchar, 1::integer, 'gj5701'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 21::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'oct_export_script_report_wf'::varchar, 'W'::varchar, 1::integer, 'gj5701'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 22::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'oct_export_script_report_wf'::varchar, 'W'::varchar, 1::integer, 'gj5701'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 23::integer, 'set'::varchar, ':tag_area|~|SD'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_area = "SD"'::varchar, 'oct_export_script_report_wf'::varchar, 'W'::varchar, 1::integer, 'gj5701'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 24::integer, 'set'::varchar, ':tag_other|~|OCT'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :tag_other = "OCT"'::varchar, 'oct_export_script_report_wf'::varchar, 'W'::varchar, 1::integer, 'gj5701'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 26::integer, 'load'::varchar, ':exception_handler_email|~|select pub_admin.get_parameter(''OCT'')::jsonb->>''email_to'' AS email_to'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    load :exception_handler_email = "select pub_admin.get_parameter(''OCT'')::jsonb->>''email_to'' AS email_to"	'::varchar, 'oct_export_script_report_wf'::varchar, 'W'::varchar, 1::integer, 'gj5701'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 27::integer, 'load'::varchar, ':script_path|~|select root||script.get_parameter||''OCT/'' from pub_admin.get_parameter(''PBAEnvRootPath'') root cross join (select pub_admin.get_parameter(''PATH_COMMON_SCRIPT'')) script'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '    load :script_path="select root||script.get_parameter||''OCT/'' from pub_admin.get_parameter(''PBAEnvRootPath'') root cross join (select pub_admin.get_parameter(''PATH_COMMON_SCRIPT'')) script"'::varchar, 'oct_export_script_report_wf'::varchar, 'W'::varchar, 1::integer, 'gj5701'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 29::integer, 'load'::varchar, ':input_directory|~|SELECT case when ''&&v_input_directory&&''=''DEFAULT'' then pub_admin.get_parameter(''OCT'')::jsonb->>''root_directory'' else ''&&v_input_directory&&'' end AS root_directory'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '    load :input_directory= "SELECT case when ''&&v_input_directory&&''=''DEFAULT'' then pub_admin.get_parameter(''OCT'')::jsonb->>''root_directory'' else ''&&v_input_directory&&'' end AS root_directory"'::varchar, 'oct_export_script_report_wf'::varchar, 'W'::varchar, 1::integer, 'gj5701'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 30::integer, 'load'::varchar, ':csv_file_path|~|select pub_admin.get_parameter(''OCT'')::jsonb->>''root_directory'''::varchar, 'main_80'::varchar, ''::varchar, ''::varchar, '    load :csv_file_path= "select pub_admin.get_parameter(''OCT'')::jsonb->>''root_directory''"'::varchar, 'oct_export_script_report_wf'::varchar, 'W'::varchar, 1::integer, 'gj5701'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 31::integer, 'load'::varchar, ':sender_email|~|select ''&&system_user&&@snapon.com'''::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '    load :sender_email= "select ''&&system_user&&@snapon.com''"'::varchar, 'oct_export_script_report_wf'::varchar, 'W'::varchar, 1::integer, 'gj5701'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 32::integer, 'load'::varchar, ':recipient_email|~|select pub_admin.get_parameter(''OCT'')::jsonb->>''email_to'' AS email_to'::varchar, 'main_100'::varchar, ''::varchar, ''::varchar, '    load :recipient_email= "select pub_admin.get_parameter(''OCT'')::jsonb->>''email_to'' AS email_to"'::varchar, 'oct_export_script_report_wf'::varchar, 'W'::varchar, 1::integer, 'gj5701'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 33::integer, 'load'::varchar, ':exclude_subdirs|~|select case when ''&&v_exclude_subdirs&&''=''DEFAULT'' then pub_admin.get_parameter(''OCT'')::jsonb->>''skip_folder_ls'' else concat(pub_admin.get_parameter(''OCT'')::jsonb->>''skip_folder_ls'','','',''&&v_exclude_subdirs&&'') end as skip_folder_ls'::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '    load :exclude_subdirs= "select case when ''&&v_exclude_subdirs&&''=''DEFAULT'' then pub_admin.get_parameter(''OCT'')::jsonb->>''skip_folder_ls'' else concat(pub_admin.get_parameter(''OCT'')::jsonb->>''skip_folder_ls'','','',''&&v_exclude_subdirs&&'') end as skip_folder_ls"'::varchar, 'oct_export_script_report_wf'::varchar, 'W'::varchar, 1::integer, 'gj5701'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 34::integer, 'load'::varchar, ':exclude_file_list|~|select case when ''&&v_exclude_files&&''=''DEFAULT'' then pub_admin.get_parameter(''OCT'')::jsonb->>''skip_file_ls'' else concat(pub_admin.get_parameter(''OCT'')::jsonb->>''skip_file_ls'','','',''&&v_exclude_files&&'') end as skip_file_ls'::varchar, 'main_120'::varchar, ''::varchar, ''::varchar, '    load :exclude_file_list= "select case when ''&&v_exclude_files&&''=''DEFAULT'' then pub_admin.get_parameter(''OCT'')::jsonb->>''skip_file_ls'' else concat(pub_admin.get_parameter(''OCT'')::jsonb->>''skip_file_ls'','','',''&&v_exclude_files&&'') end as skip_file_ls"'::varchar, 'oct_export_script_report_wf'::varchar, 'W'::varchar, 1::integer, 'gj5701'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 35::integer, 'load'::varchar, ':exclude_file_pattern|~|select case when ''&&v_exclude_file_patterns&&''=''DEFAULT'' then pub_admin.get_parameter(''OCT'')::jsonb->>''skip_file_patterns'' else concat(pub_admin.get_parameter(''OCT'')::jsonb->>''skip_file_patterns'','','',''&&v_exclude_file_patterns&&'') end as skip_file_pattern'::varchar, 'main_130'::varchar, ''::varchar, ''::varchar, '    load :exclude_file_pattern= "select case when ''&&v_exclude_file_patterns&&''=''DEFAULT'' then pub_admin.get_parameter(''OCT'')::jsonb->>''skip_file_patterns'' else concat(pub_admin.get_parameter(''OCT'')::jsonb->>''skip_file_patterns'','','',''&&v_exclude_file_patterns&&'') end as skip_file_pattern"'::varchar, 'oct_export_script_report_wf'::varchar, 'W'::varchar, 1::integer, 'gj5701'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 36::integer, 'load'::varchar, ':db_name|~|select upper(concat(split_part(current_database(),''_'',1)||''_''||split_part(current_database(),''_'',3)||''_''||split_part(current_database(),''_'',4)))'::varchar, 'main_140'::varchar, ''::varchar, ''::varchar, '    load :db_name= "select upper(concat(split_part(current_database(),''_'',1)||''_''||split_part(current_database(),''_'',3)||''_''||split_part(current_database(),''_'',4)))"'::varchar, 'oct_export_script_report_wf'::varchar, 'W'::varchar, 1::integer, 'gj5701'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 37::integer, 'load'::varchar, ':hash_comparable_file_pattern_list|~|select pub_admin.get_parameter(''OCT'')::jsonb->>''hash_comparable_file_pattern'''::varchar, 'main_150'::varchar, ''::varchar, ''::varchar, '    load :hash_comparable_file_pattern_list = "select pub_admin.get_parameter(''OCT'')::jsonb->>''hash_comparable_file_pattern''"'::varchar, 'oct_export_script_report_wf'::varchar, 'W'::varchar, 1::integer, 'gj5701'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 38::integer, 'load'::varchar, ':pba_python_path|~|select pub_admin.get_parameter(''pba_python_path'')'::varchar, 'main_160'::varchar, ''::varchar, ''::varchar, '    load :pba_python_path = "select pub_admin.get_parameter(''pba_python_path'')"'::varchar, 'oct_export_script_report_wf'::varchar, 'W'::varchar, 1::integer, 'gj5701'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 39::integer, 'run'::varchar, '&&pba_python_path&& &&script_path&&oct_script_export.py &&input_directory&& &&csv_file_path&& &&sender_email&& &&recipient_email&& &&exclude_subdirs&& &&exclude_file_list&& &&exclude_file_pattern&& &&db_name&& &&hash_comparable_file_pattern_list&&'::varchar, 'main_170'::varchar, ''::varchar, ''::varchar, '    run &&pba_python_path&& &&script_path&&oct_script_export.py &&input_directory&& &&csv_file_path&& &&sender_email&& &&recipient_email&& &&exclude_subdirs&& &&exclude_file_list&& &&exclude_file_pattern&& &&db_name&& &&hash_comparable_file_pattern_list&&'::varchar, 'oct_export_script_report_wf'::varchar, 'W'::varchar, 1::integer, 'gj5701'::varchar);
perform af_repo.fk_add_step('main_170'::varchar, 40::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'oct_export_script_report_wf'::varchar, 'W'::varchar, 1::integer, 'gj5701'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'oct_export_script_report_wf'::varchar, 'W'::varchar, 1::integer, 'gj5701'::varchar);
perform af_repo.fk_add_option('parameters'::varchar, 'parameters'::varchar, '{"v_input_directory": "DEFAULT", "v_exclude_subdirs": "DEFAULT", "v_exclude_files": "DEFAULT", "v_exclude_file_patterns": "DEFAULT"}'::varchar, 'oct_export_script_report_wf'::varchar, 'W'::varchar, 1::integer);
perform af_repo.af_compiler_insert('oct_export_script_report_wf.wfl', $q$# This workflow use to export scripts from pba server.
oct_export_script_report_wf(retention=180,v_input_directory=DEFAULT,v_exclude_subdirs=DEFAULT,v_exclude_files=DEFAULT,v_exclude_file_patterns=DEFAULT):  This workflow use to export scripts from pba server.
# Project:  FORD
#
# Name: oct_export_script_report_wf.wfl
#
# Purpose: This workflow use to export scripts from pba server.
#
#===========================================================
# Revision History
#   Ref   Date          Revisor      Comment
#   1     23-05-2024    BK           Initial Version
#	2	  26-Jul-2024	RT			 Input parameter name change
#	3	  11-SEP-2025   RT			 [FDNGPUB-2559] - To call python script for Python Version Upgrade Without Publishing Code Change
#===========================================================
# Revisor
# [Initials]		[Full Name]
# BK				Bipin Kumar
# RT				Richa Thakur
#===========================================================
	output_version
	output_options
	set :tag_area = "SD"
	set :tag_other = "OCT"
	
	load :exception_handler_email = "select pub_admin.get_parameter('OCT')::jsonb->>'email_to' AS email_to"	
	load :script_path="select root||script.get_parameter||'OCT/' from pub_admin.get_parameter('PBAEnvRootPath') root cross join (select pub_admin.get_parameter('PATH_COMMON_SCRIPT')) script"

	load :input_directory= "SELECT case when '&&v_input_directory&&'='DEFAULT' then pub_admin.get_parameter('OCT')::jsonb->>'root_directory' else '&&v_input_directory&&' end AS root_directory"
	load :csv_file_path= "select pub_admin.get_parameter('OCT')::jsonb->>'root_directory'"
	load :sender_email= "select '&&system_user&&@snapon.com'"
	load :recipient_email= "select pub_admin.get_parameter('OCT')::jsonb->>'email_to' AS email_to"
	load :exclude_subdirs= "select case when '&&v_exclude_subdirs&&'='DEFAULT' then pub_admin.get_parameter('OCT')::jsonb->>'skip_folder_ls' else concat(pub_admin.get_parameter('OCT')::jsonb->>'skip_folder_ls',',','&&v_exclude_subdirs&&') end as skip_folder_ls"
	load :exclude_file_list= "select case when '&&v_exclude_files&&'='DEFAULT' then pub_admin.get_parameter('OCT')::jsonb->>'skip_file_ls' else concat(pub_admin.get_parameter('OCT')::jsonb->>'skip_file_ls',',','&&v_exclude_files&&') end as skip_file_ls"
	load :exclude_file_pattern= "select case when '&&v_exclude_file_patterns&&'='DEFAULT' then pub_admin.get_parameter('OCT')::jsonb->>'skip_file_patterns' else concat(pub_admin.get_parameter('OCT')::jsonb->>'skip_file_patterns',',','&&v_exclude_file_patterns&&') end as skip_file_pattern"
	load :db_name= "select upper(concat(split_part(current_database(),'_',1)||'_'||split_part(current_database(),'_',3)||'_'||split_part(current_database(),'_',4)))"
	load :hash_comparable_file_pattern_list = "select pub_admin.get_parameter('OCT')::jsonb->>'hash_comparable_file_pattern'"
	load :pba_python_path = "select pub_admin.get_parameter('pba_python_path')"
	run &&pba_python_path&& &&script_path&&oct_script_export.py &&input_directory&& &&csv_file_path&& &&sender_email&& &&recipient_email&& &&exclude_subdirs&& &&exclude_file_list&& &&exclude_file_pattern&& &&db_name&& &&hash_comparable_file_pattern_list&&
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  oct_export_script_report_wf.wfl
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
