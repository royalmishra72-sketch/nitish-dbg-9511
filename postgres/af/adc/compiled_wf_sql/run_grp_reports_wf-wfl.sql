do
$workflowcontext$
declare
    /* Export Version 1.7.2
    Exported on:   2024-09-13 07:59:19-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   run_grp_reports_wf.wfl
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
perform af_repo.fk_add_context('run_grp_reports_wf'::varchar,'W'::varchar, 180::smallint, '(1.7.3.8)This workflow is used to generate Reports.'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 20::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 21::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 22::integer, 'set'::varchar, ':tag_domain|~|Reports'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_domain = "Reports"'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 23::integer, 'set'::varchar, ':grp_name|~|''&&report_groupt&&'''::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :grp_name = "''&&report_groupt&&''"'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 24::integer, 'set'::varchar, ':grp_rpt_type|~|&&report_type&&'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    set :grp_rpt_type = "&&report_type&&"'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 25::integer, 'if'::varchar, 'grp_rpt_type == NONE or grp_rpt_type =='''''::varchar, 'main_60'::varchar, 'main_70'::varchar, ''::varchar, '    if grp_rpt_type == NONE or grp_rpt_type =='''''::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 26::integer, 'set'::varchar, ':grp_rpt_type|~|NORMAL'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '        set :grp_rpt_type ="NORMAL"'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 28::integer, 'if'::varchar, 'grp_rpt_type == "ADC"'::varchar, 'main_80'::varchar, 'main_190'::varchar, ''::varchar, '    if grp_rpt_type == "ADC"'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 29::integer, 'set'::varchar, ':group_name|~|''adc_qa_&&report_groupt&&'''::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '        set :group_name = "''adc_qa_&&report_groupt&&''"'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 30::integer, 'load'::varchar, ':grp_rpt_count_1|~|select count(1) as count from bl.bl_sbs_report_meta where report_group in(&&group_name&&) and report_publish_flag=''Y'' and lower(report_group) like''adc_%%'''::varchar, 'main_100'::varchar, ''::varchar, ''::varchar, '        load :grp_rpt_count_1 = "select count(1) as count from bl.bl_sbs_report_meta where report_group in(&&group_name&&) and report_publish_flag=''Y'' and lower(report_group) like''adc_%%''"'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 31::integer, 'if'::varchar, 'grp_rpt_count_1 != 0'::varchar, 'main_110'::varchar, 'main_170'::varchar, ''::varchar, '        if grp_rpt_count_1 != 0'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 32::integer, 'load'::varchar, ':report_name|~|select string_agg(report_name,'','' order by report_group,report_name ) as rpt_nam from bl.bl_sbs_report_meta where report_group in(&&group_name&&) and report_publish_flag=''Y'' and lower(report_group) like''adc_%%'''::varchar, 'main_120'::varchar, ''::varchar, ''::varchar, '            load :report_name = "select string_agg(report_name,'','' order by report_group,report_name ) as rpt_nam from bl.bl_sbs_report_meta where report_group in(&&group_name&&) and report_publish_flag=''Y'' and lower(report_group) like''adc_%%''"'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 33::integer, 'foreach'::varchar, 'p_adc_report_name|~|:report_name|~|main_130'::varchar, 'main_260'::varchar, ''::varchar, ''::varchar, '            foreach :p_adc_report_name in :report_name'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 34::integer, 'load'::varchar, ':rep_cnt|~|select p_out_attachment from fnc_adc_qa_report(''&&p_adc_report_name&&'')'::varchar, 'main_140'::varchar, ''::varchar, ''::varchar, '                    load :rep_cnt =  "select p_out_attachment from fnc_adc_qa_report(''&&p_adc_report_name&&'')"'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 35::integer, 'if'::varchar, 'rep_cnt is not null'::varchar, 'main_150'::varchar, 'Done'::varchar, ''::varchar, '                    if rep_cnt is not null'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 36::integer, 'report'::varchar, 'nis_adc_qa_reports|~|:p_adc_report_name'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '                        report nis_adc_qa_reports(:p_adc_report_name)'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 37::integer, 'else'::varchar, ''::varchar, 'main_170'::varchar, ''::varchar, ''::varchar, '        else'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_170'::varchar, 38::integer, 'message'::varchar, 'D|~|No report list found to execute in this group'::varchar, 'main_260'::varchar, ''::varchar, ''::varchar, '            message D "No report list found to execute in this group"'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_180'::varchar, 39::integer, 'else'::varchar, ''::varchar, 'main_190'::varchar, ''::varchar, ''::varchar, '    else'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_190'::varchar, 40::integer, 'load'::varchar, ':grp_rpt_count_1|~|select count(1) as count from bl.bl_sbs_report_meta where report_group in(&&grp_name&&) and report_publish_flag=''Y'' and lower(report_group) not like''adc_%%'''::varchar, 'main_200'::varchar, ''::varchar, ''::varchar, '        load :grp_rpt_count_1 = "select count(1) as count from bl.bl_sbs_report_meta where report_group in(&&grp_name&&) and report_publish_flag=''Y'' and lower(report_group) not like''adc_%%''"'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_200'::varchar, 41::integer, 'if'::varchar, 'grp_rpt_count_1 != 0'::varchar, 'main_210'::varchar, 'main_250'::varchar, ''::varchar, '        if grp_rpt_count_1 != 0'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_210'::varchar, 42::integer, 'load'::varchar, ':report_name|~|select string_agg(report_name,'','' order by report_group,report_name ) as rpt_nam from bl.bl_sbs_report_meta where report_group in(&&grp_name&&) and report_publish_flag=''Y'' and lower(report_group) not like ''adc_%%'''::varchar, 'main_220'::varchar, ''::varchar, ''::varchar, '            load :report_name = "select string_agg(report_name,'','' order by report_group,report_name ) as rpt_nam from bl.bl_sbs_report_meta where report_group in(&&grp_name&&) and report_publish_flag=''Y'' and lower(report_group) not like ''adc_%%''"'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_220'::varchar, 43::integer, 'foreach'::varchar, 'p_report_name|~|:report_name|~|main_230'::varchar, 'main_260'::varchar, ''::varchar, ''::varchar, '            foreach :p_report_name in :report_name'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_230'::varchar, 44::integer, 'report'::varchar, 'execute_report|~|:p_report_name'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '                    report execute_report(:p_report_name)'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_240'::varchar, 45::integer, 'else'::varchar, ''::varchar, 'main_250'::varchar, ''::varchar, ''::varchar, '        else'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_250'::varchar, 46::integer, 'message'::varchar, 'D|~|No report list found to execute in this group'::varchar, 'main_260'::varchar, ''::varchar, ''::varchar, '            message D "No report list found to execute in this group"'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_260'::varchar, 47::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_option('parameters'::varchar, 'parameters'::varchar, '{"report_groupt": "<select class=\\"pc_select\\"><option>bl_reports</option><option>work_reports</option><option>ctrg_reports</option><option>downloaded_feeds_report</option></select>", "report_type": "<select class=\\"pc_select\\"><option>NORMAL</option><option>ADC</option></select>"}'::varchar, 'run_grp_reports_wf'::varchar, 'W'::varchar, 1::integer);
perform af_repo.af_compiler_insert('run_grp_reports_wf.wfl', $q$# This workflow is used to generate Reports.
run_grp_reports_wf(report_groupt=[bl_reports:work_reports:ctrg_reports:downloaded_feeds_report],report_type=[NORMAL:ADC]): This workflow is used to generate Reports.
# Project: Nissan NG DATA PUBLISHING
#
# Name: run_grp_reports_wf.wfl
#
# Purpose:This workflow is used to generate Reports.
#
#===========================================================
# Revision History
#   Ref   Date          Revisor      Comment
#   1     02-Mar-2024    NKM           Initial Version
#   2     20-May-2024    SV           QA Automation reports included
#===========================================================
# Revisor
# [Initials]		[Full Name]
# NKM             Nitish K Mishra
# SV              Samit Verma 
#===========================================================
	output_version
	output_options
	set :tag_domain = "Reports"
	set :grp_name = "'&&report_groupt&&'"
 	set :grp_rpt_type = "&&report_type&&"
	if grp_rpt_type == NONE or grp_rpt_type ==''
		set :grp_rpt_type ="NORMAL"
 	#load :grp_rpt_count_1 = "select count(1) as count from bl.bl_sbs_report_meta where report_group in(&&grp_name&&) and report_publish_flag='Y'"
	if grp_rpt_type == "ADC"
		set :group_name = "'adc_qa_&&report_groupt&&'"
	    load :grp_rpt_count_1 = "select count(1) as count from bl.bl_sbs_report_meta where report_group in(&&group_name&&) and report_publish_flag='Y' and lower(report_group) like'adc_%%'"
		if grp_rpt_count_1 != 0
		    load :report_name = "select string_agg(report_name,',' order by report_group,report_name ) as rpt_nam from bl.bl_sbs_report_meta where report_group in(&&group_name&&) and report_publish_flag='Y' and lower(report_group) like'adc_%%'"
			foreach :p_adc_report_name in :report_name
					load :rep_cnt =  "select p_out_attachment from fnc_adc_qa_report('&&p_adc_report_name&&')"
					if rep_cnt is not null
				        report nis_adc_qa_reports(:p_adc_report_name)
		else
		    message D "No report list found to execute in this group"
	else
	    load :grp_rpt_count_1 = "select count(1) as count from bl.bl_sbs_report_meta where report_group in(&&grp_name&&) and report_publish_flag='Y' and lower(report_group) not like'adc_%%'"
	    if grp_rpt_count_1 != 0
			load :report_name = "select string_agg(report_name,',' order by report_group,report_name ) as rpt_nam from bl.bl_sbs_report_meta where report_group in(&&grp_name&&) and report_publish_flag='Y' and lower(report_group) not like 'adc_%%'"
			foreach :p_report_name in :report_name
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
  run_grp_reports_wf.wfl
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
