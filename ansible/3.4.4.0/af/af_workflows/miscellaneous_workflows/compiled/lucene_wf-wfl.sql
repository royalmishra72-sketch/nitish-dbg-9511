do
$workflowcontext$
declare
    /* Export 1.8.1
    Exported on:   2026-06-19 06:43:42-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   lucene_wf.wfl
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
perform af_repo.fk_add_context('lucene_wf'::varchar,'W'::varchar, 180::smallint, '(1.8.1.0)This workflow will use the publite mode to trucate and load into luc_logical_partitions table'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 19::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'lucene_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 20::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options	'::varchar, 'lucene_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 21::integer, 'set'::varchar, ':tag_area|~|BL to CTRG_SUPPORT'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_area = "BL to CTRG_SUPPORT"'::varchar, 'lucene_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 22::integer, 'set'::varchar, ':tag_domain|~|lucene'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :tag_domain = "lucene"'::varchar, 'lucene_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 23::integer, 'publish'::varchar, 'pub_work.luc_logical_partitions_v'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    publish pub_work.luc_logical_partitions_v'::varchar, 'lucene_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 24::integer, 'execute'::varchar, 'lp_epc5_af_main_executor'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '    execute lp_epc5_af_main_executor'::varchar, 'lucene_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 25::integer, 'execute'::varchar, 'lucene_unzip_wf'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '    execute lucene_unzip_wf'::varchar, 'lucene_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 26::integer, 'serial'::varchar, 'main_80'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '    serial # Publish data in table lvt_post_ctrg_lucene_data_w'::varchar, 'lucene_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 27::integer, 'execute'::varchar, 'lvt_post_ctrg_lucene_data_w_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute lvt_post_ctrg_lucene_data_w_wf'::varchar, 'lucene_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 28::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'lucene_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'lucene_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.af_compiler_insert('lucene_wf.wfl', $q$#workflow used to populate data into ctrg_support.luc_logical_partitions table.
lucene_wf:  This workflow will use the publite mode to trucate and load into luc_logical_partitions table
# Project:  NISSAN DATA PUBLISHING
#
# Name: lucene_wf.wfl
#
# Purpose:  This workflow is used to populate data into ctrg_support.luc_logical_partitions table
#
#===========================================================
# Revision History
#   Ref #  Date          Revisor      Comment
#   1     25-AUG-2023    DU           Initial Version 
#   2     16-June-2026   NKM          NSPUB-1528  
#===========================================================
# Revisor
# [Initials]		[Full Name]
# DU                DILESH UKEY
#===========================================================
	output_version
	output_options	
	set :tag_area = "BL to CTRG_SUPPORT"
	set :tag_domain = "lucene"
    publish pub_work.luc_logical_partitions_v
	execute lp_epc5_af_main_executor
	execute lucene_unzip_wf
	serial # Publish data in table lvt_post_ctrg_lucene_data_w
		execute lvt_post_ctrg_lucene_data_w_wf
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  lucene_wf.wfl
  **
  */
raise notice '******************* SUCCESS!! Workflow import has completed. ****************************';
	
end;
$workflowcontext$ LANGUAGE 'plpgsql';
