do
$reports$
declare
    /* Export Version 1.7.3
    Exported on:   2024-06-04 06:54:58-04
    From Database: frd_pub_dev_1_db

    With parameters
      p_like_filter: no value passed
      p_report_list: oct_ddl_comparison
      p_user:        
    */
    v_version TEXT;
    v_ret     varchar;
    v_tmp     varchar;
begin
    v_version := '1.7.3';
    v_ret := '';

v_tmp := af_repo.rf_import_report_definition(
             p_version_txt            =>v_version,
             p_rpt_nm                 =>'oct_ddl_comparison',
             p_rpt_dsc                =>'OCT comparison report',
             p_rf_rpt_type_id         =>1,
             p_rpt_stndproc_nm        =>'pub_work.fnc_oct_ddl_comparison',
             p_rpt_retention_days     =>90,
             p_distribution_nm        =>'OCT',
             p_distribution_list      =>'bipin.kumar@snapon.com,richa.thakur@snapon.com,sonu.aggarwal@snapon.com,manish.khanna@snapon.com');
 
  raise info 'Successfully imported and committed 1 report definitions';
  raise info 'Imported report definitions: 
oct_ddl_comparison';
end;
$reports$
LANGUAGE 'plpgsql';
