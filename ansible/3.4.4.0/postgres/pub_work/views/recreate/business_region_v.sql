drop view if exists business_region_v;

CREATE or REPLACE VIEW business_region_v as
WITH DOI
        AS ( /** <SBS_RULE> THIS CLAUSE WILL FETCH DATA ORIGIN ID, THIS WILL BE THE ID OF DATA ORIGIN NAMED 'NIS|ALL', FROM TABLE 'DATA_ORIGIN' .</SBS_RULE>*/
            SELECT DD.DATA_ORIGIN_ID AS DATA_ORIGIN_ID
              FROM ctrg_support.DATA_ORIGIN DD
             WHERE DD.DUR_UK = 'NIS|ALL'),
	    MH
        AS (SELECT GROUP_NAME,
                   ELEMENT_CODE,
                   ELEMENT_DESC,
                   'NIS|' || GROUP_NAME || '|' || ELEMENT_CODE AS DUR_UK_CHK
              FROM bl.BL_SBS_META_HEADER
             WHERE GROUP_NAME = 'BUSINESS_REGION'),
	    DT
        AS	/** <SBS_RULE> THIS CLAUSE WILL FETCH 'DISPLAY_TYPE_ID' HAVING TYPE NAME 'DISPLAY', FROM TABLE 'DISPLAY_TYPE'.</SBS_RULE> **/
		(SELECT 1 AS DISPLAY_TYPE_ID ),		
	DEFAULT_DICT_ID 
	   AS (SELECT dur_uk_id 
	     FROM ctrg_support.business_region_dict_key_ids md
	    WHERE dur_uk = '*')	 			
			/**SELECT D.DISPLAY_TYPE_ID
              FROM DISPLAY_TYPE D
            WHERE D.TYPE_NAME = 'DISPLAY'),**/
SELECT /*
          * <SBS_PROLOG>
          * Project:  NISSAN DATA PUBLISHING
          * Purpose:  This view is used in the population of the BUSINESS_REGION table.
          *
          * PL/SQL Objects Used:
          *   <Object Type> - <Schema Owner> - <Object Name>
          *===========================================================
          * Revision History
          *   Ref #  Date         Revisor      Comment
          *   1      20/10/2015   NS           Initial revision
		  *   2      30/03/2023   PR           View Updated according to postgres
          *===========================================================
          * Revisor
          *   NS            NISHANT SONI
		  *   PR            PAWAN RAJAK
          *===========================================================
          * </SBS_PROLOG>
          * <SBS_SRCTAB  owner="CTRG_SUPPORT" name="DATA_ORIGIN" />
          * <SBS_SRCTAB  owner="" name="DISPLAY_TYPE" />
          */
 /*KEY_TO_ID('BUSINESS_REGION',MH.ELEMENT_CODE,DO.DATA_ORIGIN_ID) AS BUSINESS_REGION_ID,*/
 /** <SBS_RULE> CHAPTER_ID is passed as NULL as KEY_TO_ID function is handled by ODI KM.  </SBS_RULE> **/
    MH.element_code AS dur_uk,
	coalesce(cad.dur_uk_id,DDI.dur_uk_id) AS business_region_dict_id,
    MH.element_code AS code,
    0::integer AS parent_id ,
    NULL AS flex1,
    NULL AS flex2,
    NULL AS flex3,
    NULL AS flex4,
    NULL AS flex5,
    NULL AS flex6,
    NULL AS flex7,
    NULL AS flex8,
    NULL AS flex9,
    NULL AS flex10,
    NULL AS sort_seq,
    NULL AS secured_id,
    DOI.DATA_ORIGIN_ID AS data_origin_id,
    NULL AS user_select_secured_id,
    0::boolean AS archivable_ind ,
    1::boolean AS valid_for_media_ind ,
    0::integer AS image_id ,
    0::text AS has_children,
    DT.DISPLAY_TYPE_ID AS display_type ,
    NULL AS uc_nk1,
    NULL AS uc_nk2,
    NULL AS uc_nk3,
    NULL AS uc_nk4,
    0::text AS ancestor_list
	FROM DOI
    CROSS JOIN DT
	CROSS JOIN DEFAULT_DICT_ID DDI
	INNER JOIN MH 
	ON MH.element_code = 'US'
	LEFT JOIN ctrg_support.business_region_dict_key_ids cad
	 ON cad.dur_uk = MH.element_code;