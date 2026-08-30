drop view if exists image_blob_v;

CREATE or REPLACE VIEW pub_work.image_blob_v as 
WITH 
      img_type_default AS
       ( /** <SBS_RULE> THIS CLAUSE WILL FETCH TYPE ID OF IMAGE, HAVING TYPE_NAME  AS 'DEFAULT'. </SBS_RULE>*/ 
        SELECT 1 AS image_type_id
        --FROM image_type
        --WHERE type_name = 'DEFAULT'
       ),
	  img_type_thumbnail AS
       ( /** <SBS_RULE> THIS CLAUSE WILL FETCH TYPE ID OF IMAGE, HAVING TYPE_NAME  AS 'THUMBNAIL'. </SBS_RULE>*/ 
        SELECT 3 AS image_type_id
       -- FROM image_type
       -- WHERE type_name = 'THUMBNAIL'
       ),
	   mime_type_png AS
       ( /** <SBS_RULE> THIS CLAUSE WILL FETCH MIME_TYPE ID FOR IMAGE, HAVING EXTENSION  AS 'PNG', AS WE HAVE ALL PNG IMAGES.. </SBS_RULE>*/ 
        SELECT 3 AS mime_type_id
        --FROM mime_type
        --WHERE lower(extension) = 'png'
       ),
	   mime_type_jpg AS
       ( /** <SBS_RULE> THIS CLAUSE WILL FETCH MIME_TYPE ID FOR IMAGE, HAVING EXTENSION  AS 'PNG', AS WE HAVE ALL PNG IMAGES.. </SBS_RULE>*/ 
        SELECT 2 AS mime_type_id
       -- FROM mime_type
        --WHERE lower(extension) = 'jpeg'
       ),
	   dod AS 
	   (  /** <SBS_RULE> THIS CLAUSE WILL FETCH DATA ORIGIN ID, THIS WILL BE THE ID OF DATA ORIGIN NAMED 'NIS|ALL', FROM TABLE 'DATA_ORIGIN'. </SBS_RULE>*/
         SELECT dod.data_origin_id AS data_origin_id
         FROM ctrg_support.data_origin dod
         WHERE dod.dur_uk = 'NIS|ALL'
       ),
	   lm AS 
	  ( /** <SBS_RULE> THIS CLAUSE WILL FETCH LANG CODE OF ENGLISH LANGUAGE OF CDR, FROM TABLE 'LANG_MASTER'. </SBS_RULE>*/  
        SELECT --lang_id,
               locale_code
        FROM ctrg.lang_master
        WHERE locale_code = 'en_US'
       ),
	   bid AS 
	   ( /** <SBS_RULE> THIS CLAUSE WILL FETCH ILLUSTRATIONS FROM BL_IMAGE_DATA TABLE </SBS_RULE>*/ 
        SELECT bd.img_name,
               bd.img_hash,
               bd.img_data,
               bd.img_callout_data,
               bd.img_callout_hash,
               bd.attribute1
			   --iw.catalog as mdl_ser_code,
			   --iw.sec_num as sec_num			   
             /*  split_part(Img_Name, '-', 1) as mdl_ser_code,
               CASE WHEN length(Img_Name) - length(REPLACE(Img_Name,'-','')) = 1 
					THEN split_part(Img_Name, '-', 2)
                    WHEN length(Img_Name) - length(REPLACE(Img_Name,'-','')) = 2
					THEN split_part(Img_Name, '-', 2)
                END  AS sec_num */	
        FROM   pub_work.image_data_w bd		
        WHERE bd.attribute1 = 'NIS_ILLUSTRATIONS'
        AND  bd.img_name NOT LIKE 'NO_IMAGE%'
		AND EXISTS (SELECT 1 
		            FROM pub_work.image_w iw
					WHERE iw.img_name = bd.img_name)
       ),
	   bti AS 
	   (  /** <SBS_RULE> THIS CLAUSE WILL FETCH THUMBNAIL IMAGES FROM BL_THUMBNAIL_IMAGES TABLE </SBS_RULE>*/
        SELECT img_name,
               img_hash,
               img_data,
               attribute1
              /* split_part(Img_Name, '-', 1) as mdl_ser_code,
               CASE WHEN length(Img_Name) - length(REPLACE(Img_Name,'-','')) = 1  
			        THEN split_part(Img_Name, '-', 2)
                    WHEN length(Img_Name) - length(REPLACE(Img_Name,'-','')) = 2
					THEN split_part(Img_Name, '-', 2)
               END AS sec_num
			   mdl_ser_code,
			   sec_num*/
         FROM
            (SELECT split_part(bd.img_name, '_t', 1) img_name,
                    bd.img_hash,
                    bd.img_data,
                    bd.attribute1
               FROM  pub_work.image_data_w bd
               WHERE bd.attribute1 = 'NISTHUMBNAIL'
               AND  bd.img_name NOT LIKE 'NO_IMAGE%'
			   AND EXISTS (SELECT 1
			               FROM pub_work.image_w iw
						   WHERE split_part(bd.img_name, '_t', 1) = iw.img_name)
             )a
        ),
	   bti_no_image AS 
	   ( /** <SBS_RULE> THIS CLAUSE WILL FETCH THUMBNAIL FOR NOIMAGE FROM BL_THUMBNAIL_IMAGES </SBS_RULE>*/
        SELECT replace(img_name,'_t','') img_name,
              img_hash,
              img_data,
              attribute1
        FROM   pub_work.image_data_w
        WHERE attribute1 = 'NISTHUMBNAIL'
        AND   img_name = 'NO_IMAGE_t'
       ),
	   bid_no_img AS 
	   ( /** <SBS_RULE> THIS CLAUSE WILL FETCH THOSE ILLUSTRATION FROM BL_IMAGE_DATA TABLE FOR WHICH THUMBNAILS DO NOT EXIST</SBS_RULE>*/
        SELECT img_name,
               img_hash,
               img_data,
               img_callout_data,
               img_callout_hash,
               attribute1
        FROM   pub_work.image_data_w
        WHERE attribute1 = 'NIS_ILLUSTRATIONS'
        AND  img_name = 'NO_IMAGE'
       ),
	   bti_no_img_rem AS 
	   (  /** <SBS_RULE> THIS CLAUSE WILL FETCH THOSE ILLUSTRATION FROM BL_IMAGE_DATA TABLE FOR WHICH THUMBNAILS DO NOT EXIST</SBS_RULE>*/
        SELECT a.img_name,
               a.img_hash,
               a.img_data,
               a.img_callout_hash,
               a.attribute1,
               a.attribute2
        FROM  pub_work.image_data_w a
        WHERE a.attribute1 = 'NIS_ILLUSTRATIONS'
        AND    not exists ( SELECT 1
                               FROM   pub_work.image_data_w b
                               WHERE  b.attribute1 = 'NISTHUMBNAIL' 
                               and    concat(a.attribute2,'_THUMB') = b.attribute2  
                               and    a.img_name = split_part(b.img_name, '_t', 1)
                               ) 
        ),   
       bl_image_model AS 
	   (
        SELECT attribute1,
               img_name,
               img_data,
               img_hash
        FROM pub_work.image_data_w
        WHERE attribute1 = 'NISSAN-MODEL'
        AND TRIM(img_name) IS NOT NULL
       ),
	   bl_image_group AS 
	   (
        SELECT attribute1,
               img_name,
               img_data,
               img_hash
        FROM   pub_work.image_data_w
        WHERE attribute1 = 'NISSAN-GROUP'
        AND TRIM(img_name) IS NOT NULL
       )
	/*   bl_sbs AS 
	   (
        SELECT bss.mdl_ser_code,
		       CASE WHEN bss.sec_num = '000' THEN 0::text
                    WHEN bss.sec_num= '000A' THEN '0A'
                    ELSE ltrim(bss.sec_num::text, '0'::text)
				    END as sec_num              
        FROM bl.bl_sbs_section bss
       )*/
	   SELECT
  /**
  * <SBS_PROLOG>
  * Project:  NISSAN DATA PUBLISHING
  * Purpose:  This view is used in the population of the IMAGE_BLOB table.
  *
  * PL/SQL Objects Used:
  *   <Object Type> - <Schema Owner> - <Object Name>
  *===========================================================
  * Revision History
  *   Ref #  Date          Revisor      Comment
  *   1      27/07/2015    AB          Initial revision
  *   2      06/03/2016    KG          Populated CALLOUT_HASH_VALUE. Earlier it was NULL.
  *   3      11/11/2019    AK          NSPUB-242: Figure thumbnails populated from BL_IMAGE_DATA.
  *                                               .jpg extension removed from img_names in BL for Group and Model images.
  *                                               For all available illustrations, corresponding Figure thumbnails will be generated.
  *   4      26/05/2023    PR          View updated according to postgres.
  *   5      26/06/2023    PR          NSPUB-538: Modified code to join pub_work.image_w with bl.bl_image_data on behalf on img_name.
  *   6      05/09/2023    PR          NSPUB-672: Change IMAGE_BLOB_V to use IMAGE instead of IMAGE_KEY_IDS.
  *   7      04/08/2026    CB          Replaced bl.bl_image_data with image_data_w. 
  *===========================================================
  * Revisor
  *   AB            ABHINAV BANSAL
  *   KG            KOMAL GULATI
  *   AK            AMARDEEP KAUR
  *   PR            PAWAN RAJAK
  *   CB            Chandan Bhatia 
  *===========================================================
  * </SBS_PROLOG>
  * <SBS_SRCTAB  owner="CTRG" name="IMAGE"/>
  * <SBS_SRCTAB  owner="PUB_WORK" name="IMAGE_DATA_W" /> 
  * <SBS_SRCTAB  owner="CTRG_SUPPORT" name="DATA_ORIGIN"/>
  * <SBS_DESTTAB owner="CTRG" name="IMAGE_BLOB" />
  * <SBS_PRCGRP name="LOAD_UPPER_NAVIGATION" seq="3"/>
  */
  --/*
  /** <SBS_RULE> KEY_TO_ID FUNCTION IS USED TO GENERATE IMAGE_BLOB_ID, AS IMAGE_BLOB TABLE IN CDR DOESN'T HAVE A DUR_UK,  THIS IS RESTRICTED BY PUBLITE. </SBS_RULE>*/
  --KEY_TO_ID('IMAGE_BLOB', IMAGE_ID|| '|'|| IMAGE_TYPE_ID, DATA_ORIGIN_ID) AS IMAGE_BLOB_ID ,
        b.image_id AS image_id,
		b.image_type AS image_type,
        b.image_data AS image_data,
		b.mime_type AS mime_type,
		b.callout_data AS callout_data,		
		b.checksum_image_data,
		b.checksum_callout_data,
		b.data_origin_id AS data_origin_id,
		0::boolean AS archivable_ind,
        1::boolean AS valid_for_media_ind,
	    0::boolean AS base_lang_flag,
        'en_US' AS locale_code
      FROM
        (/** <SBS_RULE> IN FIRST PART OF UNION, ACTUAL ILLUSTRATIONS ARE FECTCHED FROM BL.. </SBS_RULE> **/
  /** <SBS_RULE> 'IMAGE_ID' IS PICKED FROM IMAGE TABLE. </SBS_RULE>*/
            SELECT iki.image_id as image_id,
	/** <SBS_RULE> IMAGE_TYPE ID INDICATES, WHETHER IT IS A ACTUAL IMAGE OR THUMBNAIL OF IMAGE. REFER  IMG_TYPE_DEFAULT FOR FETCHING SCENARIO.</SBS_RULE>*/
                   it.image_type_id AS image_type,
	/** <SBS_RULE> 'IMAGE_DATA' IS ACTUAL IMAGE, OR ITS THUMBNAIL , FETCHED FROM WORK TABLE 'bl_image_data' </SBS_RULE>*/
                   bid.img_data AS image_data,
    /** <SBS_RULE>MIME_TYPE_ID IS FETCHED FROM TABLE 'MIME_TYPE', WHERE EXTENSION IS 'PNG', AS WE HAVE ALL IMAGES IN PNG.. REFER MIME_TYPE_PNG IN WITH CLAUSE FOR FETCHING SCENARIO. </SBS_RULE>*/
                   mt.mime_type_id AS mime_type,
    /** <SBS_RULE> CALLOUT OF IMAGE . </SBS_RULE> **/
                   bid.img_callout_data AS callout_data,
				   bid.img_hash AS checksum_image_data,
                   bid.img_callout_hash AS checksum_callout_data,
    /** <SBS_RULE> DATA ORIGIN ID IS TAKEN FROM 'DATA_ORIGIN' TABLE WHERE DUR_UK HAS VALUE 'NIS|ALL'.REFER 'DO' IN WITH CLAUSE FOR FETCHING SCENARIO. </SBS_RULE> **/
                  dod.data_origin_id AS data_origin_id             
            FROM bid
            CROSS JOIN dod
	     -- INNER JOIN ctrg_support.image_key_ids iki
			INNER JOIN ctrg.image iki
			ON iki.dur_uk = concat(bid.img_name,'|',bid.attribute1)
           -- INNER JOIN bl_sbs bss 
		   -- ON ( bid.mdl_ser_code = bss.mdl_ser_code AND bid.sec_num = bss.sec_num)
            CROSS JOIN mime_type_png mt
            CROSS JOIN img_type_default it
            UNION ALL
  /** <SBS_RULE> IN THIS PART OF UNION,THUMBNAILS OF IMAGES ARE FETCHED FROM BL.. </SBS_RULE> **/
            SELECT iki.image_id as image_id,
			       it.image_type_id AS image_type,
				   bti.img_data AS image_data,
                   mt.mime_type_id AS mime_type,
                   NULL AS callout_data,                  
                   bti.img_hash AS checksum_image_data,
                   NULL AS checksum_callout_data,
				   dod.data_origin_id AS data_origin_id 
            FROM bti
			INNER JOIN bid ON bid.img_name = bti.img_name
            CROSS JOIN dod
	    --  INNER JOIN ctrg_support.image_key_ids iki	
			INNER JOIN ctrg.image iki
			ON iki.dur_uk = concat(bti.img_name,'|','NIS_ILLUSTRATIONS')		
          --  INNER JOIN bl_sbs bss 
		  --  ON ( bti.mdl_ser_code = bss.mdl_ser_code AND bti.sec_num = bss.sec_num)
            CROSS JOIN mime_type_png mt
            CROSS JOIN img_type_thumbnail it			
		    UNION ALL			
			SELECT iki.image_id AS image_id,
			       itd.image_type_id AS image_type,
				   bid_no_img.img_data AS image_data,
                   mt.mime_type_id AS mime_type,
                   bid_no_img.img_callout_data AS callout_data,                                    
                   bid_no_img.img_hash AS checksum_image_data,
                   bid_no_img.img_callout_hash AS checksum_callout_data,
				   dod.data_origin_id AS data_origin_id
            FROM bid_no_img
            CROSS JOIN dod
		 -- INNER JOIN ctrg_support.image_key_ids iki
			INNER JOIN ctrg.image iki
			ON iki.dur_uk = concat(bid_no_img.img_name,'|','NIS_ILLUSTRATIONS')
            CROSS JOIN mime_type_png mt
            CROSS JOIN img_type_default itd			
            UNION ALL
  /** <SBS_RULE> IN THIS PART OF UNION,THUMBNAILS OF IMAGES ARE FETCHED FROM BL.. </SBS_RULE> **/
         SELECT iki.image_id AS image_id,
			       itt.image_type_id AS image_type,
				   bni.img_data AS image_data,
                   mt.mime_type_id AS mime_type,
                   null AS callout_data,                                                      
                   bni.img_hash AS checksum_image_data,
                   null AS checksum_callout_data,
				   dod.data_origin_id AS data_origin_id
            FROM bti_no_image bni
            CROSS JOIN dod
		 -- INNER JOIN ctrg_support.image_key_ids iki
			INNER JOIN ctrg.image iki
			ON iki.dur_uk = concat(bni.img_name,'|','NIS_ILLUSTRATIONS')
            CROSS JOIN mime_type_png mt
            CROSS JOIN img_type_thumbnail itt			
            UNION ALL			
			SELECT iki.image_id AS image_id,
			       it.image_type_id AS image_type,
				   bti_no_image.img_data AS image_data,
                   mt.mime_type_id AS mime_type,
                   NULL AS callout_data,                                                     
                   bti_no_image.img_hash AS checksum_image_data,
                   bnir.img_callout_hash AS checksum_callout_data,
				   dod.data_origin_id AS data_origin_id
            FROM bti_no_img_rem bnir
            CROSS JOIN bti_no_image
            CROSS JOIN dod
		 -- INNER JOIN ctrg_support.image_key_ids iki
			INNER JOIN ctrg.image iki
			ON iki.dur_uk = concat(bnir.img_name,'|','NIS_ILLUSTRATIONS')
            CROSS JOIN mime_type_png mt
            CROSS JOIN img_type_thumbnail it 
			CROSS JOIN lm
            UNION ALL			
            SELECT iki.image_id AS image_id,
			       itd.image_type_id AS image_type,
				   bim.img_data AS image_data,
                   mt.mime_type_id AS mime_type,
				   NULL AS callout_data,                                                    
                   bim.img_hash AS checksum_image_data,
                   NULL AS checksum_callout_data,
                   dod.data_origin_id AS data_origin_id				   
            FROM bl_image_model bim
            CROSS JOIN dod
		--  INNER JOIN ctrg_support.image_key_ids iki
		    INNER JOIN ctrg.image iki
			ON iki.dur_uk = concat(bim.img_name,'|','NISSAN-MODEL')
            CROSS JOIN mime_type_png mt
            CROSS JOIN img_type_thumbnail itd
            UNION ALL			
            SELECT iki.image_id AS image_id,
			       itd.image_type_id AS image_type,
				   big.img_data AS image_data,
                   mt.mime_type_id AS mime_type,
                   NULL AS callout_data,                                                   
                   big.img_hash AS checksum_image_data,
                   NULL AS checksum_callout_data,
				   dod.data_origin_id AS data_origin_id
            FROM bl_image_group big
            CROSS JOIN dod
		--  INNER JOIN ctrg_support.image_key_ids iki
		    INNER JOIN ctrg.image iki
			ON iki.dur_uk = concat(big.img_name,'|','NISSAN-GROUP')
            CROSS JOIN mime_type_jpg mt
            CROSS JOIN img_type_thumbnail itd)b;
			
			
		
			
			
			