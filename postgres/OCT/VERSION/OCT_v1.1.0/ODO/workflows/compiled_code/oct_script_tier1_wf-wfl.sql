do
$workflowcontext$
declare
    /* Export Version 1.7.2
    Exported on:   2025-02-03 06:35:00-05
    From Database: frd_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   oct_script_tier1_wf.wfl
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
perform af_repo.fk_add_context('oct_script_tier1_wf'::varchar,'W'::varchar, 90::smallint, '(1.8.0.0)This workflow use to populate Scripts data from file to oct_ddl_tier1 table'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 18::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'oct_script_tier1_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 19::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'oct_script_tier1_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 20::integer, 'set'::varchar, ':tag_area|~|SD'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_area = "SD"'::varchar, 'oct_script_tier1_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 21::integer, 'set'::varchar, ':tag_other|~|OCT'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :tag_other = "OCT"'::varchar, 'oct_script_tier1_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 22::integer, 'load'::varchar, ':exception_handler_email|~|select pub_admin.get_parameter(''OCT'')::jsonb->>''email_to'' AS email_to'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    load :exception_handler_email = "select pub_admin.get_parameter(''OCT'')::jsonb->>''email_to'' AS email_to"'::varchar, 'oct_script_tier1_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 23::integer, 'load'::varchar, ':epo_path|~|select pub_admin.get_parameter(''PBAEPORootPath'')'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '    load :epo_path = "select pub_admin.get_parameter(''PBAEPORootPath'')"'::varchar, 'oct_script_tier1_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 24::integer, 'serial'::varchar, 'main_70'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '    serial #Checks of number of file available with pattern "oct_ddl_export" (Excluding files with .done extention).'::varchar, 'oct_script_tier1_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 25::integer, 'load'::varchar, ':script_path|~|select root||script.get_parameter||''OCT/'' from pub_admin.get_parameter(''PBAEnvRootPath'') root cross join (select pub_admin.get_parameter(''PATH_COMMON_SCRIPT'')) script'::varchar, 'main_80'::varchar, ''::varchar, ''::varchar, '        load :script_path="select root||script.get_parameter||''OCT/'' from pub_admin.get_parameter(''PBAEnvRootPath'') root cross join (select pub_admin.get_parameter(''PATH_COMMON_SCRIPT'')) script"'::varchar, 'oct_script_tier1_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 26::integer, 'run'::varchar, '&&script_path&&oct_FileCount.sh  &&epo_path&&OCT/TIER1 "*oct_script_export*"'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        run &&script_path&&oct_FileCount.sh  &&epo_path&&OCT/TIER1 "*oct_script_export*"'::varchar, 'oct_script_tier1_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 27::integer, 'serial'::varchar, 'main_100'::varchar, 'main_180'::varchar, ''::varchar, ''::varchar, '    serial #Set Up & load table oct_ddl_tier1'::varchar, 'oct_script_tier1_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 28::integer, 'set'::varchar, ':file_buffersize_override|~|100000000'::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '        set :file_buffersize_override ="100000000"'::varchar, 'oct_script_tier1_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 29::integer, 'set'::varchar, ':reg_ex|~|^.*oct_script_export.*\\.(csv|gz)$'::varchar, 'main_120'::varchar, ''::varchar, ''::varchar, '        set :reg_ex = "^.*oct_script_export.*\\.(csv|gz)$" #Filename Pattern'::varchar, 'oct_script_tier1_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 30::integer, 'set'::varchar, ':path|~|&&epo_path&&/OCT/TIER1'::varchar, 'main_130'::varchar, ''::varchar, ''::varchar, '        set :path = "&&epo_path&&/OCT/TIER1" #Setting File Path'::varchar, 'oct_script_tier1_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 31::integer, 'get_files'::varchar, ':path|~|:reg_ex|~|:filename'::varchar, 'main_140'::varchar, ''::varchar, ''::varchar, '        get_files :path :reg_ex :filename #Call get_files fnc'::varchar, 'oct_script_tier1_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 32::integer, 'set'::varchar, ':file_received|~|&&filename&&'::varchar, 'main_150'::varchar, ''::varchar, ''::varchar, '        set :file_received = "&&filename&&" #Store file received via get_files'::varchar, 'oct_script_tier1_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 33::integer, 'publish'::varchar, 'pub_work.file_oct_ddl_tier1'::varchar, 'main_160'::varchar, ''::varchar, ''::varchar, '        publish pub_work.file_oct_ddl_tier1 #Load oct_ddl_tier1 table'::varchar, 'oct_script_tier1_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 34::integer, 'set'::varchar, ':cwd_path|~|:path'::varchar, 'main_170'::varchar, ''::varchar, ''::varchar, '        set :cwd_path = :path #set cwd'::varchar, 'oct_script_tier1_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_170'::varchar, 35::integer, 'run'::varchar, 'mv "&&filename&&" "&&filename&&.done"'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        run mv "&&filename&&" "&&filename&&.done" # Rename file to .done'::varchar, 'oct_script_tier1_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('main_180'::varchar, 36::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'oct_script_tier1_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'oct_script_tier1_wf'::varchar, 'W'::varchar, 1::integer, 'wx7573'::varchar);
perform af_repo.af_compiler_insert('oct_script_tier1_wf.wfl', $q$#This workflow use to populate Scripts data from file to oct_ddl_tier1 table
oct_script_tier1_wf(retention=90): This workflow use to populate Scripts data from file to oct_ddl_tier1 table
# Project:  Ford NextGen Snap-on EPC
#
# Name: oct_script_tier1_wf.wfl
#
# Purpose:This workflow use to populate Scripts data into oct_ddl_tier1 table
#
#===========================================================
# Revision History
#   Ref   Date          Revisor      Comment
#   1     31-01-2025     SA          [FDNGPUB-2208] -Initial Version, Eliminated use of DR, used AF functionality to load .csv/.gz files directly through AF.
#===========================================================
# Revisor
# [Initials]		[Full Name]
# 	SA				Sonu Aggarwal
#===========================================================
    output_version
    output_options
    set :tag_area = "SD"
	set :tag_other = "OCT"
	load :exception_handler_email = "select pub_admin.get_parameter('OCT')::jsonb->>'email_to' AS email_to"
	load :epo_path = "select pub_admin.get_parameter('PBAEPORootPath')"
	serial #Checks of number of file available with pattern "oct_ddl_export" (Excluding files with .done extention).
		load :script_path="select root||script.get_parameter||'OCT/' from pub_admin.get_parameter('PBAEnvRootPath') root cross join (select pub_admin.get_parameter('PATH_COMMON_SCRIPT')) script"
		run &&script_path&&oct_FileCount.sh  &&epo_path&&OCT/TIER1 "*oct_script_export*"
	serial #Set Up & load table oct_ddl_tier1
		set :file_buffersize_override ="100000000"
		set :reg_ex = "^.*oct_script_export.*\\.(csv|gz)$" #Filename Pattern
		set :path = "&&epo_path&&/OCT/TIER1" #Setting File Path
		get_files :path :reg_ex :filename #Call get_files fnc
		set :file_received = "&&filename&&" #Store file received via get_files
		publish pub_work.file_oct_ddl_tier1 #Load oct_ddl_tier1 table
		set :cwd_path = :path #set cwd
		run mv "&&filename&&" "&&filename&&.done" # Rename file to .done
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  oct_script_tier1_wf.wfl
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
