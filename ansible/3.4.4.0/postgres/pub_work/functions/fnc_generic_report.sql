-- FUNCTION: pub_work.fnc_generic_report(character varying)

-- DROP FUNCTION IF EXISTS pub_work.fnc_generic_report(character varying);

CREATE OR REPLACE FUNCTION pub_work.fnc_generic_report(
	p_report_name character varying,
	OUT p_out_status character,
	OUT p_out_subject character varying,
	OUT p_out_body character varying,
	OUT p_out_filename character varying,
	OUT p_out_attachment text)
/*
  * <sbs_prolog>
  * project:  FORD NextGen Publishing
  * purpose:  This function is used by all reports configured in Automation framework. 
  *           This is a generic function which based on the input parameter report_name which fetch data from bl_sbs_report_meta table and 
  *                 required OUT variable are set accordingly. 
  * Postgres objects used:
  *    <object type> - <schema  owner> - <object name>
  *===========================================================
  * Revision History
  * ref #  date          revisor        comment
  * 1      20-JUL-2022     SM            Initial version
  * 2      28-SEP-2022     VB            Added if else condition on the report count as AF was failing to run the report if the query has no data.
  *                                      We will look into it again once CPAU-1095 is resolved in AF 1.6.
  * 3      14-OCT-2022     SA            Added the If-else condition on the column header as we dont always want column header in the report
                                         for eg. customer reports in Toyota.
  * 4      23-FEB-2023      RS            CYPUB-1129 : Added date parameter for report name.
  * 5       07-Jul-2023     BK          Added functionality to support threshold limit for a report.
  * 6      29-Aug-2023      BK          Renamed temporary view name to "temp_'||p_report_name||'_v" report header extraction, Added logic nullif(p_out_attachment,'') to support multilingual report data.
  * 7		8-Jan-2024		BK			FDNGPUB-1488 : Added step to create a Temp table of report data to avoid execution of report query sepratly for Count and report data.
										and Included option to set session level transaction for report query optimization.
  * 8      4-Feb-2026       CB          fnc_evaluate_bl_sbs_report_failures Added for Report Data Validation Tool Integration
 *===========================================================
  * revisor
  *   [initials]    [full name]
  *    SM            Smiley Mahajan 
  *    VB            Vikalp Bhatnagar
  *    SA            Sonu Aggarwal
  *    RS            Raminder Singh
  *    Bk            Bipin Kumar
  *    CB            Chandan Bhatia
  *===========================================================
  * </sbs_prolog>
  * <sbs_srctab owner="bl" name="bl_sbs_report_meta" />
  * insert all other tag comments that are relevant
*/
    RETURNS record
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE SECURITY DEFINER PARALLEL UNSAFE
AS $BODY$

declare
	p_count numeric;
	p_max_rows numeric;
	p_count_threshold numeric;
	p_publish_flag char;
	p_multilingual_flag char;
	p_out_query text;
	p_header text;
	p_header_flag char;
	p_string_agg text;
	p_format_query text;
	p_count_query text;
	p_final_query text;
	p_threshold_massege text;
	p_max_row_massege text;
	p_out_report_view_name text;
	p_out_report_table_name text;
	p_out_transaction_config text;
	p_rpt_row_create date;
	p_rpt_last_update date;
	p_rpt_exctn_tm date;
	p_table_exists char ;
begin
 /* Fetching the data from BL_SBS_REPORT_META Table and setting up the variables */
 select 'report_'||trim(lower(replace(p_report_name,' ','_'))), pt.report_status,pt.report_subject,pt.report_body,
 --pt.report_filename,
 /* <sbs_rule> Added date parameter for report name. </sbs_rule> */
 case 
     when report_date_required = 'Y'
     then concat(substr(pt.report_filename,1,length(pt.report_filename)-strpos(reverse(pt.report_filename),'.')),'_',to_char(current_date,'DD-Mon-YYYY'),substr(pt.report_filename,strpos(pt.report_filename,'.'))) 
     else pt.report_filename 
 end as report_filename,
 pt.report_query,pt.report_max_rows,pt.report_count_threshold,pt.report_publish_flag,
 pt.report_data_multilingual,pt.header_required,
 'report_'||trim(lower(replace(p_report_name,' ','_')))||'_v',
 pt.rpt_transaction_config,
 pt.row_last_update_ts,
 pt.row_create_ts
 into strict p_out_report_table_name, p_out_status, p_out_subject, p_out_body,
 p_out_filename,
 p_out_query,p_max_rows,p_count_threshold,p_publish_flag,p_multilingual_flag,p_header_flag,p_out_report_view_name,
 p_out_transaction_config,
 p_rpt_last_update,
 p_rpt_row_create
 from bl.bl_sbs_report_meta pt
 where pt.report_name = p_report_name;
 
  /* If report_publish_flag='Y' i.e. Report is to be published then the p_out_attachment variable is provided with the values returned by query else it remains empty */ 
 if p_publish_flag = 'Y' then 
 
	/*set session level transaction variable variable*/
	 if split_part(p_out_transaction_config,'_',1)= 'enable' then
		execute 'set local '|| p_out_transaction_config||' to true';
	 elsif split_part(p_out_transaction_config,'_',1)= 'disable' then
		execute 'set local '|| replace(p_out_transaction_config,'disable','enable')||' to false';
	 end if;
 
	/*Check if report table already exists*/
	select case when cnt > 0 then 'Y' else 'N' end as table_exist 
	into p_table_exists
	from(
	select count(1) cnt from information_schema.columns where table_schema='pub_work' and table_name = p_out_report_table_name
	) X;
		
	if p_table_exists ='Y' then
		 /* To get last report execution time of Records returned by Report Query */
		 p_count_query := 'select max(rpt_exctn_tm) rpt_exctn_tm from pub_work.'||p_out_report_table_name||';';
		 execute p_count_query into p_rpt_exctn_tm;
		
		/*check if there is any update in report query after last execution of report*/
		if coalesce(p_rpt_last_update,p_rpt_row_create) >= p_rpt_exctn_tm then 
			 /*Drop temp table and view if it is already exist due to any reason*/
			 execute 'drop view if exists pub_work.'||p_out_report_view_name||';';
			 execute 'drop table if exists pub_work.'||p_out_report_table_name||';';
			 
			  /* Creation of view to find the columns list and create temp table with report data */
			 execute 'create or replace view pub_work.'||p_out_report_view_name||' as ' || p_out_query || ';';
			
			 /* Setting up the p_header variable with the columns list */
			 select string_agg(column_name,',' order by ordinal_position) into p_header 
			 from information_schema.columns where table_schema='pub_work' and table_name = p_out_report_view_name;
			 
			 /*Creation of Temp table with help of temp view and this table will be use to fetch report count and report data as well*/
			 execute 'create table pub_work.'||p_out_report_table_name||' as select *, now() as rpt_exctn_tm from pub_work.'||p_out_report_view_name||';';
		
		elsif coalesce(p_rpt_last_update,p_rpt_row_create) < p_rpt_exctn_tm then /*when there no update in report after last execution*/
			/* Creation of view to find the columns list and load temp table with report data */
			execute 'create or replace view pub_work.'||p_out_report_view_name||' as ' || p_out_query || ';';
			
			/* Setting up the p_header variable with the columns list */
			select string_agg(column_name,',' order by ordinal_position) into p_header 
			from information_schema.columns where table_schema='pub_work' and table_name = p_out_report_view_name;
			 
			 /*Truncate rpt_ table*/
			execute 'Truncate table '||p_out_report_table_name|| ';';
			 
			 /*Insert report data from view to table*/
			execute 'insert into pub_work.'||p_out_report_table_name||' ('||p_header||',rpt_exctn_tm ) select '||p_header||', now() as rpt_exctn_tm from pub_work.'||p_out_report_view_name||';'; 
		end if;
	elsif p_table_exists ='N' then
		/* Creation of view to find the columns list and create temp table with report data */
		 execute 'create or replace view pub_work.'||p_out_report_view_name||' as ' || p_out_query || ';';
		
		 /* Setting up the p_header variable with the columns list */
		 select string_agg(column_name,',' order by ordinal_position) into p_header 
		 from information_schema.columns where table_schema='pub_work' and table_name = p_out_report_view_name;
		 
		 /*Creation of Temp table with help of temp view and this table will be use to fetch report count and report data as well*/
		 execute 'create table pub_work.'||p_out_report_table_name||' as select *, now() as rpt_exctn_tm from pub_work.'||p_out_report_view_name||';';
	end if;

	execute 'Analyse verbose '||p_out_report_table_name|| ';';
	
	/*Added for Report Data Validation Tool Integration*/
	 perform pub_work.fnc_evaluate_bl_sbs_report_failures (p_report_name,p_out_report_table_name);

	 /* Count of Records returned by Report Query */
	 p_count_query := 'select count(1) from pub_work.'||p_out_report_table_name||';';
	 execute p_count_query into p_count;
	 
	 /* Setting up the p_string_agg variable */
	 select replace(p_header,',',','','',') into p_string_agg;  
	 
		if p_count > p_count_threshold and p_count_threshold > 0 then 
			p_threshold_massege:= chr(10)|| 'The record count of this report is exceeding its threshold value.' ||chr(10)||
			'The threshold value is set at ' ||p_count_threshold::varchar||' records, but this report is generating '||p_count::varchar||' records.';
		else
			p_threshold_massege:='';
		end if;

		if p_count > p_max_rows then 
			p_max_row_massege:= chr(10)||'Totals records generated for this report are '
			||p_count||' but this attached report is listing only first '||p_max_rows::varchar||' records.';
		else
			p_max_row_massege:='';
		end if;

		if p_count > p_max_rows and p_count > p_count_threshold then
			/* If Count of Records returned by Report Query is more than p_max_rows and p_count_threshold*/
			p_final_query:= 'select * from ' || p_out_report_table_name || ' pt limit '|| p_max_rows||' ';
			p_out_body := p_out_body || chr(10) ||p_max_row_massege||chr(10)|| p_threshold_massege;
		ELSIF p_count > p_max_rows and p_count <= p_count_threshold then
			/* If Count of Records returned by Report Query is more than p_max_rows and less than p_count_threshold*/
			p_final_query:= 'select * from ' || p_out_report_table_name || ' pt limit '|| p_max_rows||' ';
			p_out_body := p_out_body || chr(10) ||p_max_row_massege;
		ELSIF p_count < p_max_rows and p_count > p_count_threshold then
			/* If Count of Records returned by Report Query is less than p_max_rows and more than p_count_threshold*/
			p_final_query:= 'select * from ' || p_out_report_table_name || ' pt';
			p_out_body := p_out_body ||chr(10)|| p_threshold_massege;
		ELSIF p_count > p_count_threshold then
			/* If Count of Records returned by Report Query is more than p_count_threshold and p_max_rows is null */
			p_final_query:= 'select * from ' || p_out_report_table_name || ' pt';
			p_out_body := p_out_body ||chr(10)|| p_threshold_massege;
		ELSIF p_count > p_max_rows then
			/* If Count of Records returned by Report Query is more than p_max_rows and p_count_threshold is null */
			p_final_query:= 'select * from ' || p_out_report_table_name || ' pt limit '|| p_max_rows||' ';
			p_out_body := p_out_body || chr(10) ||p_max_row_massege;
		else
			p_final_query := 'select * from ' || p_out_report_table_name || ' pt';
		end if;
		
		/* If report count is greater than Zero/Threshold then only report will be generated*/
		if p_count > coalesce(p_count_threshold,0) then 
			if p_header_flag = 'Y' then
				/* Formating of the Query to generate the Report Content with headers */ 
				p_format_query := 'select '''||p_header||'''||chr(10)||
								string_agg(concat('||p_string_agg||
								'),
					chr(10)) as report from ('|| p_final_query || ')d';
				else
				/* Formating of the Query to generate the Report Content without headers */ 
				p_format_query := 'select 
								string_agg(concat('||p_string_agg||
								'),
					chr(10)) as report from ('|| p_final_query || ')d';
				end if;
		else
			p_format_query := 'select ''''';
		end if; 
		
		/* Set the data in p_out_attachment variable */
		execute p_format_query into p_out_attachment;
		p_out_attachment := nullif(p_out_attachment,''); 
		/* If Report Content contains the International Characters i.e. Multilingual Data*/
		if p_multilingual_flag = 'Y' then 
			select af_repo.rft_utf_bom()||p_out_attachment::bytea into p_out_attachment;
		end if;
		
		/*Insert a current date in report table if there is no report data available*/
		if p_count = 0 then 
			execute 'insert into pub_work.'||p_out_report_table_name||' (rpt_exctn_tm ) select now() as rpt_exctn_tm;'; 
		end if;
		
 end if;   
end
$BODY$;

ALTER FUNCTION pub_work.fnc_generic_report(character varying)
    OWNER TO pub_work;
	
REVOKE EXECUTE ON FUNCTION pub_work.fnc_generic_report(character varying) FROM PUBLIC;