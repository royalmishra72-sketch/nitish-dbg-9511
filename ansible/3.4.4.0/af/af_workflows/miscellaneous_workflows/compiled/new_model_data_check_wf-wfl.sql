do
$workflowcontext$
declare
    /* Export 1.8.1
    Exported on:   2026-06-19 06:44:08-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   new_model_data_check_wf.wfl
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
perform af_repo.fk_add_context('new_model_data_check_wf'::varchar,'W'::varchar, 90::smallint, '(1.8.1.0)This workflow will data check for new model'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 18::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'new_model_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 19::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'new_model_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 20::integer, 'load'::varchar, ':model_without_img|~|select string_agg(model,'','' order by null) from bl.BL_SBS_CATALOG where status = ''Y'' and   model not in (select img_name from   bl.bl_image_data where attribute1 = ''NISSAN-MODEL'')'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    load :model_without_img = "select string_agg(model,'','' order by null) from bl.BL_SBS_CATALOG where status = ''Y'' and   model not in (select img_name from   bl.bl_image_data where attribute1 = ''NISSAN-MODEL'')" '::varchar, 'new_model_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 22::integer, 'if'::varchar, 'model_without_img is not None'::varchar, 'main_40'::varchar, 'main_110'::varchar, ''::varchar, '    if model_without_img is not None'::varchar, 'new_model_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 23::integer, 'serial'::varchar, 'main_50'::varchar, 'main_100'::varchar, ''::varchar, ''::varchar, '        serial # Send Email Notification '::varchar, 'new_model_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 24::integer, 'load'::varchar, ':email_list|~|select user_email_list from bl.bl_sbs_pub_run_notification where process_name in(''DEFAULT'')'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '            load :email_list = "select user_email_list from bl.bl_sbs_pub_run_notification where process_name in(''DEFAULT'')"'::varchar, 'new_model_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 25::integer, 'set'::varchar, ':email_subject|~|Alert: Nissan - Model Image Missing'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '            set :email_subject = "Alert: Nissan - Model Image Missing"'::varchar, 'new_model_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 26::integer, 'load'::varchar, ':email_message|~|select ''Hello Team,||chr(10)||chr(10)|| ''Image is missing in BL_SBS_CATALOG for following Models: ''||chr(10)||chr(10)|| ''Model Name:- ''||''&&model_without_img&&''||chr(10)||chr(10)||''Thanks,''||chr(10)||''Nissan Publishing Team'''::varchar, 'main_80'::varchar, ''::varchar, ''::varchar, '            load :email_message = "select ''Hello Team,||chr(10)||chr(10)|| ''Image is missing in BL_SBS_CATALOG for following Models: ''||chr(10)||chr(10)|| ''Model Name:- ''||''&&model_without_img&&''||chr(10)||chr(10)||''Thanks,''||chr(10)||''Nissan Publishing Team''"'::varchar, 'new_model_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 27::integer, 'load'::varchar, ':current_time_str|~|select to_char(current_timestamp, ''DD-MON-YYYY HH:MI:SS PM'')'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '            load :current_time_str = "select to_char(current_timestamp, ''DD-MON-YYYY HH:MI:SS PM'')"'::varchar, 'new_model_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 28::integer, 'send_email'::varchar, ':email_list|~|&&email_subject&&: &&current_time_str&&|~|&&email_message&&'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            send_email :email_list "&&email_subject&&: &&current_time_str&&" "&&email_message&&"'::varchar, 'new_model_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 29::integer, 'exit'::varchar, 'E|~|Model Image missing in BL_IMAGE_DATA for following Models: \n &&model_without_img&&'::varchar, 'Done'::varchar, 'main_110'::varchar, ''::varchar, '        exit E "Model Image missing in BL_IMAGE_DATA for following Models: \n &&model_without_img&& " '::varchar, 'new_model_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 31::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'new_model_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'new_model_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.af_compiler_insert('new_model_data_check_wf.wfl', $q$#This workflow will data check for new model
new_model_data_check_wf(retention=90): This workflow will data check for new model
# Project:  Nissan NG DATA PUBLISHING
#
# Name: new_model_data_check_wf.wfl
#
# Purpose: This workflow will data check for new model
#
#===========================================================
# Revision History
#   Ref   Date          Revisor      Comment
#   1     17-Feb-2025   CB           Initial Version
#===========================================================
# Revisor
# [Initials]		[Full Name]
# CB               Chandan Bhatia
#===========================================================
	output_version
	output_options
	load :model_without_img = "select string_agg(model,',' order by null) from bl.BL_SBS_CATALOG where status = 'Y' and   model not in (select img_name from   bl.bl_image_data where attribute1 = 'NISSAN-MODEL')" 
	
	if model_without_img is not None
		serial # Send Email Notification 
			load :email_list = "select user_email_list from bl.bl_sbs_pub_run_notification where process_name in('DEFAULT')"
			set :email_subject = "Alert: Nissan - Model Image Missing"
			load :email_message = "select 'Hello Team,||chr(10)||chr(10)|| 'Image is missing in BL_SBS_CATALOG for following Models: '||chr(10)||chr(10)|| 'Model Name:- '||'&&model_without_img&&'||chr(10)||chr(10)||'Thanks,'||chr(10)||'Nissan Publishing Team'"
			load :current_time_str = "select to_char(current_timestamp, 'DD-MON-YYYY HH:MI:SS PM')"
			send_email :email_list "&&email_subject&&: &&current_time_str&&" "&&email_message&&"
		exit E "Model Image missing in BL_IMAGE_DATA for following Models: \n &&model_without_img&& " 
		
	output_options
		
	$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  new_model_data_check_wf.wfl
  **
  */
raise notice '******************* SUCCESS!! Workflow import has completed. ****************************';
	
end;
$workflowcontext$ LANGUAGE 'plpgsql';
