do
$workflowcontext$
declare
    /* Export 1.8.1
    Exported on:   2026-06-19 06:43:55-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   new_catalog_data_check_wf.wfl
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
perform af_repo.fk_add_context('new_catalog_data_check_wf'::varchar,'W'::varchar, 90::smallint, '(1.8.1.0)This workflow will data check for new catalog'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 18::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 19::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 22::integer, 'load'::varchar, ':cats_marked_y|~|select concat(''MODEL: '', model,''; MODEL: '',model_desc,''; FROM: '',from_date,''; TO: '', to_date) from bl.bl_sbs_catalog c where status = ''N'' and 1000 < ( select count(1) from   bl.bl_f31x1470_catalog_parts bfxcp where  bfxcp.mdl_ser_code = c.model)'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    load :cats_marked_y = "select concat(''MODEL: '', model,''; MODEL: '',model_desc,''; FROM: '',from_date,''; TO: '', to_date) from bl.bl_sbs_catalog c where status = ''N'' and 1000 < ( select count(1) from   bl.bl_f31x1470_catalog_parts bfxcp where  bfxcp.mdl_ser_code = c.model)"				'::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 24::integer, 'if'::varchar, 'cats_marked_y is not None'::varchar, 'main_40'::varchar, 'main_110'::varchar, ''::varchar, '    if cats_marked_y is not None # Check parts data for new catalog '::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 25::integer, 'load'::varchar, ':message|~|select ''Following catalogs marked Status Y as parts data is now available in bl_f31x1470_catalog_parts. ''||chr(10)|| ''&&cats_marked_y&&'''::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '        load :message = "select ''Following catalogs marked Status Y as parts data is now available in bl_f31x1470_catalog_parts. ''||chr(10)|| ''&&cats_marked_y&&''"'::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 26::integer, 'set'::varchar, ':email_subject|~|Alert: Catalogs marked ''Y'' for Publishing'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '        set :email_subject = "Alert: Catalogs marked ''Y'' for Publishing"'::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 27::integer, 'set'::varchar, ':email_message|~|&&message&&'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '        set :email_message = " &&message&& "'::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 28::integer, 'load'::varchar, ':current_time_str|~|select to_char(current_timestamp, ''DD-MON-YYYY HH:MI:SS PM'')'::varchar, 'main_80'::varchar, ''::varchar, ''::varchar, '        load :current_time_str = "select to_char(current_timestamp, ''DD-MON-YYYY HH:MI:SS PM'')"'::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 29::integer, 'send_email'::varchar, ':email_list|~|&&email_subject&&: &&current_time_str&&|~|&&email_message&&'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '        send_email :email_list "&&email_subject&&: &&current_time_str&&" "&&email_message&&"'::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 30::integer, 'message'::varchar, '&&message&&'::varchar, 'main_100'::varchar, ''::varchar, ''::varchar, '        message " &&message&& "'::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 31::integer, 'sql'::varchar, 'update bl.bl_sbs_catalog c set status = ''Y'' where status = ''N'' and 1000 < ( select count(1) from  bl.bl_f31x1470_catalog_parts bfxcp where  bfxcp.mdl_ser_code = c.model)'::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '        sql "update bl.bl_sbs_catalog c set status = ''Y'' where status = ''N'' and 1000 < ( select count(1) from  bl.bl_f31x1470_catalog_parts bfxcp where  bfxcp.mdl_ser_code = c.model)"				'::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 33::integer, 'load'::varchar, ':new_catalogs|~|select  string_agg(model,'','' order by null)  as catalog   from   bl.bl_sbs_catalog c  where  c.status = ''Y''  and    model not in ( select code from ctrg.catalog )'::varchar, 'main_120'::varchar, ''::varchar, ''::varchar, '    load :new_catalogs = "select  string_agg(model,'','' order by null)  as catalog   from   bl.bl_sbs_catalog c  where  c.status = ''Y''  and    model not in ( select code from ctrg.catalog )" '::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 38::integer, 'foreach'::varchar, 'new_cat|~|:new_catalogs|~|main_130'::varchar, 'main_210'::varchar, ''::varchar, ''::varchar, '    foreach :new_cat in :new_catalogs # Check for each new catalog marked status = Y'::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 39::integer, 'load'::varchar, ':bl_sbs_section_count|~|select count(1) from bl.bl_sbs_section bss where bss.mdl_ser_code in ( ''&&new_cat&&'')'::varchar, 'main_140'::varchar, ''::varchar, ''::varchar, '        load :bl_sbs_section_count = "select count(1) from bl.bl_sbs_section bss where bss.mdl_ser_code in ( ''&&new_cat&&'')" '::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 40::integer, 'load'::varchar, ':bl_sbs_illust_count|~|select count(1) from bl.bl_sbs_illust where catalog in ( ''&&new_cat&&'')'::varchar, 'main_150'::varchar, ''::varchar, ''::varchar, '        load :bl_sbs_illust_count = "select count(1) from bl.bl_sbs_illust where catalog in ( ''&&new_cat&&'') " '::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 41::integer, 'load'::varchar, ':illustration_count|~|select count(1) from  bl.bl_sbs_illust si inner join bl.bl_image_data bid on  si.img_name = bid.img_name where si.catalog in ( ''&&new_cat&&'')'::varchar, 'main_160'::varchar, ''::varchar, ''::varchar, '        load :illustration_count = "select count(1) from  bl.bl_sbs_illust si inner join bl.bl_image_data bid on  si.img_name = bid.img_name where si.catalog in ( ''&&new_cat&&'')" '::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 42::integer, 'load'::varchar, ':message|~|select ''NEW CATALOG: ''||''&&new_cat&&''||chr(10)|| ''BL_SBS_SECTION_COUNT: ''||''&&bl_sbs_section_count&&''|| chr(10)|| ''BL_SBS_ILLUST_COUNT: ''||''&&bl_sbs_illust_count&&''|| chr(10)||''ILLUSTRATION_COUNT: ''|| ''&&illustration_count&&''||chr(10)||''NOTE: BL_SBS_SECTION_COUNT should be > 50, BL_SBS_ILLUST_COUNT should be > 100 AND ILLUSTRATION_COUNT should be > 100'''::varchar, 'main_170'::varchar, ''::varchar, ''::varchar, '        load :message = "select ''NEW CATALOG: ''||''&&new_cat&&''||chr(10)|| ''BL_SBS_SECTION_COUNT: ''||''&&bl_sbs_section_count&&''|| chr(10)|| ''BL_SBS_ILLUST_COUNT: ''||''&&bl_sbs_illust_count&&''|| chr(10)||''ILLUSTRATION_COUNT: ''|| ''&&illustration_count&&''||chr(10)||''NOTE: BL_SBS_SECTION_COUNT should be > 50, BL_SBS_ILLUST_COUNT should be > 100 AND ILLUSTRATION_COUNT should be > 100''"'::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_170'::varchar, 44::integer, 'if'::varchar, 'bl_sbs_section_count < 50 or bl_sbs_illust_count < 100 or illustration_count < 100'::varchar, 'main_180'::varchar, 'main_200'::varchar, ''::varchar, '        if bl_sbs_section_count < 50 or bl_sbs_illust_count < 100 or illustration_count < 100 '::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_180'::varchar, 45::integer, 'exit'::varchar, 'E|~|WARNING: &&message&&'::varchar, 'Done'::varchar, 'Done'::varchar, ''::varchar, '            exit E "WARNING: &&message&&"			 '::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_190'::varchar, 46::integer, 'else'::varchar, ''::varchar, 'main_200'::varchar, ''::varchar, ''::varchar, '        else '::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_200'::varchar, 47::integer, 'message'::varchar, ':message'::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '            message ":message"'::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('main_210'::varchar, 50::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'new_catalog_data_check_wf'::varchar, 'W'::varchar, 1::integer, 'af_repo'::varchar);
perform af_repo.af_compiler_insert('new_catalog_data_check_wf.wfl', $q$#This workflow will data check for new catalog
new_catalog_data_check_wf(retention=90): This workflow will data check for new catalog
# Project:  Nissan NG DATA PUBLISHING
#
# Name: new_catalog_data_check_wf.wfl
#
# Purpose: This workflow will data check for new catalog
#
#===========================================================
# Revision History
#   Ref   Date          Revisor      Comment
#   1     29-JAN-2025   CB           Initial Version
#===========================================================
# Revisor
# [Initials]		[Full Name]
# CB               Chandan Bhatia
#===========================================================
	output_version
	output_options


	load :cats_marked_y = "select concat('MODEL: ', model,'; MODEL: ',model_desc,'; FROM: ',from_date,'; TO: ', to_date) from bl.bl_sbs_catalog c where status = 'N' and 1000 < ( select count(1) from   bl.bl_f31x1470_catalog_parts bfxcp where  bfxcp.mdl_ser_code = c.model)"				

	if cats_marked_y is not None # Check parts data for new catalog 
		load :message = "select 'Following catalogs marked Status Y as parts data is now available in bl_f31x1470_catalog_parts. '||chr(10)|| '&&cats_marked_y&&'"
		set :email_subject = "Alert: Catalogs marked 'Y' for Publishing"
		set :email_message = " &&message&& "
		load :current_time_str = "select to_char(current_timestamp, 'DD-MON-YYYY HH:MI:SS PM')"
		send_email :email_list "&&email_subject&&: &&current_time_str&&" "&&email_message&&"
		message " &&message&& "
		sql "update bl.bl_sbs_catalog c set status = 'Y' where status = 'N' and 1000 < ( select count(1) from  bl.bl_f31x1470_catalog_parts bfxcp where  bfxcp.mdl_ser_code = c.model)"				

	load :new_catalogs = "select  string_agg(model,',' order by null)  as catalog  \
						from   bl.bl_sbs_catalog c \
						where  c.status = 'Y' \
						and    model not in ( select code from ctrg.catalog )" 
	
	foreach :new_cat in :new_catalogs # Check for each new catalog marked status = Y
		load :bl_sbs_section_count = "select count(1) from bl.bl_sbs_section bss where bss.mdl_ser_code in ( '&&new_cat&&')" 
		load :bl_sbs_illust_count = "select count(1) from bl.bl_sbs_illust where catalog in ( '&&new_cat&&') " 
		load :illustration_count = "select count(1) from  bl.bl_sbs_illust si inner join bl.bl_image_data bid on  si.img_name = bid.img_name where si.catalog in ( '&&new_cat&&')" 
		load :message = "select 'NEW CATALOG: '||'&&new_cat&&'||chr(10)|| 'BL_SBS_SECTION_COUNT: '||'&&bl_sbs_section_count&&'|| chr(10)|| 'BL_SBS_ILLUST_COUNT: '||'&&bl_sbs_illust_count&&'|| chr(10)||'ILLUSTRATION_COUNT: '|| '&&illustration_count&&'||chr(10)||'NOTE: BL_SBS_SECTION_COUNT should be > 50, BL_SBS_ILLUST_COUNT should be > 100 AND ILLUSTRATION_COUNT should be > 100'"
		
		if bl_sbs_section_count < 50 or bl_sbs_illust_count < 100 or illustration_count < 100 
			exit E "WARNING: &&message&&"			 
		else 
			message ":message"


	output_options
		
	$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  new_catalog_data_check_wf.wfl
  **
  */
raise notice '******************* SUCCESS!! Workflow import has completed. ****************************';
	
end;
$workflowcontext$ LANGUAGE 'plpgsql';
