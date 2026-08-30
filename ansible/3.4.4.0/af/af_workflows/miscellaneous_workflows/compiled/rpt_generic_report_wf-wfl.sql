do
$workflowcontext$
declare
    /* Export 1.8.1
    Exported on:   2026-06-19 06:44:21-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   rpt_generic_report_wf.wfl
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
    v_version := '1.8.1';
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
perform af_repo.fk_add_context('rpt_generic_report_wf'::varchar,'W'::varchar, 90::smallint, '(1.8.1.0)This workflow used generate Reports.'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 23::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'rpt_generic_report_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 24::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'rpt_generic_report_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 25::integer, 'set'::varchar, ':tag_domain|~|Reports'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_domain = "Reports"'::varchar, 'rpt_generic_report_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 26::integer, 'load'::varchar, ':no_report_database_identifier|~|select pub_admin.get_parameter(''no_report_database_identifier'')'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    load :no_report_database_identifier = "select pub_admin.get_parameter(''no_report_database_identifier'')"'::varchar, 'rpt_generic_report_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 27::integer, 'load'::varchar, ':no_report_zero_length_attachment|~|select pub_admin.get_parameter(''no_report_zero_length_attachment'')'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    load :no_report_zero_length_attachment = "select pub_admin.get_parameter(''no_report_zero_length_attachment'')" '::varchar, 'rpt_generic_report_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 28::integer, 'load'::varchar, ':grp_rpt_count_1|~|select count(1) as count from bl.bl_sbs_report_meta where report_group in(&&grp_name&&) and report_publish_flag=''Y'''::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '    load :grp_rpt_count_1 = "select count(1) as count from bl.bl_sbs_report_meta where report_group in(&&grp_name&&) and report_publish_flag=''Y''"'::varchar, 'rpt_generic_report_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 29::integer, 'set'::varchar, ':parallel_foreach_limit|~|10'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '    set :parallel_foreach_limit = "10"'::varchar, 'rpt_generic_report_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 30::integer, 'if'::varchar, 'grp_rpt_count_1 != 0'::varchar, 'main_80'::varchar, 'main_120'::varchar, ''::varchar, '    if grp_rpt_count_1 != 0'::varchar, 'rpt_generic_report_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 31::integer, 'load'::varchar, ':report_name|~|select string_agg(report_name,'','' order by report_group,report_name ) as rpt_nam from bl.bl_sbs_report_meta where report_group in(&&grp_name&&) and report_publish_flag=''Y'''::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '        load :report_name = "select string_agg(report_name,'','' order by report_group,report_name ) as rpt_nam from bl.bl_sbs_report_meta where report_group in(&&grp_name&&) and report_publish_flag=''Y''"'::varchar, 'rpt_generic_report_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 32::integer, 'parallel_foreach'::varchar, 'p_report_name|~|:report_name|~|main_100'::varchar, 'main_130'::varchar, ''::varchar, ''::varchar, '        parallel_foreach :p_report_name in :report_name'::varchar, 'rpt_generic_report_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 33::integer, 'report'::varchar, 'execute_report|~|:p_report_name'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            report execute_report(:p_report_name)'::varchar, 'rpt_generic_report_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 34::integer, 'else'::varchar, ''::varchar, 'main_120'::varchar, ''::varchar, ''::varchar, '    else'::varchar, 'rpt_generic_report_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 35::integer, 'message'::varchar, 'D|~|No report list found to execute in this group'::varchar, 'main_130'::varchar, ''::varchar, ''::varchar, '        message D "No report list found to execute in this group"'::varchar, 'rpt_generic_report_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 36::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'rpt_generic_report_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'rpt_generic_report_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.af_compiler_insert('rpt_generic_report_wf.wfl', $q$# This workflow used generate Reports.
rpt_generic_report_wf(retention=90): This workflow used generate Reports.
# Project:  NG DATA PUBLISHING
#
# Name: rpt_generic_report_wf.wfl
#
# Purpose:This workflow used to generate Reports.
#
#===========================================================
# Revision History
#   Ref   Date          Revisor      Comment
#   1     14-Mar-2023    BK           Initial Version
#	2	  16-Aug-2023    BK			  [FDNGPUB-1072] After AF 1.7.1- To pass report at rn time 
#   3     28-Aug-2023    PR           Modify wfl according to the nissan reports
#   4     08-May-2026    NKM          NSPUB-1502 Use Parallel foreach command for executing reports parallelly
#===========================================================
# Revisor
# [Initials]		[Full Name]
# BK              Bipin Kumar
# PR              Pawan Rajak
# NKM             Nitish K Mishra
#===========================================================
	output_version
	output_options
	set :tag_domain = "Reports"
	load :no_report_database_identifier = "select pub_admin.get_parameter('no_report_database_identifier')"
	load :no_report_zero_length_attachment = "select pub_admin.get_parameter('no_report_zero_length_attachment')" 
 	load :grp_rpt_count_1 = "select count(1) as count from bl.bl_sbs_report_meta where report_group in(&&grp_name&&) and report_publish_flag='Y'"
	set :parallel_foreach_limit = "10"
	if grp_rpt_count_1 != 0
		load :report_name = "select string_agg(report_name,',' order by report_group,report_name ) as rpt_nam from bl.bl_sbs_report_meta where report_group in(&&grp_name&&) and report_publish_flag='Y'"
		parallel_foreach :p_report_name in :report_name
			report execute_report(:p_report_name)
	else
		message D "No report list found to execute in this group"
	output_options
	$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  rpt_generic_report_wf.wfl
  **
  */
raise notice '******************* SUCCESS!! Workflow import has completed. ****************************';
	
end;
$workflowcontext$ LANGUAGE 'plpgsql';
