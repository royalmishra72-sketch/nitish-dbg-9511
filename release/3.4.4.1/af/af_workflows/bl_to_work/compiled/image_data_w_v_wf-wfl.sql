do
$workflowcontext$
declare
    /* Export 1.8.1
    Exported on:   2026-08-05 07:00:07-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   image_data_w_v_wf.wfl
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
perform af_repo.fk_add_context('image_data_w_v_wf'::varchar,'W'::varchar, 180::smallint, '(1.8.1.0)This workflow will used publite mode to truncate and load data into pub_work.image_data_w table'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 18::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'image_data_w_v_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 19::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'image_data_w_v_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 20::integer, 'set'::varchar, ':tag_area|~|BL to Work'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_area = "BL to Work"'::varchar, 'image_data_w_v_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 21::integer, 'set'::varchar, ':tag_domain|~|Image'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :tag_domain = "Image"'::varchar, 'image_data_w_v_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 22::integer, 'publish'::varchar, 'pub_work.image_data_w_v'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    publish pub_work.image_data_w_v'::varchar, 'image_data_w_v_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 23::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'image_data_w_v_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'image_data_w_v_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.af_compiler_insert('image_data_w_v_wf.wfl', $q$#workflow used to populate data into pub_work.image_data_w table
image_data_w_v_wf: This workflow will used publite mode to truncate and load data into pub_work.image_data_w table 
# Project: NISSAN DATA PUBLISHING
#
# Name: image_data_w_v_wf.wfl
#
# Purpose:  This workflow is used to populate data into pub_work.image_data_w table
#
#===========================================================
# Revision History
#   Ref #  Date           Revisor       Comment
#   1      05-AUG-2026    NKM           Initial Version 
#===========================================================
# Revisor
# [Initials]		  [Full Name]
#  NKM                 Nitish K Mishra
#===========================================================
    output_version
    output_options
	set :tag_area = "BL to Work"
	set :tag_domain = "Image"
	publish pub_work.image_data_w_v
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  image_data_w_v_wf.wfl
  **
  */
raise notice '******************* SUCCESS!! Workflow import has completed. ****************************';
	
end;
$workflowcontext$ LANGUAGE 'plpgsql';
