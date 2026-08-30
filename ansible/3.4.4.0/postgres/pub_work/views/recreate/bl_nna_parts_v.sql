drop view if exists BL_NNA_PARTS_V;

--------------------------------------------------------
--  DDL for View BL_NNA_PARTS_V
--------------------------------------------------------

  CREATE or REPLACE VIEW PUB_WORK.BL_NNA_PARTS_V AS
  WITH
  --  ACTIVE_CATALOGS AS
  --  (
  --  /** <SBS_RULE> THIS CLAUSE WILL RESTICT CATALOGS FROM PUBLISHING WHICH ARE NOT ACTIVE  </SBS_RULE>*/
  --  SELECT DISTINCT MODEL
  --  FROM BL_SBS_CATALOG where status = 'Y'
  --  ) ,
  REGEXP_TAB AS
  (SELECT ELEMENT_CODE FROM BL.BL_SBS_META_HEADER BSMH WHERE GROUP_NAME ='REPLACE_NON_PRINTABLE'
  )
SELECT distinct 
  /*******************************************************
  <SBS_PROLOG>
  * Project:  NISSAN DATA PUBLISHING
  * Purpose:  This VIEW holds BL_NNA_PARTS related information.
  *
  * PL/SQL Objects Used:
  * <Object Type> - <Schema  Owner> - <Object Name>
    ===========================================================
    Revision History
    Ref #	Date			    Revisor		  Comment
    [ref]	DD-MON-YYYY		   [Initials]	  [comment]
    1		  DD-MON-2015		NPT			    Initial version
    2		  09-OCT-2018		AR			    REMOVED SPACE FROM PART DESCRIPTION [NSPUB150]
	3         04-JUL-2023       DU              CODE MIGRATE FOR PG.
	4         18-OCT-2024       NKM             Add row_hash column
	5         29-DEC-2025       NKM             populate hash column using sbs_util.get_hash_text function
    ===========================================================
    Revisor
    *   [initials]		[Full Name]
    *   NPT				 NISSAN PUB TEAM
    *	AR				 ALISHA RASTOGI
	*   DU               DILESH UKEY  
	*   NKM              Nitish K Mishra
    ===========================================================
  </SBS_PROLOG>
  <SBS_SRCTAB owner="PUB_WORK" name="PRE_BL_NNA_PARTS_W" />
  <SBS_DESTTAB owner="BL" name="BL_NNA_PARTS" />
  <SBS_PRCGRP name="" seq=""/>
  Insert all other tag comments that are relevant
  *********************************************************/
  PUB_NUM,
  REPLACE(REPLACE (SEC_NUM,'*',''),' ','')SEC_NUM,
  CASE
    WHEN LENGTH(DIAG_PART) = 8
    THEN SUBSTRING(DIAG_PART,1,LENGTH(DIAG_PART)-3)
    WHEN LENGTH(DIAG_PART) = 7
    AND SUBSTRING(DIAG_PART,6,1)= ' '
    THEN REPLACE(DIAG_PART,' ','+')
    ELSE DIAG_PART
  END AS DIAG_PART,
  REPLACE (PART_NUM,' ','') PART_NUM,
  REGEXP_REPLACE(UPPER(PART_NAME) ,RX.ELEMENT_CODE,'') AS PART_NAME,
  TRIM(REGEXP_REPLACE(UPPER(PART_DESC) ,RX.ELEMENT_CODE,'')) AS PART_DESC, --REVISION 2
  PART_CODE,
  MDL_INFO,
  CASE
    WHEN APP_FROM_DATE IS NULL
    THEN '000000'
    WHEN APP_FROM_DATE ='000000'
    THEN '000000'
    ELSE APP_FROM_DATE
  END AS APP_FROM_DATE,
  CASE
    WHEN APP_TO_DATE IS NULL
    THEN '999999'
    WHEN APP_TO_DATE ='000000'
    THEN '999999'
    ELSE APP_TO_DATE
  END AS APP_TO_DATE,
  CAT_SPEC,
  MDL_SPEC1,
  MDL_SPEC2,
  MDL_SPEC3,
  MDL_SPEC4,
  FMR_ALT_ICA,
  CASE
    WHEN LENGTH(FMR_ALT_NUM)<5
    THEN NULL
    ELSE REPLACE(FMR_ALT_NUM,' ','')
  END AS FMR_ALT_NUM ,
  NEW_ALT_ICA,
  REPLACE(NEW_ALT_NUM,' ','') NEW_ALT_NUM,
  REPLACE(REPLACE (MDL_SER_CODE,'/','_'),' ','') MDL_SER_CODE,
  REPLACE(QTY_FOR_SEC,'**','AR') QTY_FOR_SEC,
  CAT_REMARK,
  UNIT_PACK_P,
  CASE WHEN ORD_SYMB='#' THEN'#'
         WHEN ORD_SYMB ='*'THEN '*'
	       WHEN ORD_SYMB = ''THEN ORD_SYMB 
	         END ORD_SYMB,
  PART_DESC_CODE,
  ORIG_CHNL_CODE,
  NA_CODE,
  SWITCH_CODE,
  PART_LETTER_NO,
  DIAG_KEY,
  INDENTURE_LEVEL,
  CTRY_CODE1,
  CTRY_CODE2,
  CTRY_CODE3,
  CTRY_CODE4,
  CTRY_CODE5,
  CTRY_CODE6,
  TRIM(TRIM_COLOR) TRIM_COLOR,
  BODY_COLOR,
  sbs_util.get_hash_text(concat(pub_num,'|',sec_num,'|',diag_part,'|',part_num,'|',part_name,'|', part_desc,'|',part_code,'|',mdl_info,'|',app_from_date,'|',app_to_date,'|',cat_spec,'|',mdl_spec1,'|',mdl_spec2,'|',mdl_spec3,'|', mdl_spec4,'|',fmr_alt_ica,'|',fmr_alt_num,'|',new_alt_ica,'|',new_alt_num,'|',mdl_ser_code,'|',qty_for_sec,'|',cat_remark,'|', unit_pack_p,'|',ord_symb,'|',part_desc_code,'|',orig_chnl_code,'|',na_code,'|',switch_code,'|',part_letter_no,'|',diag_key,'|', indenture_level,'|',ctry_code1,'|',ctry_code2,'|',ctry_code3,'|',ctry_code4,'|',ctry_code5,'|',ctry_code6,'|',trim_color,'|',body_color)) as row_hash
FROM PUB_WORK.PRE_BL_NNA_PARTS_W V1
CROSS JOIN REGEXP_TAB RX
  --INNER JOIN ACTIVE_CATALOGS
  --ON V1.MDL_SER_CODE        =REPLACE(ACTIVE_CATALOGS.MODEL,'_','/')
;
