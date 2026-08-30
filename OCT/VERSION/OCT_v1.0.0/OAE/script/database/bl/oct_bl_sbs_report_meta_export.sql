delete from bl.bl_sbs_report_meta where report_name='oct_ddl_export_report';
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
(report_group,report_name, report_status, report_subject, report_body, report_filename, report_query, report_max_rows, report_data_multilingual, report_publish_flag, report_details, header_required, report_date_required, report_count_threshold)
VALUES('oct','oct_ddl_export_report', 'D', 'Export of objects DDL', 'Please find attached objects DDL export from - ', 'oct_ddl_export.csv', 'select schema_name,object_type,replace(object_name,''"'','''') as object_name,definition 
from 
(
with column_comment as (
select -- column_comment
table_schema,table_name,
string_agg(comments,
''
'' order by comments ) as col_comment
from(
SELECT c.table_schema,c.table_name, c.column_name, c.data_type,
	''COMMENT ON COLUMN ''||c.table_schema|| ''.'' ||c.table_name|| ''.''||c.column_name ||'' is ''|| ''''''''||replace(pgd.description,'''''''',''`'')||''''''''||'';'' as comments
from pg_catalog.pg_description pgd
inner join pg_catalog.pg_stat_all_tables st on (pgd.objoid=st.relid)
inner join information_schema.columns c on (pgd.objsubid=c.ordinal_position) and (c.table_schema=st.schemaname and c.table_name=st.relname)  
) x
group by table_schema,table_name
),
indexdefination as (-- indexes
select schemaname ,tablename , string_agg( indexdef,'';
''order by indexdef)||'';'' as indexdef
from pg_catalog.pg_indexes pi2 
where indexdef not like ''%UNIQUE%'' and indexdef not like ''CREATE INDEX mt_idx%''
group by schemaname ,tablename
)
select distinct x.nspname as schema_name, ''TABLE'' as object_type, x.relname::text as object_name,
concat(
''-- Table definition
'',
table_script,
''
'',
''-- indexes
'',
idx.indexdef,
''
'',
''-- column comments
'',
col_comment,''
	   '') as definition
from(
select pn.nspname, pc.relname, ''CREATE TABLE '' || pn.nspname || ''.'' || pc.relname || E''(\n''||
   string_agg(''	''||pa.attname || '' '' || pg_catalog.format_type(pa.atttypid, pa.atttypmod) || coalesce('' DEFAULT '' || (
                                                                                                               SELECT pg_catalog.pg_get_expr(d.adbin, d.adrelid)
                                                                                                               FROM pg_catalog.pg_attrdef d
                                                                                                               WHERE d.adrelid = pa.attrelid
                                                                                                                 AND d.adnum = pa.attnum
                                                                                                                 AND pa.atthasdef
                                                                                                               ),
                                                                                                 '''') || '' '' ||
              CASE pa.attnotnull
                  WHEN TRUE THEN ''NOT NULL''
                  ELSE ''NULL''
              END, E'',\n'' order by pa.attname ) ||
   coalesce((SELECT E'',\n	'' || string_agg(''CONSTRAINT '' || replace(pc1.conname,''_pkey1'',''_pkey'') || '' '' || 
   			replace(replace(replace(replace(replace(replace(
				 pg_get_constraintdef(pc1.oid)::text,''= ANY (ARRAY[('','' in ( '')
				,''= ANY ((ARRAY['','' in ( '')
				,''::character varying)::text, ('','','')
				,''::character varying, '','','')
				,''::character varying)::text])))'','')))'')
				,''::character varying])::text[])))'','')))'')	
   			, E'',\n'' ORDER BY pc1.conname)
            FROM pg_constraint pc1
            WHERE pc1.conrelid = pa.attrelid), '''') ||
   E''
   );'' as table_script
FROM pg_catalog.pg_attribute pa
JOIN pg_catalog.pg_class pc
    ON pc.oid = pa.attrelid
JOIN pg_catalog.pg_namespace pn
    ON pn.oid = pc.relnamespace
WHERE pa.attnum > 0
    AND NOT pa.attisdropped
	and pc.relname in (
			select distinct table_name
			from information_schema.columns
			where split_part(table_name,''_'',1) not in (''file'' ,''temp'', ''orabl'',''sdv'')
			and split_part(table_name,''_'',-1) not in (''hst'',''v'', ''ind'', ''flow'',''err'')
				and table_name not in ( -- Exlude partition tables 
				SELECT child.relname
				FROM pg_inherits
					JOIN pg_class parent        ON pg_inherits.inhparent = parent.oid
					JOIN pg_class child     ON pg_inherits.inhrelid   = child.oid
					JOIN pg_namespace nmsp_parent   ON nmsp_parent.oid  = parent.relnamespace
					JOIN pg_namespace nmsp_child    ON nmsp_child.oid   = child.relnamespace)
)
GROUP BY pn.nspname, pc.relname, pa.attrelid
	) X 
left join column_comment cc on cc.table_name=x.relname and cc.table_schema=x.nspname
left join indexdefination idx on idx.tablename=x.relname and idx.schemaname=x.nspname
where nspname not in(''af_repo'')
union all -- FUNCTION & PROCEDURE
SELECT n.nspname AS schema_name
	,case when prokind=''f'' then ''FUNCTION'' when prokind =''p'' then ''PROCEDURE'' else ''NA'' end as object_type 
    ,concat(proname,''('',  pg_get_function_arguments(p.oid)::text ,'')'') as object_name
    , pg_get_functiondef(p.oid) AS definition
FROM   pg_proc p
JOIN   pg_namespace n ON n.oid = p.pronamespace
where n.nspname not in(''af_repo'',''pg_catalog'') and prokind <> ''a''
union all /*VIEW*/
select distinct schemaname as schema_name, ''VIEW'' as onject_type, viewname as onject_name,
''Create or replace view ''||viewname||'' as 
''||replace(definition,schemaname||''.'','''')||'';
''as definition
from pg_catalog.pg_views 
where schemaname not in (''af_repo'' ) 
 and split_part(viewname,''_'',1) not in (''file'' ,''temp'', ''orabl'',''rg'',''mt'') 
union all /*PARTITIONS NAME*/
SELECT distinct nmsp_parent.nspname as schema_name,''PARTITION_NAME''as object_type, parent.relname as object_name, 
string_agg(child.relname,'','' order by child.relname) as definition
FROM pg_inherits
    JOIN pg_class parent        ON pg_inherits.inhparent = parent.oid
    JOIN pg_class child     ON pg_inherits.inhrelid   = child.oid
    JOIN pg_namespace nmsp_parent   ON nmsp_parent.oid  = parent.relnamespace
    JOIN pg_namespace nmsp_child    ON nmsp_child.oid   = child.relnamespace
where split_part(child.relname,''_'',-1) not in (''pkey'',''idx'',''idx1'',''idx2'',''idx3'',''idx4'')
and split_part(child.relname,''_'',1) not in(''mt'')
and split_part(parent.relname,''_'',1) not in(''mt'')
group by nmsp_parent.nspname, parent.relname
union all /*WORKFLOWS*/
select ''af_repo'' as schema_name,''WORKFLOW'' as object_type, name as Object_name, encode(source::bytea, ''escape'') as definition 
from af_repo.fk_af_compiler
union all /*CONTEXTS OPTIONS*/
select 
''af_repo'' as schema_name,''CONTEXT_OPTIONS'' as object_type, context_tx object_name,
concat
( 
concat(''source_view:-'', coalesce(source_view::varchar ,''NULL''), '' | '' ,''pattern_name:-'', coalesce(pattern_name::varchar ,''NULL''), '' | '' ,''target_table:-'', coalesce(target_table::varchar ,''NULL''), '' | '' ,''add_columns_list:-'', coalesce(add_columns_list::varchar ,''NULL''), '' | '' ,''check_clause:-'', coalesce(check_clause::varchar ,''NULL''), '' | '' ,''check_unique_index_list:-'', coalesce(check_unique_index_list::varchar ,''NULL''), '' | '' ,''delete_flag:-'', coalesce(delete_flag::varchar ,''NULL''), '' | '' ,''distinct_flag:-'', coalesce(distinct_flag::varchar ,''NULL''), '' | '' ,''do_check:-'', coalesce(do_check::varchar ,''NULL''), '' | '' ,''do_exclusive_lock:-'', coalesce(do_exclusive_lock::varchar ,''NULL''), '' | '' ,''do_not_null:-'', coalesce(do_not_null::varchar ,''NULL''), '' | '' ,''do_pk:-'', coalesce(do_pk::varchar ,''NULL''), '' | '' ,''do_ri:-'', coalesce(do_ri::varchar ,''NULL''), '' | '' ,''do_uk:-'', coalesce(do_uk::varchar ,''NULL''), '' | '' ,''do_validations:-'', coalesce(do_validations::varchar ,''NULL''), '' | '' ,''drop_indexes:-'', coalesce(drop_indexes::varchar ,''NULL''), '' | '' ,''error_limit:-'', coalesce(error_limit::varchar ,''NULL''), '' | '' ,''error_table:-'', coalesce(error_table::varchar ,''NULL''), '' | '' ,''extended_column_mapping:-'', coalesce(extended_column_mapping::varchar ,''NULL''), '' | '' ,''file_column_delimiter:-'', coalesce(file_column_delimiter::varchar ,''NULL''), '' | '' ,''file_column_list:-'', coalesce(file_column_list::varchar ,''NULL''), '' | '' ,''file_column_start_list:-'', coalesce(file_column_start_list::varchar ,''NULL''), '' | ''),
concat(''file_constant_column_value:-'', coalesce(file_constant_column_value::varchar ,''NULL''), '' | '' ,''file_constant_value_column:-'', coalesce(file_constant_value_column::varchar ,''NULL''), '' | '' ,''file_content_columns:-'', coalesce(file_content_columns::varchar ,''NULL''), '' | '' ,''file_encoding:-'', coalesce(file_encoding::varchar ,''NULL''), '' | '' ,''file_error_record_limit:-'', coalesce(file_error_record_limit::varchar ,''NULL''), '' | '' ,''file_escape_txt:-'', coalesce(file_escape_txt::varchar ,''NULL''), '' | '' ,''file_filename_column:-'', coalesce(file_filename_column::varchar ,''NULL''), '' | '' ,''file_force_null:-'', coalesce(file_force_null::varchar ,''NULL''), '' | '' ,''file_header_rows:-'', coalesce(file_header_rows::varchar ,''NULL''), '' | '' ,''file_ignore_extra_values:-'', coalesce(file_ignore_extra_values::varchar ,''NULL''), '' | '' ,''file_insert_page_size:-'', coalesce(file_insert_page_size::varchar ,''NULL''), '' | '' ,''file_load:-'', coalesce(file_load::varchar ,''NULL''), '' | '' ,''file_name_columns:-'', coalesce(file_name_columns::varchar ,''NULL''), '' | '' ,''file_quotes:-'', coalesce(file_quotes::varchar ,''NULL''), '' | '' ,''file_record_delimiter:-'', coalesce(file_record_delimiter::varchar ,''NULL''), '' | '' ,''file_record_number_column:-'', coalesce(file_record_number_column::varchar ,''NULL''), '' | '' ,''file_save_filename:-'', coalesce(file_save_filename::varchar ,''NULL''), '' | '' ,''file_save_record_number:-'', coalesce(file_save_record_number::varchar ,''NULL''), '' | '' ,''file_skip_blank_lines:-''),
concat(coalesce(file_skip_blank_lines::varchar ,''NULL''), '' | '' ,''file_skip_column_list:-'', coalesce(file_skip_column_list::varchar ,''NULL''), '' | '' ,''fk_constraints:-'', coalesce(fk_constraints::varchar ,''NULL''), '' | '' ,''flow_table:-'', coalesce(flow_table::varchar ,''NULL''), '' | '' ,''fnc_should_drop_indexes:-'', coalesce(fnc_should_drop_indexes::varchar ,''NULL''), '' | '' ,''group_column_null:-'', coalesce(group_column_null::varchar ,''NULL''), '' | '' ,''group_table:-'', coalesce(group_table::varchar ,''NULL''), '' | '' ,''indicator_column:-'', coalesce(indicator_column::varchar ,''NULL''), '' | '' ,''indicator_table:-'', coalesce(indicator_table::varchar ,''NULL''), '' | '' ,''insert_flag:-'', coalesce(insert_flag::varchar ,''NULL''), '' | '' ,''keep_days:-'', coalesce(keep_days::varchar ,''NULL''), '' | '' ,''key_id_column:-'', coalesce(key_id_column::varchar ,''NULL''), '' | '' ,''key_id_table:-'', coalesce(key_id_table::varchar ,''NULL''), '' | '' ,''key_id_used_flag:-'', coalesce(key_id_used_flag::varchar ,''NULL''), '' | '' ,''key_id_view:-'', coalesce(key_id_view::varchar ,''NULL''), '' | '' ,''lock_wait_minutes:-'', coalesce(lock_wait_minutes::varchar ,''NULL''), '' | '' ,''log_changes:-'', coalesce(log_changes::varchar ,''NULL''), '' | '' ,''lossy_fast_update:-'', coalesce(lossy_fast_update::varchar ,''NULL''), '' | '' ,''new_run:-'', coalesce(new_run::varchar ,''NULL''), '' | '' ),
concat(''parallel_enabled:-'', coalesce(parallel_enabled::varchar ,''NULL''), '' | '' ,''partition_column_name:-'', coalesce(partition_column_name::varchar ,''NULL''), '' | '' ,''query_hint:-'', coalesce(query_hint::varchar ,''NULL''), '' | '' ,''recycle_errors:-'', coalesce(recycle_errors::varchar ,''NULL''), '' | '',''target_index_name:-'', coalesce(target_index_name::varchar ,''NULL''), '' | '' ,''transaction_configuration_options:-'', coalesce(transaction_configuration_options::varchar ,''NULL''), '' | '' ,''truncate_flag:-'', coalesce(truncate_flag::varchar ,''NULL''), '' | '' ,''update_flag:-'', coalesce(update_flag::varchar ,''NULL''))
)
FROM af_repo.fk_view_context_options_v
union all /*SCHEMA SIZE*/
select schema_name, ''SCHEMA_SIZE'' as object_type, schema_name as object_name, schema_size as definition 
from(
SELECT schema_name, 
       pg_size_pretty(sum(table_size)::bigint) as schema_size
FROM (
  SELECT pg_catalog.pg_namespace.nspname as schema_name,
         pg_relation_size(pg_catalog.pg_class.oid) as table_size
  FROM   pg_catalog.pg_class
     JOIN pg_catalog.pg_namespace ON relnamespace = pg_catalog.pg_namespace.oid
) t
GROUP BY schema_name
ORDER BY schema_name
	) X

) x
union all /*GRANTS*/
select object_schema as schema_name,  ''GRANTS'' object_type,object_name, 
string_agg(''Grantee:-''||grantee ||''|''|| '' Privileges: ''||privilegess,chr(10) order by grantee) as definition
from(
WITH rol AS (
    SELECT oid,
            rolname::text AS role_name
        FROM pg_roles
    UNION
    SELECT 0::oid AS oid,
            ''public''::text
),
schemas AS ( -- Schemas
    SELECT oid AS schema_oid,
            n.nspname::text AS schema_name,
            n.nspowner AS owner_oid,
            ''schema''::text AS object_type,
            coalesce ( n.nspacl, acldefault ( ''n''::"char", n.nspowner ) ) AS acl
        FROM pg_catalog.pg_namespace n
        WHERE n.nspname !~ ''^pg_''
            AND n.nspname <> ''information_schema''
)
,classes AS ( -- Tables, views, etc.
    SELECT schemas.schema_oid,
            schemas.schema_name AS object_schema,
            c.oid,
            c.relname::text AS object_name,
            c.relowner AS owner_oid,
            CASE
                WHEN c.relkind = ''r'' THEN ''table''
                WHEN c.relkind = ''v'' THEN ''view''
                WHEN c.relkind = ''m'' THEN ''materialized view''
                WHEN c.relkind = ''c'' THEN ''type''
                WHEN c.relkind = ''i'' THEN ''index''
                WHEN c.relkind = ''S'' THEN ''sequence''
                WHEN c.relkind = ''s'' THEN ''special''
                WHEN c.relkind = ''t'' THEN ''TOAST table''
                WHEN c.relkind = ''f'' THEN ''foreign table''
                WHEN c.relkind = ''p'' THEN ''partitioned table''
                WHEN c.relkind = ''I'' THEN ''partitioned index''
                ELSE c.relkind::text
                END AS object_type,
            CASE
                WHEN c.relkind = ''S'' THEN coalesce ( c.relacl, acldefault ( ''s''::"char", c.relowner ) )
                ELSE coalesce ( c.relacl, acldefault ( ''r''::"char", c.relowner ) )
                END AS acl
        FROM pg_class c
        JOIN schemas
            ON ( schemas.schema_oid = c.relnamespace )
        WHERE c.relkind IN ( ''r'', ''v'', ''m'', ''S'', ''f'', ''p'' )
),
cols AS ( -- Columns
    SELECT c.object_schema,
            null::integer AS oid,
            c.object_name || ''.'' || a.attname::text AS object_name,
            ''column'' AS object_type,
            c.owner_oid,
            coalesce ( a.attacl, acldefault ( ''c''::"char", c.owner_oid ) ) AS acl
        FROM pg_attribute a
        JOIN classes c
            ON ( a.attrelid = c.oid )
        WHERE a.attnum > 0
            AND NOT a.attisdropped
),
procs AS ( -- Procedures and functions
    SELECT schemas.schema_oid,
            schemas.schema_name AS object_schema,
            p.oid,
            p.proname::text AS object_name,
            p.proowner AS owner_oid,
            CASE p.prokind
                WHEN ''a'' THEN ''aggregate''
                WHEN ''w'' THEN ''window''
                WHEN ''p'' THEN ''procedure''
                ELSE ''function''
                END AS object_type,
            pg_catalog.pg_get_function_arguments ( p.oid ) AS calling_arguments,
            coalesce ( p.proacl, acldefault ( ''f''::"char", p.proowner ) ) AS acl
        FROM pg_proc p
        JOIN schemas
            ON ( schemas.schema_oid = p.pronamespace )
),
udts AS ( -- User defined types
    SELECT schemas.schema_oid,
            schemas.schema_name AS object_schema,
            t.oid,
            t.typname::text AS object_name,
            t.typowner AS owner_oid,
            CASE t.typtype
                WHEN ''b'' THEN ''base type''
                WHEN ''c'' THEN ''composite type''
                WHEN ''d'' THEN ''domain''
                WHEN ''e'' THEN ''enum type''
                WHEN ''t'' THEN ''pseudo-type''
                WHEN ''r'' THEN ''range type''
                WHEN ''m'' THEN ''multirange''
                ELSE t.typtype::text
                END AS object_type,
            coalesce ( t.typacl, acldefault ( ''T''::"char", t.typowner ) ) AS acl
        FROM pg_type t
        JOIN schemas
            ON ( schemas.schema_oid = t.typnamespace )
        WHERE ( t.typrelid = 0
                OR ( SELECT c.relkind = ''c''
                        FROM pg_catalog.pg_class c
                        WHERE c.oid = t.typrelid ) )
            AND NOT EXISTS (
                SELECT 1
                    FROM pg_catalog.pg_type el
                    WHERE el.oid = t.typelem
                        AND el.typarray = t.oid )
),
fdws AS ( -- Foreign data wrappers
    SELECT null::oid AS schema_oid,
            null::text AS object_schema,
            p.oid,
            p.fdwname::text AS object_name,
            p.fdwowner AS owner_oid,
            ''foreign data wrapper'' AS object_type,
            coalesce ( p.fdwacl, acldefault ( ''F''::"char", p.fdwowner ) ) AS acl
        FROM pg_foreign_data_wrapper p
),
fsrvs AS ( -- Foreign servers
    SELECT null::oid AS schema_oid,
            null::text AS object_schema,
            p.oid,
            p.srvname::text AS object_name,
            p.srvowner AS owner_oid,
            ''foreign server'' AS object_type,
            coalesce ( p.srvacl, acldefault ( ''S''::"char", p.srvowner ) ) AS acl
        FROM pg_foreign_server p
),
all_objects AS (
    SELECT schema_name AS object_schema,
            object_type,
            schema_name AS object_name,
            null::text AS calling_arguments,
            owner_oid,
            acl
        FROM schemas
    UNION
    SELECT object_schema,
            object_type,
            object_name,
            null::text AS calling_arguments,
            owner_oid,
            acl
        FROM classes
    UNION
    SELECT object_schema,
            object_type,
            object_name,
            null::text AS calling_arguments,
            owner_oid,
            acl
        FROM cols
    UNION
    SELECT object_schema,
            object_type,
            object_name,
            calling_arguments,
            owner_oid,
            acl
        FROM procs
    UNION
    SELECT object_schema,
            object_type,
            object_name,
            null::text AS calling_arguments,
            owner_oid,
            acl
        FROM udts
    UNION
    SELECT object_schema,
            object_type,
            object_name,
            null::text AS calling_arguments,
            owner_oid,
            acl
        FROM fdws
    UNION
    SELECT object_schema,
            object_type,
            object_name,
            null::text AS calling_arguments,
            owner_oid,
            acl
        FROM fsrvs
),
acl_base AS (
    SELECT object_schema,
            object_type,
            object_name,
            calling_arguments,
            owner_oid,
            ( aclexplode ( acl ) ).grantor AS grantor_oid,
            ( aclexplode ( acl ) ).grantee AS grantee_oid,
            ( aclexplode ( acl ) ).privilege_type AS privilege_type,
            ( aclexplode ( acl ) ).is_grantable AS is_grantable
        FROM all_objects
)
select object_schema,object_type,object_name,grantee,string_agg(distinct privilege_type,'','' order by privilege_type)  privilegess from (
SELECT acl_base.object_schema,
        acl_base.object_type,
        acl_base.object_name,
        acl_base.calling_arguments,
        owner.role_name AS object_owner,
        grantor.role_name AS grantor,
        grantee.role_name AS grantee,
        acl_base.privilege_type,
        acl_base.is_grantable
    FROM acl_base
    JOIN rol owner
        ON ( owner.oid = acl_base.owner_oid )
    JOIN rol grantor
        ON ( grantor.oid = acl_base.grantor_oid )
    JOIN rol grantee
        ON ( grantee.oid = acl_base.grantee_oid )
    WHERE acl_base.grantor_oid <> acl_base.grantee_oid ) q
where object_schema not in (''af_repo'',''af_repo_app'') and grantee not in(''lt'')  -- and  object_name=''part_item''
	and object_name not in (
		SELECT
    	child.relname       AS child
		FROM pg_inherits
	    JOIN pg_class parent            ON pg_inherits.inhparent = parent.oid
	    JOIN pg_class child             ON pg_inherits.inhrelid   = child.oid
	    JOIN pg_namespace nmsp_parent   ON nmsp_parent.oid  = parent.relnamespace
	    JOIN pg_namespace nmsp_child    ON nmsp_child.oid   = child.relnamespace
		)
and split_part(object_name,''_'',1) not in (''file'' ,''temp'', ''orabl'',''sdv'',''mt'')
and split_part(object_name,''_'',-1) not in (''hst'', ''ind'', ''flow'',''err'')
group by object_schema,object_type,object_name,grantee
order by object_schema,object_type,object_name,grantee
) Gr
group by object_schema,object_type,object_name', NULL, 'N', 'Y', 'OCT', 'N', 'Y', NULL);

Analyse verbose bl.bl_sbs_report_meta;		

ELSE
	INSERT INTO bl.bl_sbs_report_meta
(report_name, report_status, report_subject, report_body, report_filename, report_query, report_max_rows, report_data_multilingual, report_publish_flag, report_details, header_required, report_date_required, report_count_threshold
)
VALUES('oct_ddl_export_report', 'D', 'Export of objects DDL', 'Please find attached objects DDL export from - ', 'oct_ddl_export.csv', 'select schema_name,object_type,replace(object_name,''"'','''') as object_name,definition 
from 
(
with column_comment as (
select -- column_comment
table_schema,table_name,
string_agg(comments,
''
'' order by comments ) as col_comment
from(
SELECT c.table_schema,c.table_name, c.column_name, c.data_type,
	''COMMENT ON COLUMN ''||c.table_schema|| ''.'' ||c.table_name|| ''.''||c.column_name ||'' is ''|| ''''''''||replace(pgd.description,'''''''',''`'')||''''''''||'';'' as comments
from pg_catalog.pg_description pgd
inner join pg_catalog.pg_stat_all_tables st on (pgd.objoid=st.relid)
inner join information_schema.columns c on (pgd.objsubid=c.ordinal_position) and (c.table_schema=st.schemaname and c.table_name=st.relname)  
) x
group by table_schema,table_name
),
indexdefination as (-- indexes
select schemaname ,tablename , string_agg( indexdef,'';
''order by indexdef)||'';'' as indexdef
from pg_catalog.pg_indexes pi2 
where indexdef not like ''%UNIQUE%'' and indexdef not like ''CREATE INDEX mt_idx%''
group by schemaname ,tablename
)
select distinct x.nspname as schema_name, ''TABLE'' as object_type, x.relname::text as object_name,
concat(
''-- Table definition
'',
table_script,
''
'',
''-- indexes
'',
idx.indexdef,
''
'',
''-- column comments
'',
col_comment,''
	   '') as definition
from(
select pn.nspname, pc.relname, ''CREATE TABLE '' || pn.nspname || ''.'' || pc.relname || E''(\n''||
   string_agg(''	''||pa.attname || '' '' || pg_catalog.format_type(pa.atttypid, pa.atttypmod) || coalesce('' DEFAULT '' || (
                                                                                                               SELECT pg_catalog.pg_get_expr(d.adbin, d.adrelid)
                                                                                                               FROM pg_catalog.pg_attrdef d
                                                                                                               WHERE d.adrelid = pa.attrelid
                                                                                                                 AND d.adnum = pa.attnum
                                                                                                                 AND pa.atthasdef
                                                                                                               ),
                                                                                                 '''') || '' '' ||
              CASE pa.attnotnull
                  WHEN TRUE THEN ''NOT NULL''
                  ELSE ''NULL''
              END, E'',\n'' order by pa.attname ) ||
   coalesce((SELECT E'',\n	'' || string_agg(''CONSTRAINT '' || replace(pc1.conname,''_pkey1'',''_pkey'') || '' '' || 
   			replace(replace(replace(replace(replace(replace(
				 pg_get_constraintdef(pc1.oid)::text,''= ANY (ARRAY[('','' in ( '')
				,''= ANY ((ARRAY['','' in ( '')
				,''::character varying)::text, ('','','')
				,''::character varying, '','','')
				,''::character varying)::text])))'','')))'')
				,''::character varying])::text[])))'','')))'')	
   			, E'',\n'' ORDER BY pc1.conname)
            FROM pg_constraint pc1
            WHERE pc1.conrelid = pa.attrelid), '''') ||
   E''
   );'' as table_script
FROM pg_catalog.pg_attribute pa
JOIN pg_catalog.pg_class pc
    ON pc.oid = pa.attrelid
JOIN pg_catalog.pg_namespace pn
    ON pn.oid = pc.relnamespace
WHERE pa.attnum > 0
    AND NOT pa.attisdropped
	and pc.relname in (
			select distinct table_name
			from information_schema.columns
			where split_part(table_name,''_'',1) not in (''file'' ,''temp'', ''orabl'',''sdv'')
			and split_part(table_name,''_'',-1) not in (''hst'',''v'', ''ind'', ''flow'',''err'')
				and table_name not in ( -- Exlude partition tables 
				SELECT child.relname
				FROM pg_inherits
					JOIN pg_class parent        ON pg_inherits.inhparent = parent.oid
					JOIN pg_class child     ON pg_inherits.inhrelid   = child.oid
					JOIN pg_namespace nmsp_parent   ON nmsp_parent.oid  = parent.relnamespace
					JOIN pg_namespace nmsp_child    ON nmsp_child.oid   = child.relnamespace)
)
GROUP BY pn.nspname, pc.relname, pa.attrelid
	) X 
left join column_comment cc on cc.table_name=x.relname and cc.table_schema=x.nspname
left join indexdefination idx on idx.tablename=x.relname and idx.schemaname=x.nspname
where nspname not in(''af_repo'')
union all -- FUNCTION & PROCEDURE
SELECT n.nspname AS schema_name
	,case when prokind=''f'' then ''FUNCTION'' when prokind =''p'' then ''PROCEDURE'' else ''NA'' end as object_type 
    ,concat(proname,''('',  pg_get_function_arguments(p.oid)::text ,'')'') as object_name
    , pg_get_functiondef(p.oid) AS definition
FROM   pg_proc p
JOIN   pg_namespace n ON n.oid = p.pronamespace
where n.nspname not in(''af_repo'',''pg_catalog'') and prokind <> ''a''
union all /*VIEW*/
select distinct schemaname as schema_name, ''VIEW'' as onject_type, viewname as onject_name,
''Create or replace view ''||viewname||'' as 
''||replace(definition,schemaname||''.'','''')||'';
''as definition
from pg_catalog.pg_views 
where schemaname not in (''af_repo'' ) 
 and split_part(viewname,''_'',1) not in (''file'' ,''temp'', ''orabl'',''rg'',''mt'') 
union all /*PARTITIONS NAME*/
SELECT distinct nmsp_parent.nspname as schema_name,''PARTITION_NAME''as object_type, parent.relname as object_name, 
string_agg(child.relname,'','' order by child.relname) as definition
FROM pg_inherits
    JOIN pg_class parent        ON pg_inherits.inhparent = parent.oid
    JOIN pg_class child     ON pg_inherits.inhrelid   = child.oid
    JOIN pg_namespace nmsp_parent   ON nmsp_parent.oid  = parent.relnamespace
    JOIN pg_namespace nmsp_child    ON nmsp_child.oid   = child.relnamespace
where split_part(child.relname,''_'',-1) not in (''pkey'',''idx'',''idx1'',''idx2'',''idx3'',''idx4'')
and split_part(child.relname,''_'',1) not in(''mt'')
and split_part(parent.relname,''_'',1) not in(''mt'')
group by nmsp_parent.nspname, parent.relname
union all /*WORKFLOWS*/
select ''af_repo'' as schema_name,''WORKFLOW'' as object_type, name as Object_name, encode(source::bytea, ''escape'') as definition 
from af_repo.fk_af_compiler
union all /*CONTEXTS OPTIONS*/
select 
''af_repo'' as schema_name,''CONTEXT_OPTIONS'' as object_type, context_tx object_name,
concat
( 
concat(''source_view:-'', coalesce(source_view::varchar ,''NULL''), '' | '' ,''pattern_name:-'', coalesce(pattern_name::varchar ,''NULL''), '' | '' ,''target_table:-'', coalesce(target_table::varchar ,''NULL''), '' | '' ,''add_columns_list:-'', coalesce(add_columns_list::varchar ,''NULL''), '' | '' ,''check_clause:-'', coalesce(check_clause::varchar ,''NULL''), '' | '' ,''check_unique_index_list:-'', coalesce(check_unique_index_list::varchar ,''NULL''), '' | '' ,''delete_flag:-'', coalesce(delete_flag::varchar ,''NULL''), '' | '' ,''distinct_flag:-'', coalesce(distinct_flag::varchar ,''NULL''), '' | '' ,''do_check:-'', coalesce(do_check::varchar ,''NULL''), '' | '' ,''do_exclusive_lock:-'', coalesce(do_exclusive_lock::varchar ,''NULL''), '' | '' ,''do_not_null:-'', coalesce(do_not_null::varchar ,''NULL''), '' | '' ,''do_pk:-'', coalesce(do_pk::varchar ,''NULL''), '' | '' ,''do_ri:-'', coalesce(do_ri::varchar ,''NULL''), '' | '' ,''do_uk:-'', coalesce(do_uk::varchar ,''NULL''), '' | '' ,''do_validations:-'', coalesce(do_validations::varchar ,''NULL''), '' | '' ,''drop_indexes:-'', coalesce(drop_indexes::varchar ,''NULL''), '' | '' ,''error_limit:-'', coalesce(error_limit::varchar ,''NULL''), '' | '' ,''error_table:-'', coalesce(error_table::varchar ,''NULL''), '' | '' ,''extended_column_mapping:-'', coalesce(extended_column_mapping::varchar ,''NULL''), '' | '' ,''file_column_delimiter:-'', coalesce(file_column_delimiter::varchar ,''NULL''), '' | '' ,''file_column_list:-'', coalesce(file_column_list::varchar ,''NULL''), '' | '' ,''file_column_start_list:-'', coalesce(file_column_start_list::varchar ,''NULL''), '' | ''),
concat(''file_constant_column_value:-'', coalesce(file_constant_column_value::varchar ,''NULL''), '' | '' ,''file_constant_value_column:-'', coalesce(file_constant_value_column::varchar ,''NULL''), '' | '' ,''file_content_columns:-'', coalesce(file_content_columns::varchar ,''NULL''), '' | '' ,''file_encoding:-'', coalesce(file_encoding::varchar ,''NULL''), '' | '' ,''file_error_record_limit:-'', coalesce(file_error_record_limit::varchar ,''NULL''), '' | '' ,''file_escape_txt:-'', coalesce(file_escape_txt::varchar ,''NULL''), '' | '' ,''file_filename_column:-'', coalesce(file_filename_column::varchar ,''NULL''), '' | '' ,''file_force_null:-'', coalesce(file_force_null::varchar ,''NULL''), '' | '' ,''file_header_rows:-'', coalesce(file_header_rows::varchar ,''NULL''), '' | '' ,''file_ignore_extra_values:-'', coalesce(file_ignore_extra_values::varchar ,''NULL''), '' | '' ,''file_insert_page_size:-'', coalesce(file_insert_page_size::varchar ,''NULL''), '' | '' ,''file_load:-'', coalesce(file_load::varchar ,''NULL''), '' | '' ,''file_name_columns:-'', coalesce(file_name_columns::varchar ,''NULL''), '' | '' ,''file_quotes:-'', coalesce(file_quotes::varchar ,''NULL''), '' | '' ,''file_record_delimiter:-'', coalesce(file_record_delimiter::varchar ,''NULL''), '' | '' ,''file_record_number_column:-'', coalesce(file_record_number_column::varchar ,''NULL''), '' | '' ,''file_save_filename:-'', coalesce(file_save_filename::varchar ,''NULL''), '' | '' ,''file_save_record_number:-'', coalesce(file_save_record_number::varchar ,''NULL''), '' | '' ,''file_skip_blank_lines:-''),
concat(coalesce(file_skip_blank_lines::varchar ,''NULL''), '' | '' ,''file_skip_column_list:-'', coalesce(file_skip_column_list::varchar ,''NULL''), '' | '' ,''fk_constraints:-'', coalesce(fk_constraints::varchar ,''NULL''), '' | '' ,''flow_table:-'', coalesce(flow_table::varchar ,''NULL''), '' | '' ,''fnc_should_drop_indexes:-'', coalesce(fnc_should_drop_indexes::varchar ,''NULL''), '' | '' ,''group_column_null:-'', coalesce(group_column_null::varchar ,''NULL''), '' | '' ,''group_table:-'', coalesce(group_table::varchar ,''NULL''), '' | '' ,''indicator_column:-'', coalesce(indicator_column::varchar ,''NULL''), '' | '' ,''indicator_table:-'', coalesce(indicator_table::varchar ,''NULL''), '' | '' ,''insert_flag:-'', coalesce(insert_flag::varchar ,''NULL''), '' | '' ,''keep_days:-'', coalesce(keep_days::varchar ,''NULL''), '' | '' ,''key_id_column:-'', coalesce(key_id_column::varchar ,''NULL''), '' | '' ,''key_id_table:-'', coalesce(key_id_table::varchar ,''NULL''), '' | '' ,''key_id_used_flag:-'', coalesce(key_id_used_flag::varchar ,''NULL''), '' | '' ,''key_id_view:-'', coalesce(key_id_view::varchar ,''NULL''), '' | '' ,''lock_wait_minutes:-'', coalesce(lock_wait_minutes::varchar ,''NULL''), '' | '' ,''log_changes:-'', coalesce(log_changes::varchar ,''NULL''), '' | '' ,''lossy_fast_update:-'', coalesce(lossy_fast_update::varchar ,''NULL''), '' | '' ,''new_run:-'', coalesce(new_run::varchar ,''NULL''), '' | '' ),
concat(''parallel_enabled:-'', coalesce(parallel_enabled::varchar ,''NULL''), '' | '' ,''partition_column_name:-'', coalesce(partition_column_name::varchar ,''NULL''), '' | '' ,''query_hint:-'', coalesce(query_hint::varchar ,''NULL''), '' | '' ,''recycle_errors:-'', coalesce(recycle_errors::varchar ,''NULL''), '' | '',''target_index_name:-'', coalesce(target_index_name::varchar ,''NULL''), '' | '' ,''transaction_configuration_options:-'', coalesce(transaction_configuration_options::varchar ,''NULL''), '' | '' ,''truncate_flag:-'', coalesce(truncate_flag::varchar ,''NULL''), '' | '' ,''update_flag:-'', coalesce(update_flag::varchar ,''NULL''))
)
FROM af_repo.fk_view_context_options_v
union all /*SCHEMA SIZE*/
select schema_name, ''SCHEMA_SIZE'' as object_type, schema_name as object_name, schema_size as definition 
from(
SELECT schema_name, 
       pg_size_pretty(sum(table_size)::bigint) as schema_size
FROM (
  SELECT pg_catalog.pg_namespace.nspname as schema_name,
         pg_relation_size(pg_catalog.pg_class.oid) as table_size
  FROM   pg_catalog.pg_class
     JOIN pg_catalog.pg_namespace ON relnamespace = pg_catalog.pg_namespace.oid
) t
GROUP BY schema_name
ORDER BY schema_name
	) X

) x
union all /*GRANTS*/
select object_schema as schema_name,  ''GRANTS'' object_type,object_name, 
string_agg(''Grantee:-''||grantee ||''|''|| '' Privileges: ''||privilegess,chr(10) order by grantee) as definition
from(
WITH rol AS (
    SELECT oid,
            rolname::text AS role_name
        FROM pg_roles
    UNION
    SELECT 0::oid AS oid,
            ''public''::text
),
schemas AS ( -- Schemas
    SELECT oid AS schema_oid,
            n.nspname::text AS schema_name,
            n.nspowner AS owner_oid,
            ''schema''::text AS object_type,
            coalesce ( n.nspacl, acldefault ( ''n''::"char", n.nspowner ) ) AS acl
        FROM pg_catalog.pg_namespace n
        WHERE n.nspname !~ ''^pg_''
            AND n.nspname <> ''information_schema''
)
,classes AS ( -- Tables, views, etc.
    SELECT schemas.schema_oid,
            schemas.schema_name AS object_schema,
            c.oid,
            c.relname::text AS object_name,
            c.relowner AS owner_oid,
            CASE
                WHEN c.relkind = ''r'' THEN ''table''
                WHEN c.relkind = ''v'' THEN ''view''
                WHEN c.relkind = ''m'' THEN ''materialized view''
                WHEN c.relkind = ''c'' THEN ''type''
                WHEN c.relkind = ''i'' THEN ''index''
                WHEN c.relkind = ''S'' THEN ''sequence''
                WHEN c.relkind = ''s'' THEN ''special''
                WHEN c.relkind = ''t'' THEN ''TOAST table''
                WHEN c.relkind = ''f'' THEN ''foreign table''
                WHEN c.relkind = ''p'' THEN ''partitioned table''
                WHEN c.relkind = ''I'' THEN ''partitioned index''
                ELSE c.relkind::text
                END AS object_type,
            CASE
                WHEN c.relkind = ''S'' THEN coalesce ( c.relacl, acldefault ( ''s''::"char", c.relowner ) )
                ELSE coalesce ( c.relacl, acldefault ( ''r''::"char", c.relowner ) )
                END AS acl
        FROM pg_class c
        JOIN schemas
            ON ( schemas.schema_oid = c.relnamespace )
        WHERE c.relkind IN ( ''r'', ''v'', ''m'', ''S'', ''f'', ''p'' )
),
cols AS ( -- Columns
    SELECT c.object_schema,
            null::integer AS oid,
            c.object_name || ''.'' || a.attname::text AS object_name,
            ''column'' AS object_type,
            c.owner_oid,
            coalesce ( a.attacl, acldefault ( ''c''::"char", c.owner_oid ) ) AS acl
        FROM pg_attribute a
        JOIN classes c
            ON ( a.attrelid = c.oid )
        WHERE a.attnum > 0
            AND NOT a.attisdropped
),
procs AS ( -- Procedures and functions
    SELECT schemas.schema_oid,
            schemas.schema_name AS object_schema,
            p.oid,
            p.proname::text AS object_name,
            p.proowner AS owner_oid,
            CASE p.prokind
                WHEN ''a'' THEN ''aggregate''
                WHEN ''w'' THEN ''window''
                WHEN ''p'' THEN ''procedure''
                ELSE ''function''
                END AS object_type,
            pg_catalog.pg_get_function_arguments ( p.oid ) AS calling_arguments,
            coalesce ( p.proacl, acldefault ( ''f''::"char", p.proowner ) ) AS acl
        FROM pg_proc p
        JOIN schemas
            ON ( schemas.schema_oid = p.pronamespace )
),
udts AS ( -- User defined types
    SELECT schemas.schema_oid,
            schemas.schema_name AS object_schema,
            t.oid,
            t.typname::text AS object_name,
            t.typowner AS owner_oid,
            CASE t.typtype
                WHEN ''b'' THEN ''base type''
                WHEN ''c'' THEN ''composite type''
                WHEN ''d'' THEN ''domain''
                WHEN ''e'' THEN ''enum type''
                WHEN ''t'' THEN ''pseudo-type''
                WHEN ''r'' THEN ''range type''
                WHEN ''m'' THEN ''multirange''
                ELSE t.typtype::text
                END AS object_type,
            coalesce ( t.typacl, acldefault ( ''T''::"char", t.typowner ) ) AS acl
        FROM pg_type t
        JOIN schemas
            ON ( schemas.schema_oid = t.typnamespace )
        WHERE ( t.typrelid = 0
                OR ( SELECT c.relkind = ''c''
                        FROM pg_catalog.pg_class c
                        WHERE c.oid = t.typrelid ) )
            AND NOT EXISTS (
                SELECT 1
                    FROM pg_catalog.pg_type el
                    WHERE el.oid = t.typelem
                        AND el.typarray = t.oid )
),
fdws AS ( -- Foreign data wrappers
    SELECT null::oid AS schema_oid,
            null::text AS object_schema,
            p.oid,
            p.fdwname::text AS object_name,
            p.fdwowner AS owner_oid,
            ''foreign data wrapper'' AS object_type,
            coalesce ( p.fdwacl, acldefault ( ''F''::"char", p.fdwowner ) ) AS acl
        FROM pg_foreign_data_wrapper p
),
fsrvs AS ( -- Foreign servers
    SELECT null::oid AS schema_oid,
            null::text AS object_schema,
            p.oid,
            p.srvname::text AS object_name,
            p.srvowner AS owner_oid,
            ''foreign server'' AS object_type,
            coalesce ( p.srvacl, acldefault ( ''S''::"char", p.srvowner ) ) AS acl
        FROM pg_foreign_server p
),
all_objects AS (
    SELECT schema_name AS object_schema,
            object_type,
            schema_name AS object_name,
            null::text AS calling_arguments,
            owner_oid,
            acl
        FROM schemas
    UNION
    SELECT object_schema,
            object_type,
            object_name,
            null::text AS calling_arguments,
            owner_oid,
            acl
        FROM classes
    UNION
    SELECT object_schema,
            object_type,
            object_name,
            null::text AS calling_arguments,
            owner_oid,
            acl
        FROM cols
    UNION
    SELECT object_schema,
            object_type,
            object_name,
            calling_arguments,
            owner_oid,
            acl
        FROM procs
    UNION
    SELECT object_schema,
            object_type,
            object_name,
            null::text AS calling_arguments,
            owner_oid,
            acl
        FROM udts
    UNION
    SELECT object_schema,
            object_type,
            object_name,
            null::text AS calling_arguments,
            owner_oid,
            acl
        FROM fdws
    UNION
    SELECT object_schema,
            object_type,
            object_name,
            null::text AS calling_arguments,
            owner_oid,
            acl
        FROM fsrvs
),
acl_base AS (
    SELECT object_schema,
            object_type,
            object_name,
            calling_arguments,
            owner_oid,
            ( aclexplode ( acl ) ).grantor AS grantor_oid,
            ( aclexplode ( acl ) ).grantee AS grantee_oid,
            ( aclexplode ( acl ) ).privilege_type AS privilege_type,
            ( aclexplode ( acl ) ).is_grantable AS is_grantable
        FROM all_objects
)
select object_schema,object_type,object_name,grantee,string_agg(distinct privilege_type,'','' order by privilege_type)  privilegess from (
SELECT acl_base.object_schema,
        acl_base.object_type,
        acl_base.object_name,
        acl_base.calling_arguments,
        owner.role_name AS object_owner,
        grantor.role_name AS grantor,
        grantee.role_name AS grantee,
        acl_base.privilege_type,
        acl_base.is_grantable
    FROM acl_base
    JOIN rol owner
        ON ( owner.oid = acl_base.owner_oid )
    JOIN rol grantor
        ON ( grantor.oid = acl_base.grantor_oid )
    JOIN rol grantee
        ON ( grantee.oid = acl_base.grantee_oid )
    WHERE acl_base.grantor_oid <> acl_base.grantee_oid ) q
where object_schema not in (''af_repo'',''af_repo_app'') and grantee not in(''lt'')  -- and  object_name=''part_item''
	and object_name not in (
		SELECT
    	child.relname       AS child
		FROM pg_inherits
	    JOIN pg_class parent            ON pg_inherits.inhparent = parent.oid
	    JOIN pg_class child             ON pg_inherits.inhrelid   = child.oid
	    JOIN pg_namespace nmsp_parent   ON nmsp_parent.oid  = parent.relnamespace
	    JOIN pg_namespace nmsp_child    ON nmsp_child.oid   = child.relnamespace
		)
and split_part(object_name,''_'',1) not in (''file'' ,''temp'', ''orabl'',''sdv'',''mt'')
and split_part(object_name,''_'',-1) not in (''hst'', ''ind'', ''flow'',''err'')
group by object_schema,object_type,object_name,grantee
order by object_schema,object_type,object_name,grantee
) Gr
group by object_schema,object_type,object_name', NULL, 'N', 'Y', 'OCT', 'N', 'Y', NULL);
Analyse verbose bl.bl_sbs_report_meta;	
END if;
end
$$;