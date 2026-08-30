do
$workflowcontext$
declare
    /* Export 1.8.1
    Exported on:   2026-06-29 07:03:34-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   mwf_download_nissan_feeds_wf.wfl
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
perform af_repo.fk_add_context('mwf_download_nissan_feeds_wf'::varchar,'W'::varchar, 180::smallint, '(1.8.1.0)This workflow is used to download Nissan feeds .'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 21::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 22::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options	'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 23::integer, 'set'::varchar, ':tag_area|~|Downloads'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_area = "Downloads"'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 24::integer, 'set'::varchar, ':tag_domain|~|NISSAN FEEDS'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :tag_domain = "NISSAN FEEDS"'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 26::integer, 'serial'::varchar, 'main_50'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '    serial #Feed Download intiated Email'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 27::integer, 'set'::varchar, ':v_process_name|~|NISSAN_FEEDS_DOWNLOAD_START'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '        set :v_process_name = "NISSAN_FEEDS_DOWNLOAD_START"'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 28::integer, 'execute'::varchar, 'generic_email_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute generic_email_wf'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 29::integer, 'datareceipt'::varchar, 'DOWNLOAD_NNA_PRICE'::varchar, 'main_80'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NNA_PRICE 		#Price'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 30::integer, 'datareceipt'::varchar, 'DOWNLOAD_NNA_SERVFILE'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NNA_SERVFILE 	#Servfile'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 31::integer, 'datareceipt'::varchar, 'DOWNLOAD_NNA_SUPERSN'::varchar, 'main_100'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NNA_SUPERSN  	#Supersession'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 32::integer, 'datareceipt'::varchar, 'DOWNLOAD_NNA_PARTS'::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NNA_PARTS    	#NNA Parts'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 33::integer, 'datareceipt'::varchar, 'DOWNLOAD_NML_CD1_FEED'::varchar, 'main_120'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NML_CD1_FEED 	#CD1'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 34::integer, 'datareceipt'::varchar, 'DOWNLOAD_NML_CD2_FEED'::varchar, 'main_130'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NML_CD2_FEED   #CD2'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 35::integer, 'datareceipt'::varchar, 'DOWNLOAD_NML_CD3_FEED'::varchar, 'main_140'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NML_CD3_FEED   #CD3'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 36::integer, 'datareceipt'::varchar, 'DOWNLOAD_NML_CD4_FEED'::varchar, 'main_150'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NML_CD4_FEED	#CD4'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 37::integer, 'datareceipt'::varchar, 'DOWNLOAD_NML_CD5_FEED'::varchar, 'main_160'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NML_CD5_FEED	#CD5'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 38::integer, 'datareceipt'::varchar, 'DOWNLOAD_NML_CD6_FEED'::varchar, 'main_170'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NML_CD6_FEED	#CD6'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_170'::varchar, 39::integer, 'datareceipt'::varchar, 'DOWNLOAD_NML_CD7_FEED'::varchar, 'main_180'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NML_CD7_FEED	#CD7'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_180'::varchar, 40::integer, 'datareceipt'::varchar, 'DOWNLOAD_SYNONYMS_FEED'::varchar, 'main_190'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_SYNONYMS_FEED  #Synonyms'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_190'::varchar, 41::integer, 'datareceipt'::varchar, 'DOWNLOAD_VA_PARTS_FEED'::varchar, 'main_200'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_VA_PARTS_FEED	# VA Parts'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_200'::varchar, 42::integer, 'datareceipt'::varchar, 'DOWNLOAD_NNA_ILLUST_MASTER_EXCEL'::varchar, 'main_210'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NNA_ILLUST_MASTER_EXCEL #NNA Illust'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_210'::varchar, 43::integer, 'datareceipt'::varchar, 'DOWNLOAD_ILLUSTRATION_CHANGE_EXCEL'::varchar, 'main_220'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_ILLUSTRATION_CHANGE_EXCEL #ICM Illust'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_220'::varchar, 44::integer, 'datareceipt'::varchar, 'DOWNLOAD_NIS_ILLUSTRATION_IMAGE_VC'::varchar, 'main_230'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NIS_ILLUSTRATION_IMAGE_VC #TIF Image'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_230'::varchar, 45::integer, 'datareceipt'::varchar, 'DOWNLOAD_NIS_SVG_IMAGE_ZIP'::varchar, 'main_240'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NIS_SVG_IMAGE_ZIP  #SVG Image'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_240'::varchar, 46::integer, 'datareceipt'::varchar, 'DOWNLOAD_ATTACHMENT_GI'::varchar, 'main_250'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_ATTACHMENT_GI      #GI '::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_250'::varchar, 47::integer, 'datareceipt'::varchar, 'DOWNLOAD_MODEL_IMAGE'::varchar, 'main_260'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_MODEL_IMAGE   #Model Image'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_260'::varchar, 48::integer, 'datareceipt'::varchar, 'DOWNLOAD_CHAPTER_IMAGE'::varchar, 'main_270'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_CHAPTER_IMAGE #Group Image'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_270'::varchar, 49::integer, 'datareceipt'::varchar, 'DOWNLOAD_ATTACHMENT_PRICEBOOK'::varchar, 'main_280'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_ATTACHMENT_PRICEBOOK #Pricebook '::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_280'::varchar, 50::integer, 'datareceipt'::varchar, 'DOWNLOAD_GROUPSECTION_FEED'::varchar, 'main_290'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_GROUPSECTION_FEED  #Section'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_290'::varchar, 51::integer, 'datareceipt'::varchar, 'DOWNLOAD_SBS_ILLUST_EXCEL'::varchar, 'main_300'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_SBS_ILLUST_EXCEL   #Illust Feed'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_300'::varchar, 52::integer, 'serial'::varchar, 'main_310'::varchar, 'main_330'::varchar, ''::varchar, ''::varchar, '    serial # Feed Download Reports Execution'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_310'::varchar, 53::integer, 'set'::varchar, ':grp_name|~|''downloaded_feeds_report'''::varchar, 'main_320'::varchar, ''::varchar, ''::varchar, '        set :grp_name = "''downloaded_feeds_report''"'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_320'::varchar, 54::integer, 'execute'::varchar, 'rpt_generic_report_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute rpt_generic_report_wf'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_330'::varchar, 55::integer, 'serial'::varchar, 'main_340'::varchar, 'main_380'::varchar, ''::varchar, ''::varchar, '    serial # RDVT Reports Checks'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_340'::varchar, 56::integer, 'load'::varchar, ':schema_name|~|select '''''::varchar, 'main_350'::varchar, ''::varchar, ''::varchar, '        load :schema_name = "select ''''"'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_350'::varchar, 57::integer, 'load'::varchar, ':cycle_status|~|select '''''::varchar, 'main_360'::varchar, ''::varchar, ''::varchar, '        load :cycle_status = "select ''''"'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_360'::varchar, 58::integer, 'execute'::varchar, 'stop_due_to_failure'::varchar, 'main_370'::varchar, ''::varchar, ''::varchar, '        execute stop_due_to_failure'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_370'::varchar, 59::integer, 'execute'::varchar, 'exit_due_to_failure'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute exit_due_to_failure'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_380'::varchar, 60::integer, 'serial'::varchar, 'main_390'::varchar, 'main_410'::varchar, ''::varchar, ''::varchar, '    serial #Feed Download Completed Email'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_390'::varchar, 61::integer, 'set'::varchar, ':v_process_name|~|NISSAN_FEEDS_DOWNLOAD_END'::varchar, 'main_400'::varchar, ''::varchar, ''::varchar, '        set :v_process_name = "NISSAN_FEEDS_DOWNLOAD_END"'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_400'::varchar, 62::integer, 'execute'::varchar, 'generic_email_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute generic_email_wf'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_410'::varchar, 63::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.af_compiler_insert('mwf_download_nissan_feeds_wf.wfl', $q$#workflow is used to download feeds.
mwf_download_nissan_feeds_wf:  This workflow is used to download Nissan feeds .
# Project:  NISSAN DATA PUBLISHING
#
# Name: mwf_download_nissan_feeds_wf.wfl
#
# Purpose:  This workflow is used to download Nissan feeds.
#
#===========================================================
# Revision History
#   Ref #  Date          Revisor      Comment
#   1     05-DEC-2023     NKM          Initial Version 
#   2     05-Dec-2025     NKM          Rename Workflow Name and add Image download Process
#   3     12-Jan-2026     NKM          Add SVG Image Download Process
#   4     10-June-2026    NKM          RDVT 1.1.0 and 1.2.0 Enhancement
#===========================================================
# Revisor
# [Initials]		[Full Name]
# NKM               Nitish K Mishra
#===========================================================
	output_version
	output_options	
	set :tag_area = "Downloads"
	set :tag_domain = "NISSAN FEEDS"
	#set :dr_loadonly = "True"
	serial #Feed Download intiated Email
		set :v_process_name = "NISSAN_FEEDS_DOWNLOAD_START"
		execute generic_email_wf
	datareceipt DOWNLOAD_NNA_PRICE 		#Price
	datareceipt DOWNLOAD_NNA_SERVFILE 	#Servfile
	datareceipt DOWNLOAD_NNA_SUPERSN  	#Supersession
	datareceipt DOWNLOAD_NNA_PARTS    	#NNA Parts
	datareceipt DOWNLOAD_NML_CD1_FEED 	#CD1
	datareceipt DOWNLOAD_NML_CD2_FEED   #CD2
	datareceipt DOWNLOAD_NML_CD3_FEED   #CD3
	datareceipt DOWNLOAD_NML_CD4_FEED	#CD4
	datareceipt DOWNLOAD_NML_CD5_FEED	#CD5
	datareceipt DOWNLOAD_NML_CD6_FEED	#CD6
	datareceipt DOWNLOAD_NML_CD7_FEED	#CD7
	datareceipt DOWNLOAD_SYNONYMS_FEED  #Synonyms
	datareceipt DOWNLOAD_VA_PARTS_FEED	# VA Parts
	datareceipt DOWNLOAD_NNA_ILLUST_MASTER_EXCEL #NNA Illust
	datareceipt DOWNLOAD_ILLUSTRATION_CHANGE_EXCEL #ICM Illust
	datareceipt DOWNLOAD_NIS_ILLUSTRATION_IMAGE_VC #TIF Image
	datareceipt DOWNLOAD_NIS_SVG_IMAGE_ZIP  #SVG Image
	datareceipt DOWNLOAD_ATTACHMENT_GI      #GI 
	datareceipt DOWNLOAD_MODEL_IMAGE   #Model Image
	datareceipt DOWNLOAD_CHAPTER_IMAGE #Group Image
	datareceipt DOWNLOAD_ATTACHMENT_PRICEBOOK #Pricebook 
	datareceipt DOWNLOAD_GROUPSECTION_FEED  #Section
	datareceipt DOWNLOAD_SBS_ILLUST_EXCEL   #Illust Feed
	serial # Feed Download Reports Execution
		set :grp_name = "'downloaded_feeds_report'"
		execute rpt_generic_report_wf
	serial # RDVT Reports Checks
		load :schema_name = "select ''"
		load :cycle_status = "select ''"
		execute stop_due_to_failure
		execute exit_due_to_failure
	serial #Feed Download Completed Email
		set :v_process_name = "NISSAN_FEEDS_DOWNLOAD_END"
		execute generic_email_wf
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  mwf_download_nissan_feeds_wf.wfl
  **
  */
raise notice '******************* SUCCESS!! Workflow import has completed. ****************************';
	
end;
$workflowcontext$ LANGUAGE 'plpgsql';
