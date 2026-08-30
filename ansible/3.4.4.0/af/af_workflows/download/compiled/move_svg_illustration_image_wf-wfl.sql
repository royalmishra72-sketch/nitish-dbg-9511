do
$workflowcontext$
declare
    /* Export 1.8.1
    Exported on:   2026-06-19 06:39:25-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   move_svg_illustration_image_wf.wfl
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
perform af_repo.fk_add_context('move_svg_illustration_image_wf'::varchar,'W'::varchar, 90::smallint, '(1.8.1.0)This workflow is used to move the unzipped svg image File to EPO directory.'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 18::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'move_svg_illustration_image_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 19::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options	'::varchar, 'move_svg_illustration_image_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 20::integer, 'set'::varchar, ':tag_domain|~|SVG IMAGE'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_domain = "SVG IMAGE"'::varchar, 'move_svg_illustration_image_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 21::integer, 'set'::varchar, ':tag_other|~|NISSAN'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :tag_other = "NISSAN"'::varchar, 'move_svg_illustration_image_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 22::integer, 'load'::varchar, ':root_path|~|select pub_admin.get_parameter(''PBAEnvRootPath'')'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    load :root_path= "select pub_admin.get_parameter(''PBAEnvRootPath'')"'::varchar, 'move_svg_illustration_image_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 23::integer, 'load'::varchar, ':epo_path|~|select pub_admin.get_parameter(''PBAEPORootPath'')'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '    load :epo_path= "select pub_admin.get_parameter(''PBAEPORootPath'')"'::varchar, 'move_svg_illustration_image_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 24::integer, 'set'::varchar, ':dr_group_datasource|~|DOWNLOAD_NIS_SVG_IMAGE_FILES'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '    set :dr_group_datasource = "DOWNLOAD_NIS_SVG_IMAGE_FILES"'::varchar, 'move_svg_illustration_image_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 25::integer, 'stage'::varchar, ':datareceipt_id'::varchar, 'main_80'::varchar, ''::varchar, ''::varchar, '    stage :datareceipt_id '::varchar, 'move_svg_illustration_image_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 26::integer, 'set'::varchar, ':Target|~|&&epo_path&&/SVGImages'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '    set :Target="&&epo_path&&/SVGImages"'::varchar, 'move_svg_illustration_image_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 27::integer, 'run'::varchar, '&&root_path&&app/script/move_svg_images.sh &&path&& &&Target&&'::varchar, 'main_100'::varchar, ''::varchar, ''::varchar, '    run &&root_path&&app/script/move_svg_images.sh &&path&& &&Target&& '::varchar, 'move_svg_illustration_image_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 28::integer, 'cleanup'::varchar, ':datareceipt_id'::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '    cleanup :datareceipt_id'::varchar, 'move_svg_illustration_image_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 29::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'move_svg_illustration_image_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'move_svg_illustration_image_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.af_compiler_insert('move_svg_illustration_image_wf.wfl', $q$#workflow is used to move the unzipped svg image File to EPO directory..
move_svg_illustration_image_wf(retention=90):  This workflow is used to move the unzipped svg image File to EPO directory.
# Project:  NISSAN NG DATA PUBLISHING
#
# Name: move_svg_illustration_image_wf.wfl
#
# Purpose:  This workflow is used to move the unzipped svg image File to EPO directory.
#
#===========================================================
# Revision History
#   Ref #  Date            Revisor      Comment
#   1      12-Jan-2026    NKM          Initial Version 
#===========================================================
# Revisor
# [Initials]		 [Full Name]
#  NKM                Nitish K Mishra
#===========================================================
	output_version
	output_options	
	set :tag_domain = "SVG IMAGE"
	set :tag_other = "NISSAN"
	load :root_path= "select pub_admin.get_parameter('PBAEnvRootPath')"
	load :epo_path= "select pub_admin.get_parameter('PBAEPORootPath')"
	set :dr_group_datasource = "DOWNLOAD_NIS_SVG_IMAGE_FILES"
	stage :datareceipt_id 
	set :Target="&&epo_path&&/SVGImages"
	run &&root_path&&app/script/move_svg_images.sh &&path&& &&Target&& 
	cleanup :datareceipt_id
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  move_svg_illustration_image_wf.wfl
  **
  */
raise notice '******************* SUCCESS!! Workflow import has completed. ****************************';
	
end;
$workflowcontext$ LANGUAGE 'plpgsql';
