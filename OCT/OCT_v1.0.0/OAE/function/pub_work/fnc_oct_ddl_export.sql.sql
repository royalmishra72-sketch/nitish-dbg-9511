-- FUNCTION: pub_work.fnc_oct_ddl_export(character varying, character varying, character varying)

-- DROP FUNCTION IF EXISTS pub_work.fnc_oct_ddl_export(character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION pub_work.fnc_oct_ddl_export(
	p_in_schema_name character varying,
	p_in_object_type character varying,
	p_in_object_name character varying,
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
  * purpose:  This function is used to export DDL of the objects comapiled in database. and then these ddl will be used for comparison with other tiers objects DDL. 
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
	* <sbs_srctab owner="bl" name="bl_sbs_oct_meta_tables" />
	* <sbs_srctab owner="information_schema" name="columns" />
	* <sbs_srcfnc owner="pub_admin" name="get_parameter()" />
  * insert all other tag comments that are relevant
*/
declare
	p_meta_table_count numeric;
 	p_multilingual_flag char;
	p_out_query text;
	p_out_fi_query text;
	p_header text;
	p_format_query text;
	p_count_query text;
	p_final_query text;
 	p_meta_query1 text;
	p_meta_query2 text;
	p_ind_query text;
	schema_query text;
    object_type_query text; 
begin
/* To fix the Schemas name for with ddl need to be extracted*/
if p_in_schema_name ='ALL' or p_in_schema_name ='' then
	schema_query:= 'SELECT unnest(string_to_array(pub_admin.get_parameter(''OCT'')::jsonb->>''schema_ddl'','','')) AS schema_ddl';
else 
	schema_query:= 'select upper('||''''||p_in_schema_name||''''||')';
end if;

/* To fix the Object types for with ddl need to be extracted*/
if p_in_object_type ='ALL' or p_in_object_type ='' then
	object_type_query:= 'SELECT unnest(string_to_array(pub_admin.get_parameter(''OCT'')::jsonb->>''ddl_type'','','')) AS ddl_type';
else 
	object_type_query:= 'select upper('||''''||p_in_object_type||''''||')';
end if;

/* DDL query prepration*/
/* Fetching the data from BL_SBS_REPORT_META Table and setting up the variables */
select pt.report_status,concat('OCT: ',pt.report_subject,' from - ',Upper(split_part(current_database(),'_',1)||'_'||split_part(current_database(),'_',3)||'_'||split_part(current_database(),'_',4))),
concat(pt.report_body,Upper(split_part(current_database(),'_',1)||'_'||split_part(current_database(),'_',3)||'_'||split_part(current_database(),'_',4))) as report_body,
concat(split_part(current_database(),'_',1)||'_'||split_part(current_database(),'_',3)||'_'||split_part(current_database(),'_',4),'_',substr(pt.report_filename,1,length(pt.report_filename)-strpos(reverse(pt.report_filename),'.')),'_',to_char(current_date,'YYYYMMDD'),substr(pt.report_filename,strpos(pt.report_filename,'.'))) report_filename,
 pt.report_query, report_data_multilingual
 into strict p_out_status, p_out_subject, p_out_body, p_out_filename,
 p_out_query, p_multilingual_flag 
 from bl.bl_sbs_report_meta pt
 where pt.report_name = 'oct_ddl_export_report';
/*DDL query prepration */

/*Meta table query preparation*/
/* Fetching the data from bl.bl_sbs_oct_meta_tables Table where to_be_compare ='Y'*/
select 
string_agg('select '||''''||table_schema||''''||' as schema_name,''META_TABLE'' object_type,'||''''||table_name||''''||' as object_name,concat('||colums||') as combined_column from '||table_schema||'.'||table_name,' union all
') into p_meta_query1
from(
select table_schema,table_name,string_agg(column_name||'',',' order by ordinal_position) colums
from(
select cl.table_schema,cl.table_name, ''''||column_name||' - '||''''||' || '||column_name||'||'||''''||'## '||'''' as column_name,ordinal_position
from information_schema.columns cl
inner join bl.bl_sbs_oct_meta_tables mt on cl.table_schema =mt.schema_name and cl.table_name =mt.table_name
where to_be_compare='Y' and column_name not in('row_create_pe_session','row_create_ts','row_create_user_id','row_last_update_pe_session','row_last_update_ts','row_last_update_user_id','rowid','rcrd_create_ts','rcrd_create_user_id','rcrd_create_ip','rcrd_updt_ts','rcrd_updt_user_id','rcrd_updt_ip')
and column_name not in (select unnest(string_to_array(mt.exclude_columns,',')))
) x group by table_schema,table_name
) c;

p_meta_query2 := 'select schema_name,object_type,object_name, string_agg(combined_column,chr(10)) as definition
					from( ' ||p_meta_query1 ||') c group by schema_name,object_type,object_name';
/*meta table query*/

/*Add IDENTIFICATION ROW in Export file*/
p_ind_query:= 'select ''IDENTIFICATION - not a schema'' schema_name,
''IDENTIFICATION'' object_type,
''TIER NAME'' object_name,
encode(replace(split_part(current_database(),''_'',1)||''_''||split_part(current_database(),''_'',3)||''_''||split_part(current_database(),''_'',4),''\'',''\\'')::bytea,''hex'') as definition
union all
select ''IDENTIFICATION - not a schema'' as schema_name,
''IDENTIFICATION'' Object_type,
''FILE NAME'' Object_name, 
encode(replace('||''''||p_out_filename||''''||',''\'',''\\'')::bytea,''hex'') as definition
' ;
/* IDENTIFICATION ROW*/

/*combine DDL and Meta query*/
	select count(1) into p_meta_table_count from bl.bl_sbs_oct_meta_tables where to_be_compare='Y';
 /* If p_meta_table_count =0, i.e. There is no meta tables available for its data export. then only DDL will be exported*/ 

	if p_meta_table_count > 0 then 
		p_out_query:=p_out_query||' 
				union all
				'|| p_meta_query2;
	else 
		p_out_query:=p_out_query;
	end if;
/*combine DDL and Meta query*/

/*No Check need of object_name in query if input parameter is ALL or ''*/
if upper(p_in_object_name)='ALL' or p_in_object_name='' then
	p_out_fi_query:= 'select upper(schema_name) as schema_name,upper(object_type) as object_type,object_name,encode(replace(definition,''\'',''\\'')::bytea,''hex'') as definition
	from('||p_out_query||') X
	where upper(schema_name) in ( '||schema_query||' ) 
	and upper(object_type) in('||object_type_query||') 
	';
else 
	p_out_fi_query:= 'select upper(schema_name) as schema_name,upper(object_type) as object_type,object_name,encode(replace(definition,''\'',''\\'')::bytea,''hex'') as definition 
	from('||p_out_query||') X 
	where upper(schema_name) in ( '||schema_query||' ) 
	and upper(object_type) in('||object_type_query||') 
	and  object_name='||''''||p_in_object_name||''''||' 
	';
end if;
	/*Final query for p_out_attachment*/
	p_format_query:='select string_agg(concat(schema_name,'','',object_type,'','',''"'',object_name,''"'','','',definition),
					chr(10)) as report from ('||p_ind_query || ' union all ' || p_out_fi_query||') d 
					order by 1';
				raise notice 'Final Query:- %', p_format_query;			
	/* Set the data in p_out_attachment variable */
	execute p_format_query into p_out_attachment;
	p_out_attachment := nullif(p_out_attachment,''); 
end
$BODY$;

ALTER FUNCTION pub_work.fnc_oct_ddl_export(character varying, character varying, character varying)
    OWNER TO pub_work;
