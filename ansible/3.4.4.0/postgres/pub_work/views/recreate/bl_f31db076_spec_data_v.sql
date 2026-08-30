drop view if exists BL_F31DB076_SPEC_DATA_V;

--------------------------------------------------------
--  DDL for View BL_F31DB076_SPEC_DATA_V
--------------------------------------------------------

  CREATE or REPLACE VIEW PUB_WORK.BL_F31DB076_SPEC_DATA_V AS 
  WITH REGEXP_TAB AS (SELECT ELEMENT_CODE FROM BL.BL_SBS_META_HEADER BSMH WHERE GROUP_NAME ='REPLACE_NON_PRINTABLE')
   SELECT
     /**
     * <SBS_PROLOG>
     * PROJECT:  NISSAN DATA PUBLISHING
     * PURPOSE:  THIS VIEW IS USED IN THE POPULATION OF THE BL_F31DB076_SPEC_DATA TABLE.
     *
     * PL/SQL OBJECTS USED:
     *   <OBJECT TYPE> - <SCHEMA OWNER> - <OBJECT NAME>
     *===========================================================
     * REVISION HISTORY
     *   REF #  DATE          REVISOR      COMMENT 
     *   1      29-MAR-2023    PUB TEAM    INITIAL
     *   2      14-JUL-2023    DNU         CODE MIGRATED FOR PG.
     *===========================================================
     * REVISOR
     *  PT            PUB TEAM
     *  DNU           DILESH N. UKEY
     *===========================================================
     * </SBS_PROLOG>
     * <SBS_SRCTAB  owner="PUB_WORK" name="PRE_BL_F31DB076_SPEC_DATA_W"/
     * <SBS_DESTTAB owner="BL" name="BL_F31DB076_SPEC_DATA" />
     * <SBS_PRCGRP NAME="" SEQ=""/>
     */
     REGEXP_REPLACE (UPPER (SPEC_CODE), RX.ELEMENT_CODE, '')
             AS SPEC_CODE,
          CATALOG_MODEL,
          MODEL_SERIES_CODE,
          REGEXP_REPLACE (UPPER (SPEC_TRANSLATION),
                          RX.ELEMENT_CODE,
                          '')
             AS SPEC_TRANSLATION,
          DATA_REGISTRATION_DATE,
          LATEST_UPDATE_DATE,
          LATEST_UPDATE_TIME,
          LATEST_UPDATE_JOB,
          LATEST_UPDATE_STEP
     FROM PUB_WORK.PRE_BL_F31DB076_SPEC_DATA_W CROSS JOIN REGEXP_TAB RX;
