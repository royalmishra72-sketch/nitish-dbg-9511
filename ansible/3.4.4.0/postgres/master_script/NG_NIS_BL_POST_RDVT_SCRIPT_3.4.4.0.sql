--*****************************************************************
-- Project:  NISSAN NG DATA PUBLISHING
--*****************************************************************
-- Script Name: NG_NIS_BL_POST_RDVT_SCRIPT_3.4.4.0
--
-- Purpose: NextGen NISSAN v3.4.4.0 Script (for BL) 
--
--*****************************************************************
-- Revision History
--   Ref #  Date              Revisor       Comment
--   1      30-JAN-2025       NKM           Initial Version 
--*****************************************************************
-- Revisor
-- [Initials]		    [Full Name]
--  NKM                 NITISH KUMAR MISHRA
--*****************************************************************
show search_path;

set client_encoding to 'UTF8';

\conninfo
--****************
\pset format unaligned
--*****************
\timing on
--**********

\set ON_ERROR_STOP on

\set AUTOCOMMIT off

-- Set up prompt with user@database
-- Define local PSQL variables to capture results of WHOAMI query
WITH whoami AS
 (SELECT current_schema as schemaname,current_user as username
        ,now() as ctime
        ,current_database() as db_name)
SELECT w.schemaname || '@' || w.db_name AS gname, w.username
      ,w.schemaname
      ,w.ctime
      ,w.db_name sname
  FROM whoami w;
\gset
\set PROMPT1 '%:gname:> '



-->>RDVT 1.0.0
\ir  '../bl/metadata/bl_sbs_report_meta.sql'
\ir  '../bl/metadata/bl_sbs_meta_header.sql'
\ir  '../bl/metadata/bl_sbs_pub_run_notification.sql'
\ir  '../bl/metadata/bl_sbs_report_failures.sql'
\ir  '../bl/metadata/bl_sbs_meta_blctrg_alrm_cnt.sql'
\ir  '../bl/metadata/bl_sbs_catalog.sql'
\ir  '../bl/metadata/bl_backup_tables_m.sql'

-->>RDVT 1.1.0 and 1.2.0
\ir  '../bl/metadata/alter_bl_sbs_report_meta.sql'
\ir  '../bl/metadata/delete_bl_sbs_meta_header.sql'
\ir  '../bl/metadata/recheck_bl_sbs_report_failures.sql'
\ir  '../bl/metadata/update_bl_sbs_report_failures.sql'
\ir  '../bl/metadata/update_bl_sbs_meta_blctrg_alrm_cnt.sql'
\ir  '../bl/metadata/lvt_bl_sbs_report_meta_update.sql'




commit;