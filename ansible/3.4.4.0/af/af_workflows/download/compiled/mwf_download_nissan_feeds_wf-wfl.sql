do
$workflowcontext$
declare
    /* Export 1.8.1
    Exported on:   2026-06-19 06:39:38-04
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
perform af_repo.fk_add_step('main_40'::varchar, 26::integer, 'set'::varchar, ':v_process_name|~|NISSAN_FEEDS_DOWNLOAD_START'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    set :v_process_name = "NISSAN_FEEDS_DOWNLOAD_START"'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 27::integer, 'execute'::varchar, 'generic_email_wf'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '    execute generic_email_wf'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 28::integer, 'datareceipt'::varchar, 'DOWNLOAD_NNA_PRICE'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NNA_PRICE'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 29::integer, 'datareceipt'::varchar, 'DOWNLOAD_NNA_SERVFILE'::varchar, 'main_80'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NNA_SERVFILE'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 30::integer, 'datareceipt'::varchar, 'DOWNLOAD_NNA_SUPERSN'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NNA_SUPERSN'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 31::integer, 'datareceipt'::varchar, 'DOWNLOAD_NNA_PARTS'::varchar, 'main_100'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NNA_PARTS'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 32::integer, 'datareceipt'::varchar, 'DOWNLOAD_NML_CD1_FEED'::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NML_CD1_FEED'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 33::integer, 'datareceipt'::varchar, 'DOWNLOAD_NML_CD2_FEED'::varchar, 'main_120'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NML_CD2_FEED'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 34::integer, 'datareceipt'::varchar, 'DOWNLOAD_NML_CD3_FEED'::varchar, 'main_130'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NML_CD3_FEED'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 35::integer, 'datareceipt'::varchar, 'DOWNLOAD_NML_CD4_FEED'::varchar, 'main_140'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NML_CD4_FEED'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 36::integer, 'datareceipt'::varchar, 'DOWNLOAD_NML_CD5_FEED'::varchar, 'main_150'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NML_CD5_FEED'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 37::integer, 'datareceipt'::varchar, 'DOWNLOAD_NML_CD6_FEED'::varchar, 'main_160'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NML_CD6_FEED'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 38::integer, 'datareceipt'::varchar, 'DOWNLOAD_NML_CD7_FEED'::varchar, 'main_170'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NML_CD7_FEED'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_170'::varchar, 39::integer, 'datareceipt'::varchar, 'DOWNLOAD_SYNONYMS_FEED'::varchar, 'main_180'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_SYNONYMS_FEED'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_180'::varchar, 40::integer, 'datareceipt'::varchar, 'DOWNLOAD_VA_PARTS_FEED'::varchar, 'main_190'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_VA_PARTS_FEED	'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_190'::varchar, 41::integer, 'datareceipt'::varchar, 'DOWNLOAD_NNA_ILLUST_MASTER_EXCEL'::varchar, 'main_200'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NNA_ILLUST_MASTER_EXCEL'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_200'::varchar, 42::integer, 'datareceipt'::varchar, 'DOWNLOAD_ILLUSTRATION_CHANGE_EXCEL'::varchar, 'main_210'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_ILLUSTRATION_CHANGE_EXCEL'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_210'::varchar, 43::integer, 'datareceipt'::varchar, 'DOWNLOAD_NIS_ILLUSTRATION_IMAGE_VC'::varchar, 'main_220'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NIS_ILLUSTRATION_IMAGE_VC'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_220'::varchar, 44::integer, 'datareceipt'::varchar, 'DOWNLOAD_NIS_SVG_IMAGE_ZIP'::varchar, 'main_230'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_NIS_SVG_IMAGE_ZIP'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_230'::varchar, 45::integer, 'datareceipt'::varchar, 'DOWNLOAD_ATTACHMENT_GI'::varchar, 'main_240'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_ATTACHMENT_GI'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_240'::varchar, 46::integer, 'datareceipt'::varchar, 'DOWNLOAD_MODEL_IMAGE'::varchar, 'main_250'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_MODEL_IMAGE'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_250'::varchar, 47::integer, 'datareceipt'::varchar, 'DOWNLOAD_CHAPTER_IMAGE'::varchar, 'main_260'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_CHAPTER_IMAGE'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_260'::varchar, 48::integer, 'datareceipt'::varchar, 'DOWNLOAD_ATTACHMENT_PRICEBOOK'::varchar, 'main_270'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_ATTACHMENT_PRICEBOOK'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_270'::varchar, 49::integer, 'datareceipt'::varchar, 'DOWNLOAD_GROUPSECTION_FEED'::varchar, 'main_280'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_GROUPSECTION_FEED'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_280'::varchar, 50::integer, 'datareceipt'::varchar, 'DOWNLOAD_SBS_ILLUST_EXCEL'::varchar, 'main_290'::varchar, ''::varchar, ''::varchar, '    datareceipt DOWNLOAD_SBS_ILLUST_EXCEL'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_290'::varchar, 51::integer, 'set'::varchar, ':grp_name|~|''downloaded_feeds_report'''::varchar, 'main_300'::varchar, ''::varchar, ''::varchar, '    set :grp_name = "''downloaded_feeds_report''"'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_300'::varchar, 52::integer, 'execute'::varchar, 'rpt_generic_report_wf'::varchar, 'main_310'::varchar, ''::varchar, ''::varchar, '    execute rpt_generic_report_wf'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_310'::varchar, 56::integer, 'load'::varchar, ':schema_name|~|select '''''::varchar, 'main_320'::varchar, ''::varchar, ''::varchar, '    load :schema_name = "select ''''"'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_320'::varchar, 57::integer, 'load'::varchar, ':cycle_status|~|select '''''::varchar, 'main_330'::varchar, ''::varchar, ''::varchar, '    load :cycle_status = "select ''''"'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_330'::varchar, 58::integer, 'execute'::varchar, 'stop_due_to_failure'::varchar, 'main_340'::varchar, ''::varchar, ''::varchar, '    execute stop_due_to_failure'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_340'::varchar, 59::integer, 'execute'::varchar, 'exit_due_to_failure'::varchar, 'main_350'::varchar, ''::varchar, ''::varchar, '    execute exit_due_to_failure'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_350'::varchar, 60::integer, 'set'::varchar, ':v_process_name|~|NISSAN_FEEDS_DOWNLOAD_END'::varchar, 'main_360'::varchar, ''::varchar, ''::varchar, '    set :v_process_name = "NISSAN_FEEDS_DOWNLOAD_END"'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_360'::varchar, 61::integer, 'execute'::varchar, 'generic_email_wf'::varchar, 'main_370'::varchar, ''::varchar, ''::varchar, '    execute generic_email_wf'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_370'::varchar, 62::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'mwf_download_nissan_feeds_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
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
	set :v_process_name = "NISSAN_FEEDS_DOWNLOAD_START"
	execute generic_email_wf
	datareceipt DOWNLOAD_NNA_PRICE
	datareceipt DOWNLOAD_NNA_SERVFILE
	datareceipt DOWNLOAD_NNA_SUPERSN
	datareceipt DOWNLOAD_NNA_PARTS
	datareceipt DOWNLOAD_NML_CD1_FEED
	datareceipt DOWNLOAD_NML_CD2_FEED
	datareceipt DOWNLOAD_NML_CD3_FEED
	datareceipt DOWNLOAD_NML_CD4_FEED
	datareceipt DOWNLOAD_NML_CD5_FEED
	datareceipt DOWNLOAD_NML_CD6_FEED
	datareceipt DOWNLOAD_NML_CD7_FEED
	datareceipt DOWNLOAD_SYNONYMS_FEED
	datareceipt DOWNLOAD_VA_PARTS_FEED	
	datareceipt DOWNLOAD_NNA_ILLUST_MASTER_EXCEL
	datareceipt DOWNLOAD_ILLUSTRATION_CHANGE_EXCEL
	datareceipt DOWNLOAD_NIS_ILLUSTRATION_IMAGE_VC
	datareceipt DOWNLOAD_NIS_SVG_IMAGE_ZIP
	datareceipt DOWNLOAD_ATTACHMENT_GI
	datareceipt DOWNLOAD_MODEL_IMAGE
	datareceipt DOWNLOAD_CHAPTER_IMAGE
	datareceipt DOWNLOAD_ATTACHMENT_PRICEBOOK
	datareceipt DOWNLOAD_GROUPSECTION_FEED
	datareceipt DOWNLOAD_SBS_ILLUST_EXCEL
	set :grp_name = "'downloaded_feeds_report'"
	execute rpt_generic_report_wf
	#serial #RDVT Report
		#set :grp_name = "'dvt_report'"
		#execute rpt_generic_report_wf
	load :schema_name = "select ''"
	load :cycle_status = "select ''"
	execute stop_due_to_failure
	execute exit_due_to_failure
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
