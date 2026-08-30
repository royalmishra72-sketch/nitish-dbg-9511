drop view if exists VIN_CATALOG_MAP_BASE_W_V;

CREATE or REPLACE VIEW pub_work.VIN_CATALOG_MAP_BASE_W_V
as
with min_data as
		(SELECT EIGHTEEN_DIGIT_MODEL_CODE , count(1) min_count
        FROM bl.bl_f31db157_min bfdm 
        GROUP BY EIGHTEEN_DIGIT_MODEL_CODE
        ),
    vin_one as (    
		/** <SBS_RULE>CHECK IN MODEL CONTROL TABLE TO CHECK IF PROD DATE LIES BETWEEN ADOPTION DATE AND ABOLISH DATE, IF NOT THEN ADJUST FILTER DATE ACCORDING TO BOUNDARY VALUES</SBS_RULE>*/
		select distinct 
			  E.VIN_TYPE,
			  E.SERIAL_NUMBER,
			  E.EIGHTEEN_DIGIT_MODEL_CODE,
			  E.CATALOG_MODEL,
			  E.DESTINATION,
			  E.POSITION,
			  concat(E.PROD_MONTH,E.PROD_YEAR) AS PROD_DATE,
			  E.PROD_DAY,
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
			  e.min_count
		from   (
				   SELECT 	VIN.VIN_TYPE,
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
					  and  min_data.min_count = 1 
					  and  coalesce(VIN.PROD_YEAR,'')::numeric  <= 2017
				UNION ALL
				   SELECT 	VIN.VIN_TYPE,
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
					  and  min_data.min_count = 1 
					  and  coalesce(VIN.PROD_YEAR,'')::numeric  > 2017
				) E	  
			),	
			vin_range_serial as 
	        (
			select distinct v.*
			from   vin_multi_cat_w v
			inner join  pub_work.vin_type_range_w vt
			 ON (   v.CATALOG_MODEL = vt.CATALOG_MODEL
			    AND v.DESTINATION = vt.DESTINATION)   
			    and   (
			    		( v.range_vin_type = vt.VIN_TYPE
			             AND v.SERIAL_NUMBER BETWEEN vt.START_NUMBER AND vt.END_NUMBER)
                       )    
			),
vin_range_date	as
 		(   
			select distinct vin_type ,
				  serial_number ,
				  eighteen_digit_model_code ,
				  catalog_model ,
				  destination ,
				  position ,
				  prod_date ,
				  prod_day ,
				  filter_date ,
				  trim_color ,
				  body_color ,
				  spec_seq ,
				  display_title1 ,
				  display_title2 ,
				  display_title3 ,
				  display_title4 ,
				  display_title5 ,
				  display_title6 ,
				  display_title7 ,
				  display_title8				  
			from   (
					select vm.*,
						concat((
						    CASE
						      WHEN SUBSTR(vt.START_DATE,1,2)::numeric > 70
						      THEN SUBSTR(vt.START_DATE,1,2)::numeric+1900
						      WHEN SUBSTR(vt.START_DATE,1,2)::numeric < 70
						      THEN SUBSTR(vt.START_DATE,1,2)::numeric + 2000
						      ELSE 9999
						    END)::varchar
						    ,SUBSTR(vt.START_DATE,3,2)) AS START_DATE,
						    (
						    CASE
						      WHEN SUBSTR(vt.END_DATE,1,2)::numeric > 70
						      THEN SUBSTR(vt.END_DATE,1,2)::numeric+1900
						      WHEN SUBSTR(vt.END_DATE,1,2)::numeric < 70
						      THEN SUBSTR(vt.END_DATE,1,2)::numeric + 2000
						      ELSE 9999
						    END)::varchar||
						    SUBSTR(vt.END_DATE,3,2) AS end_date
						 /** <SBS_RULE>Use double pipe to generate NULL if end_date is null</SBS_RULE>*/
					from   vin_multi_cat_w vm
					left join  vin_range_serial v1
					on (  vm.vin_type = v1.vin_type
						and  vm.serial_number = v1.serial_number
						)
					inner join  pub_work.vin_type_range_w vt
					 ON (   vm.CATALOG_MODEL = vt.CATALOG_MODEL
					    AND vm.DESTINATION = vt.DESTINATION)   
					where  v1.catalog_model is NULL    
					) r 	
			where r.filter_date between r.start_date::numeric and coalesce(r.end_date::numeric,999999)	
			),
  vin_exception  as	
			(
			select distinct vm.*
			from   vin_multi_cat_w vm
		    inner join bl.bl_sbs_catalog_dist cat 
		    on (vm.catalog_model = cat.catalog_model 
		    and substr(vm.vin_type,1,3) = cat.vin_type
		    	)
			where not exists 			
						(
						select 1
						from   vin_range_serial v1
						where  vm.vin_type = v1.vin_type
						and  vm.serial_number = v1.serial_number
							)
			and  not exists 	(
					select 1
					from   vin_range_date v2
					where  vm.vin_type = v2.vin_type
					and  vm.serial_number = v2.serial_number
					)
			)
select    /*
		  * <SBS_PROLOG>
		  * PROJECT:  NISSAN DATA PUBLISHING
		  * PURPOSE:  THIS VIEW IS USED IN THE POPULATION OF THE VIN_CATALOG_MAP_BASE_W TABLE.		  
		  *           THIS VIEW  MERGES ALL DATA OF VIN MIN CATALOG DATA For VIN's THAT HAS ONE TO ONE MAPPING 
						Plus ONE's THAT HAVE ONE TO MANY MAPPING OF CATALOG.
		  *
		  * PL/SQL OBJECTS USED:
		  *   <OBJECT TYPE> - <SCHEMA OWNER> - <OBJECT NAME>
		  *===========================================================
		  * REVISION HISTORY
		  *   REF #  DATE          REVISOR      COMMENT
		  *   1            2015    NS          INITIAL REVISION
		  *   2      05/04/2017    NK          ADDED FEW DRS COMMENTS(NOT ADDED SBS RULES).
		  *   3      02/05/2023    CB          Rewritten for NextGen
		  *   4      19/08/2023    DU          View updated to use vin_type_range_w table instead of bl_f31db163_vin_type_range table.
		  *   5      28/01/2026    CB          Use of BL_SBS_VINCHECK restricted till 2017 VINs. Ref. NSPUB-1390. 
		  *===========================================================
		  * REVISOR
		  *   NS            NISHANT SONI
		  *   NK            NISHANT KARIYA
		  *   CB            Chandan Bhatia
		  *   DU            Dilesh Ukey
		  *===========================================================
		  * </SBS_PROLOG>
		  * <SBS_SRCTAB  owner="BL" name="BL_F31DB157_MIN"/>
		  * <SBS_SRCTAB  owner="BL" name="BL_F31X1340_VIN"/>
		  * <SBS_SRCTAB  owner="BL" name="BL_F31DB155_DISPLAY_GROUP"/>
		  * <SBS_SRCTAB  owner="PUB_WORK" name="VIN_TYPE_RANGE__W"/>
		  * <SBS_SRCTAB  owner="BL" name="BL_SBS_YEAR_CODE"/>
		  * <SBS_SRCTAB  owner="BL" name="BL_SBS_VINCHECK"/>
		  * <SBS_SRCTAB  owner="BL" name="BL_SBS_CATALOG_DIST"/>
		  * <SBS_SRCTAB  owner="PUB_WORK" name="VIN_MULTI_CAT_W"/>
		  * <SBS_DESTTAB owner="PUB_WORK" name="VIN_CATALOG_MAP_BASE_W" />
		  * <SBS_PRCGRP NAME="VIN_PROD_DATE_SWITCHING" SEQ="2"/>
		  */
		  vin_type ,
		  serial_number ,
		  eighteen_digit_model_code ,
		  catalog_model ,
		  destination ,
		  position ,
		  prod_date ,
		  prod_day ,
		  filter_date ,
		  trim_color ,
		  body_color ,
		  spec_seq ,
		  display_title1 ,
		  display_title2 ,
		  display_title3 ,
		  display_title4 ,
		  display_title5 ,
		  display_title6 ,
		  display_title7 ,
		  display_title8	
from   vin_one
union all
select    vin_type ,
		  serial_number ,
		  eighteen_digit_model_code ,
		  catalog_model ,
		  destination ,
		  position ,
		  prod_date ,
		  prod_day ,
		  filter_date ,
		  trim_color ,
		  body_color ,
		  spec_seq ,
		  display_title1 ,
		  display_title2 ,
		  display_title3 ,
		  display_title4 ,
		  display_title5 ,
		  display_title6 ,
		  display_title7 ,
		  display_title8	
from   vin_range_serial
union all
select    vin_type ,
		  serial_number ,
		  eighteen_digit_model_code ,
		  catalog_model ,
		  destination ,
		  position ,
		  prod_date ,
		  prod_day ,
		  filter_date ,
		  trim_color ,
		  body_color ,
		  spec_seq ,
		  display_title1 ,
		  display_title2 ,
		  display_title3 ,
		  display_title4 ,
		  display_title5 ,
		  display_title6 ,
		  display_title7 ,
		  display_title8	
from   vin_range_date
union all
select    vin_type ,
		  serial_number ,
		  eighteen_digit_model_code ,
		  catalog_model ,
		  destination ,
		  position ,
		  prod_date ,
		  prod_day ,
		  filter_date ,
		  trim_color ,
		  body_color ,
		  spec_seq ,
		  display_title1 ,
		  display_title2 ,
		  display_title3 ,
		  display_title4 ,
		  display_title5 ,
		  display_title6 ,
		  display_title7 ,
		  display_title8	
from   vin_exception;



			

	
