do
$workflowcontext$
declare
    /* Export 1.8.1
    Exported on:   2026-06-19 06:45:22-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   bl_nna_illust_master_wf.wfl
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
perform af_repo.fk_add_context('bl_nna_illust_master_wf'::varchar,'W'::varchar, 180::smallint, '(1.8.1.0)This workflow will use the fileload_changesonly mode to update and insert data into bl.bl_nna_illust_master table'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 18::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'bl_nna_illust_master_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 19::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options	'::varchar, 'bl_nna_illust_master_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 20::integer, 'set'::varchar, ':tag_area|~|Feed to BL'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_area = "Feed to BL"'::varchar, 'bl_nna_illust_master_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 21::integer, 'set'::varchar, ':tag_domain|~|illustration'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :tag_domain = "illustration"'::varchar, 'bl_nna_illust_master_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 22::integer, 'load'::varchar, ':excel_file_name|~|select gv_datarcpt_file_name from pub_admin.dr_datarcpt_file_v  where datarcpt_id = (select parentcontainerid from pub_admin.dr_datarcpt_file_v  where datarcpt_id = %s)|~|:datareceipt_id'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    load :excel_file_name = "select gv_datarcpt_file_name from pub_admin.dr_datarcpt_file_v  where datarcpt_id = (select parentcontainerid from pub_admin.dr_datarcpt_file_v  where datarcpt_id = %s)",:datareceipt_id'::varchar, 'bl_nna_illust_master_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 25::integer, 'publish'::varchar, 'pub_work.file_pre_bl_nna_illust_master_w'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '    publish pub_work.file_pre_bl_nna_illust_master_w'::varchar, 'bl_nna_illust_master_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 26::integer, 'set'::varchar, ':tab_bckup_grp|~|bl_nna_illust_master'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '    set :tab_bckup_grp = "bl_nna_illust_master"'::varchar, 'bl_nna_illust_master_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 27::integer, 'execute'::varchar, 'prc_data_backup_wf'::varchar, 'main_80'::varchar, ''::varchar, ''::varchar, '    execute prc_data_backup_wf'::varchar, 'bl_nna_illust_master_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 28::integer, 'publish'::varchar, 'pub_work.bl_nna_illust_master_v'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '    publish pub_work.bl_nna_illust_master_v'::varchar, 'bl_nna_illust_master_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 29::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'bl_nna_illust_master_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'bl_nna_illust_master_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.af_compiler_insert('bl_nna_illust_master_wf.wfl', $q$#workflow used to populate data into bl.bl_nna_illust_master table
bl_nna_illust_master_wf:  This workflow will use the fileload_changesonly mode to update and insert data into bl.bl_nna_illust_master table
# Project:  NISSAN DATA PUBLISHING
#
# Name: bl_nna_illust_master_wf.wfl
#
# Purpose:  This workflow is used to populate data into bl.bl_nna_illust_master table
#
#===========================================================
# Revision History
#   Ref #  Date          Revisor      Comment
#   1     24-JUL-2023    DNU           Initial Version 
#===========================================================
# Revisor
# [Initials]		[Full Name]
# DNU                DILESH N. UKEY
#===========================================================
	output_version
	output_options	
	set :tag_area = "Feed to BL"
	set :tag_domain = "illustration"
	load :excel_file_name = "select gv_datarcpt_file_name from pub_admin.dr_datarcpt_file_v \
						where datarcpt_id = (select parentcontainerid from pub_admin.dr_datarcpt_file_v \
						where datarcpt_id = %s)",:datareceipt_id
	publish pub_work.file_pre_bl_nna_illust_master_w
	set :tab_bckup_grp = "bl_nna_illust_master"
	execute prc_data_backup_wf
	publish pub_work.bl_nna_illust_master_v
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  bl_nna_illust_master_wf.wfl
  **
  */
raise notice '******************* SUCCESS!! Workflow import has completed. ****************************';
	
end;
$workflowcontext$ LANGUAGE 'plpgsql';
