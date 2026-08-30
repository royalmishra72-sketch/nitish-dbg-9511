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


--->>Create View 
\ir  '../pub_work/views/recreate/attachment_group_classifier_v.sql'
\ir  '../pub_work/views/recreate/attachment_group_dict_v.sql'
\ir  '../pub_work/views/recreate/attachment_group_key_ids_v.sql'
\ir  '../pub_work/views/recreate/attachment_group_v.sql'
\ir  '../pub_work/views/recreate/attachment_v.sql'
\ir  '../pub_work/views/recreate/bl_f31db076_spec_data_v.sql'
\ir  '../pub_work/views/recreate/bl_f31db153_filter_v.sql'
\ir  '../pub_work/views/recreate/bl_f31x1470_catalog_parts_cd1_v.sql'
\ir  '../pub_work/views/recreate/bl_f31x1470_catalog_parts_cd2_v.sql'
\ir  '../pub_work/views/recreate/bl_f31x1470_catalog_parts_cd5_v.sql'
\ir  '../pub_work/views/recreate/bl_f31x1470_catalog_parts_cd6_v.sql'
\ir  '../pub_work/views/recreate/bl_nna_parts_v.sql'
\ir  '../pub_work/views/recreate/bl_servfile_nissan_v.sql'
\ir  '../pub_work/views/recreate/business_region_v.sql'
\ir  '../pub_work/views/recreate/ein_addl_info_w_v.sql'
\ir  '../pub_work/views/recreate/ein_note_dict_v.sql'
\ir  '../pub_work/views/recreate/ein_note_v.sql'
\ir  '../pub_work/views/recreate/ein_note_x_v.sql'
\ir  '../pub_work/views/recreate/part_addl_info_w_v.sql'
\ir  '../pub_work/views/recreate/part_item_addl_info_w_v.sql'
\ir  '../pub_work/views/recreate/part_supersession_dict_v.sql'
\ir  '../pub_work/views/recreate/part_supersession_v.sql'
\ir  '../pub_work/views/recreate/price_book_dict_v.sql'
\ir  '../pub_work/views/recreate/price_book_v.sql'
\ir  '../pub_work/views/recreate/addl_info_group_dict_v.sql'
\ir  '../pub_work/views/recreate/addl_info_name_dict_v.sql'
\ir  '../pub_work/views/recreate/attachment_dict_v.sql'


commit;