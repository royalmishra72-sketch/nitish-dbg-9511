do
$workflowcontext$
declare
    /* Export Version 1.7.2
    Exported on:   2025-10-23 23:42:47-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   adc_qa_reports_wf.wfl
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
perform af_repo.fk_add_context('adc_qa_reports_wf'::varchar,'W'::varchar, 90::smallint, '(1.8.0.0)Workflow used to execute automated data check qa reports'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 19::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 20::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 21::integer, 'set'::varchar, ':tag_area|~|ADC QA reports'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_area = "ADC QA reports"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 22::integer, 'load'::varchar, ':v_env_root_path|~|select pub_admin.get_parameter(''PBAEnvRootPath'')'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    load :v_env_root_path = "select pub_admin.get_parameter(''PBAEnvRootPath'')"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 23::integer, 'load'::varchar, ':v_adc_input_relpath|~|select pub_admin.get_parameter(''ADC_INPUT_PATH'')'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    load :v_adc_input_relpath = "select pub_admin.get_parameter(''ADC_INPUT_PATH'')"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 24::integer, 'load'::varchar, ':v_adc_output_relpath|~|select pub_admin.get_parameter(''ADC_OUTPUT_PATH'')'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '    load :v_adc_output_relpath = "select pub_admin.get_parameter(''ADC_OUTPUT_PATH'')"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 25::integer, 'load'::varchar, ':v_epo_root_path|~|select pub_admin.get_parameter(''PBAEPORootPath'')'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '    load :v_epo_root_path = "select pub_admin.get_parameter(''PBAEPORootPath'')"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 26::integer, 'load'::varchar, ':v_adc_script_relpath|~|select pub_admin.get_parameter(''ADC_SCRIPT_PATH'')'::varchar, 'main_80'::varchar, ''::varchar, ''::varchar, '    load :v_adc_script_relpath = "select pub_admin.get_parameter(''ADC_SCRIPT_PATH'')"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 27::integer, 'load'::varchar, ':pba_java_path|~|select pub_admin.get_parameter(''pba_java_path'')'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '    load :pba_java_path = "select pub_admin.get_parameter(''pba_java_path'')"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 28::integer, 'load'::varchar, ':tier|~|select case when current_database() like ''%%pub_dev%%db'' then ''dev'' WHEN current_database() like ''%%pub_int%%db'' then ''int'' WHEN current_database() like ''%%pub_tst%%db'' then ''tst'' when current_database() like ''%%pub_prd%%db'' then ''prd'' end'::varchar, 'main_100'::varchar, ''::varchar, ''::varchar, '    load :tier = "select case when current_database() like ''%%pub_dev%%db'' then ''dev'' WHEN current_database() like ''%%pub_int%%db'' then ''int'' WHEN current_database() like ''%%pub_tst%%db'' then ''tst'' when current_database() like ''%%pub_prd%%db'' then ''prd'' end"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 29::integer, 'if'::varchar, 'tier == "prd" and target_url=="stg"'::varchar, 'main_110'::varchar, 'main_130'::varchar, ''::varchar, '    if tier == "prd" and target_url=="stg" ## Execution of this template should only be done only on PRD'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 30::integer, 'message'::varchar, 'E|~|This workflow should only be executed for PRD or PIA url from PRD tier.'::varchar, 'main_140'::varchar, ''::varchar, ''::varchar, '            message E "This workflow should only be executed for PRD or PIA url from PRD tier."'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 31::integer, 'else'::varchar, ''::varchar, 'main_130'::varchar, ''::varchar, ''::varchar, '    else'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 32::integer, 'set'::varchar, ':adc_vault_loc|~|pub_admin/adc_epc5_&&target_url&&_url'::varchar, 'main_140'::varchar, ''::varchar, ''::varchar, '        set :adc_vault_loc ="pub_admin/adc_epc5_&&target_url&&_url"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 33::integer, 'load'::varchar, ':dataset_code|~|select pub_admin.get_parameter(''ADC_OE_DATASET_CODE'')'::varchar, 'main_150'::varchar, ''::varchar, ''::varchar, '    load :dataset_code = "select pub_admin.get_parameter(''ADC_OE_DATASET_CODE'')"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 34::integer, 'set'::varchar, ':adc_input_full_path|~|&&v_epo_root_path&&&&v_adc_input_relpath&&'::varchar, 'main_160'::varchar, ''::varchar, ''::varchar, '    set :adc_input_full_path = "&&v_epo_root_path&&&&v_adc_input_relpath&&"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 35::integer, 'set'::varchar, ':adc_output_full_path|~|&&v_epo_root_path&&&&v_adc_output_relpath&&'::varchar, 'main_170'::varchar, ''::varchar, ''::varchar, '    set :adc_output_full_path = "&&v_epo_root_path&&&&v_adc_output_relpath&&"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_170'::varchar, 36::integer, 'set'::varchar, ':adc_script_full_path|~|&&v_env_root_path&&&&v_adc_script_relpath&&'::varchar, 'main_180'::varchar, ''::varchar, ''::varchar, '    set :adc_script_full_path = "&&v_env_root_path&&&&v_adc_script_relpath&&"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_180'::varchar, 37::integer, 'set'::varchar, ':attachReport|~|true'::varchar, 'main_190'::varchar, ''::varchar, ''::varchar, '    set :attachReport = "true"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_190'::varchar, 38::integer, 'if'::varchar, 'target_url=="pia"'::varchar, 'main_200'::varchar, 'main_210'::varchar, ''::varchar, '    if target_url=="pia"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_200'::varchar, 39::integer, 'load'::varchar, ':bypassproxy|~|select pub_admin.get_parameter(''ADC_BYPASSPROXY_PIA'')'::varchar, 'main_210'::varchar, ''::varchar, ''::varchar, '        load :bypassproxy = "select pub_admin.get_parameter(''ADC_BYPASSPROXY_PIA'')"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_210'::varchar, 40::integer, 'if'::varchar, 'target_url=="prd"'::varchar, 'main_220'::varchar, 'main_230'::varchar, ''::varchar, '    if target_url=="prd"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_220'::varchar, 41::integer, 'load'::varchar, ':bypassproxy|~|select pub_admin.get_parameter(''ADC_BYPASSPROXY_PRD'')'::varchar, 'main_230'::varchar, ''::varchar, ''::varchar, '        load :bypassproxy = "select pub_admin.get_parameter(''ADC_BYPASSPROXY_PRD'')"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_230'::varchar, 42::integer, 'if'::varchar, 'target_url=="stg"'::varchar, 'main_240'::varchar, 'main_250'::varchar, ''::varchar, '    if target_url=="stg"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_240'::varchar, 43::integer, 'load'::varchar, ':bypassproxy|~|select pub_admin.get_parameter(''ADC_BYPASSPROXY_STG'')'::varchar, 'main_250'::varchar, ''::varchar, ''::varchar, '        load :bypassproxy = "select pub_admin.get_parameter(''ADC_BYPASSPROXY_STG'')"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_250'::varchar, 44::integer, 'load'::varchar, ':emailList|~|select user_email_list from bl.bl_sbs_pub_run_notification where process_name=''START_PROCESS'''::varchar, 'main_260'::varchar, ''::varchar, ''::varchar, '    load :emailList = "select user_email_list from bl.bl_sbs_pub_run_notification where process_name=''START_PROCESS''"'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_260'::varchar, 45::integer, 'set'::varchar, ':cwd_path|~|&&v_env_root_path&&/app/script/'::varchar, 'main_270'::varchar, ''::varchar, ''::varchar, '    set :cwd_path ="&&v_env_root_path&&/app/script/" 	'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_270'::varchar, 46::integer, 'run'::varchar, '"&&v_env_root_path&&/app/script/adcEPC5Call.sh" &&_dbid&& "&&adc_vault_loc&&" "&&adc_input_full_path&&" "&&adc_output_full_path&&" "&&adc_script_full_path&&" "&&dataset_code&&" "&&emailList&&" "&&attachReport&&" "&&bypassproxy&&"  "&&pba_java_path&&"'::varchar, 'main_280'::varchar, ''::varchar, ''::varchar, '    run "&&v_env_root_path&&/app/script/adcEPC5Call.sh" &&_dbid&& "&&adc_vault_loc&&" "&&adc_input_full_path&&" "&&adc_output_full_path&&" "&&adc_script_full_path&&" "&&dataset_code&&" "&&emailList&&" "&&attachReport&&" "&&bypassproxy&&"  "&&pba_java_path&&" #adcepc5call'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_280'::varchar, 47::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_option('parameters'::varchar, 'parameters'::varchar, '{"target_url": "<select class=\\"pc_select\\"><option>pia</option><option>prd</option><option>stg</option></select>"}'::varchar, 'adc_qa_reports_wf'::varchar, 'W'::varchar, 1::integer);
perform af_repo.af_compiler_insert('adc_qa_reports_wf.wfl', $q$#Workflow used to execute automated data check qa reports
adc_qa_reports_wf(retention=90,target_url=[pia:prd:stg]): Workflow used to execute automated data check qa reports
# Project:  Nissan NG DATA PUBLISHING
#
# Name: adc_qa_reports_wf.wfl
#
# Purpose:  Workflow used to execute automated data check qa reports
#
#===========================================================
# Revision History
#   Ref   Date          Revisor      Comment
#   1     07-JUNE-2024    NKM        Initial Version 
#   2     22-OCT-2025     NKM        Added variable pba_java_path to call jkd using pba_param_t
#===========================================================
# Revisor
# [Initials]		[Full Name]
# NKM               Nitish K Mishra
#===========================================================
    output_version
    output_options
	set :tag_area = "ADC QA reports"
	load :v_env_root_path = "select pub_admin.get_parameter('PBAEnvRootPath')"
	load :v_adc_input_relpath = "select pub_admin.get_parameter('ADC_INPUT_PATH')"
	load :v_adc_output_relpath = "select pub_admin.get_parameter('ADC_OUTPUT_PATH')"
	load :v_epo_root_path = "select pub_admin.get_parameter('PBAEPORootPath')"
	load :v_adc_script_relpath = "select pub_admin.get_parameter('ADC_SCRIPT_PATH')"
	load :pba_java_path = "select pub_admin.get_parameter('pba_java_path')"
	load :tier = "select case when current_database() like '%%pub_dev%%db' then 'dev' WHEN current_database() like '%%pub_int%%db' then 'int' WHEN current_database() like '%%pub_tst%%db' then 'tst' when current_database() like '%%pub_prd%%db' then 'prd' end"
	if tier == "prd" and target_url=="stg" ## Execution of this template should only be done only on PRD
			message E "This workflow should only be executed for PRD or PIA url from PRD tier."
	else
		set :adc_vault_loc ="pub_admin/adc_epc5_&&target_url&&_url"
	load :dataset_code = "select pub_admin.get_parameter('ADC_OE_DATASET_CODE')"
	set :adc_input_full_path = "&&v_epo_root_path&&&&v_adc_input_relpath&&"
	set :adc_output_full_path = "&&v_epo_root_path&&&&v_adc_output_relpath&&"
	set :adc_script_full_path = "&&v_env_root_path&&&&v_adc_script_relpath&&"
	set :attachReport = "true"
	if target_url=="pia"
		load :bypassproxy = "select pub_admin.get_parameter('ADC_BYPASSPROXY_PIA')"
	if target_url=="prd"
		load :bypassproxy = "select pub_admin.get_parameter('ADC_BYPASSPROXY_PRD')"
	if target_url=="stg"
		load :bypassproxy = "select pub_admin.get_parameter('ADC_BYPASSPROXY_STG')"
	load :emailList = "select user_email_list from bl.bl_sbs_pub_run_notification where process_name='START_PROCESS'"
	set :cwd_path ="&&v_env_root_path&&/app/script/" 	
	run "&&v_env_root_path&&/app/script/adcEPC5Call.sh" &&_dbid&& "&&adc_vault_loc&&" "&&adc_input_full_path&&" "&&adc_output_full_path&&" "&&adc_script_full_path&&" "&&dataset_code&&" "&&emailList&&" "&&attachReport&&" "&&bypassproxy&&"  "&&pba_java_path&&" #adcepc5call
 	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  adc_qa_reports_wf.wfl
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
