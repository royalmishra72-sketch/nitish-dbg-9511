do
$workflowcontext$
declare
    /* Export 1.8.1
    Exported on:   2026-06-19 06:43:29-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   create_new_catalog_wf.wfl
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
perform af_repo.fk_add_context('create_new_catalog_wf'::varchar,'W'::varchar, 90::smallint, '(1.8.1.0)Workflow is used to perform Default insert into BL_SBS_CATALOG based on new catalog entry.'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 18::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 19::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 20::integer, 'load'::varchar, ':cat_count|~|select count(1) from pub_work.new_catalog_entry_v'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    load :cat_count = "select count(1) from pub_work.new_catalog_entry_v" '::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 21::integer, 'load'::varchar, ':email_list|~|select string_agg(user_email_list,'','') as address from bl.bl_sbs_pub_run_notification where process_name =''DEFAULT'''::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    load :email_list = "select string_agg(user_email_list,'','') as address from bl.bl_sbs_pub_run_notification where process_name =''DEFAULT''"'::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 22::integer, 'load'::varchar, ':new_cat_without_parts|~|select concat(''MODEL: '', model,''; MODEL: '',model_desc) from new_catalog_entry_v where status = ''N'''::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    load :new_cat_without_parts	= "select concat(''MODEL: '', model,''; MODEL: '',model_desc) from new_catalog_entry_v where status = ''N''" '::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 24::integer, 'if'::varchar, 'cat_count > 0'::varchar, 'main_60'::varchar, 'main_160'::varchar, ''::varchar, '    if cat_count > 0 # Check and insert new catalog entries '::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 25::integer, 'load'::varchar, ':new_cat|~|select concat(''MODEL: '', model,''; MODEL: '',model_desc,''; FROM: '',from_date,''; TO: '', to_date,''; STATUS: '', status) from new_catalog_entry_v'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '        load :new_cat 	= "select concat(''MODEL: '', model,''; MODEL: '',model_desc,''; FROM: '',from_date,''; TO: '', to_date,''; STATUS: '', status) from new_catalog_entry_v" '::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 26::integer, 'set'::varchar, ':sql_query|~|insert into bl.BL_SBS_CATALOG (make,model,model_desc,pub_num,from_date,to_date,format,status,row_create_user_id)select make,model,model_desc,pub_num,from_date,to_date,format, status,''OneTouch'' as row_create_user_id from new_catalog_entry_v'::varchar, 'main_80'::varchar, ''::varchar, ''::varchar, '        set :sql_query = "insert into bl.BL_SBS_CATALOG (make,model,model_desc,pub_num,from_date,to_date,format,status,row_create_user_id)select make,model,model_desc,pub_num,from_date,to_date,format, status,''OneTouch'' as row_create_user_id from new_catalog_entry_v" '::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 27::integer, 'load'::varchar, ':message|~|select ''There is following new catalog. Please review and approve its entry for BL_SBS_CATALOG.''||chr(10)|| ''&&new_cat&&'''::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '        load :message = "select ''There is following new catalog. Please review and approve its entry for BL_SBS_CATALOG.''||chr(10)|| ''&&new_cat&&''"'::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 28::integer, 'set'::varchar, ':email_subject|~|Alert: New Catalogs Arrived'::varchar, 'main_100'::varchar, ''::varchar, ''::varchar, '        set :email_subject = "Alert: New Catalogs Arrived"'::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 29::integer, 'set'::varchar, ':email_message|~|&&message&&'::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '        set :email_message = " &&message&& "'::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 30::integer, 'load'::varchar, ':current_time_str|~|select to_char(current_timestamp, ''DD-MON-YYYY HH:MI:SS PM'')'::varchar, 'main_120'::varchar, ''::varchar, ''::varchar, '        load :current_time_str = "select to_char(current_timestamp, ''DD-MON-YYYY HH:MI:SS PM'')"'::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 31::integer, 'send_email'::varchar, ':email_list|~|&&email_subject&&: &&current_time_str&&|~|&&email_message&&'::varchar, 'main_130'::varchar, ''::varchar, ''::varchar, '        send_email :email_list "&&email_subject&&: &&current_time_str&&" "&&email_message&&"'::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 32::integer, 'message'::varchar, '&&message&&'::varchar, 'main_140'::varchar, ''::varchar, ''::varchar, '        message " &&message&& "'::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 33::integer, 'sql'::varchar, '&&sql_query&&'::varchar, 'main_150'::varchar, ''::varchar, ''::varchar, '        sql "&&sql_query&&"'::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 34::integer, 'wait_operator_response'::varchar, '300|~|Please review New catalog entries. Make model name change now, if needed.'::varchar, 'main_160'::varchar, ''::varchar, ''::varchar, '        wait_operator_response 300 " Please review New catalog entries. Make model name change now, if needed. " '::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 37::integer, 'if'::varchar, 'new_cat_without_parts is not None'::varchar, 'main_170'::varchar, 'main_240'::varchar, ''::varchar, '    if new_cat_without_parts is not None'::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_170'::varchar, 38::integer, 'load'::varchar, ':message|~|select ''These Catalogs do not have parts data in bl_f31x1470_catalog_parts ''||chr(10)|| ''&&new_cat_without_parts&&'' ||chr(10)|| ''So, catalog will not be published and status will be marked N in BL_SBS_CATALOG.'''::varchar, 'main_180'::varchar, ''::varchar, ''::varchar, '        load :message = "select ''These Catalogs do not have parts data in bl_f31x1470_catalog_parts ''||chr(10)|| ''&&new_cat_without_parts&&'' ||chr(10)|| ''So, catalog will not be published and status will be marked N in BL_SBS_CATALOG.''"'::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_180'::varchar, 39::integer, 'set'::varchar, ':email_subject|~|Alert: New Catalogs Missing parts Data'::varchar, 'main_190'::varchar, ''::varchar, ''::varchar, '        set :email_subject = "Alert: New Catalogs Missing parts Data"'::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_190'::varchar, 40::integer, 'set'::varchar, ':email_message|~|&&message&&'::varchar, 'main_200'::varchar, ''::varchar, ''::varchar, '        set :email_message = " &&message&& "'::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_200'::varchar, 41::integer, 'load'::varchar, ':current_time_str|~|select to_char(current_timestamp, ''DD-MON-YYYY HH:MI:SS PM'')'::varchar, 'main_210'::varchar, ''::varchar, ''::varchar, '        load :current_time_str = "select to_char(current_timestamp, ''DD-MON-YYYY HH:MI:SS PM'')"'::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_210'::varchar, 42::integer, 'send_email'::varchar, ':email_list|~|&&email_subject&&: &&current_time_str&&|~|&&email_message&&'::varchar, 'main_220'::varchar, ''::varchar, ''::varchar, '        send_email :email_list "&&email_subject&&: &&current_time_str&&" "&&email_message&&"'::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_220'::varchar, 43::integer, 'message'::varchar, '&&message&&'::varchar, 'main_230'::varchar, ''::varchar, ''::varchar, '        message " &&message&& "'::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_230'::varchar, 44::integer, 'wait_operator_response'::varchar, '300|~|Please review New catalog entries without parts data. These catalogs will not be published.'::varchar, 'main_240'::varchar, ''::varchar, ''::varchar, '        wait_operator_response 300 " Please review New catalog entries without parts data. These catalogs will not be published. " '::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_240'::varchar, 47::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'create_new_catalog_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.af_compiler_insert('create_new_catalog_wf.wfl', $q$#Workflow is used to perform Default insert into BL_SBS_CATALOG based on new catalog entry.
create_new_catalog_wf(retention=90): Workflow is used to perform Default insert into BL_SBS_CATALOG based on new catalog entry.
# Project:  Nissan NG DATA PUBLISHING
#
# Name: create_new_catalog_wf.wfl
#
# Purpose: This workflow is used to perform the pub data edits in case required.
#
#===========================================================
# Revision History
#   Ref   Date          Revisor      Comment
#   1     16-JAN-2025   CB           Initial Version
#===========================================================
# Revisor
# [Initials]		[Full Name]
# CB               Chandan Bhatia
#===========================================================
	output_version
	output_options
	load :cat_count = "select count(1) from pub_work.new_catalog_entry_v" 
	load :email_list = "select string_agg(user_email_list,',') as address from bl.bl_sbs_pub_run_notification where process_name ='DEFAULT'"
	load :new_cat_without_parts	= "select concat('MODEL: ', model,'; MODEL: ',model_desc) from new_catalog_entry_v where status = 'N'" 

	if cat_count > 0 # Check and insert new catalog entries 
		load :new_cat 	= "select concat('MODEL: ', model,'; MODEL: ',model_desc,'; FROM: ',from_date,'; TO: ', to_date,'; STATUS: ', status) from new_catalog_entry_v" 
		set :sql_query = "insert into bl.BL_SBS_CATALOG (make,model,model_desc,pub_num,from_date,to_date,format,status,row_create_user_id)select make,model,model_desc,pub_num,from_date,to_date,format, status,'OneTouch' as row_create_user_id from new_catalog_entry_v" 
		load :message = "select 'There is following new catalog. Please review and approve its entry for BL_SBS_CATALOG.'||chr(10)|| '&&new_cat&&'"
		set :email_subject = "Alert: New Catalogs Arrived"
		set :email_message = " &&message&& "
		load :current_time_str = "select to_char(current_timestamp, 'DD-MON-YYYY HH:MI:SS PM')"
		send_email :email_list "&&email_subject&&: &&current_time_str&&" "&&email_message&&"
		message " &&message&& "
		sql "&&sql_query&&"
		wait_operator_response 300 " Please review New catalog entries. Make model name change now, if needed. " 


	if new_cat_without_parts is not None
		load :message = "select 'These Catalogs do not have parts data in bl_f31x1470_catalog_parts '||chr(10)|| '&&new_cat_without_parts&&' ||chr(10)|| 'So, catalog will not be published and status will be marked N in BL_SBS_CATALOG.'"
		set :email_subject = "Alert: New Catalogs Missing parts Data"
		set :email_message = " &&message&& "
		load :current_time_str = "select to_char(current_timestamp, 'DD-MON-YYYY HH:MI:SS PM')"
		send_email :email_list "&&email_subject&&: &&current_time_str&&" "&&email_message&&"
		message " &&message&& "
		wait_operator_response 300 " Please review New catalog entries without parts data. These catalogs will not be published. " 

	
	output_options
		
	$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  create_new_catalog_wf.wfl
  **
  */
raise notice '******************* SUCCESS!! Workflow import has completed. ****************************';
	
end;
$workflowcontext$ LANGUAGE 'plpgsql';
