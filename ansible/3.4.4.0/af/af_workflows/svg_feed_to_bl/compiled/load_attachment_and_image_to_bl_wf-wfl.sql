do
$workflowcontext$
declare
    /* Export 1.8.1
    Exported on:   2026-06-19 06:46:22-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   load_attachment_and_image_to_bl_wf.wfl
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
perform af_repo.fk_add_context('load_attachment_and_image_to_bl_wf'::varchar,'W'::varchar, 90::smallint, '(1.8.1.0)This workflow is used for load attachments and Images to BL.'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 18::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'load_attachment_and_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 19::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options	'::varchar, 'load_attachment_and_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 20::integer, 'set'::varchar, ':tag_area|~|Feed to BL'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_area = "Feed to BL"'::varchar, 'load_attachment_and_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 21::integer, 'set'::varchar, ':tag_domain|~|Image and Attachment'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :tag_domain = "Image and Attachment"'::varchar, 'load_attachment_and_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 22::integer, 'sql'::varchar, 'truncate table curr_run_image_data_w'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    sql "truncate table curr_run_image_data_w"'::varchar, 'load_attachment_and_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 23::integer, 'sql'::varchar, 'truncate table curr_run_source_image_w'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '    sql "truncate table curr_run_source_image_w"'::varchar, 'load_attachment_and_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 24::integer, 'execute'::varchar, 'load_model_image_to_bl_wf'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '    execute load_model_image_to_bl_wf #Model Image Load'::varchar, 'load_attachment_and_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 25::integer, 'execute'::varchar, 'load_chapter_image_to_bl_wf'::varchar, 'main_80'::varchar, ''::varchar, ''::varchar, '    execute load_chapter_image_to_bl_wf #Group Image Load'::varchar, 'load_attachment_and_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 26::integer, 'execute'::varchar, 'load_attachment_to_bl_gi_wf'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '    execute load_attachment_to_bl_gi_wf #GI Attachment Load '::varchar, 'load_attachment_and_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 27::integer, 'execute'::varchar, 'load_attachment_to_bl_pricebook_wf'::varchar, 'main_100'::varchar, ''::varchar, ''::varchar, '    execute load_attachment_to_bl_pricebook_wf #Pricebook Attachment Load'::varchar, 'load_attachment_and_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 28::integer, 'execute'::varchar, 'load_illustration_image_to_bl_wf'::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '    execute load_illustration_image_to_bl_wf #TIF and SVG Image Load'::varchar, 'load_attachment_and_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 29::integer, 'serial'::varchar, 'main_120'::varchar, 'main_160'::varchar, ''::varchar, ''::varchar, '    serial # Reports'::varchar, 'load_attachment_and_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 30::integer, 'set'::varchar, ':grp_name|~|''nis_image_not_processed'''::varchar, 'main_130'::varchar, ''::varchar, ''::varchar, '        set :grp_name = "''nis_image_not_processed''" '::varchar, 'load_attachment_and_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 31::integer, 'execute'::varchar, 'rpt_generic_report_wf'::varchar, 'main_140'::varchar, ''::varchar, ''::varchar, '        execute rpt_generic_report_wf'::varchar, 'load_attachment_and_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 32::integer, 'set'::varchar, ':grp_name|~|''nis_bl_large_images'''::varchar, 'main_150'::varchar, ''::varchar, ''::varchar, '        set :grp_name = "''nis_bl_large_images''" '::varchar, 'load_attachment_and_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 33::integer, 'execute'::varchar, 'rpt_generic_report_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute rpt_generic_report_wf'::varchar, 'load_attachment_and_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 34::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'load_attachment_and_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'load_attachment_and_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.af_compiler_insert('load_attachment_and_image_to_bl_wf.wfl', $q$#workflow used for load attachments and Images to BL
load_attachment_and_image_to_bl_wf(retention=90):  This workflow is used for load attachments and Images to BL.
# Project:  NISSAN NA NG DATA PUBLISHING
#
# Name: load_attachment_and_image_to_bl_wf.wfl
#
# Purpose:  TThis workflow is used for load attachments and Images to BL.
#
#===========================================================
# Revision History
#   Ref #  Date           Revisor      Comment
#   1      30-APR-2026   NKM          Initial Version 
#===========================================================
# Revisor
# [Initials]		[Full Name]
#  NKM               NITISH KUMAR MISHRA
#===========================================================
	output_version
	output_options	
	set :tag_area = "Feed to BL"
	set :tag_domain = "Image and Attachment"
	sql "truncate table curr_run_image_data_w"
	sql "truncate table curr_run_source_image_w"
	execute load_model_image_to_bl_wf #Model Image Load
	execute load_chapter_image_to_bl_wf #Group Image Load
	execute load_attachment_to_bl_gi_wf #GI Attachment Load 
	execute load_attachment_to_bl_pricebook_wf #Pricebook Attachment Load
	execute load_illustration_image_to_bl_wf #TIF and SVG Image Load
	serial # Reports
		set :grp_name = "'nis_image_not_processed'" 
		execute rpt_generic_report_wf
		set :grp_name = "'nis_bl_large_images'" 
		execute rpt_generic_report_wf
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  load_attachment_and_image_to_bl_wf.wfl
  **
  */
raise notice '******************* SUCCESS!! Workflow import has completed. ****************************';
	
end;
$workflowcontext$ LANGUAGE 'plpgsql';
