drop view if exists ATTACHMENT_GROUP_DICT_V;
  CREATE or REPLACE VIEW PUB_WORK.ATTACHMENT_GROUP_DICT_V AS 
   SELECT 
        /**
          * <SBS_PROLOG>
          * Project:  NISSAN DATA PUBLISHING
          * Purpose:  This view is used in the population of the ATTACHMENT_GROUP_DICT TABLE .
          *
          * PL/SQL Objects Used:
          *   <Object Type> - <Schema Owner> - <Object Name>
          *===========================================================
          * Revision History
          *   Ref #  Date          Revisor      Comment
          *   1      23-07-2015     AB          Initial revision
		  *   2      05-05-2023     DNU         Initial
          *===========================================================
          * Revisor
          *   AB                 ABHINAV BANSAL
		  *   DNU                DILESH N. UKEY
          *===========================================================
          * </SBS_PROLOG>
          * <SBS_SRCTAB owner="BL" name="BL_SBS_META_HEADER" />
          * <SBS_DESTTAB owner="CTRG" name="ATTACHMENT_GROUP_DICT" />
          * <SBS_PRCGRP name="LOAD_ATTACHMENTS" seq=""/>
          *
		  <sbs_rule>attachment_group_dict_id column from view as AF will create this.</sbs_rule>**/
          --ctrg_support.key_to_id('attachment_group_dict',element_code) as attachment_group_dict_id,
          ELEMENT_CODE   AS DUR_UK,
          'en_US'        AS BASE_LANG_LOCALE_CODE,
          BG_BG,
          CS_CZ,
          DA_DK,
          DE_AT,
          DE_CH,
          DE_DE,
          EL_GR,
          EN_GB,
          EN_US,
          ES_ES,
          ET_EE,
          ES_MX,
          FI_FI,
          FR_CA,
          FR_FR,
          HR_HR,
          HI_IN,
          HU_HU,
          IT_IT,
          JA_JP,
          KO_KR,
          LT_LT,
          LV_LV,
          NL_BE,
          NL_NL,
          NO_NO,
          PL_PL,
          PT_BR,
          PT_PT,
          RO_RO,
          RU_RU,
          SK_SK,
          SL_SI,
          SV_SE,
          TH_TH,
          TR_TR, 
          UK_UA,
          VI_VN,
          ZH_CN,
          ZH_HK,
          ZH_TW,
          ZZ_ZZ,
          NULL  AS NON_TRANSLATABLE,
          FALSE AS ARCHIVABLE_IND,
          TRUE  AS VALID_FOR_MEDIA_IND
          FROM BL.BL_SBS_META_HEADER
          WHERE GROUP_NAME = 'ATTACHMENT_GROUP'
		  UNION ALL
		  SELECT 
		  '*'  AS DUR_UK,
          '*'  AS BASE_LANG_LOCALE_CODE,
          NULL AS BG_BG,
          NULL AS CS_CZ,
          NULL AS DA_DK,
          NULL AS DE_AT,
          NULL AS DE_CH,
          NULL AS DE_DE,
          NULL AS EL_GR,
          NULL AS EN_GB,
          NULL AS EN_US,
          NULL AS ES_ES,
          NULL AS ET_EE,
          NULL AS ES_MX,
          NULL AS FI_FI,
          NULL AS FR_CA,
          NULL AS FR_FR,
          NULL AS HR_HR,
          NULL AS HI_IN,
          NULL AS HU_HU,
          NULL AS IT_IT,
          NULL AS JA_JP,
          NULL AS KO_KR,
          NULL AS LT_LT,
          NULL AS LV_LV,
          NULL AS NL_BE,
          NULL AS NL_NL,
          NULL AS NO_NO,
          NULL AS PL_PL,
          NULL AS PT_BR,
          NULL AS PT_PT,
          NULL AS RO_RO,
          NULL AS RU_RU,
          NULL AS SK_SK,
          NULL AS SL_SI,
          NULL AS SV_SE,
          NULL AS TH_TH,
          NULL AS TR_TR, 
          NULL AS UK_UA,
          NULL AS VI_VN,
          NULL AS ZH_CN,
          NULL AS ZH_HK,
          NULL AS ZH_TW,
          NULL AS ZZ_ZZ,
          NULL AS NON_TRANSLATABLE,
          FALSE AS ARCHIVABLE_IND,
          TRUE  AS VALID_FOR_MEDIA_IND ;
		  
