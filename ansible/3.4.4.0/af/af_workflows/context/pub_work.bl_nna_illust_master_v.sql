do
$viewcontext$
declare
    /* Export Version 1.8.1
    Exported on:   2026-06-22 00:59:45-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: pub_work.bl_nna_illust_master_v
      p_view_list:   no value passed
      p_user:        pub_work
    */
    installCount int;
    property_key_count int;
    property_value_count int;
    v_version TEXT;
    v_state   TEXT;
    v_msg     TEXT;
    v_err_msg TEXT := '';
    v_detail  TEXT;
    v_hint    TEXT;
    v_context TEXT;
    v_tmp     varchar;
    v_ret     varchar;
    v_cnt     smallint;
    v_err_cnt smallint;
begin
    v_err_cnt := 0;
    v_ret := '';

v_tmp := af_repo.fk_import_view_context(p_version_tx=>'1.8.1',p_context_tx=>'pub_work.bl_nna_illust_master_v',p_source_view=>'pub_work.bl_nna_illust_master_v',p_pattern_name=>'__sbs_changesonly_v1_0',p_target_table=>'bl.bl_nna_illust_master',p_transaction_configuration_options=>'x<NULL>x',p_query_hint=>'x<NULL>x',p_partition_column_name=>'x<NULL>x',p_parallel_enabled=>-1::smallint,p_distinct_flag=>'t',p_do_exclusive_lock=>'t',p_lock_wait_minutes=>60::smallint,p_fnc_should_drop_indexes=>'x<NULL>x',p_drop_indexes=>'f',p_flow_table=>'pub_work.bl_nna_illust_master_v_flow',p_indicator_table=>'pub_work.bl_nna_illust_master_v_ind',p_target_index_name=>'bl_nna_illust_master_pkey',p_error_table=>'pub_work.bl_nna_illust_master_v_err',p_insert_flag=>'t',p_update_flag=>'t',p_lossy_fast_update=>'f',p_delete_flag=>'f',p_truncate_flag=>'f',p_indicator_column=>'x<NULL>x',p_group_table=>'x<NULL>x',p_group_column_null=>'x<NULL>x',p_key_id_used_flag=>'f',p_key_id_column=>'x<NULL>x',p_key_id_table=>'x<NULL>x',p_key_id_view=>'x<NULL>x',p_do_validations=>'t',p_do_not_null=>'f',p_do_pk=>'t',p_do_ri=>'f',p_flow_fk_list=>'x<NULL>x',p_do_uk=>'f',p_check_unique_index_list=>'x<NULL>x',p_do_check=>'t',p_check_clause=>'length(illust_no)<=	100 AND length(order_date)<= 8 AND length(delivery_date)<= 8 AND length(delivery_plan_date) <= 8 AND length(illust_co_code)<= 1 AND length(model)<= 10 AND length(model_year) <= 4 AND length(dest_code) <= 5 AND length(sec) <= 10 AND length(sec_dif) <= 2 AND length(illust_size_ind) <= 10 AND length(rec_date)<= 8 AND length(prerelease_ind)<= 10 AND length(field0)<= 100 AND length(field1) <= 100 AND length(field2) <= 100 AND length(field3) <= 100 AND length(field4) <= 100',p_error_limit=>'99%',p_recycle_errors=>'t',p_log_changes=>'f',p_add_columns_list=>'x<NULL>x',p_new_run=>'f',p_keep_days=>-1::smallint,p_file_load=>'f',p_file_insert_page_size=>-1,p_file_record_delimiter=>'x<NULL>x',p_file_column_start_list=>'x<NULL>x',p_file_column_delimiter=>'x<NULL>x',p_file_quotes=>'x<NULL>x',p_file_header_rows=>-1::smallint,p_file_escape_txt=>'x<NULL>x',p_file_ignore_extra_values=>'t',p_file_skip_blank_lines=>'t',p_file_force_null=>'f',p_file_encoding=>'x<NULL>x',p_file_column_list=>'x<NULL>x',p_file_skip_column_list=>'x<NULL>x',p_file_name_columns=>'x<NULL>x',p_file_content_columns=>'x<NULL>x',p_file_error_record_limit=>-1::smallint,p_file_save_record_number=>'f',p_file_record_number_column=>'x<NULL>x',p_file_save_filename=>'f',p_file_filename_column=>'x<NULL>x',p_file_constant_column_value=>'x<NULL>x',p_file_constant_value_column=>'x<NULL>x',p_tag_domain=>'x<NULL>x',p_tag_area=>'x<NULL>x',p_tag_feed=>'x<NULL>x',p_tag_other=>'x<NULL>x'
,p_folder_path=>'x<NULL>x',p_extended_mapping=>E'[{"f1":"3","f2":"delivery_date","f3":"regexp_replace(trim(f.delivery_date),''\\\\r|\\\\n'','''',''g'')"}, {"f1":"4","f2":"delivery_plan_date","f3":"regexp_replace(trim(f.delivery_plan_date),''\\\\r|\\\\n'','''',''g'')"}, {"f1":"8","f2":"dest_code","f3":"regexp_replace(trim(f.dest_code),''\\\\r|\\\\n'','''',''g'')"}, {"f1":"14","f2":"field0","f3":"regexp_replace(trim(f.field0),''\\\\r|\\\\n'','''',''g'')"}, {"f1":"15","f2":"field1","f3":"regexp_replace(trim(f.field1),''\\\\r|\\\\n'','''',''g'')"}, {"f1":"16","f2":"field2","f3":"regexp_replace(trim(f.field2),''\\\\r|\\\\n'','''',''g'')"}, {"f1":"17","f2":"field3","f3":"regexp_replace(trim(f.field3),''\\\\r|\\\\n'','''',''g'')"}, {"f1":"18","f2":"field4","f3":"regexp_replace(trim(f.field4),''\\\\r|\\\\n'','''',''g'')"}, {"f1":"5","f2":"illust_co_code","f3":"regexp_replace(trim(f.illust_co_code),''\\\\r|\\\\n'','''',''g'')"}, {"f1":"1","f2":"illust_no","f3":"regexp_replace(trim(f.illust_no),''\\\\r|\\\\n'','''',''g'')"}, {"f1":"11","f2":"illust_size_ind","f3":"regexp_replace(trim(f.illust_size_ind),''\\\\r|\\\\n'','''',''g'')"}, {"f1":"6","f2":"model","f3":"regexp_replace(trim(f.model),''\\\\r|\\\\n'','''',''g'')"}, {"f1":"7","f2":"model_year","f3":"regexp_replace(trim(f.model_year),''\\\\r|\\\\n'','''',''g'')"}, {"f1":"2","f2":"order_date","f3":"regexp_replace(trim(f.order_date),''\\\\r|\\\\n'','''',''g'')"}, {"f1":"13","f2":"prerelease_ind","f3":"regexp_replace(trim(f.prerelease_ind),''\\\\r|\\\\n'','''',''g'')"}, {"f1":"12","f2":"rec_date","f3":"regexp_replace(trim(f.rec_date),''\\\\r|\\\\n'','''',''g'')"}, {"f1":"9","f2":"sec","f3":"regexp_replace(trim(f.sec),''\\\\r|\\\\n'','''',''g'')"}, {"f1":"10","f2":"sec_dif","f3":"regexp_replace(trim(f.sec_dif),''\\\\r|\\\\n'','''',''g'')"}]',p_skip_columns=>'x<NULL>x'
,p_file_column_paths=>'x<NULL>x'
,p_comment_tx=>'NSPUB-1443');
 
-- Commit views to wide table
  raise info 'Successfully imported and committed 1 view definitions';
  raise info 'Imported view definitions 
pub_work.bl_nna_illust_master_v';
-- Now compile the views that were exported
v_cnt := 0;


begin 
  v_tmp := af_repo.fk_compile_options( p_context_tx =>'pub_work.bl_nna_illust_master_v',p_user_id=>'af_repo');
  v_ret := v_ret||chr(10)||'Compiled view: pub_work.bl_nna_illust_master_v';
  v_cnt := v_cnt + 1;              
exception
  when others then 
    get stacked diagnostics
     v_state   = returned_sqlstate,
     v_msg     = message_text,
     v_detail  = pg_exception_detail,
     v_hint    = pg_exception_hint,
     v_context = pg_exception_context;
     v_ret := v_ret||chr(10)||'View context <pub_work.bl_nna_illust_master_v> had compile failure: ' ||v_msg;
     v_err_cnt := v_err_cnt + 1;
     v_err_msg := v_err_msg||',pub_work.bl_nna_illust_master_v';
end;
  raise info '%', v_ret;
  raise info '% Compile failures encountered',v_err_cnt;
  if v_err_cnt > 0 then
    raise info 'Check logs % view(s) did not compile.
Views that failed to compile
%',v_err_cnt, v_err_msg;
  end if;
end;
$viewcontext$ 
LANGUAGE 'plpgsql';

