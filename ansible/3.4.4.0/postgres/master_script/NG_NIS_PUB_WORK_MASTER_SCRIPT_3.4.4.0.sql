--*****************************************************************
-- Project:  NISSAN NG DATA PUBLISHING
--*****************************************************************
-- Script Name: NG_NIS_PUB_WORK_MASTER_SCRIPT_3.4.4.0
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



-->>Table 
\ir  '../pub_work/table/pre_bl_images_to_process_w.sql'
\ir  '../pub_work/table/curr_run_image_data_w.sql'
\ir  '../pub_work/table/curr_run_source_image_w.sql'
\ir  '../pub_work/table/bl_image_data_h.sql'
\ir  '../pub_work/table/pre_bl_nna_illust_master_w.sql'
\ir  '../pub_work/table/remove_object.sql'

-->>SVG Image Related Changes
\ir  '../pub_work/views/bl_image_data_v.sql'
\ir  '../pub_work/views/bl_nna_illust_master_v.sql'


commit;