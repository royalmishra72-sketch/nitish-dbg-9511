drop view if exists ein_addl_info_w_v;

CREATE or REPLACE VIEW pub_work.ein_addl_info_w_v AS 
WITH vin_cat_map as not materialized
         ( /* <SBS_RULE> THIS CLAUSE WILL FETCH DATA OF VIN_CATALOG_MAP_W, JOIN WITH BL_SBS_CATALOG.</SBS_RULE>*/
		      SELECT   --DISTINCT 
		      			wvcm.*							
              FROM vin_catalog_map_w wvcm
              JOIN bl.bl_sbs_catalog b
              ON   wvcm.catalog_model = b.model
             WHERE b.status = 'Y'
			 ),	
	/*		 
     VIN_1
        AS (  <SBS_RULE> THIS CLAUSE WILL FETCH DATA OF VIN_CAT_MAP WHERE SEQUENCE NOT IN ('0000000001', '0000000000')</SBS_RULE>
		     SELECT vin_type,
                   serial_number,
                   CATALOG_MODEL,
                   SPEC_SEQ
              FROM VIN_CAT_MAP
             WHERE SPEC_SEQ NOT IN ('0000000001', '0000000000')),	
           */  		 
    vin_spec
        AS ( /* <SBS_RULE> THIS CLAUSE WILL FETCH DATA OF VIN_1 JOIN SPEC_CODE_W</SBS_RULE>*/
		    SELECT vcm.vin_type,
                   vcm.serial_number,
                   vcm.catalog_model AS vin_catalog,
                   spec.spec_code AS spec_code,
                   bnml.catalog_model as spec_catalog
            FROM   VIN_CAT_MAP vcm
            JOIN   pub_work.spec_code_w spec
            ON     vcm.spec_seq = spec.spec_sequence
	        left  JOIN bl.bl_f31db076_spec_data bnml
	          ON   spec.spec_code = bnml.spec_code
	          AND vcm.catalog_model = bnml.catalog_model
	        WHERE SPEC_SEQ NOT IN ('0000000001', '0000000000')  
			),
	/*		
    spec_data
        AS (   <SBS_RULE> THIS CLAUSE WILL FETCH DATA OF VIN_SPEC JOIN BL_F31DB076_SPEC_DATA</SBS_RULE>
		    SELECT vs.vin_type,
                   vs.serial_number,
                   vs.VIN_CATALOG,
                   vs.spec_code,
                   bnml.catalog_model AS spec_catalog
              FROM vin_spec vs
              JOIN bl.bl_f31db076_spec_data bnml
              ON   vs.spec_code = bnml.spec_code
              AND vs.vin_catalog = bnml.catalog_model
			)			
    vin_nocatalog
		AS (  <SBS_RULE> THIS CLAUSE WILL FETCH DATA OF VIN_SPEC EXCEPT SPEC_DATA</SBS_RULE>
		    SELECT vin_type, serial_number, spec_code FROM vin_spec
            EXCEPT
            SELECT vin_type, serial_number, spec_code FROM spec_data
			),			
    spec_addvalue
        AS (  <SBS_RULE> THIS CLAUSE WILL FETCH DATA OF VIN_SPEC JOIN WITH VIN_NOCATALOG AND UNION ALL WITH SPEC_DATA</SBS_RULE>
		     SELECT a.vin_type, a.serial_number, a.vin_catalog, a.spec_code, null as spec_catalog
             FROM  vin_spec a JOIN  vin_nocatalog b
             ON  a.vin_type = b.vin_type
             AND a.serial_number = B.SERIAL_NUMBER
             AND a.spec_code = b.spec_code
            UNION ALL
            SELECT vin_type, serial_number, vin_catalog, spec_code, spec_catalog
            FROM spec_data),*/
	addvalue
        AS ( /* <SBS_RULE> THIS CLAUSE WILL FETCH DUR_UK_EIN , DUR_UK_ADDL FROM VIN_CAT_MAP UNION ALL WITH SPEC_ADDVALUE</SBS_RULE>*/
           SELECT 
				--concat(vin_type,serial_number) AS dur_uk_ein,
           		  vin_type,
           		  serial_number, 
           		  catalog_model,	
                  concat('MIN|',eighteen_digit_model_code) AS dur_uk_addl,
                  'MIN' as code
           FROM  vin_cat_map
           where  eighteen_digit_model_code IS NOT NULL
           UNION ALL
           SELECT 
				--concat(vin_type,serial_number)AS dur_uk_ein,
           		  vin_type,
				  serial_number,
				  vin_catalog as catalog_model,	
                  concat('Spec Codes','|',spec_code,'|',spec_catalog) AS dur_uk_addl,
                  'Spec_Codes' as code
           FROM vin_spec
           ),
	s_data AS
    (SELECT spec_code,catalog_model,spec_translation from bl.bl_f31db076_spec_data where spec_code <> '*****'
     UNION
     SELECT DISTINCT spec_code,null as catalog_model, spec_code as spec_translation 
     FROM spec_code_w WK 
	 WHERE NOT EXISTS (SELECT 1 
	 				   FROM bl.bl_f31db076_spec_data SP 
	 				   WHERE SP.spec_code = WK.SPEC_CODE 
	 				   AND SP.catalog_model is null)),
	/*
	codevalue AS
   (
   <SBS_RULE> THIS CLAUSE WILL FETCH DATA ELEMENT_DESC AND ADDTIONAL INFO VALUE,FROM TABLE 'WRK_MERGE_PARTS' AND 'BL_SBS_META_HEADER' .</SBS_RULE>
	SELECT DISTINCT
		    h.element_desc AS element_desc,
		    concat(h.element_desc,'|', eighteen_digit_model_code) AS DUR_UK,
    h.sort_seq
  FROM vin_catalog_map_w
  cross join bl.bl_sbs_meta_header h
  WHERE eighteen_digit_model_code IS NOT null
  and   h.group_name='VIN'
  and   h.element_code='MIN'
	),*/  
  codevalue AS
  (
	  /* <SBS_RULE> THIS CLAUSE WILL FETCH DATA ELEMENT_DESC AND ADDTIONAL INFO VALUE,FROM TABLE 'WRK_MERGE_PARTS' AND 'BL_SBS_META_HEADER' .</SBS_RULE>*/
		SELECT DISTINCT
			    h.element_desc AS element_desc,
			    concat(h.element_desc,'|', eighteen_digit_model_code) AS DUR_UK,
	    h.sort_seq,
	    NULL AS SPEC_TRANSLATION
	  FROM vin_catalog_map_w
	  cross join bl.bl_sbs_meta_header h
	  WHERE eighteen_digit_model_code IS NOT null
	  and   h.group_name='VIN'
	  and   h.element_code='MIN'  
	  UNION ALL
	  SELECT --DISTINCT 
			spec_code::VARCHAR   AS element_desc,
			concat(h.element_desc,'|',spec_code,'|',catalog_model) AS DUR_UK,
			h.sort_seq as sort_seq,
			spec_translation
		FROM s_data
		cross join  bl.bl_sbs_meta_header h
		WHERE group_name='VIN'
		AND element_code='Spec_Codes'		
  ),
  codevalue1 as materialized (
	  select cval.*, 
	  		 CASE
		          WHEN cval.element_desc IN ('FORMER PART NUMBER','ALT NUM')
		          THEN concat(substring(substring(cval.dur_uk,position('|' in cval.dur_uk) +1),1,5),'-',
		                   substring(substring(cval.dur_uk,position('|' in cval.dur_uk) +1),6))
		          WHEN split_part(cval.dur_uk,'|',2)is not null
		          THEN coalesce(cval.spec_translation,substring(cval.dur_uk,position('|' in cval.dur_uk) +1))
		          ELSE substring(cval.dur_uk,position('|' in cval.dur_uk) +1)
		      END AS addl_info_value_dict	
	  from  codevalue cval
	  )
   SELECT --distinct
   			/*
          * <SBS_PROLOG>
          * Project:  NISSAN DATA PUBLISHING
          * Purpose:  This view is used in the population of the EIN_ADDL_INFO_W table
          * PL/SQL Objects Used:
          *   <Object Type> - <Schema Owner> - <Object Name>
          *===========================================================
          * Revision History
          *   Ref #  Date          Revisor      Comment
          *   1      15-05-2023    PR          Initial revision
          *   2      21-07-2023    CB          Optimized
          *===========================================================
          * Revisor
          *   PR                PAWAN RAJAK
		  *   CB                Chandan Bhatia
          *===========================================================
          * </SBS_PROLOG>
          * <SBS_SRCTAB owner="PUB_WORK" name="VIN_CATALOG_MAP_W" />
          * <SBS_SRCTAB owner="CTRG_SUPPORT" name="DATA_ORIGIN" />
          * <SBS_DESTTAB owner="PUB_WORK" name="EIN_ADDL_INFO_W" />
          * <SBS_PRCGRP name="" seq=""/>
          */
		  catalog_dur_uk, /** <SBS_RULE> CATALOG_DUR_UK IS PICKED FROM REFERRRING TABLE_NAME AS 'VIN_CATALOG_MAP_W'. </SBS_RULE> **/
          ein_dur_uk, /** <SBS_RULE> CATALOG_DUR_UK IS PICKED FROM REFERRRING TABLE_NAME AS 'VIN_CATALOG_MAP_W'. </SBS_RULE> **/
          code, /** <SBS_RULE> CODE IS PICKED FROM REFERRRING CTRG ADDVALUE. </SBS_RULE> **/
          addl_info_name_dict_dur_uk,/** <SBS_RULE> ADDL_INFO_NAME_DICT_DUR_UK IS PICKED FROM REFERRRING CTRG CODEVALUE1. </SBS_RULE> **/
          addl_info_value_dict,
		  concat('EIN','|',addl_info_name_dict_dur_uk,'|',sbs_util.get_hash_varchar(addl_info_value_dict))
			AS addl_info_value_dict_dur_uk,
			sort_seq 			  
		  FROM ( SELECT  av.catalog_model AS catalog_dur_uk,
                         concat(av.vin_type,av.serial_number) AS ein_dur_uk,				         
		                 h.element_desc as code,
		                 h.sort_seq,
                         cval.element_desc as addl_info_name_dict_dur_uk,				   
                         cval.addl_info_value_dict				   
            FROM 	addvalue av	
			--INNER JOIN pub_work.vin_catalog_map_w vdu
	        --ON av.dur_uk_ein = concat(vdu.vin_type,vdu.serial_number)
			--ON (av.vin_type = vdu.vin_type
			--and  av.serial_number = vdu.serial_number)
			INNER JOIN codevalue1 cval
	        ON cval.dur_uk = av.dur_uk_addl
	        inner join bl.bl_sbs_meta_header h
            on   h.element_code = av.code
			WHERE h.group_name = 'VIN' 
	        )a;
