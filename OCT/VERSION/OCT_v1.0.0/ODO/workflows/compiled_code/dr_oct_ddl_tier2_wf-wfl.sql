do
$workflowcontext$
declare
    /* Export Version 1.7.2
    Exported on:   2024-06-19 09:53:22-04
    From Database: frd_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   dr_oct_ddl_tier2_wf.wfl
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
perform af_repo.fk_add_context('dr_oct_ddl_tier2_wf'::varchar,'W'::varchar, 180::smallint, '(1.7.3)This workflow use to populate DDL from file to oct_ddl_tier2 table'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 18::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'dr_oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 19::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'dr_oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 20::integer, 'set'::varchar, ':tag_area|~|SD'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_area = "SD"'::varchar, 'dr_oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 21::integer, 'set'::varchar, ':tag_other|~|OCT'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :tag_other = "OCT"'::varchar, 'dr_oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 22::integer, 'load'::varchar, ':exception_handler_email|~|select pub_admin.get_parameter(''OCT'')::jsonb->>''email_to'' AS email_to'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    load :exception_handler_email = "select pub_admin.get_parameter(''OCT'')::jsonb->>''email_to'' AS email_to"'::varchar, 'dr_oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 23::integer, 'serial'::varchar, 'main_60'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '    serial #Checks of number of file available with pattern "oct_ddl_export" (Excluding files with .done extention).'::varchar, 'dr_oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 24::integer, 'load'::varchar, ':epo_path|~|select pub_admin.get_parameter(''PBAEPORootPath'')'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '        load :epo_path= "select pub_admin.get_parameter(''PBAEPORootPath'')"'::varchar, 'dr_oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 25::integer, 'load'::varchar, ':script_path|~|select root||script.get_parameter||''OCT/'' from pub_admin.get_parameter(''PBAEnvRootPath'') root cross join (select pub_admin.get_parameter(''PATH_COMMON_SCRIPT'')) script'::varchar, 'main_80'::varchar, ''::varchar, ''::varchar, '        load :script_path="select root||script.get_parameter||''OCT/'' from pub_admin.get_parameter(''PBAEnvRootPath'') root cross join (select pub_admin.get_parameter(''PATH_COMMON_SCRIPT'')) script"'::varchar, 'dr_oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 26::integer, 'run'::varchar, '&&script_path&&oct_FileCount.sh  &&epo_path&&OCT/TIER2 "*oct_ddl_export*"'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        run &&script_path&&oct_FileCount.sh  &&epo_path&&OCT/TIER2 "*oct_ddl_export*"'::varchar, 'dr_oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 27::integer, 'datareceipt'::varchar, 'OCT_DDL_LOADING_TIER2'::varchar, 'main_100'::varchar, ''::varchar, ''::varchar, '    datareceipt OCT_DDL_LOADING_TIER2 #DR Call & load  pub_work.oct_ddl_tier2 table'::varchar, 'dr_oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 28::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'dr_oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'dr_oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.af_compiler_insert('dr_oct_ddl_tier2_wf.wfl', $q$# This workflow use to populate DDL from file to oct_ddl_tier2 table
dr_oct_ddl_tier2_wf(retention=180):  This workflow use to populate DDL from file to oct_ddl_tier2 table
# Project:  FORD
#
# Name: dr_oct_ddl_tier2_wf.wfl
#
# Purpose:  This workflow use to populate DDL from file to oct_ddl_tier2 table
#
#===========================================================
# Revision History
#   Ref   Date          Revisor      Comment
#   1     01-05-2024    BK           Initial Version
#===========================================================
# Revisor
# [Initials]		[Full Name]
# 	BK				Bipin Kumar
#===========================================================
	output_version
	output_options
	set :tag_area = "SD"
	set :tag_other = "OCT"
	load :exception_handler_email = "select pub_admin.get_parameter('OCT')::jsonb->>'email_to' AS email_to"
	serial #Checks of number of file available with pattern "oct_ddl_export" (Excluding files with .done extention).
		load :epo_path= "select pub_admin.get_parameter('PBAEPORootPath')"
		load :script_path="select root||script.get_parameter||'OCT/' from pub_admin.get_parameter('PBAEnvRootPath') root cross join (select pub_admin.get_parameter('PATH_COMMON_SCRIPT')) script"
		run &&script_path&&oct_FileCount.sh  &&epo_path&&OCT/TIER2 "*oct_ddl_export*"
	datareceipt OCT_DDL_LOADING_TIER2 #DR Call & load  pub_work.oct_ddl_tier2 table
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  dr_oct_ddl_tier2_wf.wfl
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
