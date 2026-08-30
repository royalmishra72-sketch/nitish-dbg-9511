update bl.bl_sbs_report_meta set report_query='/**
	* <SBS_PROLOG>
	* PURPOSE:  This report is used to verify lucene files created in current pub run with 		previous run
	*===========================================================
	* REVISION HISTORY
	* REF #  DATE          REVISOR      COMMENT
	* 1      27-04-2026    RT			Initial version
	* 1      03-06-2026    RT			Report Query updated
	*===========================================================
	* Revisor
	* [initials]    [Full Name]
	*  RT            Richa Thakur
	*===========================================================
	* </SBS_PROLOG>
	* <SBS_SRCTAB owner="bl" name="bl.bl_sbs_report_failures" ></SBS_SRCTAB>
	* <SBS_SRCTAB owner="pub_work" name="pub_work.lvt_post_ctrg_lucene_data_w" ></SBS_SRCTAB>
	* <SBS_SRCTAB owner="pub_admin" name="pub_admin.pba_param_v" ></SBS_SRCTAB>
	* <SBS_PRCGRP name="lvt_lucene_verification_report"></SBS_PRCGRP>
**/
with old_luc_dtl as ( 
	select luc_file_name, luc_file_size::float, luc_file_create_ts from pub_work.lvt_post_ctrg_lucene_data_w where luc_dtl_file_type = ''lucene_detail_previous_run''
	), 
new_luc_dtl as ( 
	select luc_file_name, luc_file_size::float, luc_file_create_ts from pub_work.lvt_post_ctrg_lucene_data_w where luc_dtl_file_type = ''lucene_detail_current_run''
	),
luc_chg_per as (
	select param_value_txt::integer as lucene_change_percent, param_nm from pub_admin.pba_param_v where param_nm = ''LVT_LUCENE_DATA_CHANGE_PERCENT''
)
select ''"''||Issue||''"'' as observation,
''"''||Lucene_file_name||''"'' as lucene_file_name,
''"''||Issue_detail||''"'' as detail
 from (
/*<SBS_RULE> Below select to verify size reduction in Lucene files </SBS_RULE> */ 
select concat(''Lucene Size reduced by greater than or equal to '',lucene_change_percent,''% in Current pub run'') as Issue,
		luc.luc_file_name as Lucene_file_name,
		concat(''New file size : '',new_size,'' , Old file size : '',old_size,'' , Percent_change : '',percent_change,''%'') as Issue_detail
from ( select new_luc.luc_file_name,new_luc.luc_file_size new_size,old_luc.luc_file_size old_size, 
		case when new_luc.luc_file_size < old_luc.luc_file_size then 
		round((((old_luc.luc_file_size-new_luc.luc_file_size)/old_luc.luc_file_size)*100)::numeric ,2) 
		end percent_change from new_luc_dtl new_luc 
		inner join old_luc_dtl old_luc 
		on new_luc.luc_file_name=old_luc.luc_file_name 
	)luc cross join luc_chg_per where percent_change>=lucene_change_percent
	and not exists (select 1 from bl.bl_sbs_report_failures where report_name = ''lvt_lucene_verification_report'' and status = ''pass_after_failure'')
/*<SBS_RULE> Below union is to verify Lucene files present in previous run but not in the Current pub run </SBS_RULE> */
	union 
		select ''File Present in Previous run but not in the Current pub run'' as Issue,
		old_luc.luc_file_name as Lucene_file_name,
		concat(''Old file Size : '',old_luc.luc_file_size, '' , New file Size : '', new_luc.luc_file_size) as Issue_detail
		 from new_luc_dtl new_luc 
		right join old_luc_dtl old_luc
		on new_luc.luc_file_name=old_luc.luc_file_name 
		where new_luc.luc_file_name is null
	union
/*<SBS_RULE> Below union is to verify Lucene file not created in Current pub run </SBS_RULE> */	
		select ''Lucene file not created in Current pub run'' as Issue,
            new_luc.luc_file_name as Lucene_file_name,
            concat(''Newer Luc file timestamp is equal to Older file timestamp, New_file_ts : '', new_luc.luc_file_create_ts , '' , Old_file_ts : '', old_luc.luc_file_create_ts) as Issue_detail
        from new_luc_dtl new_luc 
        inner join old_luc_dtl old_luc 
            on new_luc.luc_file_name = old_luc.luc_file_name
        where new_luc.luc_file_create_ts <= old_luc.luc_file_create_ts)
	order by Issue, Lucene_file_name', row_last_update_ts=now() where report_name = 'lvt_lucene_verification_report';