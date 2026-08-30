do
$workflowcontext$
declare
    /* Export Version 1.7.2
    Exported on:   2024-01-16 23:55:52-05
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   archive_nissan_zip_data_wf.wfl
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
    v_version := '1.7.2';
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
perform af_repo.fk_add_context('archive_nissan_zip_data_wf'::varchar,'W'::varchar, 180::smallint, '(1.7.3)This workflow is used to archive NISSAN ZIP data.'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 18::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 19::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 20::integer, 'set'::varchar, ':tag_area|~|Feed to BL'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_area = "Feed to BL"'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 21::integer, 'set'::varchar, ':tag_other|~|Archive'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :tag_other = "Archive"'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 22::integer, 'load'::varchar, ':root_path|~|select pub_admin.get_parameter(''PBAEnvRootPath'')'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    load :root_path= "select pub_admin.get_parameter(''PBAEnvRootPath'')"'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 23::integer, 'load'::varchar, ':epo_path|~|select pub_admin.get_parameter(''PBAEPORootPath'')'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '    load :epo_path= "select pub_admin.get_parameter(''PBAEPORootPath'')"'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 24::integer, 'run'::varchar, '&&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD1 &&root_path&&/data/depot/archive/NML/CD1 CD1'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '    run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD1 &&root_path&&/data/depot/archive/NML/CD1 CD1'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 25::integer, 'run'::varchar, '&&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD2 &&root_path&&/data/depot/archive/NML/CD2 CD2'::varchar, 'main_80'::varchar, ''::varchar, ''::varchar, '    run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD2 &&root_path&&/data/depot/archive/NML/CD2 CD2'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_80'::varchar, 26::integer, 'run'::varchar, '&&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD4 &&root_path&&/data/depot/archive/NML/CD4 CD4'::varchar, 'main_90'::varchar, ''::varchar, ''::varchar, '    run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD4 &&root_path&&/data/depot/archive/NML/CD4 CD4'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_90'::varchar, 27::integer, 'run'::varchar, '&&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD5 &&root_path&&/data/depot/archive/NML/CD5 CD5'::varchar, 'main_100'::varchar, ''::varchar, ''::varchar, '    run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD5 &&root_path&&/data/depot/archive/NML/CD5 CD5'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_100'::varchar, 28::integer, 'run'::varchar, '&&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD6 &&root_path&&/data/depot/archive/NML/CD6 CD6'::varchar, 'main_110'::varchar, ''::varchar, ''::varchar, '    run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD6 &&root_path&&/data/depot/archive/NML/CD6 CD6 '::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_110'::varchar, 29::integer, 'run'::varchar, '&&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD7 &&root_path&&/data/depot/archive/NML/CD7 CD7'::varchar, 'main_120'::varchar, ''::varchar, ''::varchar, '    run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD7 &&root_path&&/data/depot/archive/NML/CD7 CD7'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_120'::varchar, 30::integer, 'run'::varchar, '&&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD3 &&root_path&&/data/depot/archive/NML/CD3 CD3'::varchar, 'main_130'::varchar, ''::varchar, ''::varchar, '    run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD3 &&root_path&&/data/depot/archive/NML/CD3 CD3'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_130'::varchar, 31::integer, 'run'::varchar, '&&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NNA/Parts &&root_path&&/data/depot/archive/NNA/Parts PARTS'::varchar, 'main_140'::varchar, ''::varchar, ''::varchar, '    run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NNA/Parts &&root_path&&/data/depot/archive/NNA/Parts PARTS'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_140'::varchar, 32::integer, 'run'::varchar, '&&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NNA/Supersession &&root_path&&/data/depot/archive/NNA/Supersession SUPERSESSION'::varchar, 'main_150'::varchar, ''::varchar, ''::varchar, '    run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NNA/Supersession &&root_path&&/data/depot/archive/NNA/Supersession SUPERSESSION'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_150'::varchar, 33::integer, 'run'::varchar, '&&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NNA/Price &&root_path&&/data/depot/archive/NNA/Price PRICE'::varchar, 'main_160'::varchar, ''::varchar, ''::varchar, '    run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NNA/Price &&root_path&&/data/depot/archive/NNA/Price PRICE'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_160'::varchar, 34::integer, 'run'::varchar, '&&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NNA/Servfile &&root_path&&/data/depot/archive/NNA/Servfile SERVFILE'::varchar, 'main_170'::varchar, ''::varchar, ''::varchar, '    run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NNA/Servfile &&root_path&&/data/depot/archive/NNA/Servfile SERVFILE'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_170'::varchar, 35::integer, 'run'::varchar, '&&root_path&&/app/script/archive_feeds.sh &&epo_path&&/GroupSectionFeed &&root_path&&/data/depot/archive/GroupSectionFeed GROUPSEC'::varchar, 'main_180'::varchar, ''::varchar, ''::varchar, '    run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/GroupSectionFeed &&root_path&&/data/depot/archive/GroupSectionFeed GROUPSEC'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_180'::varchar, 36::integer, 'run'::varchar, '&&root_path&&/app/script/archive_feeds.sh &&epo_path&&/Images/TextFeed &&root_path&&/data/depot/archive/Images/TextFeed IMAGE'::varchar, 'main_190'::varchar, ''::varchar, ''::varchar, '    run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/Images/TextFeed &&root_path&&/data/depot/archive/Images/TextFeed IMAGE'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_190'::varchar, 37::integer, 'run'::varchar, '&&root_path&&/app/script/archive_feeds.sh &&epo_path&&/VA_Parts &&root_path&&/data/depot/archive/VA_Parts VA_PARTS'::varchar, 'main_200'::varchar, ''::varchar, ''::varchar, '    run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/VA_Parts &&root_path&&/data/depot/archive/VA_Parts VA_PARTS'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_200'::varchar, 38::integer, 'run'::varchar, '&&root_path&&/app/script/archive_feeds.sh &&epo_path&&/Synonyms &&root_path&&/data/depot/archive/Synonyms MISC'::varchar, 'main_210'::varchar, ''::varchar, ''::varchar, '    run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/Synonyms &&root_path&&/data/depot/archive/Synonyms MISC'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_210'::varchar, 39::integer, 'run'::varchar, '&&root_path&&/app/script/archive_feeds.sh &&epo_path&&/CatalogPdf &&root_path&&/data/depot/archive/CatalogPdf CATALOGPDF'::varchar, 'main_220'::varchar, ''::varchar, ''::varchar, '    run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/CatalogPdf &&root_path&&/data/depot/archive/CatalogPdf CATALOGPDF'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('main_220'::varchar, 40::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'archive_nissan_zip_data_wf'::varchar, 'W'::varchar, 1::integer, 'bh8825'::varchar);
perform af_repo.af_compiler_insert('archive_nissan_zip_data_wf.wfl', $q$#workflow used to archive NISSAN ZIP data.
archive_nissan_zip_data_wf(retention=180):  This workflow is used to archive NISSAN ZIP data.
# Project:  NISSAN NG DATA PUBLISHING
#
# Name: archive_nissan_zip_data_wf.wfl
#
# Purpose:  This workflow is used to archive NISSAN ZIP data.
#
#===========================================================
# Revision History
#   Ref #  Date          Revisor      Comment
#   1     04-AUG-2023    NKM          Initial Version
#===========================================================
# Revisor
# [Initials]		[Full Name]
# NKM                Nitish Kumar Mishra
#===========================================================
	output_version
	output_options
	set :tag_area = "Feed to BL"
	set :tag_other = "Archive"
	load :root_path= "select pub_admin.get_parameter('PBAEnvRootPath')"
	load :epo_path= "select pub_admin.get_parameter('PBAEPORootPath')"
	run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD1 &&root_path&&/data/depot/archive/NML/CD1 CD1
	run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD2 &&root_path&&/data/depot/archive/NML/CD2 CD2
	run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD4 &&root_path&&/data/depot/archive/NML/CD4 CD4
	run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD5 &&root_path&&/data/depot/archive/NML/CD5 CD5
	run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD6 &&root_path&&/data/depot/archive/NML/CD6 CD6 
	run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD7 &&root_path&&/data/depot/archive/NML/CD7 CD7
	run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NML/Source/CD3 &&root_path&&/data/depot/archive/NML/CD3 CD3
	run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NNA/Parts &&root_path&&/data/depot/archive/NNA/Parts PARTS
	run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NNA/Supersession &&root_path&&/data/depot/archive/NNA/Supersession SUPERSESSION
	run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NNA/Price &&root_path&&/data/depot/archive/NNA/Price PRICE
	run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/NNA/Servfile &&root_path&&/data/depot/archive/NNA/Servfile SERVFILE
	run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/GroupSectionFeed &&root_path&&/data/depot/archive/GroupSectionFeed GROUPSEC
	run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/Images/TextFeed &&root_path&&/data/depot/archive/Images/TextFeed IMAGE
	run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/VA_Parts &&root_path&&/data/depot/archive/VA_Parts VA_PARTS
	run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/Synonyms &&root_path&&/data/depot/archive/Synonyms MISC
	run &&root_path&&/app/script/archive_feeds.sh &&epo_path&&/CatalogPdf &&root_path&&/data/depot/archive/CatalogPdf CATALOGPDF
	output_options
	
	
	
	$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  archive_nissan_zip_data_wf.wfl
  **
  */
raise notice '******************* SUCCESS!! Workflow import has completed. ****************************';
	
Exception 
		when others then 
		rollback;
		get stacked diagnostics
        v_state   = returned_sqlstate,
        v_msg     = message_text,
        v_detail  = pg_exception_detail,
        v_hint    = pg_exception_hint,
        v_context = pg_exception_context;

    raise notice E'Workflow import script ran into a problem. Exception details:
        state  : %
        message: %
        detail : %
        hint   : %
        context: %', v_state, v_msg, v_detail, v_hint, v_context;

end;
$workflowcontext$ LANGUAGE 'plpgsql';
