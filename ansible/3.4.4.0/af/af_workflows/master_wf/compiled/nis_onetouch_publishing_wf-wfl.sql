do
$workflowcontext$
declare
    /* Export 1.8.1
    Exported on:   2026-06-30 07:07:46-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   nis_onetouch_publishing_wf.wfl
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
perform af_repo.fk_add_context('nis_onetouch_publishing_wf'::varchar,'W'::varchar, 90::smallint, '(1.8.1.0)This Workflow used to load CTRG Tables from Feed.'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 21::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 22::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options	'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 23::integer, 'set'::varchar, ':tag_area|~|Feed to CTRG'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_area = "Feed to CTRG"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 24::integer, 'set'::varchar, ':tag_domain|~|OneTouch Operations'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :tag_domain = "OneTouch Operations"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 25::integer, 'load'::varchar, ':email_list|~|select string_agg(user_email_list,'','') as address from bl.bl_sbs_pub_run_notification where process_name =''DEFAULT'''::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    load :email_list = "select string_agg(user_email_list,'','') as address from bl.bl_sbs_pub_run_notification where process_name =''DEFAULT''"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 26::integer, 'if'::varchar, 'run_type == "Run_Prerequisites"'::varchar, 'main_60'::varchar, 'main_340'::varchar, ''::varchar, '    if run_type == "Run_Prerequisites"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 27::integer, 'set'::varchar, ':v_process_name|~|PREREQUISITE_WORKFLOW_STARTED'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '        set :v_process_name = "PREREQUISITE_WORKFLOW_STARTED"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 28::integer, 'execute'::varchar, 'generic_email_wf'::varchar, 'main_80'::varchar, ''::varchar, ''::varchar, '        execute generic_email_wf'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 29::integer, 'execute'::varchar, 'autoseeder_bl_sbs_report_failures'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '        execute autoseeder_bl_sbs_report_failures'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 30::integer, 'sql'::varchar, 'select pub_work.fnc_reset_bl_sbs_report_failures()'::varchar, 'main_100'::varchar, ''::varchar, ''::varchar, '        sql "select pub_work.fnc_reset_bl_sbs_report_failures()"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 31::integer, 'datareceipt'::varchar, 'DOWNLOAD_CATALOG_PDF'::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '        datareceipt DOWNLOAD_CATALOG_PDF #Download PDF''s'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 32::integer, 'load'::varchar, ':catalog_name|~|select catalog_list from pub_work.current_month_catalog_name_v'::varchar, 'main_120'::varchar, ''::varchar, ''::varchar, '        load :catalog_name= "select catalog_list from pub_work.current_month_catalog_name_v"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 33::integer, 'load'::varchar, ':catalog_count|~|select catalog_count from pub_work.current_month_catalog_name_v'::varchar, 'main_130'::varchar, ''::varchar, ''::varchar, '        load :catalog_count= "select catalog_count from pub_work.current_month_catalog_name_v"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 34::integer, 'load'::varchar, ':new_catalog_count|~|select count(1) from pub_work.new_catalog_entry_v'::varchar, 'main_140'::varchar, ''::varchar, ''::varchar, '        load :new_catalog_count= "select count(1) from pub_work.new_catalog_entry_v"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 35::integer, 'serial'::varchar, 'main_150'::varchar, 'main_200'::varchar, ''::varchar, ''::varchar, '        serial # Notification For Catalog PDF Download'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 36::integer, 'load'::varchar, ':email_list|~|select user_email_list from bl.bl_sbs_pub_run_notification where process_name in(''NISSAN_CATALOG_IMAGE_SYNC_PROCESS_START'')'::varchar, 'main_160'::varchar, ''::varchar, ''::varchar, '            load :email_list = "select user_email_list from bl.bl_sbs_pub_run_notification where process_name in(''NISSAN_CATALOG_IMAGE_SYNC_PROCESS_START'')"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 37::integer, 'set'::varchar, ':email_subject|~|Catalog PDFs Downloaded from Outfacing to EPO'::varchar, 'main_170'::varchar, ''::varchar, ''::varchar, '            set :email_subject = "Catalog PDFs Downloaded from Outfacing to EPO"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_170'::varchar, 38::integer, 'load'::varchar, ':email_message|~|select ''Hello Team, ''||chr(10)||chr(10)||''Following catalogs have been successfully downloaded in EPO: ''||chr(10)||''Total No Of Catalog:- ''||''&&catalog_count&&''||chr(10)||''Catalog Name:-''||''&&catalog_name&&''||chr(10)||chr(10)||''Thanks,''||chr(10)||''Nissan Publishing Team''|~|"'::varchar, 'main_180'::varchar, ''::varchar, ''::varchar, '            load :email_message = "select ''Hello Team, ''||chr(10)||chr(10)||''Following catalogs have been successfully downloaded in EPO: ''||chr(10)||''Total No Of Catalog:- ''||''&&catalog_count&&''||chr(10)||''Catalog Name:-''||''&&catalog_name&&''||chr(10)||chr(10)||''Thanks,''||chr(10)||''Nissan Publishing Team''""'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_180'::varchar, 39::integer, 'load'::varchar, ':current_time_str|~|select to_char(current_timestamp, ''DD-MON-YYYY HH:MI:SS PM'')'::varchar, 'main_190'::varchar, ''::varchar, ''::varchar, '            load :current_time_str = "select to_char(current_timestamp, ''DD-MON-YYYY HH:MI:SS PM'')"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_190'::varchar, 40::integer, 'send_email'::varchar, ':email_list|~|&&email_subject&&: &&current_time_str&&|~|&&email_message&&'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            send_email :email_list "&&email_subject&&: &&current_time_str&&" "&&email_message&&"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_200'::varchar, 42::integer, 'if'::varchar, 'new_catalog_count > 0'::varchar, 'main_210'::varchar, 'main_260'::varchar, ''::varchar, '        if new_catalog_count > 0 '::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_210'::varchar, 43::integer, 'serial'::varchar, 'main_220'::varchar, 'main_260'::varchar, ''::varchar, ''::varchar, '            serial # Notification For New Catalog'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_220'::varchar, 44::integer, 'load'::varchar, ':new_cats|~|select concat(''MODEL: '',string_agg( model ,'' , '')) from new_catalog_entry_v'::varchar, 'main_230'::varchar, ''::varchar, ''::varchar, '                load :new_cats = "select concat(''MODEL: '',string_agg( model ,'' , '')) from new_catalog_entry_v" '::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_230'::varchar, 45::integer, 'set'::varchar, ':email_subject|~|Alert: New Catalogs available'::varchar, 'main_240'::varchar, ''::varchar, ''::varchar, '                set :email_subject = "Alert: New Catalogs available"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_240'::varchar, 46::integer, 'load'::varchar, ':email_message|~|select ''Alert: New Catalogs available''||chr(10)||''&&new_cats&&'''::varchar, 'main_250'::varchar, ''::varchar, ''::varchar, '                load :email_message = "select ''Alert: New Catalogs available''||chr(10)||''&&new_cats&&''"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_250'::varchar, 47::integer, 'send_email'::varchar, ':email_list|~|&&email_subject&&: &&current_time_str&&|~|&&email_message&&'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '                send_email :email_list "&&email_subject&&: &&current_time_str&&" "&&email_message&&"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_260'::varchar, 50::integer, 'serial'::varchar, 'main_270'::varchar, 'main_290'::varchar, ''::varchar, ''::varchar, '        serial # Run Prerequisite reports'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_270'::varchar, 51::integer, 'set'::varchar, ':grp_name|~|''prerequisite_reports'''::varchar, 'main_280'::varchar, ''::varchar, ''::varchar, '            set :grp_name = "''prerequisite_reports''"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_280'::varchar, 52::integer, 'execute'::varchar, 'rpt_generic_report_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            execute rpt_generic_report_wf #Run Prerequisite reports'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_290'::varchar, 54::integer, 'serial'::varchar, 'main_300'::varchar, 'main_340'::varchar, ''::varchar, ''::varchar, '        serial # Check and stop if any report Failed'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_300'::varchar, 57::integer, 'load'::varchar, ':schema_name|~|select '''''::varchar, 'main_310'::varchar, ''::varchar, ''::varchar, '            load :schema_name = "select ''''"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_310'::varchar, 58::integer, 'load'::varchar, ':cycle_status|~|select '''''::varchar, 'main_320'::varchar, ''::varchar, ''::varchar, '            load :cycle_status = "select ''''"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_320'::varchar, 59::integer, 'execute'::varchar, 'stop_due_to_failure'::varchar, 'main_330'::varchar, ''::varchar, ''::varchar, '            execute stop_due_to_failure'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_330'::varchar, 60::integer, 'execute'::varchar, 'exit_due_to_failure'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            execute exit_due_to_failure'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_340'::varchar, 62::integer, 'if'::varchar, 'run_type == "Run_Feed_To_CTRG"'::varchar, 'main_350'::varchar, 'main_450'::varchar, ''::varchar, '    if run_type == "Run_Feed_To_CTRG"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_350'::varchar, 63::integer, 'load'::varchar, ':prerequisite_workflow_execution_check|~|select pub_work.fnc_prerequisite_workflow_check()'::varchar, 'main_360'::varchar, ''::varchar, ''::varchar, '        load :prerequisite_workflow_execution_check = "select pub_work.fnc_prerequisite_workflow_check()"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_360'::varchar, 64::integer, 'if'::varchar, 'prerequisite_workflow_execution_check == "GO AHEAD" 	'::varchar, 'main_370'::varchar, 'main_390'::varchar, ''::varchar, '        if prerequisite_workflow_execution_check == "GO AHEAD" 	'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_370'::varchar, 65::integer, 'message'::varchar, 'D|~|No concerns proceeding forward in publishing cycle execution. All Prerequisites process executed successfully.'::varchar, 'main_410'::varchar, ''::varchar, ''::varchar, '            message D "No concerns proceeding forward in publishing cycle execution. All Prerequisites process executed successfully."'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_380'::varchar, 66::integer, 'else'::varchar, ''::varchar, 'main_390'::varchar, ''::varchar, ''::varchar, '        else'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_390'::varchar, 67::integer, 'load'::varchar, ':error_message|~|select trim(concat(''&&prerequisite_workflow_execution_check&&''))'::varchar, 'main_400'::varchar, ''::varchar, ''::varchar, '            load :error_message = "select trim(concat(''&&prerequisite_workflow_execution_check&&''))"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_400'::varchar, 68::integer, 'message'::varchar, 'E|~|&&error_message&&'::varchar, 'main_410'::varchar, ''::varchar, ''::varchar, '            message E "&&error_message&&"'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_410'::varchar, 69::integer, 'serial'::varchar, 'main_420'::varchar, 'main_450'::varchar, ''::varchar, ''::varchar, '        serial # Feed Download to CTRG Load'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_420'::varchar, 70::integer, 'execute'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'main_430'::varchar, ''::varchar, ''::varchar, '            execute mwf_download_nissan_feeds_wf # Feed Download'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_430'::varchar, 71::integer, 'execute'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'main_440'::varchar, ''::varchar, ''::varchar, '            execute mwf_feed_to_bl_wf # Feed to BL'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_440'::varchar, 72::integer, 'execute'::varchar, 'mwf_bl_to_ctrg_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            execute mwf_bl_to_ctrg_wf # BL to CTRG		'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_450'::varchar, 73::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_option('parameters'::varchar, 'parameters'::varchar, '{"run_type": "<select class=\"pc_select\"><option>Run_Prerequisites</option><option>Run_Feed_To_CTRG</option></select>"}'::varchar, 'nis_onetouch_publishing_wf'::varchar, 'W'::varchar, 1::integer);
perform af_repo.af_compiler_insert('nis_onetouch_publishing_wf.wfl', $q$#master Onetouch workflow Feed to CTRG
nis_onetouch_publishing_wf(retention=90,run_type=[Run_Prerequisites:Run_Feed_To_CTRG]): This Workflow used to load CTRG Tables from Feed.
# Project: NISSAN DATA PUBLISHING
#
# Name: nis_onetouch_publishing_wf.wfl
#
# Purpose:  This Workflow used to load CTRG Tables from Feed.
#
#===========================================================
# Revision History
#   Ref #  Date          Revisor      Comment
#	1      10-FEB-2026   CB           Initial Creation
#   2      12-JUNE-2026  NKM          RDVT 1.1.0 and 1.2.0 Enhancement
#   3      18-JUNE-2026  NKM          Add Prerequisites workflow execution check process
#===========================================================
# Revisor
# [Initials]		[Full Name]
# CB                 Chandan Bhatia 
# NKM                Nitish K Mishra
#===========================================================
    output_version
    output_options	
	set :tag_area = "Feed to CTRG"
	set :tag_domain = "OneTouch Operations"
	load :email_list = "select string_agg(user_email_list,',') as address from bl.bl_sbs_pub_run_notification where process_name ='DEFAULT'"
	if run_type == "Run_Prerequisites"
		set :v_process_name = "PREREQUISITE_WORKFLOW_STARTED"
		execute generic_email_wf
		execute autoseeder_bl_sbs_report_failures
		sql "select pub_work.fnc_reset_bl_sbs_report_failures()"
		datareceipt DOWNLOAD_CATALOG_PDF #Download PDF's
		load :catalog_name= "select catalog_list from pub_work.current_month_catalog_name_v"
		load :catalog_count= "select catalog_count from pub_work.current_month_catalog_name_v"
		load :new_catalog_count= "select count(1) from pub_work.new_catalog_entry_v"
		serial # Notification For Catalog PDF Download
			load :email_list = "select user_email_list from bl.bl_sbs_pub_run_notification where process_name in('NISSAN_CATALOG_IMAGE_SYNC_PROCESS_START')"
			set :email_subject = "Catalog PDFs Downloaded from Outfacing to EPO"
			load :email_message = "select 'Hello Team, '||chr(10)||chr(10)||'Following catalogs have been successfully downloaded in EPO: '||chr(10)||'Total No Of Catalog:- '||'&&catalog_count&&'||chr(10)||'Catalog Name:-'||'&&catalog_name&&'||chr(10)||chr(10)||'Thanks,'||chr(10)||'Nissan Publishing Team'""
			load :current_time_str = "select to_char(current_timestamp, 'DD-MON-YYYY HH:MI:SS PM')"
			send_email :email_list "&&email_subject&&: &&current_time_str&&" "&&email_message&&"
		
		if new_catalog_count > 0 
			serial # Notification For New Catalog
				load :new_cats = "select concat('MODEL: ',string_agg( model ,' , ')) from new_catalog_entry_v" 
				set :email_subject = "Alert: New Catalogs available"
				load :email_message = "select 'Alert: New Catalogs available'||chr(10)||'&&new_cats&&'"
				send_email :email_list "&&email_subject&&: &&current_time_str&&" "&&email_message&&"
				#wait_operator_response 300 "Alert: New Catalogs available. Please extract its data from PDF."
		
		serial # Run Prerequisite reports
			set :grp_name = "'prerequisite_reports'"
			execute rpt_generic_report_wf #Run Prerequisite reports

		serial # Check and stop if any report Failed
			#set :grp_name = "'dvt_report'"
			#execute rpt_generic_report_wf
			load :schema_name = "select ''"
			load :cycle_status = "select ''"
			execute stop_due_to_failure
			execute exit_due_to_failure
		
	if run_type == "Run_Feed_To_CTRG"
		load :prerequisite_workflow_execution_check = "select pub_work.fnc_prerequisite_workflow_check()"
		if prerequisite_workflow_execution_check == "GO AHEAD" 	
			message D "No concerns proceeding forward in publishing cycle execution. All Prerequisites process executed successfully."
		else
			load :error_message = "select trim(concat('&&prerequisite_workflow_execution_check&&'))"
			message E "&&error_message&&"
		serial # Feed Download to CTRG Load
			execute mwf_download_nissan_feeds_wf # Feed Download
			execute mwf_feed_to_bl_wf # Feed to BL
			execute mwf_bl_to_ctrg_wf # BL to CTRG		
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  nis_onetouch_publishing_wf.wfl
  **
  */
raise notice '******************* SUCCESS!! Workflow import has completed. ****************************';
	
end;
$workflowcontext$ LANGUAGE 'plpgsql';
