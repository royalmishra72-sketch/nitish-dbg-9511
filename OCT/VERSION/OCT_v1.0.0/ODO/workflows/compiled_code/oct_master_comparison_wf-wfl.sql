do
$workflowcontext$
declare
    /* Export Version 1.7.2
    Exported on:   2024-06-19 09:53:23-04
    From Database: frd_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   oct_master_comparison_wf.wfl
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
perform af_repo.fk_add_context('oct_master_comparison_wf'::varchar,'W'::varchar, 90::smallint, '(1.7.3)This workflow use to populate data from file to pub_work.oct_ddl_tier1&pub_work.oct_ddl_tier2 table and compare the data of both table'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 18::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 19::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 20::integer, 'set'::varchar, ':tag_area|~|SD'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_area = "SD"'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 21::integer, 'set'::varchar, ':tag_other|~|OCT'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :tag_other = "OCT"'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 22::integer, 'load'::varchar, ':exception_handler_email|~|select pub_admin.get_parameter(''OCT'')::jsonb->>''email_to'' AS email_to'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    load :exception_handler_email = "select pub_admin.get_parameter(''OCT'')::jsonb->>''email_to'' AS email_to"'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 23::integer, 'set'::varchar, ':comparison_of|~|&&v_comparison_of&&'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '    set :comparison_of=&&v_comparison_of&&'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 24::integer, 'if'::varchar, 'comparison_of==''DDL'''::varchar, 'main_70'::varchar, 'main_110'::varchar, ''::varchar, '    if comparison_of==''DDL'''::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 25::integer, 'serial'::varchar, 'main_80'::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '        serial # DDL'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 26::integer, 'execute'::varchar, 'dr_oct_ddl_tier1_wf'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '            execute dr_oct_ddl_tier1_wf #Loading of file data from Tier1 Folder to table pub_work.oct_ddl_tier1'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 27::integer, 'execute'::varchar, 'dr_oct_ddl_tier2_wf'::varchar, 'main_100'::varchar, ''::varchar, ''::varchar, '            execute dr_oct_ddl_tier2_wf #Loading of file data from Tier2 Folder to table pub_work.oct_ddl_tier2'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 28::integer, 'execute'::varchar, 'oct_comparison_report_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            execute oct_comparison_report_wf'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 29::integer, 'if'::varchar, 'comparison_of==''SCRIPT'''::varchar, 'main_120'::varchar, 'main_160'::varchar, ''::varchar, '    if comparison_of==''SCRIPT'''::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 30::integer, 'serial'::varchar, 'main_130'::varchar, 'main_160'::varchar, ''::varchar, ''::varchar, '        serial # SCRIPT'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 31::integer, 'execute'::varchar, 'dr_oct_script_tier1_wf'::varchar, 'main_140'::varchar, ''::varchar, ''::varchar, '            execute dr_oct_script_tier1_wf #Loading of file data from Tier1 Folder to table pub_work.oct_ddl_tier1'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 32::integer, 'execute'::varchar, 'dr_oct_script_tier2_wf'::varchar, 'main_150'::varchar, ''::varchar, ''::varchar, '            execute dr_oct_script_tier2_wf #Loading of file data from Tier2 Folder to table pub_work.oct_ddl_tier2'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 33::integer, 'execute'::varchar, 'oct_comparison_report_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            execute oct_comparison_report_wf # Data Comparison of table pub_work.oct_ddl_tier1 and pub_work.oct_ddl_tier2'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 34::integer, 'if'::varchar, 'comparison_of==''BOTH'''::varchar, 'main_170'::varchar, 'main_250'::varchar, ''::varchar, '    if comparison_of==''BOTH'''::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_170'::varchar, 35::integer, 'serial'::varchar, 'main_180'::varchar, 'main_210'::varchar, ''::varchar, ''::varchar, '        serial # DDL'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_180'::varchar, 36::integer, 'execute'::varchar, 'dr_oct_ddl_tier1_wf'::varchar, 'main_190'::varchar, ''::varchar, ''::varchar, '            execute dr_oct_ddl_tier1_wf #Loading of file data from Tier1 Folder to table pub_work.oct_ddl_tier1'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_190'::varchar, 37::integer, 'execute'::varchar, 'dr_oct_ddl_tier2_wf'::varchar, 'main_200'::varchar, ''::varchar, ''::varchar, '            execute dr_oct_ddl_tier2_wf #Loading of file data from Tier2 Folder to table pub_work.oct_ddl_tier2'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_200'::varchar, 38::integer, 'execute'::varchar, 'oct_comparison_report_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            execute oct_comparison_report_wf # Data Comparison of table pub_work.oct_ddl_tier1 and pub_work.oct_ddl_tier2'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_210'::varchar, 39::integer, 'serial'::varchar, 'main_220'::varchar, 'main_250'::varchar, ''::varchar, ''::varchar, '        serial # SCRIPT'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_220'::varchar, 40::integer, 'execute'::varchar, 'dr_oct_script_tier1_wf'::varchar, 'main_230'::varchar, ''::varchar, ''::varchar, '            execute dr_oct_script_tier1_wf #Loading of file data from Tier1 Folder to table pub_work.oct_ddl_tier1'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_230'::varchar, 41::integer, 'execute'::varchar, 'dr_oct_script_tier2_wf'::varchar, 'main_240'::varchar, ''::varchar, ''::varchar, '            execute dr_oct_script_tier2_wf #Loading of file data from Tier2 Folder to table pub_work.oct_ddl_tier2'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_240'::varchar, 42::integer, 'execute'::varchar, 'oct_comparison_report_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            execute oct_comparison_report_wf # Data Comparison of table pub_work.oct_ddl_tier1 and pub_work.oct_ddl_tier2'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_250'::varchar, 43::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_option('parameters'::varchar, 'parameters'::varchar, '{"v_comparison_of": "<select class=\\"pc_select\\"><option>DDL</option><option>SCRIPT</option><option>BOTH</option></select>"}'::varchar, 'oct_master_comparison_wf'::varchar, 'W'::varchar, 1::integer);
perform af_repo.af_compiler_insert('oct_master_comparison_wf.wfl', $q$#This workflow use to populate data from file to pub_work.oct_ddl_tier1&pub_work.oct_ddl_tier2 table and compare the data of both table
oct_master_comparison_wf(retention=90,v_comparison_of=[DDL:SCRIPT:BOTH]): This workflow use to populate data from file to pub_work.oct_ddl_tier1&pub_work.oct_ddl_tier2 table and compare the data of both table
# Project:  Ford
#
# Name: oct_master_comparison_wf.wfl
#
# Purpose:This workflow use to populate data from file to pub_work.oct_ddl_tier1&pub_work.oct_ddl_tier2 table and compare the data of both table
#
#===========================================================
# Revision History
#   Ref   Date          Revisor      Comment
#   1     30-05-2024     BK           Initial Version
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
    set :comparison_of=&&v_comparison_of&&
	if comparison_of=='DDL'
		serial # DDL
			execute dr_oct_ddl_tier1_wf #Loading of file data from Tier1 Folder to table pub_work.oct_ddl_tier1
			execute dr_oct_ddl_tier2_wf #Loading of file data from Tier2 Folder to table pub_work.oct_ddl_tier2
			execute oct_comparison_report_wf
	if comparison_of=='SCRIPT'
		serial # SCRIPT
			execute dr_oct_script_tier1_wf #Loading of file data from Tier1 Folder to table pub_work.oct_ddl_tier1
			execute dr_oct_script_tier2_wf #Loading of file data from Tier2 Folder to table pub_work.oct_ddl_tier2
			execute oct_comparison_report_wf # Data Comparison of table pub_work.oct_ddl_tier1 and pub_work.oct_ddl_tier2
	if comparison_of=='BOTH'
		serial # DDL
			execute dr_oct_ddl_tier1_wf #Loading of file data from Tier1 Folder to table pub_work.oct_ddl_tier1
			execute dr_oct_ddl_tier2_wf #Loading of file data from Tier2 Folder to table pub_work.oct_ddl_tier2
			execute oct_comparison_report_wf # Data Comparison of table pub_work.oct_ddl_tier1 and pub_work.oct_ddl_tier2
		serial # SCRIPT
			execute dr_oct_script_tier1_wf #Loading of file data from Tier1 Folder to table pub_work.oct_ddl_tier1
			execute dr_oct_script_tier2_wf #Loading of file data from Tier2 Folder to table pub_work.oct_ddl_tier2
			execute oct_comparison_report_wf # Data Comparison of table pub_work.oct_ddl_tier1 and pub_work.oct_ddl_tier2
    output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  oct_master_comparison_wf.wfl
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
