--*****************************************************************
-- Project:  NISSAN NG DATA PUBLISHING
--*****************************************************************
-- Script Name: NG_NIS_BL_MASTER_SCRIPT_3.4.4.1
--
-- Purpose: NextGen NISSAN v3.4.4.1 Script (for BL) 
--
--*****************************************************************
-- Revision History
--   Ref #  Date              Revisor       Comment
--   1      15-Aug-2026       NKM           Initial Version 
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




-->>Update attribute2 column for All Type Of Image
\ir  '../bl/metadata/bl_image_data.sql'
\ir  '../bl/metadata/bl_sbs_report_meta.sql'


--->> Add Primary Key
\ir  '../bl/table/alter_bl_image_data.sql'





commit;