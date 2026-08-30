do
$workflowcontext$
declare
    /* Export 1.8.1
    Exported on:   2026-07-08 01:36:57-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   mwf_bl_to_ctrg_wf.wfl
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
perform af_repo.fk_add_context('mwf_bl_to_ctrg_wf'::varchar,'W'::varchar, 180::smallint, '(1.8.1.0)This Workflow used to load CTRG Tables.'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 32::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 33::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options	'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 34::integer, 'sql'::varchar, 'select pub_work.fnc_initiate_ctrg_load()'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    sql "select pub_work.fnc_initiate_ctrg_load()"  #check the status of INITIATE_CTRG,INITIATE_POST_CTRG and INITIATE_HOSTING'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 35::integer, 'set'::varchar, ':tag_area|~|BL to CTRG'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :tag_area = "BL to CTRG"'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 36::integer, 'serial'::varchar, 'main_50'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '    serial #MASTER_BL_TO_CTRG_LOAD_WF Initiated Email'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 37::integer, 'set'::varchar, ':v_process_name|~|MWF_BL_TO_CTRG_START'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '        set :v_process_name = "MWF_BL_TO_CTRG_START"'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 38::integer, 'execute'::varchar, 'generic_email_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute generic_email_wf'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 39::integer, 'load'::varchar, ':root_path|~|select pub_admin.get_parameter(''PBAEnvRootPath'')'::varchar, 'main_80'::varchar, ''::varchar, ''::varchar, '    load :root_path = "select pub_admin.get_parameter(''PBAEnvRootPath'')"'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 40::integer, 'load'::varchar, ':epo_path|~|select pub_admin.get_parameter(''PBAEPORootPath'')'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '    load :epo_path = "select pub_admin.get_parameter(''PBAEPORootPath'')"'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 43::integer, 'serial'::varchar, 'main_100'::varchar, 'main_120'::varchar, ''::varchar, ''::varchar, '    serial # Data check (Model, Catalog) '::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 44::integer, 'execute'::varchar, 'new_model_data_check_wf'::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '        execute new_model_data_check_wf	'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 45::integer, 'execute'::varchar, 'new_catalog_data_check_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute new_catalog_data_check_wf'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 46::integer, 'execute'::varchar, 'load_work_wf'::varchar, 'main_130'::varchar, ''::varchar, ''::varchar, '    execute load_work_wf'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 47::integer, 'serial'::varchar, 'main_140'::varchar, 'main_160'::varchar, ''::varchar, ''::varchar, '    serial # Run Work reports'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 48::integer, 'set'::varchar, ':grp_name|~|''work_reports'''::varchar, 'main_150'::varchar, ''::varchar, ''::varchar, '        set :grp_name = "''work_reports''"'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 49::integer, 'execute'::varchar, 'rpt_generic_report_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute rpt_generic_report_wf'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 50::integer, 'serial'::varchar, 'main_170'::varchar, 'main_190'::varchar, ''::varchar, ''::varchar, '    serial # This Step will clean files recursively from EPO'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_170'::varchar, 51::integer, 'set'::varchar, ':relative_target_path|~|/QA_REPORTS/ADC_INPUT'::varchar, 'main_180'::varchar, ''::varchar, ''::varchar, '        set :relative_target_path = "/QA_REPORTS/ADC_INPUT"'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_180'::varchar, 52::integer, 'execute'::varchar, 'clean_files_from_epo_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute clean_files_from_epo_wf'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_190'::varchar, 53::integer, 'serial'::varchar, 'main_200'::varchar, 'main_230'::varchar, ''::varchar, ''::varchar, '    serial # This Step will generate QA reports at pubapp server.'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_200'::varchar, 54::integer, 'set'::varchar, ':report_groupt|~|work_reports'::varchar, 'main_210'::varchar, ''::varchar, ''::varchar, '        set :report_groupt = "work_reports"'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_210'::varchar, 55::integer, 'set'::varchar, ':report_type|~|ADC'::varchar, 'main_220'::varchar, ''::varchar, ''::varchar, '        set :report_type = "ADC"'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_220'::varchar, 56::integer, 'execute'::varchar, 'run_grp_reports_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute run_grp_reports_wf'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_230'::varchar, 57::integer, 'execute'::varchar, 'load_ctrg_wf'::varchar, 'main_240'::varchar, ''::varchar, ''::varchar, '    execute load_ctrg_wf'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_240'::varchar, 58::integer, 'execute'::varchar, 'master_load_csr_tables_wf'::varchar, 'main_250'::varchar, ''::varchar, ''::varchar, '    execute master_load_csr_tables_wf'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_250'::varchar, 60::integer, 'serial'::varchar, 'main_260'::varchar, 'main_280'::varchar, ''::varchar, ''::varchar, '    serial # This step will generate ctrg_support rowcount threshold report.'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_260'::varchar, 61::integer, 'set'::varchar, ':ct_rcth_schema_name|~|ctrg_support'::varchar, 'main_270'::varchar, ''::varchar, ''::varchar, '        set :ct_rcth_schema_name = "ctrg_support"'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_270'::varchar, 62::integer, 'execute'::varchar, 'tool_rpt_rowcount_threshold'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute tool_rpt_rowcount_threshold'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_280'::varchar, 63::integer, 'serial'::varchar, 'main_290'::varchar, 'main_310'::varchar, ''::varchar, ''::varchar, '    serial #This step will generate ctrg rowcount threshold report.'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_290'::varchar, 64::integer, 'set'::varchar, ':ct_rcth_schema_name|~|ctrg'::varchar, 'main_300'::varchar, ''::varchar, ''::varchar, '        set :ct_rcth_schema_name = "ctrg"'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_300'::varchar, 65::integer, 'execute'::varchar, 'tool_rpt_rowcount_threshold'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute tool_rpt_rowcount_threshold'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_310'::varchar, 66::integer, 'execute'::varchar, 'load_sbs_hosting_table_partition_rules_wf'::varchar, 'main_320'::varchar, ''::varchar, ''::varchar, '    execute load_sbs_hosting_table_partition_rules_wf'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_320'::varchar, 67::integer, 'sql'::varchar, 'select ctrg_support.load_ctrg_partition_ddl(''WEB'', ''ctrg'',''ctrg'')'::varchar, 'main_330'::varchar, ''::varchar, ''::varchar, '    sql "select ctrg_support.load_ctrg_partition_ddl(''WEB'', ''ctrg'',''ctrg'')"'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_330'::varchar, 68::integer, 'execute'::varchar, 'last_published_dataset_property_v_wf'::varchar, 'main_340'::varchar, ''::varchar, ''::varchar, '    execute last_published_dataset_property_v_wf'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_340'::varchar, 69::integer, 'serial'::varchar, 'main_350'::varchar, 'main_370'::varchar, ''::varchar, ''::varchar, '    serial #ctrg_reports execution'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_350'::varchar, 70::integer, 'set'::varchar, ':grp_name|~|''ctrg_reports'''::varchar, 'main_360'::varchar, ''::varchar, ''::varchar, '        set :grp_name = "''ctrg_reports''"'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_360'::varchar, 71::integer, 'execute'::varchar, 'rpt_generic_report_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute rpt_generic_report_wf'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_370'::varchar, 72::integer, 'serial'::varchar, 'main_380'::varchar, 'main_400'::varchar, ''::varchar, ''::varchar, '    serial #ctrg_validation execution'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_380'::varchar, 73::integer, 'set'::varchar, ':grp_name|~|''ctrg_validation'''::varchar, 'main_390'::varchar, ''::varchar, ''::varchar, '        set :grp_name = "''ctrg_validation''"'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_390'::varchar, 74::integer, 'execute'::varchar, 'rpt_generic_report_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute rpt_generic_report_wf'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_400'::varchar, 75::integer, 'set'::varchar, ':report_groupt|~|ctrg_reports'::varchar, 'main_410'::varchar, ''::varchar, ''::varchar, '    set :report_groupt = "ctrg_reports"'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_410'::varchar, 76::integer, 'set'::varchar, ':report_type|~|ADC'::varchar, 'main_420'::varchar, ''::varchar, ''::varchar, '    set :report_type = "ADC"'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_420'::varchar, 77::integer, 'execute'::varchar, 'run_grp_reports_wf'::varchar, 'main_430'::varchar, ''::varchar, ''::varchar, '    execute run_grp_reports_wf	'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_430'::varchar, 78::integer, 'execute'::varchar, 'lucene_wf'::varchar, 'main_440'::varchar, ''::varchar, ''::varchar, '    execute lucene_wf'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_440'::varchar, 79::integer, 'execute'::varchar, 'lvt_lucene_verification_report_wf'::varchar, 'main_450'::varchar, ''::varchar, ''::varchar, '    execute lvt_lucene_verification_report_wf'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_450'::varchar, 80::integer, 'serial'::varchar, 'main_460'::varchar, 'main_500'::varchar, ''::varchar, ''::varchar, '    serial # RDVT Reports Checks'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_460'::varchar, 81::integer, 'set'::varchar, ':schema_name|~|ctrg'::varchar, 'main_470'::varchar, ''::varchar, ''::varchar, '        set :schema_name = "ctrg"'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_470'::varchar, 82::integer, 'set'::varchar, ':cycle_status|~|monthly'::varchar, 'main_480'::varchar, ''::varchar, ''::varchar, '        set :cycle_status = "monthly"'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_480'::varchar, 83::integer, 'execute'::varchar, 'stop_due_to_failure'::varchar, 'main_490'::varchar, ''::varchar, ''::varchar, '        execute stop_due_to_failure'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_490'::varchar, 84::integer, 'execute'::varchar, 'exit_due_to_failure'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute exit_due_to_failure 	'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_500'::varchar, 85::integer, 'execute'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'main_510'::varchar, ''::varchar, ''::varchar, '    execute archive_nissan_zip_data_wf'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_510'::varchar, 86::integer, 'serial'::varchar, 'main_520'::varchar, 'main_540'::varchar, ''::varchar, ''::varchar, '    serial #MASTER_BL_TO_CTRG_LOAD_WF completed Email'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_520'::varchar, 87::integer, 'set'::varchar, ':v_process_name|~|MWF_BL_TO_CTRG_END'::varchar, 'main_530'::varchar, ''::varchar, ''::varchar, '        set :v_process_name = "MWF_BL_TO_CTRG_END"'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_530'::varchar, 88::integer, 'execute'::varchar, 'generic_email_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute generic_email_wf'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_540'::varchar, 89::integer, 'sql'::varchar, 'select pub_work.fnc_complete_ctrg_load()'::varchar, 'main_550'::varchar, ''::varchar, ''::varchar, '    sql "select pub_work.fnc_complete_ctrg_load()" #will mark ''INITIATE_CTRG'', ''INITIATE_POST_CTRG'', ''INITIATE_HOSTING'' in Ready state'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_550'::varchar, 90::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.af_compiler_insert('mwf_bl_to_ctrg_wf.wfl', $q$#workflow used to load CTRG Tables.
mwf_bl_to_ctrg_wf: This Workflow used to load CTRG Tables.
# Project: NISSAN DATA PUBLISHING
#
# Name: mwf_bl_to_ctrg_wf.wfl
#
# Purpose:  This workflow is used to load CTRG Tables.
#
#===========================================================
# Revision History
#   Ref #  Date          Revisor      Comment
#   1      19-JUN-2023   DNU          Initial Version 
#   2      26-JUN-2023   DNU          Csr table loading mwf and tool_publishing_validation_report wfl added. 
#   3      29-AUG-2023   PR           Update generic reporting wfl.
#   4      13-SEP-2023   NKM          Add Archive process after Lucene Execution
#	5      13-JUNE-2023  NKM          ADD ADC Report Generation Step
#	6      22-Oct-2024   CB           ng_dino added
#	7      29-JAN-2026   CB           new_catalog_data_check_wf, new_model_data_check_wf added + dvt_report
#   8      23-FEB-2026   NKM          Added Validate lucene size Process
#   9      10-June-2026  NKM          RDVT 1.1.0 and 1.2.0 Enhancement
#   10     15-June-2026  NKM          Add LVT Process
#   11     26-June-2026  NKM          Added ctrg validation Report Execution Process
#   12     07-July-2026  NKM          Removed Dino Step 
#===========================================================
# Revisor
# [Initials]		[Full Name]
# DNU                DILESH N. UKEY
# PR                 PAWAN RAJAK
# NKM                Nitish Kumar Mishra 
# CB                 Chandan Bhatia 
#===========================================================
    output_version
    output_options	
	sql "select pub_work.fnc_initiate_ctrg_load()"  #check the status of INITIATE_CTRG,INITIATE_POST_CTRG and INITIATE_HOSTING
	set :tag_area = "BL to CTRG"
	serial #MASTER_BL_TO_CTRG_LOAD_WF Initiated Email
		set :v_process_name = "MWF_BL_TO_CTRG_START"
		execute generic_email_wf
	load :root_path = "select pub_admin.get_parameter('PBAEnvRootPath')"
	load :epo_path = "select pub_admin.get_parameter('PBAEPORootPath')"
	#set :dataset_id = "1bdd62d7-8692-7da4-e053-41d516ac0add"
	#execute ng_dino
	serial # Data check (Model, Catalog) 
		execute new_model_data_check_wf	
		execute new_catalog_data_check_wf
	execute load_work_wf
	serial # Run Work reports
		set :grp_name = "'work_reports'"
		execute rpt_generic_report_wf
	serial # This Step will clean files recursively from EPO
		set :relative_target_path = "/QA_REPORTS/ADC_INPUT"
		execute clean_files_from_epo_wf
	serial # This Step will generate QA reports at pubapp server.
		set :report_groupt = "work_reports"
		set :report_type = "ADC"
		execute run_grp_reports_wf
	execute load_ctrg_wf
	execute master_load_csr_tables_wf
	#execute tool_publishing_validation_report
	serial # This step will generate ctrg_support rowcount threshold report.
		set :ct_rcth_schema_name = "ctrg_support"
		execute tool_rpt_rowcount_threshold
	serial #This step will generate ctrg rowcount threshold report.
		set :ct_rcth_schema_name = "ctrg"
		execute tool_rpt_rowcount_threshold
	execute load_sbs_hosting_table_partition_rules_wf
	sql "select ctrg_support.load_ctrg_partition_ddl('WEB', 'ctrg','ctrg')"
	execute last_published_dataset_property_v_wf
	serial #ctrg_reports execution
		set :grp_name = "'ctrg_reports'"
		execute rpt_generic_report_wf
	serial #ctrg_validation execution
		set :grp_name = "'ctrg_validation'"
		execute rpt_generic_report_wf
	set :report_groupt = "ctrg_reports"
	set :report_type = "ADC"
	execute run_grp_reports_wf	
	execute lucene_wf
	execute lvt_lucene_verification_report_wf
	serial # RDVT Reports Checks
		set :schema_name = "ctrg"
		set :cycle_status = "monthly"
		execute stop_due_to_failure
		execute exit_due_to_failure 	
	execute archive_nissan_zip_data_wf
	serial #MASTER_BL_TO_CTRG_LOAD_WF completed Email
		set :v_process_name = "MWF_BL_TO_CTRG_END"
		execute generic_email_wf
	sql "select pub_work.fnc_complete_ctrg_load()" #will mark 'INITIATE_CTRG', 'INITIATE_POST_CTRG', 'INITIATE_HOSTING' in Ready state
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  mwf_bl_to_ctrg_wf.wfl
  **
  */
raise notice '******************* SUCCESS!! Workflow import has completed. ****************************';
	
end;
$workflowcontext$ LANGUAGE 'plpgsql';
