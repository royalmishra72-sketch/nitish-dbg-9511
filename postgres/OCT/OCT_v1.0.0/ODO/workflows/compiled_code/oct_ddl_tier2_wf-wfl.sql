do
$workflowcontext$
declare
    /* Export Version 1.7.2
    Exported on:   2024-06-19 09:53:23-04
    From Database: frd_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_view_list:   oct_ddl_tier2_wf.wfl
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
perform af_repo.fk_add_context('oct_ddl_tier2_wf'::varchar,'W'::varchar, 90::smallint, '(1.7.3.8)This workflow use to populate data from file to oct_ddl_tier2 table'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('Start'::varchar, 18::integer, 'output_version'::varchar, ''::varchar, 'main_10'::varchar, ''::varchar, ''::varchar, '    output_version'::varchar, 'oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_10'::varchar, 19::integer, 'output_options'::varchar, ''::varchar, 'main_20'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_20'::varchar, 20::integer, 'set'::varchar, ':tag_area|~|SD'::varchar, 'main_30'::varchar, ''::varchar, ''::varchar, '    set :tag_area = "SD"'::varchar, 'oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_30'::varchar, 21::integer, 'set'::varchar, ':tag_other|~|OCT'::varchar, 'main_40'::varchar, ''::varchar, ''::varchar, '    set :tag_other = "OCT"'::varchar, 'oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_40'::varchar, 22::integer, 'load'::varchar, ':exception_handler_email|~|select pub_admin.get_parameter(''OCT'')::jsonb->>''email_to'' AS email_to'::varchar, 'main_50'::varchar, ''::varchar, ''::varchar, '    load :exception_handler_email = "select pub_admin.get_parameter(''OCT'')::jsonb->>''email_to'' AS email_to"'::varchar, 'oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_50'::varchar, 23::integer, 'set'::varchar, ':file_buffersize_override|~|100000000'::varchar, 'main_60'::varchar, ''::varchar, ''::varchar, '    set :file_buffersize_override ="100000000"'::varchar, 'oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_60'::varchar, 24::integer, 'publish'::varchar, 'pub_work.file_oct_ddl_tier2'::varchar, 'main_70'::varchar, ''::varchar, ''::varchar, '    publish pub_work.file_oct_ddl_tier2 # To load oct_ddl_tier2 table'::varchar, 'oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('main_70'::varchar, 25::integer, 'output_options'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '    output_options'::varchar, 'oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.fk_add_step('ExceptionHandler'::varchar, 32767::integer, 'ExceptionHandler'::varchar, ''::varchar, 'Done'::varchar, ''::varchar, ''::varchar, '[EOF]'::varchar, 'oct_ddl_tier2_wf'::varchar, 'W'::varchar, 1::integer, 'mg7962'::varchar);
perform af_repo.af_compiler_insert('oct_ddl_tier2_wf.wfl', $q$#This workflow use to populate data from file to oct_ddl_tier2 table
oct_ddl_tier2_wf(retention=90): This workflow use to populate data from file to oct_ddl_tier2 table
# Project:  Ford NextGen Snap-on EPC
#
# Name: oct_ddl_tier2_wf.wfl
#
# Purpose:This workflow use to populate data into oct_ddl_tier2 table
#
#===========================================================
# Revision History
#   Ref   Date          Revisor      Comment
#   1     01-05-2024     BK           Initial Version
#===========================================================
# Revisor
# [Initials]		[Full Name]
# 	BK				Bipin Kumar
#===========================================================
    output_version
    output_options
    set :tag_area = "SD"
	set :tag_other = "OCT"
	load :exception_handler_email = "select pub_admin.get_parameter('OCT')::jsonb->>'email_to' AS email_to"
	set :file_buffersize_override ="100000000"
    publish pub_work.file_oct_ddl_tier2 # To load oct_ddl_tier2 table
    output_options$q$);
end;
$afcompiler$
LANGUAGE 'plpgsql';

 
  raise info 'Successfully imported and committed 1 workflow definitions';
  /* 
  ** Imported Workflows:
  oct_ddl_tier2_wf.wfl
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
