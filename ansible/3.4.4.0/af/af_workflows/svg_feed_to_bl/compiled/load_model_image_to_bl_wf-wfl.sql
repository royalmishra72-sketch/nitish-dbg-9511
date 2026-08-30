do
$workflowcontext$
declare
    /* Export 1.8.1
    Exported on:   2026-06-19 06:47:26-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   load_model_image_to_bl_wf.wfl
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
perform af_repo.fk_add_context('load_model_image_to_bl_wf'::varchar,'W'::varchar, 90::smallint, '(1.8.1.0)This workflow is used for load Model Images to BL.'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 18::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 19::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options	'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 20::integer, 'set'::varchar, ':tag_area|~|Feed to BL'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_area = "Feed to BL"'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 21::integer, 'set'::varchar, ':tag_domain|~|IMAGE'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :tag_domain = "IMAGE"'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 23::integer, 'load'::varchar, ':no_report_database_identifier|~|select pub_admin.get_parameter(''no_report_database_identifier'')'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    load :no_report_database_identifier = select pub_admin.get_parameter(''no_report_database_identifier'')'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 24::integer, 'load'::varchar, ':pubRootPath|~|select pub_admin.get_parameter(''PBAEnvRootPath'')'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '    load :pubRootPath = "select pub_admin.get_parameter(''PBAEnvRootPath'')"'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 25::integer, 'load'::varchar, ':epoRootPath|~|select pub_admin.get_parameter(''PBAEPORootPath'')'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '    load :epoRootPath = "select pub_admin.get_parameter(''PBAEPORootPath'')"'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 26::integer, 'load'::varchar, ':service_acc|~|select pub_admin.get_parameter(''serviceUserName'')'::varchar, 'main_80'::varchar, ''::varchar, ''::varchar, '    load :service_acc ="select pub_admin.get_parameter(''serviceUserName'')"'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 27::integer, 'load'::varchar, ':img_srvr|~|select pub_admin.get_parameter(''IMGServerName'')'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '    load :img_srvr = "select pub_admin.get_parameter(''IMGServerName'')"'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 28::integer, 'load'::varchar, ':img_srvr_root|~|select pub_admin.get_parameter(''IMGEnvRootPath'')'::varchar, 'main_100'::varchar, ''::varchar, ''::varchar, '    load :img_srvr_root = "select pub_admin.get_parameter(''IMGEnvRootPath'')"'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 29::integer, 'load'::varchar, ':imageTypeVar|~|select ''model'''::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '    load :imageTypeVar = "select ''model''"'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 30::integer, 'load'::varchar, ':imgFormat|~|select ''png'''::varchar, 'main_120'::varchar, ''::varchar, ''::varchar, '    load :imgFormat="select ''png''"'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 31::integer, 'load'::varchar, ':imageHeight|~|select ''3508'''::varchar, 'main_130'::varchar, ''::varchar, ''::varchar, '    load :imageHeight="select ''3508''"'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 32::integer, 'load'::varchar, ':imageWidth|~|select ''2496'''::varchar, 'main_140'::varchar, ''::varchar, ''::varchar, '    load :imageWidth="select ''2496''"'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 33::integer, 'load'::varchar, ':thumnbnailHeight|~|select ''120'''::varchar, 'main_150'::varchar, ''::varchar, ''::varchar, '    load :thumnbnailHeight="select ''120''"'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 34::integer, 'load'::varchar, ':thumnbnailWidth|~|select ''150'''::varchar, 'main_160'::varchar, ''::varchar, ''::varchar, '    load :thumnbnailWidth="select ''150''"'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 36::integer, 'run'::varchar, '&&pubRootPath&&/app/script/Images/call_ipp.sh &&pubRootPath&& &&epoRootPath&& &&service_acc&& &&img_srvr&& &&img_srvr_root&& &&imageTypeVar&& &&imgFormat&& &&imageHeight&& &&imageWidth&& &&thumnbnailHeight&& &&thumnbnailWidth&&'::varchar, 'main_170'::varchar, ''::varchar, ''::varchar, '    run &&pubRootPath&&/app/script/Images/call_ipp.sh &&pubRootPath&& &&epoRootPath&& &&service_acc&& &&img_srvr&& &&img_srvr_root&& &&imageTypeVar&& &&imgFormat&& &&imageHeight&& &&imageWidth&& &&thumnbnailHeight&& &&thumnbnailWidth&&'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_170'::varchar, 37::integer, 'sql'::varchar, 'truncate table pre_bl_image_data_w'::varchar, 'main_180'::varchar, ''::varchar, ''::varchar, '    sql "truncate table pre_bl_image_data_w"'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_180'::varchar, 38::integer, 'sql'::varchar, 'truncate table pre_bl_images_to_process_w'::varchar, 'main_190'::varchar, ''::varchar, ''::varchar, '    sql "truncate table pre_bl_images_to_process_w"'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_190'::varchar, 39::integer, 'datareceipt'::varchar, 'LOAD_IMAGE_DATA'::varchar, 'main_200'::varchar, ''::varchar, ''::varchar, '    datareceipt LOAD_IMAGE_DATA #Loading pre_bl_image_data_w'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_200'::varchar, 40::integer, 'publish'::varchar, 'pub_work.bl_image_data_v'::varchar, 'main_210'::varchar, ''::varchar, ''::varchar, '    publish pub_work.bl_image_data_v #Loading bl_image_data'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_210'::varchar, 41::integer, 'sql'::varchar, 'insert into pub_work.curr_run_image_data_w select * from pub_work.pre_bl_image_data_w'::varchar, 'main_220'::varchar, ''::varchar, ''::varchar, '    sql "insert into pub_work.curr_run_image_data_w select * from pub_work.pre_bl_image_data_w"'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_220'::varchar, 43::integer, 'sql'::varchar, 'analyze verbose pub_work.curr_run_image_data_w'::varchar, 'main_230'::varchar, ''::varchar, ''::varchar, '    sql "analyze verbose pub_work.curr_run_image_data_w"'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_230'::varchar, 45::integer, 'run'::varchar, '&&pubRootPath&&/app/script/Images/archive_images.sh &&pubRootPath&& &&epoRootPath&& &&imageTypeVar&&'::varchar, 'main_240'::varchar, ''::varchar, ''::varchar, '    run &&pubRootPath&&/app/script/Images/archive_images.sh &&pubRootPath&& &&epoRootPath&& &&imageTypeVar&&'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_240'::varchar, 46::integer, 'datareceipt'::varchar, 'LOAD_IMAGES_TO_PROCESS'::varchar, 'main_250'::varchar, ''::varchar, ''::varchar, '    datareceipt LOAD_IMAGES_TO_PROCESS #Loading pre_bl_images_to_process_w'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_250'::varchar, 48::integer, 'sql'::varchar, 'insert into pub_work.curr_run_source_image_w select img_name,img_type from pub_work.pre_bl_images_to_process_w'::varchar, 'main_260'::varchar, ''::varchar, ''::varchar, '    sql "insert into pub_work.curr_run_source_image_w select img_name,img_type from pub_work.pre_bl_images_to_process_w"'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_260'::varchar, 50::integer, 'sql'::varchar, 'analyze verbose pub_work.curr_run_source_image_w'::varchar, 'main_270'::varchar, ''::varchar, ''::varchar, '    sql "analyze verbose pub_work.curr_run_source_image_w"'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_270'::varchar, 55::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'load_model_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.af_compiler_insert('load_model_image_to_bl_wf.wfl', $q$#workflow used to load Model Images to BL
load_model_image_to_bl_wf(retention=90):  This workflow is used for load Model Images to BL.
# Project:  NISSAN NA NG DATA PUBLISHING
#
# Name: load_model_image_to_bl_wf.wfl
#
# Purpose:  This workflow is used to load Model Images to BL.
#
#===========================================================
# Revision History
#   Ref #  Date           Revisor      Comment
#   1      27-JULY-2023   NKM          Initial Version 
#===========================================================
# Revisor
# [Initials]		[Full Name]
#  NKM               NITISH KUMAR MISHRA
#===========================================================
	output_version
	output_options	
	set :tag_area = "Feed to BL"
	set :tag_domain = "IMAGE"
	#This variable will select param_value from pba_param_t
	load :no_report_database_identifier = select pub_admin.get_parameter('no_report_database_identifier')
	load :pubRootPath = "select pub_admin.get_parameter('PBAEnvRootPath')"
	load :epoRootPath = "select pub_admin.get_parameter('PBAEPORootPath')"
	load :service_acc ="select pub_admin.get_parameter('serviceUserName')"
	load :img_srvr = "select pub_admin.get_parameter('IMGServerName')"
	load :img_srvr_root = "select pub_admin.get_parameter('IMGEnvRootPath')"
	load :imageTypeVar = "select 'model'"
	load :imgFormat="select 'png'"
	load :imageHeight="select '3508'"
	load :imageWidth="select '2496'"
	load :thumnbnailHeight="select '120'"
	load :thumnbnailWidth="select '150'"
	#Execution of call_ipp.sh script
	run &&pubRootPath&&/app/script/Images/call_ipp.sh &&pubRootPath&& &&epoRootPath&& &&service_acc&& &&img_srvr&& &&img_srvr_root&& &&imageTypeVar&& &&imgFormat&& &&imageHeight&& &&imageWidth&& &&thumnbnailHeight&& &&thumnbnailWidth&&
    sql "truncate table pre_bl_image_data_w"
	sql "truncate table pre_bl_images_to_process_w"
	datareceipt LOAD_IMAGE_DATA #Loading pre_bl_image_data_w
	publish pub_work.bl_image_data_v #Loading bl_image_data
	sql "insert into pub_work.curr_run_image_data_w select * from pub_work.pre_bl_image_data_w"
	# Analyzing Table
	sql "analyze verbose pub_work.curr_run_image_data_w"
	#Archive of Source images
	run &&pubRootPath&&/app/script/Images/archive_images.sh &&pubRootPath&& &&epoRootPath&& &&imageTypeVar&&
	datareceipt LOAD_IMAGES_TO_PROCESS #Loading pre_bl_images_to_process_w
	# Insert Curr run source Images data 
	sql "insert into pub_work.curr_run_source_image_w select img_name,img_type from pub_work.pre_bl_images_to_process_w"
	# Analyzing Table
	sql "analyze verbose pub_work.curr_run_source_image_w"
	#set :grp_name = "'nis_image_not_processed'" 
	#execute rpt_generic_report_wf #This report is used to get list of images not processed
	#set :grp_name = "'nis_bl_large_images'" 
	#execute rpt_generic_report_wf #This report is used to get list of NISSAN large Images at bl level
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  load_model_image_to_bl_wf.wfl
  **
  */
raise notice '******************* SUCCESS!! Workflow import has completed. ****************************';
	
end;
$workflowcontext$ LANGUAGE 'plpgsql';
