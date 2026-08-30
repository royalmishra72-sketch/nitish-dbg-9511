drop view if exists ATTACHMENT_GROUP_KEY_IDS_V;

CREATE or REPLACE VIEW PUB_WORK.ATTACHMENT_GROUP_KEY_IDS_V AS
      SELECT 
        /**
          * <SBS_PROLOG>
          * Project:  NISSAN DATA PUBLISHING
          * Purpose:  This view is used in the population of the CTRG_SUPPORT.ATTACHMENT_GROUP_KEY_IDS  TABLE .
          *
          * PL/SQL Objects Used:
          *   <Object Type> - <Schema Owner> - <Object Name>
          *===========================================================
          * Revision History
          *   Ref #  Date          Revisor      Comment
		  *   1      08-JUN-2023     DNU         Initial
          *===========================================================
          * Revisor
		  *   DNU                DILESH N. UKEY
          *===========================================================
          * </SBS_PROLOG>
          * <SBS_SRCTAB  owner="BL" name="BL_SBS_META_HEADER" />
          * <SBS_DESTTAB owner="CTRG_SUPPORT" name="ATTACHMENT_GROUP_KEY_IDS" />
          * <SBS_PRCGRP name="" seq=""/>
          **
          <sbs_rule>This Clause fetching element_code from bl_sbs_meta_header table having group name ATTACHMENT_GROUP <sbs_rule>*/
		  ELEMENT_CODE AS DUR_UK
          FROM BL.BL_SBS_META_HEADER
          WHERE GROUP_NAME = 'ATTACHMENT_GROUP'
		  ;