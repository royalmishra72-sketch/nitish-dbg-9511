-- FUNCTION: pub_work.fnc_oct_ddl_comparison()

-- DROP FUNCTION IF EXISTS pub_work.fnc_oct_ddl_comparison();

CREATE OR REPLACE FUNCTION pub_work.fnc_oct_ddl_comparison(
	OUT p_out_status character,
	OUT p_out_subject character varying,
	OUT p_out_body character varying,
	OUT p_out_filename character varying,
	OUT p_out_attachment text)
    RETURNS record
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE SECURITY DEFINER PARALLEL UNSAFE
AS $BODY$

/*
  * <sbs_prolog>
  * project:  EPC5 NextGen Publishing
  * purpose:  This function is used to compare the data of table oct_ddl_tier1 and oct_ddl_tier2 and generates the report if differences found. 
  *           This is a OCT function which based on the input parameter report_name which fetch data from bl_sbs_report_meta table and 
  *                 required OUT variable are set accordingly. 
  * Postgres objects used:
  *    <object type> - <schema  owner> - <object name>
  *===========================================================
  * Revision History
  * ref #  date          revisor        comment
  * 1      10-Jun-2024     BK            Initial version
 *===========================================================
  * revisor
  *   [initials]    [full name]
  *    Bk            Bipin Kumar
  *===========================================================
  * </sbs_prolog>
  * <sbs_srctab owner="bl" name="bl_sbs_report_meta" />
  * <sbs_srctab owner="pub_work" name="oct_ddl_tier1" />
  * <sbs_srctab owner="pub_work" name="oct_ddl_tier2" />
  * insert all other tag comments that are relevant
*/
declare
 	p_out_query text;
	p_format_query text;
	p_header text;
	p_final_query text;
	p_tier1 text;
	p_tier2 text;
	p_line_diff_tier1 text;
	p_line_diff_tier2 text;
	p_tier1_deffinition text;
	p_tier2_deffinition text;
begin
/*report header*/
/*Prepare the report header, If object_name='HOST NAME' then remove the first part (rich_) from host name of table oct_ddl_tier1*/
	select definition, 
		case when object_name='HOST NAME' then 
			replace(definition,split_part(definition,'_',1)||'_','')||'_line_diff'
			else definition||'_line_diff'
			end,
		case when object_name='HOST NAME' then
			replace(definition,split_part(definition,'_',1)||'_','')||'_definition'
			else definition||'_definition'
			end
	into p_tier1,
	p_line_diff_tier1,
	p_tier1_deffinition 
	from (select object_name,
			coalesce(
				(select definition from pub_work.oct_ddl_tier1 t1 where t.object_name=t1.object_name and t1.object_name='TIER NAME'),
				(select definition from pub_work.oct_ddl_tier1 t2 where t.object_name=t2.object_name and t2.object_name='HOST NAME')
				) as definition
			from pub_work.oct_ddl_tier1 t
			where object_name='TIER NAME' or object_name = 'HOST NAME'
		 ) t1;
		 
/*Prepare the report header, If object_name='HOST NAME' then remove the first part (rich_) from host name of table oct_ddl_tier2*/
	select definition, 
	case when object_name='HOST NAME' then
		replace(definition,split_part(definition,'_',1)||'_','')||'_line_diff'
		else definition||'_line_diff'
		end,
	case when object_name='HOST NAME' then
		replace(definition,split_part(definition,'_',1)||'_','')||'_definition'
		else definition||'_definition'
		end
	into p_tier2,
	p_line_diff_tier2,
	p_tier2_deffinition
	from (select distinct object_name,
				coalesce(
				(select definition from pub_work.oct_ddl_tier2 t1 where t.object_name=t1.object_name and t1.object_name='TIER NAME'),
				(select definition from pub_work.oct_ddl_tier2 t2 where t.object_name=t2.object_name and t2.object_name='HOST NAME')
					) as definition
			from pub_work.oct_ddl_tier2 t
			where object_name='TIER NAME' or object_name = 'HOST NAME'
		 ) t2;
/*report header*/

	/* Fetching the data from BL_SBS_REPORT_META Table and setting up the variables */
	select  pt.report_status,'OCT: '|| p_tier1||' and '||p_tier2||' '||pt.report_subject,pt.report_body,
	  concat(replace(p_tier1,'rich_','')||'_and_'||replace(p_tier2,'rich_','')||' '|| substr(pt.report_filename,1,length(pt.report_filename)-strpos(reverse(pt.report_filename),'.')),'_',to_char(current_date,'YYYYMMDD'),substr(pt.report_filename,strpos(pt.report_filename,'.'))) report_filename,
	 pt.report_query,
	 'schema_name,object_type,object_name,checks,'||p_line_diff_tier1||','||p_line_diff_tier2||','||p_tier1_deffinition||','||p_tier2_deffinition
	/* Setting up the p_header variable with the columns list of report header */
	into strict p_out_status, p_out_subject, p_out_body, p_out_filename,
	 p_out_query, p_header
	 from bl.bl_sbs_report_meta pt
	 where pt.report_name = 'oct_ddl_comparison_report';
	 
	 /*Final query for p_out_attachment*/
	 p_format_query := 'select '''||p_header||'''||chr(10)||
					string_agg(concat(schema_name,'','',object_type,'','',object_name,'','',checks,'','',env1_line_diff,'','',env2_line_diff,'','',env1_definition,'','',env2_definition
					),
			chr(10)) as report from ('|| p_out_query || ')d';
			
	/* Set the data in p_out_attachment variable */
	execute p_format_query into p_out_attachment;
	p_out_attachment := nullif(p_out_attachment,''); 
end
$BODY$;

ALTER FUNCTION pub_work.fnc_oct_ddl_comparison()
    OWNER TO pub_work;
