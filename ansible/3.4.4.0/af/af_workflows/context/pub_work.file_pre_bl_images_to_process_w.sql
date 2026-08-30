do
$viewcontext$
declare
    /* Export Version 1.8.1
    Exported on:   2026-06-22 00:59:25-04
    From Database: nis_pub_dev_1_db

    With parameters
      p_like_filter: pub_work.file_pre_bl_images_to_process_w
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

v_tmp := af_repo.fk_import_view_context(p_version_tx=>'1.8.1',p_context_tx=>'pub_work.file_pre_bl_images_to_process_w',p_source_view=>'file',p_pattern_name=>'__sbs_fileload_publite_v1_0',p_target_table=>'pub_work.pre_bl_images_to_process_w',p_transaction_configuration_options=>'x<NULL>x',p_query_hint=>'x<NULL>x',p_partition_column_name=>'x<NULL>x',p_parallel_enabled=>-1::smallint,p_distinct_flag=>'f',p_do_exclusive_lock=>'f',p_lock_wait_minutes=>-1::smallint,p_fnc_should_drop_indexes=>'x<NULL>x',p_drop_indexes=>'f',p_flow_table=>'x<NULL>x',p_indicator_table=>'x<NULL>x',p_target_index_name=>'x<NULL>x',p_error_table=>'x<NULL>x',p_insert_flag=>'t',p_update_flag=>'t',p_lossy_fast_update=>'f',p_delete_flag=>'t',p_truncate_flag=>'t',p_indicator_column=>'x<NULL>x',p_group_table=>'x<NULL>x',p_group_column_null=>'x<NULL>x',p_key_id_used_flag=>'f',p_key_id_column=>'x<NULL>x',p_key_id_table=>'x<NULL>x',p_key_id_view=>'x<NULL>x',p_do_validations=>'f',p_do_not_null=>'f',p_do_pk=>'f',p_do_ri=>'f',p_flow_fk_list=>'x<NULL>x',p_do_uk=>'f',p_check_unique_index_list=>'x<NULL>x',p_do_check=>'f',p_check_clause=>'x<NULL>x',p_error_limit=>'x<NULL>x',p_recycle_errors=>'f',p_log_changes=>'f',p_add_columns_list=>'x<NULL>x',p_new_run=>'f',p_keep_days=>-1::smallint,p_file_load=>'t',p_file_insert_page_size=>-1,p_file_record_delimiter=>E'\\n',p_file_column_start_list=>'x<NULL>x',p_file_column_delimiter=>'||',p_file_quotes=>'!NQ!',p_file_header_rows=>0::smallint,p_file_escape_txt=>'x<NULL>x',p_file_ignore_extra_values=>'t',p_file_skip_blank_lines=>'t',p_file_force_null=>'t',p_file_encoding=>'x<NULL>x',p_file_column_list=>'img_name,img_type',p_file_skip_column_list=>'x<NULL>x',p_file_name_columns=>'x<NULL>x',p_file_content_columns=>'x<NULL>x',p_file_error_record_limit=>-1::smallint,p_file_save_record_number=>'f',p_file_record_number_column=>'x<NULL>x',p_file_save_filename=>'f',p_file_filename_column=>'x<NULL>x',p_file_constant_column_value=>'x<NULL>x',p_file_constant_value_column=>'x<NULL>x',p_tag_domain=>'x<NULL>x',p_tag_area=>'x<NULL>x',p_tag_feed=>'x<NULL>x',p_tag_other=>'x<NULL>x'
,p_folder_path=>'x<NULL>x',p_extended_mapping=>'x<NULL>x',p_skip_columns=>'x<NULL>x'
,p_file_column_paths=>'x<NULL>x,x<NULL>x'
,p_comment_tx=>'Test');
 
-- Commit views to wide table
  raise info 'Successfully imported and committed 1 view definitions';
  raise info 'Imported view definitions 
pub_work.file_pre_bl_images_to_process_w';
-- Now compile the views that were exported
v_cnt := 0;


begin 
  v_tmp := af_repo.fk_compile_options( p_context_tx =>'pub_work.file_pre_bl_images_to_process_w',p_user_id=>'af_repo');
  v_ret := v_ret||chr(10)||'Compiled view: pub_work.file_pre_bl_images_to_process_w';
  v_cnt := v_cnt + 1;              
exception
  when others then 
    get stacked diagnostics
     v_state   = returned_sqlstate,
     v_msg     = message_text,
     v_detail  = pg_exception_detail,
     v_hint    = pg_exception_hint,
     v_context = pg_exception_context;
     v_ret := v_ret||chr(10)||'View context <pub_work.file_pre_bl_images_to_process_w> had compile failure: ' ||v_msg;
     v_err_cnt := v_err_cnt + 1;
     v_err_msg := v_err_msg||',pub_work.file_pre_bl_images_to_process_w';
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

