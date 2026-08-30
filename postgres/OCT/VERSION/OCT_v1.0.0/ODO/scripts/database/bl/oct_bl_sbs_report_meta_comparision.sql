delete from bl.bl_sbs_report_meta where report_name='oct_ddl_comparison_report';
do $$
begin
IF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_schema = 'bl' 
        AND table_name = 'bl_sbs_report_meta' 
        AND column_name = 'report_group'
		) 
THEN
	INSERT INTO bl.bl_sbs_report_meta
(report_group, report_name, report_status, report_subject, report_body, report_filename, report_query, report_max_rows, report_data_multilingual, report_publish_flag, report_details, header_required, report_date_required, report_count_threshold)
VALUES('oct', 'oct_ddl_comparison_report', 'D', 'Comparison report', 'Please find attached comparison report of both environment.', 'comparison_report.csv', 'with ct_tier1 as (
select 
	coalesce(
		(select definition from pub_work.oct_ddl_tier1 t1 where t.object_name=t1.object_name and t1.object_name=''TIER NAME''),
		(select replace(definition,''rich_'','''') from pub_work.oct_ddl_tier1 t2 where t.object_name=t2.object_name and t2.object_name=''HOST NAME'')
			) as tier1
from pub_work.oct_ddl_tier1 t
where object_name=''TIER NAME'' or object_name = ''HOST NAME''
),
ct_tier2 as(
select 
	coalesce(
		(select definition from pub_work.oct_ddl_tier2 t1 where t.object_name=t1.object_name and t1.object_name=''TIER NAME''),
		(select replace(definition,''rich_'','''') from pub_work.oct_ddl_tier2 t2 where t.object_name=t2.object_name and t2.object_name=''HOST NAME'')
			) as tier2
from pub_work.oct_ddl_tier2 t
where object_name=''TIER NAME'' or object_name = ''HOST NAME''
),
diff_objects as(
select distinct schema_name,object_type,object_name,
tier1,
tier2,
REGEXP_REPLACE(first_value(env1_definition)over(partition by schema_name,object_type,object_name order by env1_definition), ''"'', ''""'',''g'') as env1_definition,
REGEXP_REPLACE(first_value(env2_definition)over (partition by schema_name,object_type,object_name order by env2_definition), ''"'', ''""'',''g'') as env2_definition
from(
	select
	coalesce(e1.schema_name,e2.schema_name) as schema_name,
	coalesce(e1.object_type,e2.object_type) as object_type,
	coalesce(e1.object_name,e2.object_name) as object_name,
	e1.definition as env1_definition,
	e2.definition as env2_definition
	from pub_work.oct_ddl_tier1 e1
	full outer join pub_work.oct_ddl_tier2 e2 
	on (e1.schema_name=e2.schema_name and e1.object_name=e2.object_name and e1.object_type=e2.object_type) -- or 1=1
	and 
	coalesce(replace(regexp_replace(e1.definition, ''[^[:print:]]'', '''', ''g''),'' '','''')::text,''#'')=
	coalesce(replace(regexp_replace(e2.definition, ''[^[:print:]]'', '''', ''g''),'' '','''')::text,''#'')
	) x 
	cross join ct_tier1
	cross join ct_tier2
--	where (env1_definition is null or env2_definition is null)
	where coalesce(env1_definition,env2_definition) is not null
	and object_type <> ''IDENTIFICATION''
-- and object_name=''pub_work.bl_vcis_car_v'' -- and object_type=''partition_name''
	),
	line_spliter as(
	select unnest(array[''PARTITION_NAME'',''CONTEXT_OPTIONS'']) as partition_name,
			unnest(array['','',''|'']) as spliter
	)
,unnest_array1 as(
select schema_name, object_type,object_name,--tier1,
unnest(array[string_to_array(env1_definition,coalesce(spliter,chr(10)))]) as env1_definition
from diff_objects  
left join line_spliter on diff_objects.object_type=line_spliter.partition_name
where env1_definition is not null and env2_definition is not null
) 
,unnest_array2 as(
select schema_name, object_type,object_name ,--tier2,
	unnest(array[string_to_array(env2_definition,coalesce(spliter,chr(10)))]) as env2_definition
from diff_objects  
left join line_spliter on diff_objects.object_type=line_spliter.partition_name
where env1_definition is not null and env2_definition is not null
)
,line_diff as(
select
schema_name,
object_type,
object_name,
REGEXP_REPLACE(string_agg(trim(env1_definition),chr(10) order by trim(env1_definition)), ''"'', ''""'',''g'') as env1_definition,
REGEXP_REPLACE(string_agg(trim(env2_definition),chr(10) order by trim(env2_definition)), ''"'', ''""'',''g'') as env2_definition
from(
select 
	coalesce(u1.schema_name,u2.schema_name) as schema_name,
	coalesce(u1.object_type,u2.object_type) as object_type,
	coalesce(u1.object_name,u2.object_name) as object_name,
	u1.env1_definition,
	u2.env2_definition
from unnest_array1 u1
full outer join unnest_array2 u2
on u1.schema_name=u2.schema_name and u1.object_type=u2.object_type and u1.object_name=u2.object_name 
and regexp_replace(replace(replace(replace(replace(trim(u1.env1_definition)::text,''"'',''''),'','',''''),'';'',''''),'' '',''''), ''[^[:print:]]'', '''', ''g'')::text=
	regexp_replace(replace(replace(replace(replace(trim(u2.env2_definition)::text,''"'',''''),'','',''''),'';'',''''),'' '',''''), ''[^[:print:]]'', '''', ''g'')::text
) X where env1_definition is null or env2_definition is null
group by schema_name,object_type,object_name
)
select 
schema_name,
object_type,
object_name,
checks,
 case when length(env1_line_diff ) > 32000 then ''Too large to store in csv.'' else env1_line_diff end as env1_line_diff,
 case when length(env2_line_diff ) > 32000 then ''Too large to store in csv.'' else env2_line_diff end as env2_line_diff,
env1_definition,
env2_definition
from(
	select 
	obd.schema_name,
	obd.object_type,
	''"'' || obd.object_name ||''"'' as object_name,
	''"'' || case when (obd.env1_definition is null ) then ''Exist on ''||obd.tier2||'' only''  
			when (obd.env2_definition is null ) then ''Exist on ''||obd.tier1||'' only''
			when (obd.env2_definition is not null and obd.env2_definition is not null) then ''Exist on both environment''
			end ||''"'' as checks,
	''"'' ||case when (obd.env1_definition is null or obd.env2_definition is null) then '''' 
		else 
			replace(replace(trim(trim(lined.env1_definition),'','')::text,''"'',''''),'';'','''')
		end  ||''"'' as env1_line_diff,
	''"'' ||case when (obd.env1_definition is null or obd.env2_definition is null) then '''' 
		else 
			replace(replace(trim(trim(lined.env2_definition),'','')::text,''"'',''''),'';'','''')
		end  ||''"''  as env2_line_diff,
	''"'' ||case when (obd.env1_definition is null or obd.env2_definition is null) then '''' 
			   when length(obd.env1_definition) > 32000 then ''Definition is too large to store in csv.''
		else
			obd.env1_definition
		end  ||''"'' as env1_definition,
	''"'' ||case when (obd.env1_definition is null or obd.env2_definition is null) then '''' 
				when length(obd.env2_definition) > 32000 then ''Definition is too large to store in csv.''
		else 
			obd.env2_definition
		end  ||''"'' as env2_definition
	from diff_objects obd
	left join line_diff lined
	on obd.schema_name=lined.schema_name and obd.object_type=lined.object_type and obd.object_name=lined.object_name
) X where coalesce(env1_line_diff,env2_line_diff,''#'')<>''#''
order by 2,1,4,3', NULL, 'N', 'Y', 'OCT', 'Y', 'Y', NULL);
Analyse verbose bl.bl_sbs_report_meta;
ELSE
	INSERT INTO bl.bl_sbs_report_meta
(report_name, report_status, report_subject, report_body, report_filename, report_query, report_max_rows, report_data_multilingual, report_publish_flag, report_details, header_required, report_date_required, report_count_threshold)
VALUES('oct_ddl_comparison_report', 'D', 'Comparison report', 'Please find attached comparison report of both environment.', 'comparison_report.csv', 'with ct_tier1 as (
select 
	coalesce(
		(select definition from pub_work.oct_ddl_tier1 t1 where t.object_name=t1.object_name and t1.object_name=''TIER NAME''),
		(select replace(definition,''rich_'','''') from pub_work.oct_ddl_tier1 t2 where t.object_name=t2.object_name and t2.object_name=''HOST NAME'')
			) as tier1
from pub_work.oct_ddl_tier1 t
where object_name=''TIER NAME'' or object_name = ''HOST NAME''
),
ct_tier2 as(
select 
	coalesce(
		(select definition from pub_work.oct_ddl_tier2 t1 where t.object_name=t1.object_name and t1.object_name=''TIER NAME''),
		(select replace(definition,''rich_'','''') from pub_work.oct_ddl_tier2 t2 where t.object_name=t2.object_name and t2.object_name=''HOST NAME'')
			) as tier2
from pub_work.oct_ddl_tier2 t
where object_name=''TIER NAME'' or object_name = ''HOST NAME''
),
diff_objects as(
select distinct schema_name,object_type,object_name,
tier1,
tier2,
REGEXP_REPLACE(first_value(env1_definition)over(partition by schema_name,object_type,object_name order by env1_definition), ''"'', ''""'',''g'') as env1_definition,
REGEXP_REPLACE(first_value(env2_definition)over (partition by schema_name,object_type,object_name order by env2_definition), ''"'', ''""'',''g'') as env2_definition
from(
	select
	coalesce(e1.schema_name,e2.schema_name) as schema_name,
	coalesce(e1.object_type,e2.object_type) as object_type,
	coalesce(e1.object_name,e2.object_name) as object_name,
	e1.definition as env1_definition,
	e2.definition as env2_definition
	from pub_work.oct_ddl_tier1 e1
	full outer join pub_work.oct_ddl_tier2 e2 
	on (e1.schema_name=e2.schema_name and e1.object_name=e2.object_name and e1.object_type=e2.object_type) -- or 1=1
	and 
	coalesce(replace(regexp_replace(e1.definition, ''[^[:print:]]'', '''', ''g''),'' '','''')::text,''#'')=
	coalesce(replace(regexp_replace(e2.definition, ''[^[:print:]]'', '''', ''g''),'' '','''')::text,''#'')
	) x 
	cross join ct_tier1
	cross join ct_tier2
--	where (env1_definition is null or env2_definition is null)
	where coalesce(env1_definition,env2_definition) is not null
	and object_type <> ''IDENTIFICATION''
-- and object_name=''pub_work.bl_vcis_car_v'' -- and object_type=''partition_name''
	),
	line_spliter as(
	select unnest(array[''PARTITION_NAME'',''CONTEXT_OPTIONS'']) as partition_name,
			unnest(array['','',''|'']) as spliter
	)
,unnest_array1 as(
select schema_name, object_type,object_name,--tier1,
unnest(array[string_to_array(env1_definition,coalesce(spliter,chr(10)))]) as env1_definition
from diff_objects  
left join line_spliter on diff_objects.object_type=line_spliter.partition_name
where env1_definition is not null and env2_definition is not null
) 
,unnest_array2 as(
select schema_name, object_type,object_name ,--tier2,
	unnest(array[string_to_array(env2_definition,coalesce(spliter,chr(10)))]) as env2_definition
from diff_objects  
left join line_spliter on diff_objects.object_type=line_spliter.partition_name
where env1_definition is not null and env2_definition is not null
)
,line_diff as(
select
schema_name,
object_type,
object_name,
REGEXP_REPLACE(string_agg(trim(env1_definition),chr(10) order by trim(env1_definition)), ''"'', ''""'',''g'') as env1_definition,
REGEXP_REPLACE(string_agg(trim(env2_definition),chr(10) order by trim(env2_definition)), ''"'', ''""'',''g'') as env2_definition
from(
select 
	coalesce(u1.schema_name,u2.schema_name) as schema_name,
	coalesce(u1.object_type,u2.object_type) as object_type,
	coalesce(u1.object_name,u2.object_name) as object_name,
	u1.env1_definition,
	u2.env2_definition
from unnest_array1 u1
full outer join unnest_array2 u2
on u1.schema_name=u2.schema_name and u1.object_type=u2.object_type and u1.object_name=u2.object_name 
and regexp_replace(replace(replace(replace(replace(trim(u1.env1_definition)::text,''"'',''''),'','',''''),'';'',''''),'' '',''''), ''[^[:print:]]'', '''', ''g'')::text=
	regexp_replace(replace(replace(replace(replace(trim(u2.env2_definition)::text,''"'',''''),'','',''''),'';'',''''),'' '',''''), ''[^[:print:]]'', '''', ''g'')::text
) X where env1_definition is null or env2_definition is null
group by schema_name,object_type,object_name
)
select 
schema_name,
object_type,
object_name,
checks,
 case when length(env1_line_diff ) > 32000 then ''Too large to store in csv.'' else env1_line_diff end as env1_line_diff,
 case when length(env2_line_diff ) > 32000 then ''Too large to store in csv.'' else env2_line_diff end as env2_line_diff,
env1_definition,
env2_definition
from(
	select 
	obd.schema_name,
	obd.object_type,
	''"'' || obd.object_name ||''"'' as object_name,
	''"'' || case when (obd.env1_definition is null ) then ''Exist on ''||obd.tier2||'' only''  
			when (obd.env2_definition is null ) then ''Exist on ''||obd.tier1||'' only''
			when (obd.env2_definition is not null and obd.env2_definition is not null) then ''Exist on both environment''
			end ||''"'' as checks,
	''"'' ||case when (obd.env1_definition is null or obd.env2_definition is null) then '''' 
		else 
			replace(replace(trim(trim(lined.env1_definition),'','')::text,''"'',''''),'';'','''')
		end  ||''"'' as env1_line_diff,
	''"'' ||case when (obd.env1_definition is null or obd.env2_definition is null) then '''' 
		else 
			replace(replace(trim(trim(lined.env2_definition),'','')::text,''"'',''''),'';'','''')
		end  ||''"''  as env2_line_diff,
	''"'' ||case when (obd.env1_definition is null or obd.env2_definition is null) then '''' 
			   when length(obd.env1_definition) > 32000 then ''Definition is too large to store in csv.''
		else
			obd.env1_definition
		end  ||''"'' as env1_definition,
	''"'' ||case when (obd.env1_definition is null or obd.env2_definition is null) then '''' 
				when length(obd.env2_definition) > 32000 then ''Definition is too large to store in csv.''
		else 
			obd.env2_definition
		end  ||''"'' as env2_definition
	from diff_objects obd
	left join line_diff lined
	on obd.schema_name=lined.schema_name and obd.object_type=lined.object_type and obd.object_name=lined.object_name
) X where coalesce(env1_line_diff,env2_line_diff,''#'')<>''#''
order by 2,1,4,3', NULL, 'N', 'Y', 'OCT', 'Y', 'Y', NULL);
Analyse verbose bl.bl_sbs_report_meta;
END IF;
END
$$ ;