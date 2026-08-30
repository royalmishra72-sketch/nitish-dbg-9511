drop view if exists ATTACHMENT_GROUP_V;

CREATE or REPLACE VIEW PUB_WORK.ATTACHMENT_GROUP_V AS 
       WITH DOI AS 
       (
       SELECT DATA_ORIGIN_ID
       FROM CTRG_SUPPORT.DATA_ORIGIN
       WHERE DUR_UK = 'NIS|ALL'
       ),
       DT AS 
       (
       SELECT 1 AS DISPLAY_TYPE_ID
       ),
       SMH AS 
       (
       SELECT ELEMENT_CODE, ELEMENT_DESC, SORT_SEQ
       FROM BL.BL_SBS_META_HEADER
       WHERE GROUP_NAME = 'ATTACHMENT_GROUP'
        )
        SELECT 
        /**
          * <SBS_PROLOG>
          * Project:  NISSAN DATA PUBLISHING
          * Purpose:  This view is used in the population of the CTRG ATTACHMENT_GROUP TABLE .
          *
          * PL/SQL Objects Used:
          *   <Object Type> - <Schema Owner> - <Object Name>
          *===========================================================
          * Revision History
          *   Ref #  Date          Revisor      Comment
          *   1      23-07-2015     AB          INITIAL DRAFT
		  *   2      08-05-2023     DNU         INIITIAL
          *===========================================================
          * Revisor
          *   AB                 ABHINAV BANSAL
		  *   DNU                DILESH N. UKEY
          *===========================================================
          * </SBS_PROLOG>
          * <SBS_SRCTAB  owner="BL" name="BL_SBS_META_HEADER" />
          * <SBS_SRCTAB owner="CTRG_SUPPORT" name="DATA_ORIGIN" />
          * <SBS_DESTTAB owner="CTRG" name="ATTACHMENT_GROUP" />
          * <SBS_PRCGRP name="LOAD_ATTACHMENTS" seq=""/>
          *
		  *<sbs_rule>attachment_group_id column from view as AF will create this.</sbs_rule>*/
          --KEY_TO_ID('ATTACHMENT_GROUP',SMH.ELEMENT_CODE) AS ATTACHMENT_GROUP_ID
          SMH.ELEMENT_CODE AS DUR_UK,
		  COALESCE(AGD.ATTACHMENT_GROUP_DICT_ID,(SELECT ATTACHMENT_GROUP_DICT_ID FROM CTRG.ATTACHMENT_GROUP_DICT WHERE DUR_UK = '*')) AS ATTACHMENT_GROUP_DICT_ID,
		  NULL::INT        AS PARENT_ID,
          NULL             AS flex1,
          NULL             AS flex2,
          NULL             AS flex3,
          NULL             AS flex4,
          NULL             AS flex5,
          NULL             AS flex6,
          NULL             AS flex7,
          NULL             AS flex8,
          NULL             AS flex9,
          NULL             AS flex10,
		  SMH.SORT_SEQ       AS SORT_SEQ,		  
		  NULL               AS CODE,
		  NULL               AS SECURED_ID,
          DOI.DATA_ORIGIN_ID AS DATA_ORIGIN_ID,
		  AGC.ATTACHMENT_GROUP_CLASSIFIER_ID AS ATTACHMENT_GROUP_CLASSIFIER_ID,
		  FALSE              AS ARCHIVABLE_IND,
          TRUE               AS VALID_FOR_MEDIA_IND,
		  CASE SMH.ELEMENT_CODE WHEN 'Links' THEN TRUE
		  ELSE FALSE 
		  END AS URL_ONLY,
          DT.DISPLAY_TYPE_ID AS DISPLAY_TYPE
          FROM SMH
          CROSS JOIN DT
          CROSS JOIN DOI
		  INNER JOIN CTRG.ATTACHMENT_GROUP_CLASSIFIER AGC
		  ON SMH.ELEMENT_CODE = AGC.CODE
		  LEFT OUTER JOIN CTRG.ATTACHMENT_GROUP_DICT AGD
		  ON SMH.ELEMENT_CODE = AGD.DUR_UK;
