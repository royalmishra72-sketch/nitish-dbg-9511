--*****************************************************************
-- Project:  NISSAN NG DATA PUBLISHING
--*****************************************************************
-- Script Name: NG_NIS_PUB_WORK_POST_RDVT_SCRIPT_3.4.4.0
--
-- Purpose: NextGen NISSAN v3.4.4.0 Script (for PUB_WORK) 
--
--*****************************************************************
-- Revision History
--   Ref #  Date              Revisor       Comment
--   1      19-JAN-2026       NKM           Initial Version 
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



-->>SVG Image Related Changes
\ir  '../pub_work/views/vin_multi_cat_w_v.sql'
\ir  '../pub_work/views/vin_catalog_map_base_w_v.sql'
\ir  '../pub_work/views/new_catalog_entry_v.sql'
\ir  '../pub_work/views/current_month_catalog_name_v.sql'
\ir  '../pub_work/views/equipment_cont_filter_x_v.sql'

\ir  '../pub_work/functions/fnc_generic_report.sql'
\ir  '../pub_work/functions/fnc_prerequisite_workflow_check.sql'






commit;