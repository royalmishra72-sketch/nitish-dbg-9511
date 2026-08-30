do
$workflowcontext$
declare
    /* Export 1.8.1
    Exported on:   2026-06-19 06:47:13-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   load_illustration_image_to_bl_wf.wfl
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
perform af_repo.fk_add_context('load_illustration_image_to_bl_wf'::varchar,'W'::varchar, 90::smallint, '(1.8.1.0)This workflow is used for load Illustration Images to BL.'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 19::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'load_illustration_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 20::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options	'::varchar, 'load_illustration_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 21::integer, 'set'::varchar, ':tag_area|~|Feed to BL'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_area = "Feed to BL"'::varchar, 'load_illustration_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 22::integer, 'set'::varchar, ':tag_domain|~|IMAGE'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :tag_domain = "IMAGE"'::varchar, 'load_illustration_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 23::integer, 'execute'::varchar, 'load_tif_image_to_bl_wf'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    execute load_tif_image_to_bl_wf #Load TIF Image'::varchar, 'load_illustration_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 24::integer, 'execute'::varchar, 'load_svg_image_to_bl_wf'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '    execute load_svg_image_to_bl_wf #Load SVG Image'::varchar, 'load_illustration_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 25::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'load_illustration_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'load_illustration_image_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.af_compiler_insert('load_illustration_image_to_bl_wf.wfl', $q$#workflow used to load Illustration Images to BL
load_illustration_image_to_bl_wf(retention=90):  This workflow is used for load Illustration Images to BL.
# Project:  NISSAN NA NG DATA PUBLISHING
#
# Name: load_illustration_image_to_bl_wf.wfl
#
# Purpose:  This workflow is used to load Illustration Images to BL.
#
#===========================================================
# Revision History
#   Ref #  Date           Revisor      Comment
#   1      25-JULY-2023   NKM          Initial Version 
#	2      19-Jan-2026    NKM          Add SVG Image Loading Process
#===========================================================
# Revisor
# [Initials]		[Full Name]
#  NKM               NITISH KUMAR MISHRA
#===========================================================
	output_version
	output_options	
	set :tag_area = "Feed to BL"
	set :tag_domain = "IMAGE"
	execute load_tif_image_to_bl_wf #Load TIF Image
	execute load_svg_image_to_bl_wf #Load SVG Image
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  load_illustration_image_to_bl_wf.wfl
  **
  */
raise notice '******************* SUCCESS!! Workflow import has completed. ****************************';
	
end;
$workflowcontext$ LANGUAGE 'plpgsql';
