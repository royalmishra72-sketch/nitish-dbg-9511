drop view if exists BL_SERVFILE_NISSAN_V;

CREATE or REPLACE VIEW PUB_WORK.BL_SERVFILE_NISSAN_V AS
 WITH REGEXP_TAB AS 
 (
 SELECT ELEMENT_CODE FROM BL.BL_SBS_META_HEADER BSMH WHERE GROUP_NAME ='REPLACE_NON_PRINTABLE'
 )
  SELECT
  /**
  * <SBS_PROLOG>
  * PROJECT:  NISSAN DATA PUBLISHING
  * PURPOSE:  THIS VIEW IS USED IN THE POPULATION OF THE CTRG PUB_WORK PRE_BL_SERVFILE_NISSAN_W TABLE.
  *
  * PL/SQL OBJECTS USED:
  *   <OBJECT TYPE> - <SCHEMA OWNER> - <OBJECT NAME>
  *===========================================================
  * REVISION HISTORY
  *   REF #  DATE          REVISOR      COMMENT
  *   1      28-JUN-2023    DNU         INITIAL
  *===========================================================
  * REVISOR
  *   DNU           DILESH N. UKEY
  *===========================================================
  * </SBS_PROLOG>
  * <SBS_SRCTAB  owner="BL" name="BL_SBS_META_HEADER"/
  * <SBS_SRCTAB  owner="PUB_WORK" name="PRE_BL_SERVFILE_NISSAN_W"/
  * <SBS_DESTTAB owner="BL" name="BL_SERVFILE_NISSAN" />
  * <SBS_PRCGRP NAME="" SEQ=""/>
  */
   LPAD (SERV_SEQ, 10, '0') AS  SERV_SEQ,
   SRVPART,
   FILLER8,
   REGEXP_REPLACE (UPPER (SRVDESC), RX.ELEMENT_CODE, '') AS SRVDESC,
   FILLER9,
   REGEXP_REPLACE (
            UPPER ( CONCAT(
                   TRIM (SUBSTRING (SRVTEXT, 1, 24))
                , ' '
                , TRIM (SUBSTRING (SRVTEXT, 25, 24))
                , ' '
                , TRIM (SUBSTRING (SRVTEXT, 49, 26)))),
             RX.ELEMENT_CODE,
             '')
             AS SRVTEXT,
    FILLER10
    FROM PUB_WORK.PRE_BL_SERVFILE_NISSAN_W 
	CROSS JOIN REGEXP_TAB RX
    WHERE srvpart IS NOT NULL 
	OR SRVDESC IS NOT NULL 
	OR SRVTEXT IS NOT NULL;
