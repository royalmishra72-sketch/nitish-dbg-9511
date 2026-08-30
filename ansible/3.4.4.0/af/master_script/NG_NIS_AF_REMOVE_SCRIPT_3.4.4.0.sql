--*****************************************************************
-- Project:  NISSAN NG DATA PUBLISHING
--*****************************************************************
-- Script Name: NIS_AF_REMOVE_SCRIPT_3.4.4.0
--
-- Purpose: NextGen NISSAN v3.4.4.0 Script (for AF objects) 
--
--*****************************************************************
-- Revision History
--   Ref #  Date              Revisor       Comment
--   1      17-Jan-2026      NKM           Initial Version 
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

\set AUTOCOMMIT on

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

--->>Remove WF and Context

\ir  '../script/wf_cleanup.sql'
\ir  '../script/context_cleanup.sql'

commit;