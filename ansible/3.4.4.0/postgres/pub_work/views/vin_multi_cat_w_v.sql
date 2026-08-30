drop view if exists vin_multi_cat_w_v;

CREATE or REPLACE VIEW pub_work.vin_multi_cat_w_v as 
with min_data as
		(SELECT EIGHTEEN_DIGIT_MODEL_CODE , count(1) min_count
        FROM bl.bl_f31db157_min bfdm 
        GROUP BY EIGHTEEN_DIGIT_MODEL_CODE
        )
	select /*
		  * <SBS_PROLOG>
		  * PROJECT:  NISSAN DATA PUBLISHING
		  * PURPOSE:  THIS VIEW IS USED IN THE POPULATION OF THE VIN_MULTI_CAT_W TABLE.
		  *           THIS VIEW BASICALLY PICKS ALL VIN DATA AND JOINS IT WITH MIN DATA FOR THOSE MINS, 
					  THAT ARE MAPPED TO MORE THAN 1 CATALOG. THEN DATA IS JOINED WITH BL_F31DB155_DISPLAY_GROUP
					  TO DERIVE CATALOG FILTERS.
		  *
		  * PL/SQL OBJECTS USED:
		  *   <OBJECT TYPE> - <SCHEMA OWNER> - <OBJECT NAME>
		  *===========================================================
		  * REVISION HISTORY
		  *   REF #  DATE          REVISOR      COMMENT
		  *   1            2015    NS          INITIAL REVISION
		  *   2      05/04/2017    NK          ADDED FEW DRS COMMENTS(NOT ADDED SBS RULES).
		  *   3      02/05/2023    CB          Rewritten for NextGen
		  *   4      28/01/2026    CB          Use of BL_SBS_VINCHECK restricted till 2017 VINs. Ref. NSPUB-1390. 
		  *===========================================================
		  * REVISOR
		  *   NS            NISHANT SONI
		  *   NK            NISHANT KARIYA
		  *   CB            Chandan Bhatia
		  *===========================================================
		  * </SBS_PROLOG>
		  * <SBS_SRCTAB  owner="BL" name="LANGIDS"/>
		  * <SBS_SRCTAB  owner="BL" name="BL_F31DB157_MIN"/>
		  * <SBS_SRCTAB  owner="BL" name="BL_F31X1340_VIN"/>
		  * <SBS_SRCTAB  owner="BL" name="BL_F31DB155_DISPLAY_GROUP"/>
		  * <SBS_SRCTAB  owner="BL" name="BL_SBS_VINCHECK"/>
		  * <SBS_SRCTAB  owner="BL" name="BL_SBS_YEAR_CODE"/>
		  * <SBS_SRCTAB  owner="BL" name="BL_SBS_CATALOG"/>
		  * <SBS_DESTTAB owner="PUB_WORK" name="VIN_MULTI_CAT_W"/>
		  * <SBS_PRCGRP NAME="VIN_PROD_DATE_SWITCHING" SEQ="1"/>
		  */
		  E.VIN_TYPE,
		  E.SERIAL_NUMBER,
		  E.EIGHTEEN_DIGIT_MODEL_CODE,
		  E.CATALOG_MODEL,
		  E.DESTINATION,
		  E.POSITION,
		  concat(E.PROD_MONTH,E.PROD_YEAR) AS PROD_DATE,
		  E.PROD_DAY,
	      /** <SBS_RULE>CHECK IN MODEL CONTROL TABLE TO CHECK IF PROD DATE LIES BETWEEN ADOPTION DATE AND ABOLISH DATE, 
			IF NOT THEN ADJUST FILTER DATE ACCORDING TO BOUNDARY VALUES</SBS_RULE>*/
		  case 
			   WHEN 
			   concat(E.PROD_YEAR,E.PROD_MONTH)::numeric NOT BETWEEN 
			   concat(E.ADOPTION_YEAR,E.ADOPTION_MONTH)::numeric AND concat(E.ABOLISH_YEAR,E.ABOLISH_MONTH)::numeric
			  THEN (
				CASE
				  WHEN concat(E.PROD_YEAR,E.PROD_MONTH)::numeric < concat(E.ADOPTION_YEAR,E.ADOPTION_MONTH)::numeric
				  THEN concat(E.ADOPTION_YEAR,E.ADOPTION_MONTH)::numeric
				  ELSE concat(E.ABOLISH_YEAR,E.ABOLISH_MONTH)::numeric
				END)
			  ELSE concat(E.PROD_YEAR,E.PROD_MONTH)::numeric
			END AS FILTER_DATE,
		--  ADOPTION_YEAR,
		--  ADOPTION_MONTH,
		  E.TRIM_COLOR,
		  E.BODY_COLOR,
		  E.SPEC_SEQ,
		  E.DISPLAY_TITLE1,
		  E.DISPLAY_TITLE2,
		  E.DISPLAY_TITLE3,
		  E.DISPLAY_TITLE4,
		  E.DISPLAY_TITLE5,
		  E.DISPLAY_TITLE6,
		  E.DISPLAY_TITLE7,
		  E.DISPLAY_TITLE8,
		  concat(SUBSTR(VIN_TYPE, 1, 8), ' ', SUBSTR(VIN_TYPE, 10, 2)) range_vin_type
	from   (
			   SELECT --DISTINCT 
						VIN.VIN_TYPE,
						VIN.SERIAL_NUMBER,
						B.CATALOG_MODEL,
						VIN.PROD_YEAR,
						VIN.PROD_MONTH,
						VIN.PROD_DAY,
						B.EIGHTEEN_DIGIT_MODEL_CODE,
						B.POSITION,
						B.DESTINATION,
						VIN.TRIM_COLOR,
						VIN.BODY_COLOR,
						VIN.SPEC_SEQ,        
					  D.MODEL_NAME,
					  CASE
						WHEN SUBSTR(D.ADOPTION_DATE,1,2)::numeric > 70
						THEN SUBSTR(D.ADOPTION_DATE,1,2)::numeric+1900
						WHEN SUBSTR(D.ADOPTION_DATE,1,2)::numeric < 70
						THEN SUBSTR(D.ADOPTION_DATE,1,2)::numeric + 2000
						ELSE 9999
					  END::varchar                                 AS ADOPTION_YEAR ,
					  coalesce(SUBSTR(D.ADOPTION_DATE,3,2),'99') AS ADOPTION_MONTH,
					  CASE
						WHEN SUBSTR(D.ABOLISH_DATE,1,2)::numeric > 70
						THEN SUBSTR(D.ABOLISH_DATE,1,2)::numeric+1900
						WHEN SUBSTR(D.ABOLISH_DATE,1,2)::numeric < 70
						THEN SUBSTR(D.ABOLISH_DATE,1,2)::numeric + 2000
						ELSE 9999
					  END::varchar                                AS ABOLISH_YEAR ,
					  coalesce(SUBSTR(D.ABOLISH_DATE,3,2),'99') AS ABOLISH_MONTH,
					  D.DISPLAY_TITLE1,
					  D.DISPLAY_TITLE2,
					  D.DISPLAY_TITLE3,
					  D.DISPLAY_TITLE4,
					  D.DISPLAY_TITLE5,
					  D.DISPLAY_TITLE6,
					  D.DISPLAY_TITLE7,
					  D.DISPLAY_TITLE8,
					  min_data.min_count
			   FROM  bl.BL_F31X1340_VIN VIN 
				JOIN bl.BL_SBS_VINCHECK vincheck
				ON SUBSTR(vin.vin_type,1,3) = vincheck.mfg_identifier
				AND concat(SUBSTR(vin.vin_type,vincheck.pos_1::integer,1) ,SUBSTR(VIN.VIN_TYPE,VINCHECK.POS_2::integer,1))=VINCHECK.CHECK_STRING
				  inner JOIN bl.BL_F31DB157_min B
				  ON (VIN.MODEL_PREFIX
					||VIN.MODEL_BASE
					||VIN.MODEL_SUFFIX                 = B.EIGHTEEN_DIGIT_MODEL_CODE)
				  inner join  min_data on ( B.EIGHTEEN_DIGIT_MODEL_CODE = min_data.EIGHTEEN_DIGIT_MODEL_CODE)
				JOIN bl.BL_F31DB155_DISPLAY_GROUP D
				ON (B.CATALOG_MODEL = D.CATALOG_MODEL
				AND B.DESTINATION   = D.DESTINATION)	  
				WHERE coalesce(VIN.PROD_YEAR,'')  <> ''
				  AND PROD_YEAR             <> '0000'
				  AND SUBSTR(VIN_TYPE,10,1) IN (SELECT DISTINCT CODE FROM BL.BL_SBS_YEAR_CODE)
				  and min_data.min_count > 1 
				  and coalesce(VIN.PROD_YEAR,'')::numeric  <= 2017				  
				union all    
			   SELECT --DISTINCT 
						VIN.VIN_TYPE,
						VIN.SERIAL_NUMBER,
						B.CATALOG_MODEL,
						VIN.PROD_YEAR,
						VIN.PROD_MONTH,
						VIN.PROD_DAY,
						B.EIGHTEEN_DIGIT_MODEL_CODE,
						B.POSITION,
						B.DESTINATION,
						VIN.TRIM_COLOR,
						VIN.BODY_COLOR,
						VIN.SPEC_SEQ,        
					  D.MODEL_NAME,
					  CASE
						WHEN SUBSTR(D.ADOPTION_DATE,1,2)::numeric > 70
						THEN SUBSTR(D.ADOPTION_DATE,1,2)::numeric+1900
						WHEN SUBSTR(D.ADOPTION_DATE,1,2)::numeric < 70
						THEN SUBSTR(D.ADOPTION_DATE,1,2)::numeric + 2000
						ELSE 9999
					  END::varchar                                 AS ADOPTION_YEAR ,
					  coalesce(SUBSTR(D.ADOPTION_DATE,3,2),'99') AS ADOPTION_MONTH,
					  CASE
						WHEN SUBSTR(D.ABOLISH_DATE,1,2)::numeric > 70
						THEN SUBSTR(D.ABOLISH_DATE,1,2)::numeric+1900
						WHEN SUBSTR(D.ABOLISH_DATE,1,2)::numeric < 70
						THEN SUBSTR(D.ABOLISH_DATE,1,2)::numeric + 2000
						ELSE 9999
					  END::varchar                                AS ABOLISH_YEAR ,
					  coalesce(SUBSTR(D.ABOLISH_DATE,3,2),'99') AS ABOLISH_MONTH,
					  D.DISPLAY_TITLE1,
					  D.DISPLAY_TITLE2,
					  D.DISPLAY_TITLE3,
					  D.DISPLAY_TITLE4,
					  D.DISPLAY_TITLE5,
					  D.DISPLAY_TITLE6,
					  D.DISPLAY_TITLE7,
					  D.DISPLAY_TITLE8,
					  min_data.min_count
			   FROM  bl.BL_F31X1340_VIN VIN 
			   /*
				JOIN bl.BL_SBS_VINCHECK vincheck
				ON SUBSTR(vin.vin_type,1,3) = vincheck.mfg_identifier
				AND concat(SUBSTR(vin.vin_type,vincheck.pos_1::integer,1) ,SUBSTR(VIN.VIN_TYPE,VINCHECK.POS_2::integer,1))=VINCHECK.CHECK_STRING
				*/
				    inner JOIN bl.BL_F31DB157_min B
				  ON (VIN.MODEL_PREFIX
					||VIN.MODEL_BASE
					||VIN.MODEL_SUFFIX                 = B.EIGHTEEN_DIGIT_MODEL_CODE)
				  inner join  min_data on ( B.EIGHTEEN_DIGIT_MODEL_CODE = min_data.EIGHTEEN_DIGIT_MODEL_CODE)
				JOIN bl.BL_F31DB155_DISPLAY_GROUP D
				ON (B.CATALOG_MODEL = D.CATALOG_MODEL
				AND B.DESTINATION   = D.DESTINATION)	  
				WHERE coalesce(VIN.PROD_YEAR,'')  <> ''
				  AND PROD_YEAR             <> '0000'
				  AND SUBSTR(VIN_TYPE,10,1) IN (SELECT DISTINCT CODE FROM BL.BL_SBS_YEAR_CODE)
				  and    min_data.min_count > 1 
				and  coalesce(VIN.PROD_YEAR,'')::numeric  > 2017	
				and  B.catalog_model  in (select bsc.model from bl.bl_sbs_catalog bsc where  bsc.status = 'Y')
			) E	;
