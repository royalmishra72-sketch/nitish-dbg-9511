drop view if exists EIN_NOTE_X_V;
  CREATE or REPLACE VIEW PUB_WORK.EIN_NOTE_X_V AS
  WITH DOI AS
  (
  /* <SBS_RULE> THIS CLAUSE WILL FETCH DATA ORIGIN ID, THIS WILL BE THE ID OF DATA ORIGIN NAMED 'NIS|ALL', FROM TABLE 'DATA_ORIGIN' .</SBS_RULE>*/
  SELECT DATA_ORIGIN_ID AS DATA_ORIGIN_ID
  FROM CTRG_SUPPORT.DATA_ORIGIN 
  WHERE DUR_UK = 'NIS|ALL'
  ),
  EIN AS
  (
  /* <SBS_RULE> THIS CLAUSE WILL FETCH SPECIAL VIN FROM WRK_VIN_CATALOG_MAP.</SBS_RULE>*/
  SELECT CONCAT(VIN_TYPE,SERIAL_NUMBER) AS EIN_DUR_UK
  FROM PUB_WORK.VIN_CATALOG_MAP_W WVCM
  INNER JOIN BL.BL_SBS_CATALOG B
  ON WVCM.CATALOG_MODEL                     = B.model
  WHERE SUBSTRING(PROD_DATE,3,4)::INT              >=2001
  AND SUBSTRING(EIGHTEEN_DIGIT_MODEL_CODE,18) IN ('X','Y','Z')
  AND SPEC_SEQ                             IN ('0000000000','0000000001')
  AND B.STATUS                              = 'Y'
  AND SUBSTRING(VIN_TYPE,1,3)                 IN ('JN1','JN3','JN6','JN8','KNM')
  ),
  BSN AS
  (
  /* <SBS_RULE> THIS CLAUSE WILL FETCH DUR_UK FOR NOTE TABLE FROM BL_SBS_NOTE.</SBS_RULE>*/
  SELECT CONCAT(ELEMENT_CODE,'|',ELEMENT_DESC) AS DUR_UK_NOTE
  FROM BL.BL_SBS_META_HEADER 
  WHERE GROUP_NAME ='VIN_NOTE'
  AND ELEMENT_CODE = 'SPCL_VIN_NOTE'
  )
SELECT
  /*
  * <SBS_PROLOG>
  * Project:  NISSAN DATA PUBLISHING
  * Purpose:  This view is used in the population of the CTRG EIN_NOTE_X table
  * PL/SQL Objects Used:
  *   <Object Type> - <Schema Owner> - <Object Name>
  *===========================================================
  * Revision History
  *   Ref #  Date          Revisor      Comment
  *   1      08-02-2017    SD          Initial revision
  *   2      12-05-2023    DNU         Initial
  *===========================================================
  * Revisor
  *   SD                SUMAN DESMUKH
  *   DNU               DILESH N. UKEY
  *===========================================================
  * </SBS_PROLOG>
  * <SBS_SRCTAB owner="CTRG_SUPPORT" name="DATA_ORIGIN" />
  * <SBS_SRCTAB owner="BL" name="BL_SBS_META_HEADER" />
  * <SBS_SRCTAB owner="BL" name="BL_SBS_CATALOG" />
  * <SBS_SRCTAB owner="PUB_WORK" name="VIN_CATALOG_MAP_W" />
  * <SBS_DESTTAB owner="CTRG" name="EIN_NOTE_X" />
  * <SBS_PRCGRP name="" seq=""/>
  */
  KEIN.EIN_ID         AS EIN_ID,
  KNOTE.EIN_NOTE_ID   AS NOTE_ID,
  DOI.DATA_ORIGIN_ID  AS DATA_ORIGIN_ID,
  KEIN.CATALOG_ID     AS CATALOG_ID,
  FALSE               AS ARCHIVABLE_IND,
  TRUE                AS VALID_FOR_MEDIA_IND
FROM DOI
CROSS JOIN EIN
CROSS JOIN BSN
INNER JOIN CTRG.EIN KEIN
ON (EIN.EIN_DUR_UK = KEIN.DUR_UK
AND DOI.DATA_ORIGIN_ID = KEIN.DATA_ORIGIN_ID)
INNER JOIN CTRG.EIN_NOTE KNOTE
ON (BSN.DUR_UK_NOTE = KNOTE.DUR_UK
AND DOI.DATA_ORIGIN_ID = KNOTE.DATA_ORIGIN_ID);
 
