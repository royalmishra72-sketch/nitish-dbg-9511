do
$workflowcontext$
declare
    /* Export 1.8.1
    Exported on:   2026-06-26 02:55:38-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   mwf_feed_to_bl_wf.wfl
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
perform af_repo.fk_add_context('mwf_feed_to_bl_wf'::varchar,'W'::varchar, 180::smallint, '(1.8.1.0)This Workflow used to load BL Tables.'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 27::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 28::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options	'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 29::integer, 'set'::varchar, ':tag_area|~|Feed to BL'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_area = "Feed to BL"'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 30::integer, 'serial'::varchar, 'main_40'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '    serial # Feed To BL Initiated Email'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 31::integer, 'set'::varchar, ':v_process_name|~|MWF_FEED_TO_BL_START'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '        set :v_process_name = "MWF_FEED_TO_BL_START"'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 32::integer, 'execute'::varchar, 'generic_email_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute generic_email_wf'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 33::integer, 'execute'::varchar, 'prc_data_backup_pb_flag_reset_wf'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '    execute prc_data_backup_pb_flag_reset_wf'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 34::integer, 'sql'::varchar, 'call pub_admin.set_parameter_value(''LVT_LUCENE_BACKUP'',''TODO'')'::varchar, 'main_80'::varchar, ''::varchar, ''::varchar, '    sql "call pub_admin.set_parameter_value(''LVT_LUCENE_BACKUP'',''TODO'')"'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 35::integer, 'serial'::varchar, 'main_90'::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '    serial # This step will take backup of all sbs tables.'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 36::integer, 'set'::varchar, ':tab_bckup_grp|~|sbs'::varchar, 'main_100'::varchar, ''::varchar, ''::varchar, '        set :tab_bckup_grp = "sbs"'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 37::integer, 'execute'::varchar, 'prc_data_backup_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute prc_data_backup_wf'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 38::integer, 'serial'::varchar, 'main_120'::varchar, 'main_140'::varchar, ''::varchar, ''::varchar, '    serial # This step will take backup of  bl_f31x1470_catalog_parts table.'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 39::integer, 'set'::varchar, ':tab_bckup_grp|~|parts'::varchar, 'main_130'::varchar, ''::varchar, ''::varchar, '        set :tab_bckup_grp = "parts"'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 40::integer, 'execute'::varchar, 'prc_data_backup_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute prc_data_backup_wf	'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 41::integer, 'serial'::varchar, 'main_150'::varchar, 'main_170'::varchar, ''::varchar, ''::varchar, '    serial # This step will take backup of bl_f31x1340_vin table.'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 42::integer, 'set'::varchar, ':tab_bckup_grp|~|vin'::varchar, 'main_160'::varchar, ''::varchar, ''::varchar, '        set :tab_bckup_grp = "vin"'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 43::integer, 'execute'::varchar, 'prc_data_backup_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute prc_data_backup_wf'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_170'::varchar, 44::integer, 'serial'::varchar, 'main_180'::varchar, 'main_200'::varchar, ''::varchar, ''::varchar, '    serial # This step will take backup of bl_image_data table.'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_180'::varchar, 45::integer, 'set'::varchar, ':tab_bckup_grp|~|bl_image_data'::varchar, 'main_190'::varchar, ''::varchar, ''::varchar, '        set :tab_bckup_grp = "bl_image_data"'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_190'::varchar, 46::integer, 'execute'::varchar, 'prc_data_backup_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute prc_data_backup_wf		'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_200'::varchar, 47::integer, 'serial'::varchar, 'main_210'::varchar, 'main_230'::varchar, ''::varchar, ''::varchar, '    serial # SBS Section Feed and Illust Feed'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_210'::varchar, 48::integer, 'datareceipt'::varchar, 'Nissan_Section'::varchar, 'main_220'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_Section'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_220'::varchar, 49::integer, 'datareceipt'::varchar, 'SBS_ILLUST'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        datareceipt SBS_ILLUST'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_230'::varchar, 50::integer, 'serial'::varchar, 'main_240'::varchar, 'main_310'::varchar, ''::varchar, ''::varchar, '    serial #Conversion of CD Files'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_240'::varchar, 51::integer, 'execute'::varchar, 'dr_nml_parts_cd1_conversion_wf'::varchar, 'main_250'::varchar, ''::varchar, ''::varchar, '        execute dr_nml_parts_cd1_conversion_wf'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_250'::varchar, 52::integer, 'execute'::varchar, 'dr_nml_parts_cd2_conversion_wf'::varchar, 'main_260'::varchar, ''::varchar, ''::varchar, '        execute dr_nml_parts_cd2_conversion_wf'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_260'::varchar, 53::integer, 'execute'::varchar, 'dr_nml_misc_cd3_conversion_wf'::varchar, 'main_270'::varchar, ''::varchar, ''::varchar, '        execute dr_nml_misc_cd3_conversion_wf'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_270'::varchar, 54::integer, 'execute'::varchar, 'dr_nml_vin_cd4_conversion_wf'::varchar, 'main_280'::varchar, ''::varchar, ''::varchar, '        execute dr_nml_vin_cd4_conversion_wf'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_280'::varchar, 55::integer, 'execute'::varchar, 'dr_nml_parts_cd5_conversion_wf'::varchar, 'main_290'::varchar, ''::varchar, ''::varchar, '        execute dr_nml_parts_cd5_conversion_wf'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_290'::varchar, 56::integer, 'execute'::varchar, 'dr_nml_parts_cd6_conversion_wf'::varchar, 'main_300'::varchar, ''::varchar, ''::varchar, '        execute dr_nml_parts_cd6_conversion_wf'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_300'::varchar, 57::integer, 'execute'::varchar, 'dr_nml_vin_cd7_conversion_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute dr_nml_vin_cd7_conversion_wf'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_310'::varchar, 58::integer, 'serial'::varchar, 'main_320'::varchar, 'main_360'::varchar, ''::varchar, ''::varchar, '    serial #Loading feeds CD1,CD2,CD5,CD6'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_320'::varchar, 59::integer, 'datareceipt'::varchar, 'catalog_parts_cd1'::varchar, 'main_330'::varchar, ''::varchar, ''::varchar, '        datareceipt catalog_parts_cd1'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_330'::varchar, 60::integer, 'datareceipt'::varchar, 'catalog_parts_cd2'::varchar, 'main_340'::varchar, ''::varchar, ''::varchar, '        datareceipt catalog_parts_cd2'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_340'::varchar, 61::integer, 'datareceipt'::varchar, 'catalog_parts_cd5'::varchar, 'main_350'::varchar, ''::varchar, ''::varchar, '        datareceipt catalog_parts_cd5'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_350'::varchar, 62::integer, 'datareceipt'::varchar, 'catalog_parts_cd6'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        datareceipt catalog_parts_cd6'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_360'::varchar, 63::integer, 'serial'::varchar, 'main_370'::varchar, 'main_380'::varchar, ''::varchar, ''::varchar, '    serial #Loading NML CD7 Feed'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_370'::varchar, 64::integer, 'datareceipt'::varchar, 'Nissan_NML_VIN2'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_NML_VIN2'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_380'::varchar, 65::integer, 'serial'::varchar, 'main_390'::varchar, 'main_400'::varchar, ''::varchar, ''::varchar, '    serial #Loading NML CD4 Feed'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_390'::varchar, 66::integer, 'datareceipt'::varchar, 'Nissan_NML_VIN1'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_NML_VIN1'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_400'::varchar, 67::integer, 'serial'::varchar, 'main_410'::varchar, 'main_590'::varchar, ''::varchar, ''::varchar, '    serial #NML CD3 Feed'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_410'::varchar, 68::integer, 'datareceipt'::varchar, 'Nissan_18DigitModelCode'::varchar, 'main_420'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_18DigitModelCode'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_420'::varchar, 69::integer, 'datareceipt'::varchar, 'Nissan_ModelControl'::varchar, 'main_430'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_ModelControl'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_430'::varchar, 70::integer, 'datareceipt'::varchar, 'Nissan_AppliedModelOld'::varchar, 'main_440'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_AppliedModelOld'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_440'::varchar, 71::integer, 'datareceipt'::varchar, 'Nissan_CDExpression'::varchar, 'main_450'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_CDExpression'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_450'::varchar, 72::integer, 'datareceipt'::varchar, 'Nissan_TOMChassis'::varchar, 'main_460'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_TOMChassis'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_460'::varchar, 73::integer, 'datareceipt'::varchar, 'Nissan_VINDist'::varchar, 'main_470'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_VINDist'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_470'::varchar, 74::integer, 'datareceipt'::varchar, 'Nissan_MinorChgSwitch'::varchar, 'main_480'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_MinorChgSwitch'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_480'::varchar, 75::integer, 'datareceipt'::varchar, 'Nissan_SpecSeq'::varchar, 'main_490'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_SpecSeq'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_490'::varchar, 76::integer, 'datareceipt'::varchar, 'Nissan_TSBPartNum'::varchar, 'main_500'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_TSBPartNum'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_500'::varchar, 77::integer, 'datareceipt'::varchar, 'Nissan_Abbreviation'::varchar, 'main_510'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_Abbreviation'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_510'::varchar, 78::integer, 'datareceipt'::varchar, 'Nissan_PartCode'::varchar, 'main_520'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_PartCode'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_520'::varchar, 79::integer, 'datareceipt'::varchar, 'Nissan_SupPartNum'::varchar, 'main_530'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_SupPartNum'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_530'::varchar, 80::integer, 'datareceipt'::varchar, 'Nissan_CatalogStatusNew'::varchar, 'main_540'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_CatalogStatusNew'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_540'::varchar, 81::integer, 'datareceipt'::varchar, 'Nissan_AppliedModelNew'::varchar, 'main_550'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_AppliedModelNew'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_550'::varchar, 82::integer, 'datareceipt'::varchar, 'Nissan_SpecTrans'::varchar, 'main_560'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_SpecTrans'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_560'::varchar, 83::integer, 'datareceipt'::varchar, 'Nissan_CatalogUseExp'::varchar, 'main_570'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_CatalogUseExp'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_570'::varchar, 84::integer, 'datareceipt'::varchar, 'Nissan_CatalogStatusOld'::varchar, 'main_580'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_CatalogStatusOld'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_580'::varchar, 85::integer, 'datareceipt'::varchar, 'Nissan_CatalogTypeControl'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_CatalogTypeControl'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_590'::varchar, 86::integer, 'serial'::varchar, 'main_600'::varchar, 'main_690'::varchar, ''::varchar, ''::varchar, '    serial # NNA Feeds'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_600'::varchar, 87::integer, 'datareceipt'::varchar, 'Nissan_SYNONYMS'::varchar, 'main_610'::varchar, ''::varchar, ''::varchar, '        datareceipt Nissan_SYNONYMS'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_610'::varchar, 88::integer, 'datareceipt'::varchar, 'VA_PARTS'::varchar, 'main_620'::varchar, ''::varchar, ''::varchar, '        datareceipt VA_PARTS'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_620'::varchar, 89::integer, 'datareceipt'::varchar, 'NissanParts'::varchar, 'main_630'::varchar, ''::varchar, ''::varchar, '        datareceipt NissanParts'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_630'::varchar, 90::integer, 'datareceipt'::varchar, 'NissanPrice'::varchar, 'main_640'::varchar, ''::varchar, ''::varchar, '        datareceipt NissanPrice'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_640'::varchar, 91::integer, 'datareceipt'::varchar, 'NissanServfile'::varchar, 'main_650'::varchar, ''::varchar, ''::varchar, '        datareceipt NissanServfile'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_650'::varchar, 92::integer, 'datareceipt'::varchar, 'NissanSupersession'::varchar, 'main_660'::varchar, ''::varchar, ''::varchar, '        datareceipt NissanSupersession'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_660'::varchar, 93::integer, 'datareceipt'::varchar, 'ILLUSTRATION_CHANGE'::varchar, 'main_670'::varchar, ''::varchar, ''::varchar, '        datareceipt ILLUSTRATION_CHANGE'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_670'::varchar, 94::integer, 'sql'::varchar, 'truncate table pre_bl_nna_illust_master_w'::varchar, 'main_680'::varchar, ''::varchar, ''::varchar, '        sql "truncate table pre_bl_nna_illust_master_w"'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_680'::varchar, 95::integer, 'datareceipt'::varchar, 'NNA_ILLUST_MASTER'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        datareceipt NNA_ILLUST_MASTER'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_690'::varchar, 96::integer, 'serial'::varchar, 'main_700'::varchar, 'main_720'::varchar, ''::varchar, ''::varchar, '    serial # SUPPORT AND FEATURE MAP'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_700'::varchar, 97::integer, 'datareceipt'::varchar, 'GEN_SBS_SUPPORT'::varchar, 'main_710'::varchar, ''::varchar, ''::varchar, '        datareceipt GEN_SBS_SUPPORT'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_710'::varchar, 98::integer, 'datareceipt'::varchar, 'GEN_FEATURE_MAP'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        datareceipt GEN_FEATURE_MAP'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_720'::varchar, 99::integer, 'execute'::varchar, 'load_attachment_and_image_to_bl_wf'::varchar, 'main_730'::varchar, ''::varchar, ''::varchar, '    execute load_attachment_and_image_to_bl_wf'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_730'::varchar, 100::integer, 'serial'::varchar, 'main_740'::varchar, 'main_760'::varchar, ''::varchar, ''::varchar, '    serial # This step will Generate all BL Reports.'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_740'::varchar, 101::integer, 'set'::varchar, ':grp_name|~|''bl_reports'''::varchar, 'main_750'::varchar, ''::varchar, ''::varchar, '        set :grp_name = "''bl_reports''"'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_750'::varchar, 102::integer, 'execute'::varchar, 'rpt_generic_report_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute rpt_generic_report_wf'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_760'::varchar, 103::integer, 'serial'::varchar, 'main_770'::varchar, 'main_790'::varchar, ''::varchar, ''::varchar, '    serial # This Step will generate Rowcount and Threshold report for BL schema.'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_770'::varchar, 104::integer, 'load'::varchar, ':ct_rcth_schema_name|~|select ''bl'''::varchar, 'main_780'::varchar, ''::varchar, ''::varchar, '        load :ct_rcth_schema_name = "select ''bl''"'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_780'::varchar, 105::integer, 'execute'::varchar, 'tool_rpt_rowcount_threshold'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute tool_rpt_rowcount_threshold'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_790'::varchar, 106::integer, 'serial'::varchar, 'main_800'::varchar, 'main_840'::varchar, ''::varchar, ''::varchar, '    serial # RDVT Reports Checks'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_800'::varchar, 107::integer, 'set'::varchar, ':schema_name|~|bl'::varchar, 'main_810'::varchar, ''::varchar, ''::varchar, '        set :schema_name = "bl"'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_810'::varchar, 108::integer, 'set'::varchar, ':cycle_status|~|monthly'::varchar, 'main_820'::varchar, ''::varchar, ''::varchar, '        set :cycle_status = "monthly"'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_820'::varchar, 109::integer, 'execute'::varchar, 'stop_due_to_failure'::varchar, 'main_830'::varchar, ''::varchar, ''::varchar, '        execute stop_due_to_failure 	'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_830'::varchar, 110::integer, 'execute'::varchar, 'exit_due_to_failure'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute exit_due_to_failure 	'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_840'::varchar, 111::integer, 'execute'::varchar, 'create_new_catalog_wf'::varchar, 'main_850'::varchar, ''::varchar, ''::varchar, '    execute create_new_catalog_wf #New Catalog Entry'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_850'::varchar, 112::integer, 'execute'::varchar, 'dr_purge_wf'::varchar, 'main_860'::varchar, ''::varchar, ''::varchar, '    execute dr_purge_wf'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_860'::varchar, 113::integer, 'serial'::varchar, 'main_870'::varchar, 'main_890'::varchar, ''::varchar, ''::varchar, '    serial # Feed To BL Completed Email'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_870'::varchar, 114::integer, 'set'::varchar, ':v_process_name|~|MWF_FEED_TO_BL_END'::varchar, 'main_880'::varchar, ''::varchar, ''::varchar, '        set :v_process_name = "MWF_FEED_TO_BL_END"'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_880'::varchar, 115::integer, 'execute'::varchar, 'generic_email_wf'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '        execute generic_email_wf'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_890'::varchar, 116::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'mwf_feed_to_bl_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.af_compiler_insert('mwf_feed_to_bl_wf.wfl', $q$#workflow used to load BL Tables.
mwf_feed_to_bl_wf: This Workflow used to load BL Tables.
# Project: NISSAN DATA PUBLISHING
#
# Name: mwf_feed_to_bl_wf.wfl
#
# Purpose:  This workflow is used to load BL Tables.
#
#===========================================================
# Revision History
#   Ref #  Date          Revisor      Comment
#   1      08-AUG-2023   DNU          Initial Version  
#   2      29-AUG-2023   PR           Update generic reporting wfl.    
#	3      17-SEP-2024   NKM          Add Model,Chapter and Attachment Loading Process  
#	4      30-JAN-2026   CB           Added dvt_report, stop_due_to_failure, create_new_catalog_wf 	
#   5      07-MAY-2026   NKM          NSPUB-1496 Fix Missing SVG Report Failure in Second Cycle Due to curr_run_source_image_w Truncation
#   6     10-June-2026   NKM          RDVT 1.1.0 and 1.2.0 Enhancement
#   7     16-June-2026   NKM          Add backup status reset for LVT tables 
#===========================================================
# Revisor
# [Initials]		[Full Name]
# DNU                DILESH N. UKEY
# PR                 PAWAN RAJAK
# NKM                Nitish K Mishra 
# CB                 Chandan Bhatia 
#===========================================================
    output_version
    output_options	
	set :tag_area = "Feed to BL"
	serial # Feed To BL Initiated Email
		set :v_process_name = "MWF_FEED_TO_BL_START"
		execute generic_email_wf
	execute prc_data_backup_pb_flag_reset_wf
	sql "call pub_admin.set_parameter_value('LVT_LUCENE_BACKUP','TODO')"
	serial # This step will take backup of all sbs tables.
		set :tab_bckup_grp = "sbs"
		execute prc_data_backup_wf
	serial # This step will take backup of  bl_f31x1470_catalog_parts table.
		set :tab_bckup_grp = "parts"
		execute prc_data_backup_wf	
	serial # This step will take backup of bl_f31x1340_vin table.
		set :tab_bckup_grp = "vin"
		execute prc_data_backup_wf
	serial # This step will take backup of bl_image_data table.
		set :tab_bckup_grp = "bl_image_data"
		execute prc_data_backup_wf		
	serial # SBS Section Feed and Illust Feed
		datareceipt Nissan_Section
		datareceipt SBS_ILLUST
	serial #Conversion of CD Files
		execute dr_nml_parts_cd1_conversion_wf
		execute dr_nml_parts_cd2_conversion_wf
		execute dr_nml_misc_cd3_conversion_wf
		execute dr_nml_vin_cd4_conversion_wf
		execute dr_nml_parts_cd5_conversion_wf
		execute dr_nml_parts_cd6_conversion_wf
		execute dr_nml_vin_cd7_conversion_wf
	serial #Loading feeds CD1,CD2,CD5,CD6
		datareceipt catalog_parts_cd1
		datareceipt catalog_parts_cd2
		datareceipt catalog_parts_cd5
		datareceipt catalog_parts_cd6
	serial #Loading NML CD7 Feed
		datareceipt Nissan_NML_VIN2
	serial #Loading NML CD4 Feed
		datareceipt Nissan_NML_VIN1
	serial #NML CD3 Feed
		datareceipt Nissan_18DigitModelCode
		datareceipt Nissan_ModelControl
		datareceipt Nissan_AppliedModelOld
		datareceipt Nissan_CDExpression
		datareceipt Nissan_TOMChassis
		datareceipt Nissan_VINDist
		datareceipt Nissan_MinorChgSwitch
		datareceipt Nissan_SpecSeq
		datareceipt Nissan_TSBPartNum
		datareceipt Nissan_Abbreviation
		datareceipt Nissan_PartCode
		datareceipt Nissan_SupPartNum
		datareceipt Nissan_CatalogStatusNew
		datareceipt Nissan_AppliedModelNew
		datareceipt Nissan_SpecTrans
		datareceipt Nissan_CatalogUseExp
		datareceipt Nissan_CatalogStatusOld
		datareceipt Nissan_CatalogTypeControl
	serial # NNA Feeds
		datareceipt Nissan_SYNONYMS
		datareceipt VA_PARTS
		datareceipt NissanParts
		datareceipt NissanPrice
		datareceipt NissanServfile
		datareceipt NissanSupersession
		datareceipt ILLUSTRATION_CHANGE
		sql "truncate table pre_bl_nna_illust_master_w"
		datareceipt NNA_ILLUST_MASTER
	serial # SUPPORT AND FEATURE MAP
		datareceipt GEN_SBS_SUPPORT
		datareceipt GEN_FEATURE_MAP
	execute load_attachment_and_image_to_bl_wf
	serial # This step will Generate all BL Reports.
		set :grp_name = "'bl_reports'"
		execute rpt_generic_report_wf
	serial # This Step will generate Rowcount and Threshold report for BL schema.
		load :ct_rcth_schema_name = "select 'bl'"
		execute tool_rpt_rowcount_threshold
	serial # RDVT Reports Checks
		set :schema_name = "bl"
		set :cycle_status = "monthly"
		execute stop_due_to_failure 	
		execute exit_due_to_failure 	
	execute create_new_catalog_wf #New Catalog Entry
	execute dr_purge_wf
	serial # Feed To BL Completed Email
		set :v_process_name = "MWF_FEED_TO_BL_END"
		execute generic_email_wf
	output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  mwf_feed_to_bl_wf.wfl
  **
  */
raise notice '******************* SUCCESS!! Workflow import has completed. ****************************';
	
end;
$workflowcontext$ LANGUAGE 'plpgsql';
