do
$workflowcontext$
declare
    /* Export 1.8.1
    Exported on:   2026-06-29 04:23:21-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   stop_due_to_failure.wfl
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
perform af_repo.fk_add_context('stop_due_to_failure'::varchar,'W'::varchar, 90::smallint, '(1.8.1.0)Workflow to stop or pause cycle due to failures'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 24::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 25::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 27::integer, 'load'::varchar, ':no_report_database_identifier|~|select pub_admin.get_parameter(''no_report_database_identifier'')'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    load :no_report_database_identifier= "select pub_admin.get_parameter(''no_report_database_identifier'')"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 28::integer, 'load'::varchar, ':db_name|~|select upper(split_part(''&&_dbid&&'',''_'',1))'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    load :db_name = "select upper(split_part(''&&_dbid&&'',''_'',1))"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 29::integer, 'if'::varchar, 'db_name == "SUB"'::varchar, 'main_50'::varchar, 'main_70'::varchar, ''::varchar, '    if db_name == "SUB"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 30::integer, 'set'::varchar, ':meta_header|~|''bl_sub_meta_header'''::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '        set :meta_header= ''bl_sub_meta_header'''::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 31::integer, 'else'::varchar, ''::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '    else '::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 32::integer, 'if'::varchar, 'db_name == "EQH"'::varchar, 'main_80'::varchar, 'main_100'::varchar, ''::varchar, '        if db_name == "EQH"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 33::integer, 'set'::varchar, ':meta_header|~|''bl_sbs_meta_header_ng'''::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '            set :meta_header= ''bl_sbs_meta_header_ng'''::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 34::integer, 'else'::varchar, ''::varchar, 'main_100'::varchar, ''::varchar, ''::varchar, '        else '::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 35::integer, 'set'::varchar, ':meta_header|~|''bl_sbs_meta_header'''::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '            set :meta_header= ''bl_sbs_meta_header'''::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 37::integer, 'load'::varchar, ':sql_stmt|~|select concat(''select element_code from bl.'',&&meta_header&&,'' where group_name = ''''REPORT_FAILURE_ACTION'''''')'::varchar, 'main_120'::varchar, ''::varchar, ''::varchar, '    load :sql_stmt= "select concat(''select element_code from bl.'',&&meta_header&&,'' where group_name = ''''REPORT_FAILURE_ACTION'''''')"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 39::integer, 'load'::varchar, ':action_on_failure|~|&&sql_stmt&&'::varchar, 'main_130'::varchar, ''::varchar, ''::varchar, '    load :action_on_failure =&&sql_stmt&&'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 41::integer, 'load'::varchar, ':is_valid_input|~|select count(distinct 1) from bl.bl_sbs_meta_blctrg_alrm_cnt a where upper(a.schema_name) =upper(''&&schema_name&&'') and upper(a.pub_cycle) =upper(''&&cycle_status&&'');'::varchar, 'main_140'::varchar, ''::varchar, ''::varchar, '    load :is_valid_input = select count(distinct 1) from bl.bl_sbs_meta_blctrg_alrm_cnt a where upper(a.schema_name) =upper(''&&schema_name&&'') and upper(a.pub_cycle) =upper(''&&cycle_status&&'');'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 43::integer, 'if'::varchar, 'is_valid_input==0'::varchar, 'main_150'::varchar, 'main_170'::varchar, ''::varchar, '    if is_valid_input==0'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 44::integer, 'message'::varchar, 'D|~|PASS'::varchar, 'main_270'::varchar, ''::varchar, ''::varchar, '        message D "PASS"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 45::integer, 'else'::varchar, ''::varchar, 'main_170'::varchar, ''::varchar, ''::varchar, '    else '::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_170'::varchar, 48::integer, 'sql'::varchar, 'select fnc_rdvt_error_table_data(''&&schema_name&&'', ''&&cycle_status&&'')'::varchar, 'main_180'::varchar, ''::varchar, ''::varchar, '        sql "select fnc_rdvt_error_table_data(''&&schema_name&&'', ''&&cycle_status&&'')"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_180'::varchar, 51::integer, 'set'::varchar, ':v_report_type|~|INDIVIDUAL'::varchar, 'main_190'::varchar, ''::varchar, ''::varchar, '        set :v_report_type = "INDIVIDUAL"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_190'::varchar, 52::integer, 'load'::varchar, ':v_report_name|~|select ''rdvt_''||''&&schema_name&&''||''_threshold_breach_report'''::varchar, 'main_200'::varchar, ''::varchar, ''::varchar, '        load :v_report_name= "select ''rdvt_''||''&&schema_name&&''||''_threshold_breach_report''"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_200'::varchar, 53::integer, 'set'::varchar, ':v_parallel_foreach_limit|~|1'::varchar, 'main_210'::varchar, ''::varchar, ''::varchar, '        set :v_parallel_foreach_limit = 1 '::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_210'::varchar, 54::integer, 'load'::varchar, ':function_input_cycle_type|~|select concat('','','''''''''''',''&&cycle_status&&'','''''''''''','')'')'::varchar, 'main_220'::varchar, ''::varchar, ''::varchar, '        load :function_input_cycle_type= "select concat('','','''''''''''',''&&cycle_status&&'','''''''''''','')'')"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_220'::varchar, 57::integer, 'sql'::varchar, 'update bl.bl_sbs_report_meta  set report_query = replace(report_query,'',**cycle_type**)'',''&&function_input_cycle_type&&'')  ,report_body=''PUB CYCLE TYPE: '' ||''&&cycle_status&&''||chr(10)||report_body  where report_name =''&&v_report_name&&'''::varchar, 'main_230'::varchar, ''::varchar, ''::varchar, '        sql "update bl.bl_sbs_report_meta  set report_query = replace(report_query,'',**cycle_type**)'',''&&function_input_cycle_type&&'')  ,report_body=''PUB CYCLE TYPE: '' ||''&&cycle_status&&''||chr(10)||report_body  where report_name =''&&v_report_name&&''"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_230'::varchar, 62::integer, 'serial'::varchar, 'main_240'::varchar, 'main_260'::varchar, ''::varchar, ''::varchar, '        serial # Threshold breach report calling'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_240'::varchar, 63::integer, 'load'::varchar, ':v_name|~|select ''&&v_report_name&&'''::varchar, 'main_250'::varchar, ''::varchar, ''::varchar, '            load :v_name= select ''&&v_report_name&&'''::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_250'::varchar, 64::integer, 'execute'::varchar, 'rdvt_generic_report_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            execute rdvt_generic_report_wf '::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_260'::varchar, 67::integer, 'sql'::varchar, 'update bl.bl_sbs_report_meta  set report_query = replace(report_query,''&&function_input_cycle_type&&'','',**cycle_type**)'') ,report_body=''Process has been stopped to validate data for issues as reported in attached CSV''  where report_name =''&&v_report_name&&'''::varchar, 'main_270'::varchar, ''::varchar, ''::varchar, '        sql "update bl.bl_sbs_report_meta  set report_query = replace(report_query,''&&function_input_cycle_type&&'','',**cycle_type**)'') ,report_body=''Process has been stopped to validate data for issues as reported in attached CSV''  where report_name =''&&v_report_name&&''"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_270'::varchar, 72::integer, 'serial'::varchar, 'main_280'::varchar, 'main_330'::varchar, ''::varchar, ''::varchar, '    serial # Update RDVT Report subject'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_280'::varchar, 74::integer, 'load'::varchar, ':failure_count|~|select count(1) from bl.bl_sbs_report_failures where status =''failure'''::varchar, 'main_290'::varchar, ''::varchar, ''::varchar, '        load :failure_count = "select count(1) from bl.bl_sbs_report_failures where status =''failure''"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_290'::varchar, 76::integer, 'if'::varchar, 'failure_count != 0'::varchar, 'main_300'::varchar, 'main_320'::varchar, ''::varchar, '        if failure_count != 0  #Include ACTION NEEDED IMMEDIATELY in rdvt report subject when there is failure '::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_300'::varchar, 77::integer, 'sql'::varchar, 'update bl.bl_sbs_report_meta set report_subject = ''ACTION NEEDED IMMEDIATELY - RDVT REPORT:- Generated with status Warning or Failure'' where report_name =''report_for_warning_n_failure'''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            sql	"update bl.bl_sbs_report_meta set report_subject = ''ACTION NEEDED IMMEDIATELY - RDVT REPORT:- Generated with status Warning or Failure'' where report_name =''report_for_warning_n_failure''"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_310'::varchar, 78::integer, 'else'::varchar, ''::varchar, 'main_320'::varchar, ''::varchar, ''::varchar, '        else #When there is no failure mail subject Notify for wanrning only '::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_320'::varchar, 79::integer, 'sql'::varchar, 'update bl.bl_sbs_report_meta set report_subject = ''IMPORTANT RDVT REPORT:- Generated with status Warning'' where report_name =''report_for_warning_n_failure'''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            sql	"update bl.bl_sbs_report_meta set report_subject = ''IMPORTANT RDVT REPORT:- Generated with status Warning'' where report_name =''report_for_warning_n_failure''"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_330'::varchar, 82::integer, 'load'::varchar, ':v_email_body|~|select concat(''update bl.bl_sbs_report_meta set report_body = concat(report_body,'''' :- '''',chr(10),chr(13),(select email_body from pub_work.fnc_rdvt_failures_mail_body('',''''''&&schema_name&&'''''','')),chr(10),chr(13),''''Thanks'''',chr(10),''''Nissan Publishing Team'''') where report_name =''''report_for_warning_n_failure'''''')'::varchar, 'main_340'::varchar, ''::varchar, ''::varchar, '    load :v_email_body = select concat(''update bl.bl_sbs_report_meta set report_body = concat(report_body,'''' :- '''',chr(10),chr(13),(select email_body from pub_work.fnc_rdvt_failures_mail_body('',''''''&&schema_name&&'''''','')),chr(10),chr(13),''''Thanks'''',chr(10),''''Nissan Publishing Team'''') where report_name =''''report_for_warning_n_failure'''''')'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_340'::varchar, 83::integer, 'sql'::varchar, '&&v_email_body&&'::varchar, 'main_350'::varchar, ''::varchar, ''::varchar, '    sql "&&v_email_body&&"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_350'::varchar, 85::integer, 'serial'::varchar, 'main_360'::varchar, 'main_400'::varchar, ''::varchar, ''::varchar, '    serial # rdvt_report calling for list of warnign and failure 			'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_360'::varchar, 86::integer, 'set'::varchar, ':v_report_type|~|GROUP'::varchar, 'main_370'::varchar, ''::varchar, ''::varchar, '        set :v_report_type = "GROUP"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_370'::varchar, 87::integer, 'set'::varchar, ':v_name|~|rdvt_report'::varchar, 'main_380'::varchar, ''::varchar, ''::varchar, '        set :v_name = "rdvt_report"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_380'::varchar, 88::integer, 'set'::varchar, ':v_parallel_foreach_limit|~|1'::varchar, 'main_390'::varchar, ''::varchar, ''::varchar, '        set :v_parallel_foreach_limit = 1'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_390'::varchar, 89::integer, 'execute'::varchar, 'rdvt_generic_report_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute rdvt_generic_report_wf'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_400'::varchar, 91::integer, 'serial'::varchar, 'main_410'::varchar, 'main_420'::varchar, ''::varchar, ''::varchar, '    serial #Reset rdvt report subject'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_410'::varchar, 92::integer, 'sql'::varchar, 'update bl.bl_sbs_report_meta set report_subject = ''IMPORTANT RDVT REPORT:- Generated with status Warning or Failure'',report_body=''This report is listing reports that are generated with status Warning or Failure'' where report_name =''report_for_warning_n_failure'''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        sql "update bl.bl_sbs_report_meta set report_subject = ''IMPORTANT RDVT REPORT:- Generated with status Warning or Failure'',report_body=''This report is listing reports that are generated with status Warning or Failure'' where report_name =''report_for_warning_n_failure''"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_420'::varchar, 95::integer, 'if'::varchar, 'is_valid_input==0'::varchar, 'main_430'::varchar, 'main_450'::varchar, ''::varchar, '    if is_valid_input==0'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_430'::varchar, 96::integer, 'message'::varchar, 'D|~|PASS'::varchar, 'main_470'::varchar, ''::varchar, ''::varchar, '        message D "PASS"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_440'::varchar, 97::integer, 'else'::varchar, ''::varchar, 'main_450'::varchar, ''::varchar, ''::varchar, '    else'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_450'::varchar, 98::integer, 'load'::varchar, ':sql_stmt1|~|select concat(''update bl.bl_sbs_report_failures set status =''''warning'''' where report_name ='',''''''&&v_report_name&&'''''','' and (select count(1)= sum(case when col1 =''''**TABLE LISTS WITH WARNING ERROR COUNTS**'''' then 1 else 0 end) only_warning from pub_work.report_'',''&&v_report_name&&'','' where col1 like ''''**%%**'''')'')'::varchar, 'main_460'::varchar, ''::varchar, ''::varchar, '        load :sql_stmt1=select concat(''update bl.bl_sbs_report_failures set status =''''warning'''' where report_name ='',''''''&&v_report_name&&'''''','' and (select count(1)= sum(case when col1 =''''**TABLE LISTS WITH WARNING ERROR COUNTS**'''' then 1 else 0 end) only_warning from pub_work.report_'',''&&v_report_name&&'','' where col1 like ''''**%%**'''')'')'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_460'::varchar, 100::integer, 'sql'::varchar, '&&sql_stmt1&&'::varchar, 'main_470'::varchar, ''::varchar, ''::varchar, '        sql "&&sql_stmt1&&"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_470'::varchar, 102::integer, 'load'::varchar, ':report_data_validation_status|~|select pub_work.fnc_stop_due_to_failure()'::varchar, 'main_480'::varchar, ''::varchar, ''::varchar, '    load :report_data_validation_status = "select pub_work.fnc_stop_due_to_failure()"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_480'::varchar, 105::integer, 'if'::varchar, 'report_data_validation_status == "GO AHEAD" 	'::varchar, 'main_490'::varchar, 'main_510'::varchar, ''::varchar, '    if report_data_validation_status == "GO AHEAD" 	'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_490'::varchar, 106::integer, 'message'::varchar, 'D|~|No concerns proceeding forward in publishing cycle execution. Threshold Counts and Report Data so far looks good.'::varchar, 'main_600'::varchar, ''::varchar, ''::varchar, '        message D "No concerns proceeding forward in publishing cycle execution. Threshold Counts and Report Data so far looks good."'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_500'::varchar, 107::integer, 'else'::varchar, ''::varchar, 'main_510'::varchar, ''::varchar, ''::varchar, '    else '::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_510'::varchar, 108::integer, 'load'::varchar, ':error_message|~|select trim(concat(''&&report_data_validation_status&&''))'::varchar, 'main_520'::varchar, ''::varchar, ''::varchar, '        load :error_message = "select trim(concat(''&&report_data_validation_status&&''))"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_520'::varchar, 109::integer, 'if'::varchar, 'action_on_failure == "PAUSE"'::varchar, 'main_530'::varchar, 'main_590'::varchar, ''::varchar, '        if action_on_failure == "PAUSE"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_530'::varchar, 110::integer, 'load'::varchar, ':email_subject|~|select concat(upper(''&&_dbid&&''),'' - ACTION NEEDED IMMEDIATELY: RDVT'','' at ''||upper(nullif(trim(''&&schema_name&&''),''''))|| '' level'','' - Wait Process for validating data for reported issues - Initiated'')'::varchar, 'main_540'::varchar, ''::varchar, ''::varchar, '            load :email_subject = "select concat(upper(''&&_dbid&&''),'' - ACTION NEEDED IMMEDIATELY: RDVT'','' at ''||upper(nullif(trim(''&&schema_name&&''),''''))|| '' level'','' - Wait Process for validating data for reported issues - Initiated'')"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_540'::varchar, 111::integer, 'load'::varchar, ':email_message|~|select concat(''Process has been stopped to validate data for issues as reported below: '',chr(10),''&&error_message&&'')'::varchar, 'main_550'::varchar, ''::varchar, ''::varchar, '            load :email_message = "select concat(''Process has been stopped to validate data for issues as reported below: '',chr(10),''&&error_message&&'')"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_550'::varchar, 112::integer, 'load'::varchar, ':current_time_str|~|select to_char(current_timestamp, ''DD-MON-YYYY HH:MI:SS PM'')'::varchar, 'main_560'::varchar, ''::varchar, ''::varchar, '            load :current_time_str = "select to_char(current_timestamp, ''DD-MON-YYYY HH:MI:SS PM'')"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_560'::varchar, 113::integer, 'send_email'::varchar, ':exception_handler_email|~|&&email_subject&&: &&current_time_str&&|~|&&email_message&&'::varchar, 'main_570'::varchar, ''::varchar, ''::varchar, '            send_email :exception_handler_email "&&email_subject&&: &&current_time_str&&" "&&email_message&&"'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_570'::varchar, 114::integer, 'wait_operator_response'::varchar, '5760|~|Please respond if data is good to proceed forward.'::varchar, 'main_600'::varchar, ''::varchar, ''::varchar, '            wait_operator_response 5760 "Please respond if data is good to proceed forward."'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_580'::varchar, 115::integer, 'else'::varchar, ''::varchar, 'main_590'::varchar, ''::varchar, ''::varchar, '        else	'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_590'::varchar, 117::integer, 'execute'::varchar, 'rdvt_error_message_wf'::varchar, 'main_600'::varchar, ''::varchar, ''::varchar, '            execute rdvt_error_message_wf'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_600'::varchar, 119::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_option('parameters'::varchar, 'parameters'::varchar, '{"schema_name": "", "cycle_status": ""}'::varchar, 'stop_due_to_failure'::varchar, 'W'::varchar, 1::integer);
perform af_repo.af_compiler_insert('stop_due_to_failure.wfl', $q$#Workflow to autopopulate bl_sbs_report_failures table based on modifications in bl_sbs_report_meta
stop_due_to_failure(schema_name=,cycle_status=,retention=90): Workflow to stop or pause cycle due to failures
# Project: NEXT GEN PUBLISHING
#
# Name: stop_due_to_failure.wfl
#
# Purpose:  This workflow is used to to stop or pause cycle due to failures
#
#===========================================================
# Revision History
#   Ref   Date          Revisor      Comment
#   1     28-NOV-2025    SM           Initial Version 
#	2	  11-Mar-2026	 BK			  No Function call if there is no input schema passed.
#	3	  14-April-2026	 BK			  FDNGPUB-2792: RDVT Enhancement vs 1.1.0
#	4	  22-May-2026	 BK			  FDNGPUB-2827: Include 'ACTION NEEDED IMMEDIATELY' in RDVT report mail subject when any report have listed with failure
#									  FDNGPUB-2827: Include fnc_rdvt_error_table_data() to load error hash in meta table 
#									  FDNGPUB-2827: Update status of threshold_breach_report to warning, if the onlt list of **TABLE LISTS WITH WARNING ERROR COUNTS** exists in report 
#===========================================================
# Revisor
# [Initials]		[Full Name]
# 	SM               Smiley Mahajan
#	BK				 Bipin Kumar
#===========================================================
	output_version
	output_options
	#load :exception_handler_email = "select string_agg(address,',') as address from bl.bl_email_notification_m where valid=1 group by valid" #Temp
	load :no_report_database_identifier= "select pub_admin.get_parameter('no_report_database_identifier')"
	load :db_name = "select upper(split_part('&&_dbid&&','_',1))"
	if db_name == "SUB"
		set :meta_header= 'bl_sub_meta_header'
	else 
		if db_name == "EQH"
			set :meta_header= 'bl_sbs_meta_header_ng'
		else 
			set :meta_header= 'bl_sbs_meta_header'
			
	load :sql_stmt= "select concat('select element_code from bl.',&&meta_header&&,' where group_name = ''REPORT_FAILURE_ACTION''')"
		
	load :action_on_failure =&&sql_stmt&&
	
	load :is_valid_input = select count(distinct 1) from bl.bl_sbs_meta_blctrg_alrm_cnt a where upper(a.schema_name) =upper('&&schema_name&&') and upper(a.pub_cycle) =upper('&&cycle_status&&');
	
	if is_valid_input==0
		message D "PASS"
	else 
	
		# Update error table hash data in bl.bl_sbs_meta_blctrg_alrm_cnt table
		sql "select fnc_rdvt_error_table_data('&&schema_name&&', '&&cycle_status&&')"


		set :v_report_type = "INDIVIDUAL"
		load :v_report_name= "select 'rdvt_'||'&&schema_name&&'||'_threshold_breach_report'"
		set :v_parallel_foreach_limit = 1 
		load :function_input_cycle_type= "select concat(',','''''','&&cycle_status&&','''''',')')"
		
		#update report_query and report_body to schema and cycle type specific
		sql "update bl.bl_sbs_report_meta \
		set report_query = replace(report_query,',**cycle_type**)','&&function_input_cycle_type&&') \
		,report_body='PUB CYCLE TYPE: ' ||'&&cycle_status&&'||chr(10)||report_body \
		where report_name ='&&v_report_name&&'"
		
		serial # Threshold breach report calling
			load :v_name= select '&&v_report_name&&'
			execute rdvt_generic_report_wf 

		#reset bl_sbs_report_meta
		sql "update bl.bl_sbs_report_meta \
 		set report_query = replace(report_query,'&&function_input_cycle_type&&',',**cycle_type**)')\
		,report_body='Process has been stopped to validate data for issues as reported in attached CSV' \
		where report_name ='&&v_report_name&&'"
		
	serial # Update RDVT Report subject
		
		load :failure_count = "select count(1) from bl.bl_sbs_report_failures where status ='failure'"
		
		if failure_count != 0  #Include ACTION NEEDED IMMEDIATELY in rdvt report subject when there is failure 
			sql	"update bl.bl_sbs_report_meta set report_subject = 'ACTION NEEDED IMMEDIATELY - RDVT REPORT:- Generated with status Warning or Failure' where report_name ='report_for_warning_n_failure'"
		else #When there is no failure mail subject Notify for wanrning only 
			sql	"update bl.bl_sbs_report_meta set report_subject = 'IMPORTANT RDVT REPORT:- Generated with status Warning' where report_name ='report_for_warning_n_failure'"
	
	
	load :v_email_body = select concat('update bl.bl_sbs_report_meta set report_body = concat(report_body,'' :- '',chr(10),chr(13),(select email_body from pub_work.fnc_rdvt_failures_mail_body(','''&&schema_name&&''',')),chr(10),chr(13),''Thanks'',chr(10),''Nissan Publishing Team'') where report_name =''report_for_warning_n_failure''')
	sql "&&v_email_body&&"
	
	serial # rdvt_report calling for list of warnign and failure 			
		set :v_report_type = "GROUP"
		set :v_name = "rdvt_report"
		set :v_parallel_foreach_limit = 1
		execute rdvt_generic_report_wf
		
	serial #Reset rdvt report subject
		sql "update bl.bl_sbs_report_meta set report_subject = 'IMPORTANT RDVT REPORT:- Generated with status Warning or Failure',report_body='This report is listing reports that are generated with status Warning or Failure' where report_name ='report_for_warning_n_failure'"
	
	#Update status of threshold_breach_report to warning, if only list of **TABLE LISTS WITH WARNING ERROR COUNTS** exists in report 
	if is_valid_input==0
		message D "PASS"
	else
		load :sql_stmt1=select concat('update bl.bl_sbs_report_failures set status =''warning'' where report_name =','''&&v_report_name&&''',' and (select count(1)= sum(case when col1 =''**TABLE LISTS WITH WARNING ERROR COUNTS**'' then 1 else 0 end) only_warning from pub_work.report_','&&v_report_name&&',' where col1 like ''**%%**'')')
		
		sql "&&sql_stmt1&&"
	
	load :report_data_validation_status = "select pub_work.fnc_stop_due_to_failure()"
	

	if report_data_validation_status == "GO AHEAD" 	
		message D "No concerns proceeding forward in publishing cycle execution. Threshold Counts and Report Data so far looks good."
	else 
		load :error_message = "select trim(concat('&&report_data_validation_status&&'))"
		if action_on_failure == "PAUSE"
			load :email_subject = "select concat(upper('&&_dbid&&'),' - ACTION NEEDED IMMEDIATELY: RDVT',' at '||upper(nullif(trim('&&schema_name&&'),''))|| ' level',' - Wait Process for validating data for reported issues - Initiated')"
			load :email_message = "select concat('Process has been stopped to validate data for issues as reported below: ',chr(10),'&&error_message&&')"
			load :current_time_str = "select to_char(current_timestamp, 'DD-MON-YYYY HH:MI:SS PM')"
			send_email :exception_handler_email "&&email_subject&&: &&current_time_str&&" "&&email_message&&"
			wait_operator_response 5760 "Please respond if data is good to proceed forward."
		else	
			# message E "&&error_message&&"
			execute rdvt_error_message_wf
	
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  stop_due_to_failure.wfl
  **
  */
raise notice '******************* SUCCESS!! Workflow import has completed. ****************************';
	
end;
$workflowcontext$ LANGUAGE 'plpgsql';
