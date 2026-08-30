do
$workflowcontext$
declare
    /* Export Version 1.7.2
    Exported on:   2024-06-25 02:09:15-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   clean_files_from_epo_wf.wfl
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
perform af_repo.fk_add_context('clean_files_from_epo_wf'::varchar,'W'::varchar, 90::smallint, '(1.7.3.8)Workflow used to clean files recursively from EPO'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 18::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'clean_files_from_epo_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 19::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'clean_files_from_epo_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 20::integer, 'load'::varchar, ':v_env_root_path|~|select pub_admin.get_parameter(''PBAEnvRootPath'')'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    load :v_env_root_path = "select pub_admin.get_parameter(''PBAEnvRootPath'')"'::varchar, 'clean_files_from_epo_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 21::integer, 'load'::varchar, ':v_epo_root_path|~|select pub_admin.get_parameter(''PBAEPORootPath'')'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    load :v_epo_root_path = "select pub_admin.get_parameter(''PBAEPORootPath'')"'::varchar, 'clean_files_from_epo_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 22::integer, 'set'::varchar, ':v_script_path|~|&&v_env_root_path&&/app/script/'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    set :v_script_path = "&&v_env_root_path&&/app/script/"'::varchar, 'clean_files_from_epo_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 23::integer, 'if'::varchar, 'relative_target_path != '''' and relative_target_path !=NONE'::varchar, 'main_60'::varchar, 'main_80'::varchar, ''::varchar, '    if relative_target_path != '''' and relative_target_path !=NONE'::varchar, 'clean_files_from_epo_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 24::integer, 'run'::varchar, '&&v_script_path&&RecursiveCleanFiles.sh &&v_epo_root_path&&/&&relative_target_path&&'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '        run &&v_script_path&&RecursiveCleanFiles.sh &&v_epo_root_path&&/&&relative_target_path&&'::varchar, 'clean_files_from_epo_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 25::integer, 'else'::varchar, ''::varchar, 'main_80'::varchar, ''::varchar, ''::varchar, '    else'::varchar, 'clean_files_from_epo_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 26::integer, 'message'::varchar, 'W|~|Please pass the correct relative path, it can''t be empty'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '        message W "Please pass the correct relative path, it can''t be empty"'::varchar, 'clean_files_from_epo_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 27::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'clean_files_from_epo_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'clean_files_from_epo_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_option('parameters'::varchar, 'parameters'::varchar, '{"relative_target_path": ""}'::varchar, 'clean_files_from_epo_wf'::varchar, 'W'::varchar, 1::integer);
perform af_repo.af_compiler_insert('clean_files_from_epo_wf.wfl', $q$#Workflow used to clean files recursively from EPO
clean_files_from_epo_wf(relative_target_path=,retention=90): Workflow used to clean files recursively from EPO
# Project: Nissan NG DATA PUBLISHING
#
# Name: clean_files_from_epo_wf.wfl
#
# Purpose: This workflow is used to clean files recursively from EPO
#
#===========================================================
# Revision History
#   Ref   Date          Revisor      Comment
#   1     07-JUNE-2024    NKM        Initial Version 
#===========================================================
# Revisor
# [Initials]		[Full Name]
# NKM               Nitish K Mishra
#===========================================================
	output_version
	output_options
	load :v_env_root_path = "select pub_admin.get_parameter('PBAEnvRootPath')"
	load :v_epo_root_path = "select pub_admin.get_parameter('PBAEPORootPath')"
	set :v_script_path = "&&v_env_root_path&&/app/script/"
	if relative_target_path != '' and relative_target_path !=NONE
		run &&v_script_path&&RecursiveCleanFiles.sh &&v_epo_root_path&&/&&relative_target_path&&
	else
		message W "Please pass the correct relative path, it can't be empty"
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  clean_files_from_epo_wf.wfl
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
