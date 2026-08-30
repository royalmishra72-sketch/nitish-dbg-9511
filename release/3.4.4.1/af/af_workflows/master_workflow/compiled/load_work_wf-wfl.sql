do
$workflowcontext$
declare
    /* Export 1.8.1
    Exported on:   2026-08-07 06:39:36-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   load_work_wf.wfl
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
perform af_repo.fk_add_context('load_work_wf'::varchar,'W'::varchar, 180::smallint, '(1.8.1.0)This Workflow used to load Work Tables.'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 22::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 23::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 24::integer, 'set'::varchar, ':tag_area|~|BL to Work'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_area = "BL to Work"'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 25::integer, 'set'::varchar, ':tag_domain|~|Work'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :tag_domain = "Work"'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 26::integer, 'serial'::varchar, 'main_50'::varchar, 'main_360'::varchar, ''::varchar, ''::varchar, '    serial # This block will load the data in serial.'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 27::integer, 'parallel'::varchar, 'main_60|~|main_70'::varchar, 'main_130'::varchar, ''::varchar, ''::varchar, '        parallel # This block will load the data in parallel.'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 28::integer, 'publish'::varchar, 'pub_work.vin_multi_cat_w_v'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            publish pub_work.vin_multi_cat_w_v'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 29::integer, 'serial'::varchar, 'main_80'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            serial # This block will load the data in serial.'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 30::integer, 'publish'::varchar, 'pub_work.part_addl_info_w_v'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '                publish pub_work.part_addl_info_w_v'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 31::integer, 'publish'::varchar, 'pub_work.servfile_w_v'::varchar, 'main_100'::varchar, ''::varchar, ''::varchar, '                publish pub_work.servfile_w_v                            '::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 32::integer, 'publish'::varchar, 'pub_work.model_display_groups_w_v'::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '                publish pub_work.model_display_groups_w_v                '::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 33::integer, 'publish'::varchar, 'pub_work.spec_code_string_w_v'::varchar, 'main_120'::varchar, ''::varchar, ''::varchar, '                publish pub_work.spec_code_string_w_v                    '::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 34::integer, 'publish'::varchar, 'pub_work.spec_code_desc_w_v'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '                publish pub_work.spec_code_desc_w_v '::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 35::integer, 'parallel'::varchar, 'main_140|~|main_150|~|main_160'::varchar, 'main_170'::varchar, ''::varchar, ''::varchar, '        parallel # This block will load the data in parallel.				'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 36::integer, 'publish'::varchar, 'pub_work.merge_parts_w_v'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            publish pub_work.merge_parts_w_v                            '::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 37::integer, 'publish'::varchar, 'pub_work.spec_code_w_v'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            publish pub_work.spec_code_w_v  '::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 38::integer, 'publish'::varchar, 'pub_work.image_w_v'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            publish pub_work.image_w_v'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_170'::varchar, 39::integer, 'parallel'::varchar, 'main_180|~|main_190|~|main_200|~|main_210'::varchar, 'main_280'::varchar, ''::varchar, ''::varchar, '        parallel # This block will load the data in parallel.'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_180'::varchar, 40::integer, 'publish'::varchar, 'pub_work.part_item_appl_filter_w_v'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            publish pub_work.part_item_appl_filter_w_v                '::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_190'::varchar, 41::integer, 'publish'::varchar, 'pub_work.part_item_w_v'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            publish pub_work.part_item_w_v                            '::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_200'::varchar, 42::integer, 'publish'::varchar, 'pub_work.part_item_non_appl_filter_w_v'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            publish pub_work.part_item_non_appl_filter_w_v   '::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_210'::varchar, 43::integer, 'serial'::varchar, 'main_220'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            serial # This block will load the data in serial.'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_220'::varchar, 44::integer, 'publish'::varchar, 'pub_work.image_data_w_v'::varchar, 'main_230'::varchar, ''::varchar, ''::varchar, '                publish pub_work.image_data_w_v'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_230'::varchar, 45::integer, 'publish'::varchar, 'pub_work.page_w_v'::varchar, 'main_240'::varchar, ''::varchar, ''::varchar, '                publish pub_work.page_w_v                               '::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_240'::varchar, 46::integer, 'publish'::varchar, 'pub_work.part_item_addl_info_w_v'::varchar, 'main_250'::varchar, ''::varchar, ''::varchar, '                publish pub_work.part_item_addl_info_w_v       '::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_250'::varchar, 47::integer, 'publish'::varchar, 'pub_work.part_w_v'::varchar, 'main_260'::varchar, ''::varchar, ''::varchar, '                publish pub_work.part_w_v'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_260'::varchar, 48::integer, 'publish'::varchar, 'pub_work.vin_type_range_w_v'::varchar, 'main_270'::varchar, ''::varchar, ''::varchar, '                publish pub_work.vin_type_range_w_v'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_270'::varchar, 49::integer, 'publish'::varchar, 'pub_work.vin_catalog_map_base_w_v'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '                publish pub_work.vin_catalog_map_base_w_v         '::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_280'::varchar, 50::integer, 'publish'::varchar, 'pub_work.vin_filters_w_v'::varchar, 'main_290'::varchar, ''::varchar, ''::varchar, '        publish pub_work.vin_filters_w_v                            '::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_290'::varchar, 51::integer, 'publish'::varchar, 'pub_work.vin_filter_dtswitch_w_v'::varchar, 'main_300'::varchar, ''::varchar, ''::varchar, '        publish pub_work.vin_filter_dtswitch_w_v              '::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_300'::varchar, 52::integer, 'publish'::varchar, 'pub_work.vin_catalog_map_nrml_w_v'::varchar, 'main_310'::varchar, ''::varchar, ''::varchar, '        publish pub_work.vin_catalog_map_nrml_w_v       '::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_310'::varchar, 53::integer, 'publish'::varchar, 'pub_work.vin_catalog_map_w_v'::varchar, 'main_320'::varchar, ''::varchar, ''::varchar, '        publish pub_work.vin_catalog_map_w_v '::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_320'::varchar, 54::integer, 'publish'::varchar, 'pub_work.bl_sbs_catalog_update_v'::varchar, 'main_330'::varchar, ''::varchar, ''::varchar, '        publish pub_work.bl_sbs_catalog_update_v		'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_330'::varchar, 55::integer, 'parallel'::varchar, 'main_340|~|main_350'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        parallel # This block will load the data in parallel.'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_340'::varchar, 56::integer, 'publish'::varchar, 'pub_work.filter_item_w_v'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            publish pub_work.filter_item_w_v                          '::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_350'::varchar, 57::integer, 'publish'::varchar, 'pub_work.ein_addl_info_w_v'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            publish pub_work.ein_addl_info_w_v'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('main_360'::varchar, 58::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'load_work_wf'::varchar, 'W'::varchar, 1::integer, 'sv9399'::varchar);
perform af_repo.af_compiler_insert('load_work_wf.wfl', $q$#workflow used to load Work Tables.
load_work_wf: This Workflow used to load Work Tables.
# Project: NISSAN DATA PUBLISHING
#
# Name: load_work_wf.wfl
#
# Purpose:  This workflow is used to load Work Tables.
#
#===========================================================
# Revision History
#   Ref #  Date          Revisor      Comment
#   1      16-JUN-2023   DNU          Initial Version 
#   2      31-JULY-2025  NKM          Rearrange the loading process to reduce loading time
#   3      05-AUG-2026   CB           Publish image_data_w_v added	
#===========================================================
# Revisor
# [Initials]		[Full Name]
# DNU                DILESH N. UKEY
# NKM                Nitish K Mishra
# CB                 Chandan Bhatia
#===========================================================
    output_version
    output_options
	set :tag_area = "BL to Work"
	set :tag_domain = "Work"
    serial # This block will load the data in serial.
        parallel # This block will load the data in parallel.
            publish pub_work.vin_multi_cat_w_v
            serial # This block will load the data in serial.
                publish pub_work.part_addl_info_w_v
                publish pub_work.servfile_w_v                            
                publish pub_work.model_display_groups_w_v                
                publish pub_work.spec_code_string_w_v                    
                publish pub_work.spec_code_desc_w_v 
        parallel # This block will load the data in parallel.				
			publish pub_work.merge_parts_w_v                            
			publish pub_work.spec_code_w_v  
			publish pub_work.image_w_v
        parallel # This block will load the data in parallel.
            publish pub_work.part_item_appl_filter_w_v                
            publish pub_work.part_item_w_v                            
            publish pub_work.part_item_non_appl_filter_w_v   
            serial # This block will load the data in serial.
				publish pub_work.image_data_w_v
                publish pub_work.page_w_v                               
                publish pub_work.part_item_addl_info_w_v       
                publish pub_work.part_w_v
				publish pub_work.vin_type_range_w_v
                publish pub_work.vin_catalog_map_base_w_v         
        publish pub_work.vin_filters_w_v                            
        publish pub_work.vin_filter_dtswitch_w_v              
        publish pub_work.vin_catalog_map_nrml_w_v       
        publish pub_work.vin_catalog_map_w_v 
		publish pub_work.bl_sbs_catalog_update_v		
        parallel # This block will load the data in parallel.
			publish pub_work.filter_item_w_v                          
			publish pub_work.ein_addl_info_w_v
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  load_work_wf.wfl
  **
  */
raise notice '******************* SUCCESS!! Workflow import has completed. ****************************';
	
end;
$workflowcontext$ LANGUAGE 'plpgsql';
