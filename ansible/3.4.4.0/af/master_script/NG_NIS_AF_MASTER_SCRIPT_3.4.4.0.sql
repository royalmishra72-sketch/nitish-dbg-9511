--*****************************************************************
-- Project:  NISSAN NG DATA PUBLISHING
--*****************************************************************
-- Script Name: NIS_AF_MASTER_SCRIPT_3.4.4.0
--
-- Purpose: NextGen NISSAN v3.4.4.0 Script (for AF objects) 
--
--*****************************************************************
-- Revision History
--   Ref #  Date              Revisor       Comment
--   1      30-Jan-2026       NKM           Initial Version 
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


---->>>SVG Download (NSPUB-1431)
\ir  '../af_workflows/download/compiled/move_svg_illustration_image_wf-wfl.sql'
\ir  '../af_workflows/download/compiled/mwf_download_nissan_feeds_wf-wfl.sql'

---->>Feed to BL for SVG Image(NSPUB-1432)
\ir  '../af_workflows/svg_feed_to_bl/compiled/load_tif_image_to_bl_wf-wfl.sql'
\ir  '../af_workflows/svg_feed_to_bl/compiled/load_svg_image_to_bl_wf-wfl.sql'
\ir  '../af_workflows/svg_feed_to_bl/compiled/load_illustration_image_to_bl_wf-wfl.sql'
\ir  '../af_workflows/svg_feed_to_bl/compiled/load_model_image_to_bl_wf-wfl.sql'
\ir  '../af_workflows/svg_feed_to_bl/compiled/load_chapter_image_to_bl_wf-wfl.sql'
\ir  '../af_workflows/svg_feed_to_bl/compiled/load_attachment_to_bl_gi_wf-wfl.sql'
\ir  '../af_workflows/svg_feed_to_bl/compiled/load_attachment_to_bl_pricebook_wf-wfl.sql'
\ir  '../af_workflows/svg_feed_to_bl/compiled/load_attachment_and_image_to_bl_wf-wfl.sql'


--->>Missing SVG Image Report
\ir  '../af_workflows/missing_svg/compiled/bl_nna_illust_master_wf-wfl.sql'

-->>Context 
\ir  '../af_workflows/context/pub_work.file_pre_bl_images_to_process_w.sql'
\ir  '../af_workflows/context/pub_work.file_pre_bl_nna_illust_master_w.sql'
\ir  '../af_workflows/context/pub_work.bl_nna_illust_master_v.sql'

--->>OneToch WorkFlow
\ir  '../af_workflows/miscellaneous_workflows/compiled/create_new_catalog_wf-wfl.sql'
\ir  '../af_workflows/miscellaneous_workflows/compiled/new_catalog_data_check_wf-wfl.sql'
\ir  '../af_workflows/miscellaneous_workflows/compiled/new_model_data_check_wf-wfl.sql'
\ir  '../af_workflows/miscellaneous_workflows/compiled/rpt_generic_report_wf-wfl.sql'
\ir  '../af_workflows/miscellaneous_workflows/compiled/lucene_wf-wfl.sql'
\ir  '../af_workflows/miscellaneous_workflows/compiled/stop_due_to_failure-wfl.sql'


--->>Master WorkFlow
\ir  '../af_workflows/master_wf/compiled/mwf_download_nissan_feeds_wf-wfl.sql'
\ir  '../af_workflows/master_wf/compiled/mwf_feed_to_bl_wf-wfl.sql'
\ir  '../af_workflows/master_wf/compiled/mwf_bl_to_ctrg_wf-wfl.sql'
\ir  '../af_workflows/master_wf/compiled/nis_onetouch_publishing_wf-wfl.sql'

commit;