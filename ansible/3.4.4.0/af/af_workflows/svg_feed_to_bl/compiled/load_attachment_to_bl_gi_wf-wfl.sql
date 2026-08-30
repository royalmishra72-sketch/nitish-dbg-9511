do
$workflowcontext$
declare
    /* Export 1.8.1
    Exported on:   2026-06-19 06:46:35-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   load_attachment_to_bl_gi_wf.wfl
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
perform af_repo.fk_add_context('load_attachment_to_bl_gi_wf'::varchar,'W'::varchar, 90::smallint, '(1.8.1.0)This workflow is used for Load General Information Attachment data to BL.'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 20::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 21::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options	'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 22::integer, 'set'::varchar, ':tag_area|~|Feed to BL'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_area = "Feed to BL"'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 23::integer, 'set'::varchar, ':tag_domain|~|Attachment'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :tag_domain = "Attachment"'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 25::integer, 'load'::varchar, ':no_report_database_identifier|~|select pub_admin.get_parameter(''no_report_database_identifier'')'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    load :no_report_database_identifier = select pub_admin.get_parameter(''no_report_database_identifier'')'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 26::integer, 'load'::varchar, ':pubRootPath|~|select pub_admin.get_parameter(''PBAEnvRootPath'')'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '    load :pubRootPath = "select pub_admin.get_parameter(''PBAEnvRootPath'')"'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 27::integer, 'load'::varchar, ':epoRootPath|~|select pub_admin.get_parameter(''PBAEPORootPath'')'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '    load :epoRootPath = "select pub_admin.get_parameter(''PBAEPORootPath'')"'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 28::integer, 'load'::varchar, ':service_acc|~|select pub_admin.get_parameter(''serviceUserName'')'::varchar, 'main_80'::varchar, ''::varchar, ''::varchar, '    load :service_acc ="select pub_admin.get_parameter(''serviceUserName'')"'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 29::integer, 'load'::varchar, ':img_srvr|~|select pub_admin.get_parameter(''IMGServerName'')'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '    load :img_srvr = "select pub_admin.get_parameter(''IMGServerName'')"'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 30::integer, 'load'::varchar, ':img_srvr_root|~|select pub_admin.get_parameter(''IMGEnvRootPath'')'::varchar, 'main_100'::varchar, ''::varchar, ''::varchar, '    load :img_srvr_root = "select pub_admin.get_parameter(''IMGEnvRootPath'')"'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 31::integer, 'load'::varchar, ':pba_python_path|~|select pub_admin.get_parameter(''pba_python_path'')'::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '    load :pba_python_path = "select pub_admin.get_parameter(''pba_python_path'')"'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 32::integer, 'load'::varchar, ':imageTypeVar|~|select ''pdf_gi'''::varchar, 'main_120'::varchar, ''::varchar, ''::varchar, '    load :imageTypeVar = "select ''pdf_gi''"'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 33::integer, 'load'::varchar, ':imgFormat|~|select ''pdf'''::varchar, 'main_130'::varchar, ''::varchar, ''::varchar, '    load :imgFormat="select ''pdf''"'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 34::integer, 'load'::varchar, ':imageHeight|~|select ''3508'''::varchar, 'main_140'::varchar, ''::varchar, ''::varchar, '    load :imageHeight="select ''3508''"'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 35::integer, 'load'::varchar, ':imageWidth|~|select ''2496'''::varchar, 'main_150'::varchar, ''::varchar, ''::varchar, '    load :imageWidth="select ''2496''"'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 36::integer, 'load'::varchar, ':thumnbnailHeight|~|select ''215'''::varchar, 'main_160'::varchar, ''::varchar, ''::varchar, '    load :thumnbnailHeight="select ''215''"'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 37::integer, 'load'::varchar, ':thumnbnailWidth|~|select ''245'''::varchar, 'main_170'::varchar, ''::varchar, ''::varchar, '    load :thumnbnailWidth="select ''245''"'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_170'::varchar, 39::integer, 'run'::varchar, '&&pba_python_path&& &&pubRootPath&&/app/script/GICreation.py'::varchar, 'main_180'::varchar, ''::varchar, ''::varchar, '    run &&pba_python_path&& &&pubRootPath&&/app/script/GICreation.py'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_180'::varchar, 41::integer, 'run'::varchar, '&&pubRootPath&&/app/script/Images/call_ipp.sh &&pubRootPath&& &&epoRootPath&& &&service_acc&& &&img_srvr&& &&img_srvr_root&& &&imageTypeVar&& &&imgFormat&& &&imageHeight&& &&imageWidth&& &&thumnbnailHeight&& &&thumnbnailWidth&&'::varchar, 'main_190'::varchar, ''::varchar, ''::varchar, '    run &&pubRootPath&&/app/script/Images/call_ipp.sh &&pubRootPath&& &&epoRootPath&& &&service_acc&& &&img_srvr&& &&img_srvr_root&& &&imageTypeVar&& &&imgFormat&& &&imageHeight&& &&imageWidth&& &&thumnbnailHeight&& &&thumnbnailWidth&&'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_190'::varchar, 42::integer, 'sql'::varchar, 'truncate table pre_bl_image_data_w'::varchar, 'main_200'::varchar, ''::varchar, ''::varchar, '    sql "truncate table pre_bl_image_data_w"'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_200'::varchar, 43::integer, 'sql'::varchar, 'truncate table pre_bl_images_to_process_w'::varchar, 'main_210'::varchar, ''::varchar, ''::varchar, '    sql "truncate table pre_bl_images_to_process_w"'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_210'::varchar, 44::integer, 'datareceipt'::varchar, 'LOAD_IMAGE_DATA'::varchar, 'main_220'::varchar, ''::varchar, ''::varchar, '    datareceipt LOAD_IMAGE_DATA #Loading pre_bl_image_data_w'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_220'::varchar, 45::integer, 'publish'::varchar, 'pub_work.bl_image_data_v'::varchar, 'main_230'::varchar, ''::varchar, ''::varchar, '    publish pub_work.bl_image_data_v #Loading bl_image_data'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_230'::varchar, 46::integer, 'sql'::varchar, 'insert into pub_work.curr_run_image_data_w select * from pub_work.pre_bl_image_data_w'::varchar, 'main_240'::varchar, ''::varchar, ''::varchar, '    sql "insert into pub_work.curr_run_image_data_w select * from pub_work.pre_bl_image_data_w"'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_240'::varchar, 48::integer, 'sql'::varchar, 'analyze verbose pub_work.curr_run_image_data_w'::varchar, 'main_250'::varchar, ''::varchar, ''::varchar, '    sql "analyze verbose pub_work.curr_run_image_data_w"'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_250'::varchar, 50::integer, 'run'::varchar, '&&pubRootPath&&/app/script/Images/archive_images.sh &&pubRootPath&& &&epoRootPath&& &&imageTypeVar&&'::varchar, 'main_260'::varchar, ''::varchar, ''::varchar, '    run &&pubRootPath&&/app/script/Images/archive_images.sh &&pubRootPath&& &&epoRootPath&& &&imageTypeVar&&'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_260'::varchar, 51::integer, 'datareceipt'::varchar, 'LOAD_IMAGES_TO_PROCESS'::varchar, 'main_270'::varchar, ''::varchar, ''::varchar, '    datareceipt LOAD_IMAGES_TO_PROCESS #Loading pre_bl_images_to_process_w'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_270'::varchar, 52::integer, 'sql'::varchar, 'insert into pub_work.curr_run_source_image_w select img_name,img_type from pub_work.pre_bl_images_to_process_w'::varchar, 'main_280'::varchar, ''::varchar, ''::varchar, '    sql "insert into pub_work.curr_run_source_image_w select img_name,img_type from pub_work.pre_bl_images_to_process_w"'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_280'::varchar, 54::integer, 'sql'::varchar, 'analyze verbose pub_work.curr_run_source_image_w'::varchar, 'main_290'::varchar, ''::varchar, ''::varchar, '    sql "analyze verbose pub_work.curr_run_source_image_w"'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_290'::varchar, 58::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.af_compiler_insert('load_attachment_to_bl_gi_wf.wfl', $q$#workflow used to Load General Information Attachment data to BL.
load_attachment_to_bl_gi_wf(retention=90):  This workflow is used for Load General Information Attachment data to BL.
# Project:  NISSAN NA NG DATA PUBLISHING
#
# Name: load_attachment_to_bl_gi_wf.wfl
#
# Purpose:  This workflow is used to Load General Information Attachment data to BL.
#
#===========================================================
# Revision History
#   Ref #  Date           Revisor      Comment
#   1      31-JULY-2023   NKM          Initial Version 
#   2      29-AUG-2023    PR           Update generic reporting wfl. 
#===========================================================
# Revisor
# [Initials]		[Full Name]
#  NKM               NITISH KUMAR MISHRA
#  PR                PAWAN RAJAK
#===========================================================
	output_version
	output_options	
	set :tag_area = "Feed to BL"
	set :tag_domain = "Attachment"
	#This variable will select param_value from pba_param_t
	load :no_report_database_identifier = select pub_admin.get_parameter('no_report_database_identifier')
	load :pubRootPath = "select pub_admin.get_parameter('PBAEnvRootPath')"
	load :epoRootPath = "select pub_admin.get_parameter('PBAEPORootPath')"
	load :service_acc ="select pub_admin.get_parameter('serviceUserName')"
	load :img_srvr = "select pub_admin.get_parameter('IMGServerName')"
	load :img_srvr_root = "select pub_admin.get_parameter('IMGEnvRootPath')"
	load :pba_python_path = "select pub_admin.get_parameter('pba_python_path')"
	load :imageTypeVar = "select 'pdf_gi'"
	load :imgFormat="select 'pdf'"
	load :imageHeight="select '3508'"
	load :imageWidth="select '2496'"
	load :thumnbnailHeight="select '215'"
	load :thumnbnailWidth="select '245'"
	#GI Creation step from catalog pdf
	run &&pba_python_path&& &&pubRootPath&&/app/script/GICreation.py
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
	sql "insert into pub_work.curr_run_source_image_w select img_name,img_type from pub_work.pre_bl_images_to_process_w"
	# Analyzing Table
	sql "analyze verbose pub_work.curr_run_source_image_w"
	#report image_bl_report(p_report_name='rpt_nis_image_not_processed') 
	#set :grp_name = "'nis_image_not_processed'" 
	#execute rpt_generic_report_wf #This report is used to get list of images not processed
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  load_attachment_to_bl_gi_wf.wfl
  **
  */
raise notice '******************* SUCCESS!! Workflow import has completed. ****************************';
	
end;
$workflowcontext$ LANGUAGE 'plpgsql';
