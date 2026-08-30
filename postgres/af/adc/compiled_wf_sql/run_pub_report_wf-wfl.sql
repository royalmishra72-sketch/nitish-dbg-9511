do
$workflowcontext$
declare
    /* Export Version 1.7.2
    Exported on:   2024-09-13 07:58:52-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   run_pub_report_wf.wfl
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
perform af_repo.fk_add_context('run_pub_report_wf'::varchar,'W'::varchar, 180::smallint, '(1.7.3.8)This workflow used to Generate Reports.'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 20::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 21::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 22::integer, 'set'::varchar, ':tag_domain|~|Reports'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_domain = "Reports"'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 23::integer, 'set'::varchar, ':rpt_type|~|&&report_type&&'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :rpt_type = "&&report_type&&"'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 24::integer, 'if'::varchar, 'rpt_type == NONE or rpt_type =='''''::varchar, 'main_50'::varchar, 'main_60'::varchar, ''::varchar, '    if rpt_type == NONE or rpt_type =='''''::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 25::integer, 'set'::varchar, ':rpt_type|~|NORMAL'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '        set :rpt_type ="NORMAL"'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 27::integer, 'load'::varchar, ':no_report_database_identifier|~|select pub_admin.get_parameter(''no_report_database_identifier'')'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '    load :no_report_database_identifier = "select pub_admin.get_parameter(''no_report_database_identifier'')"'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 28::integer, 'if'::varchar, 'rpt_type == "ADC"'::varchar, 'main_80'::varchar, 'main_200'::varchar, ''::varchar, '    if rpt_type == "ADC"'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 29::integer, 'load'::varchar, ':rpt_grpt|~|select string_agg(distinct report_group, '','' order by report_group )from bl.bl_sbs_report_meta where report_group ~ ''adc_qa'''::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '            load :rpt_grpt = "select string_agg(distinct report_group, '','' order by report_group )from bl.bl_sbs_report_meta where report_group ~ ''adc_qa''"'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 30::integer, 'set'::varchar, ':rpt_grpv|~|''&&rpt_grpt&&'''::varchar, 'main_100'::varchar, ''::varchar, ''::varchar, '            set :rpt_grpv = "''&&rpt_grpt&&''"'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 31::integer, 'load'::varchar, ':rpt_grp|~|SELECT array_to_string(ARRAY(SELECT quote_literal(unnest(string_to_array(&&rpt_grpv&&, '','')))), '','')'::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '            load :rpt_grp = "SELECT array_to_string(ARRAY(SELECT quote_literal(unnest(string_to_array(&&rpt_grpv&&, '','')))), '','')"'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 32::integer, 'load'::varchar, ':report_name|~|select string_agg(report_name, '','' order by report_name ) 						from bl.bl_sbs_report_meta 						where  report_group in (&&rpt_grp&&) and report_name ~ %s|~|:report_name_regexp'::varchar, 'main_120'::varchar, ''::varchar, ''::varchar, '            load :report_name = "select string_agg(report_name, '','' order by report_name ) 						from bl.bl_sbs_report_meta 						where  report_group in (&&rpt_grp&&) and report_name ~ %s",:report_name_regexp '::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 35::integer, 'if'::varchar, 'report_name != None'::varchar, 'main_130'::varchar, 'main_180'::varchar, ''::varchar, '            if report_name != None'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 36::integer, 'foreach'::varchar, 'p_adc_report_name|~|:report_name|~|main_140'::varchar, 'main_260'::varchar, ''::varchar, ''::varchar, '                foreach :p_adc_report_name in :report_name'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 37::integer, 'load'::varchar, ':rep_cnt|~|select p_out_attachment from fnc_adc_qa_report(''&&p_adc_report_name&&'')'::varchar, 'main_150'::varchar, ''::varchar, ''::varchar, '                        load :rep_cnt =  "select p_out_attachment from fnc_adc_qa_report(''&&p_adc_report_name&&'')"'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 38::integer, 'if'::varchar, 'rep_cnt is not null'::varchar, 'main_160'::varchar, 'Done'::varchar, ''::varchar, '                        if rep_cnt is not null'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 39::integer, 'report'::varchar, 'nis_adc_qa_reports|~|:p_adc_report_name'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '                            report nis_adc_qa_reports(:p_adc_report_name)'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_170'::varchar, 40::integer, 'else'::varchar, ''::varchar, 'main_180'::varchar, ''::varchar, ''::varchar, '            else'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_180'::varchar, 41::integer, 'message'::varchar, 'D|~|Hello -Please Pass Valid Report Name'::varchar, 'main_260'::varchar, ''::varchar, ''::varchar, '                message D "Hello -Please Pass Valid Report Name"'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_190'::varchar, 42::integer, 'else'::varchar, ''::varchar, 'main_200'::varchar, ''::varchar, ''::varchar, '    else'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_200'::varchar, 43::integer, 'load'::varchar, ':report_name|~|select string_agg(report_name, '','' order by report_name ) 						from bl.bl_sbs_report_meta 						where  report_group !~ ''adc_qa'' and  report_name ~ %s|~|:report_name_regexp'::varchar, 'main_210'::varchar, ''::varchar, ''::varchar, '            load :report_name = "select string_agg(report_name, '','' order by report_name ) 						from bl.bl_sbs_report_meta 						where  report_group !~ ''adc_qa'' and  report_name ~ %s",:report_name_regexp'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_210'::varchar, 46::integer, 'if'::varchar, 'report_name != None'::varchar, 'main_220'::varchar, 'main_250'::varchar, ''::varchar, '            if report_name != None'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_220'::varchar, 47::integer, 'foreach'::varchar, 'p_report_name|~|:report_name|~|main_230'::varchar, 'main_260'::varchar, ''::varchar, ''::varchar, '                foreach :p_report_name in :report_name'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_230'::varchar, 48::integer, 'report'::varchar, 'execute_report|~|:p_report_name'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '                        report execute_report(:p_report_name)'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_240'::varchar, 49::integer, 'else'::varchar, ''::varchar, 'main_250'::varchar, ''::varchar, ''::varchar, '            else'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_250'::varchar, 50::integer, 'message'::varchar, 'D|~|Hello -Please Pass Valid Report Name'::varchar, 'main_260'::varchar, ''::varchar, ''::varchar, '                message D "Hello -Please Pass Valid Report Name"'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_260'::varchar, 51::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_option('parameters'::varchar, 'parameters'::varchar, '{"report_name_regexp": "", "report_type": "<select class=\\"pc_select\\"><option>NORMAL</option><option>ADC</option></select>"}'::varchar, 'run_pub_report_wf'::varchar, 'W'::varchar, 1::integer);
perform af_repo.af_compiler_insert('run_pub_report_wf.wfl', $q$# This workflow used to Generate Reports.
run_pub_report_wf(report_name_regexp=,report_type=[NORMAL:ADC]) : This workflow used to Generate Reports.
# Project:  Nissan NG DATA PUBLISHING
#
# Name: run_pub_report_wf.wfl
#
# Purpose:This workflow used to Generate Reports.
#
#===========================================================
# Revision History
#   Ref   Date          Revisor      Comment
#   1     03-Mar-2024    NKM          Initial Version
#   2     20-May-2024    SV           QA Automation reports included
#===========================================================
# Revisor
# [Initials]		[Full Name]
# NKM                Nitish K Mishra
# SV                 Samit Verma
#===========================================================
	output_version
	output_options
	set :tag_domain = "Reports"
	set :rpt_type = "&&report_type&&"
	if rpt_type == NONE or rpt_type ==''
		set :rpt_type ="NORMAL"
	# Write out the individual Report
	load :no_report_database_identifier = "select pub_admin.get_parameter('no_report_database_identifier')"
	if rpt_type == "ADC"
			load :rpt_grpt = "select string_agg(distinct report_group, ',' order by report_group )from bl.bl_sbs_report_meta where report_group ~ 'adc_qa'"
			set :rpt_grpv = "'&&rpt_grpt&&'"
			load :rpt_grp = "SELECT array_to_string(ARRAY(SELECT quote_literal(unnest(string_to_array(&&rpt_grpv&&, ',')))), ',')"
			load :report_name = "select string_agg(report_name, ',' order by report_name ) \\
						from bl.bl_sbs_report_meta \\
						where  report_group in (&&rpt_grp&&) and report_name ~ %s",:report_name_regexp 
			if report_name != None
				foreach :p_adc_report_name in :report_name
						load :rep_cnt =  "select p_out_attachment from fnc_adc_qa_report('&&p_adc_report_name&&')"
						if rep_cnt is not null
					        report nis_adc_qa_reports(:p_adc_report_name)
			else
				message D "Hello -Please Pass Valid Report Name"
	else
			load :report_name = "select string_agg(report_name, ',' order by report_name ) \\
						from bl.bl_sbs_report_meta \\
						where  report_group !~ 'adc_qa' and  report_name ~ %s",:report_name_regexp
			if report_name != None
				foreach :p_report_name in :report_name
					    report execute_report(:p_report_name)
			else
			    message D "Hello -Please Pass Valid Report Name"
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  run_pub_report_wf.wfl
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
