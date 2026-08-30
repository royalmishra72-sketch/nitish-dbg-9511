drop view if exists ATTACHMENT_GROUP_CLASSIFIER_V;

  CREATE or REPLACE VIEW PUB_WORK.ATTACHMENT_GROUP_CLASSIFIER_V AS 
  WITH DOI AS 
    (
	/*<sbs_rule>This Clause fetching data_origin_id from data_origin table having dur_uk NIS|ALL <sbs_rule>*/
	SELECT DATA_ORIGIN_ID
    FROM CTRG_SUPPORT.DATA_ORIGIN
    WHERE DUR_UK = 'NIS|ALL'
    ),
    SMH AS 
	(
    /*<sbs_rule>This Clause fetching element_code from bl_sbs_meta_header table having group name ATTACHMENT_GROUP <sbs_rule>*/	
     SELECT ELEMENT_CODE
     FROM BL.BL_SBS_META_HEADER
     WHERE GROUP_NAME = 'ATTACHMENT_GROUP'
	)
       SELECT 
         /**
          * <SBS_PROLOG>
          * Project:  NISSAN DATA PUBLISHING
          * Purpose:  This view is used in the population of the CTRG ATTACHMENT_GROUP_CLASSIFIER TABLE .
          *
          * PL/SQL Objects Used:
          *   <Object Type> - <Schema Owner> - <Object Name>
          *===========================================================
          * Revision History
          *   Ref #  Date          Revisor      Comment
          *   1      23-07-2015     AB          INITIAL DRAFT
		  *   2      05-05-2023     DNU         Initial
          *===========================================================
          * Revisor
          *   AB                 ABHINAV BANSAL
		  *   DNU                DILESH N. UKEY
          *===========================================================
          * </SBS_PROLOG>
          * <SBS_SRCTAB  owner="BL" name="BL_SBS_META_HEADER" />
          * <SBS_SRCTAB owner="CTRG_SUPPORT" name="DATA_ORIGIN" />
          * <SBS_DESTTAB owner="CTRG" name="ATTACHMENT_GROUP_CLASSIFIER" />
          * <SBS_PRCGRP name="LOAD_ATTACHMENTS" seq=""/>
          **/
		   
            AGKI.DUR_UK_ID     AS  ATTACHMENT_GROUP_CLASSIFIER_ID, 
			SMH.ELEMENT_CODE   AS CODE,
            DOI.DATA_ORIGIN_ID AS DATA_ORIGIN_ID,
			FALSE              AS ARCHIVABLE_IND,
            TRUE               AS VALID_FOR_MEDIA_IND
            FROM SMH
			JOIN CTRG_SUPPORT.ATTACHMENT_GROUP_KEY_IDS  AGKI
			/*<sbs_rule> attachment_group_classifier_id taken from ctrg_support.attachment_group_key_ids tablebecause attachment_group_classifier key_ids table not available <sbs_rule>*/
			ON  AGKI.DUR_UK = SMH.ELEMENT_CODE
            CROSS JOIN DOI;
