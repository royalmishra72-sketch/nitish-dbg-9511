drop view if exists attachment_v;

CREATE or REPLACE VIEW pub_work.attachment_v
 AS
 WITH doi AS ( /*<SBS_RULE> Single value NIS|ALL will be used for all DATA_ORIGIN_ID </SBS_RULE>*/
         SELECT data_origin.data_origin_id
           FROM ctrg_support.data_origin
          WHERE data_origin.dur_uk = 'NIS|ALL'
           ), 
	 mt AS (
          SELECT 7 AS mime_type_id
          ), 
	 mtl AS (
         SELECT 14 AS mime_type_id
           ), 
    dt AS (
         SELECT 1 AS display_type_id
         ), 
   catalog_gi AS ( /** <SBS_RULE>This will fetch all the catalog general information from the bl_image_data table at bl. For general information attribute1 has value as 'NIS-GI' </SBS_RULE> **/
         SELECT bl_image_data.img_name,
                bl_image_data.attribute1
          FROM  bl.bl_image_data
          WHERE bl_image_data.attribute1 = 'NISSAN-GI' 
		  AND (bl_image_data.img_name IN ( SELECT bl_sbs_catalog.model
                                           FROM bl.bl_sbs_catalog
                                           WHERE bl_sbs_catalog.status = 'Y'))
                 ), 
	price_book_gi AS ( /** <SBS_RULE>This will fetch all the price book information from the bl_image_data table at bl. For general information attribute1 has value as 'NISSAN_PRICE_BOOK' </SBS_RULE> **/
          SELECT bl_image_data.img_name,
                 bl_image_data.attribute1,
                lpad(replace(bl_image_data.img_name, 'NPRI', ''), 10, '0') AS sort_seq
           FROM bl.bl_image_data
          WHERE bl_image_data.attribute1 = 'NISSAN_PRICE_BOOK'
                     ), 
	accessory_catalog_gi AS ( /** <SBS_RULE>This will fetch all the Accessory Catalog information from the bl_image_data table at bl. For general information attribute1 has value as 'NISSAN_ACCESSORY_CATALOG' </SBS_RULE> **/
          SELECT bl_image_data.img_name,
                 bl_image_data.attribute1,
                 lpad(replace(bl_image_data.img_name, 'NIACC', ''), 10, '0') AS sort_seq
           FROM bl.bl_image_data
          WHERE bl_image_data.attribute1 = 'NISSAN_ACCESSORY_CATALOG'
                            ), 
		at_links AS ( /** <SBS_RULE>This will fetch all the Links information from the BL_SBS_EXTERNAL_URL table at bl. </SBS_RULE> **/
         --SELECT url_name,
               -- url_link,
               -- group_name,
               -- sort_seq
           --FROM bl.bl_sbs_external_url
		   SELECT en_us AS url_name
	             ,element_code AS url_link
		         ,'Links' AS group_name
				 ,sort_seq
	       FROM bl.bl_sbs_meta_header 
	       WHERE group_name = 'ATTACHMENT_LINK'		   
                    )
 SELECT DISTINCT /**
                   * <SBS_PROLOG>
                   * Project:  NISSAN DATA PUBLISHING
                   * Purpose:  This view is used in the population of the ATTACHMENT table.
                   *
                   * PL/SQL Objects Used:
                   *   <Object Type> - <Schema Owner> - <Object Name>
                   *===========================================================
                   * Revision History
                   *   Ref #  Date          Revisor      Comment
                   *   1      23/07/2015    AB           Initial revision
				   *   2      10/05/2023    DNU          INITIAL           
                   *===========================================================
                   * Revisor
                   *   AB            ABHINAV BANSAL
				   *   DNU           DILESH N. UKEY
                   *===========================================================
                   * </SBS_PROLOG>
                   * <SBS_SRCTAB  owner="BL"  name="BL_IMAGE_DATA" />
				   * <SBS_SRCTAB  owner="BL"  name="BL_SBS_CATALOG" />
				   * <SBS_SRCTAB  owner="BL"  name="BL_SBS_EXTERNAL_URL" />
                   * <SBS_SRCTAB  owner="CTRG_SUPPORT" name="DATA_ORIGIN" />
                   * <SBS_PRCGRP  name="LOAD_ATTACHMENTS" seq="55"/>
                   */
                 a.attachment_group_id,
                 a.dur_uk,
                 a.global_scope AS global_flag,
                 CASE
                 WHEN a.attachment_blob_dict_id IS NULL 
				 THEN true
                 ELSE false
                 END AS null_attachment,
                 COALESCE(a.attachment_dict_id, ( SELECT attachment_dict.attachment_dict_id
           FROM ctrg.attachment_dict
           WHERE attachment_dict.dur_uk::text = '*'::text)) AS attachment_dict_id,
           COALESCE(a.attachment_blob_dict_id, ( SELECT attachment_blob_dict.attachment_blob_dict_id
           FROM ctrg.attachment_blob_dict
          WHERE attachment_blob_dict.dur_uk::text = '*'::text)) AS attachment_blob_dict_id,
           a.flex1,
           NULL AS flex2,
           NULL AS flex3,
           NULL AS flex4,
           NULL AS flex5,
           NULL AS flex6,
           NULL AS flex7,
           NULL AS flex8,
           NULL AS flex9,
           NULL AS flex10,
           NULL AS checksum_data,
           NULL::integer AS p_range_from,
           NULL::integer AS p_range_to,
           NULL::integer AS m_range_from,
           NULL::integer AS m_range_to,
           NULL::text AS code,
           a.alphanum_sort_seq AS sort_seq,
           NULL::text AS secured_id,
           a.data_origin_id,
           NULL::integer AS row_ae_id,
           a.mime_type_id AS mime_type,
           a.display_type_id AS display_type,
           NULL::text AS direct_filter_1,
           NULL::text AS direct_filter_2,
           NULL::text AS direct_filter_3,
           NULL::text AS direct_filter_4,
           NULL::text AS direct_filter_5,
           false AS archivable_ind,
           true AS valid_for_media_ind,
           NULL::timestamp with time zone AS publish_date,
           NULL::timestamp with time zone AS expiration_date
   FROM ( SELECT ag.attachment_group_id,
                 ad.attachment_dict_id,
                 abd.attachment_blob_dict_id,
                 concat(catalog_gi.img_name, '|', catalog_gi.attribute1) AS dur_uk,
                 catalog_gi.img_name AS flex1,
                 0 AS null_attachment,
                 doi.data_origin_id,
                 NULL::text AS alphanum_sort_seq,
                 0 AS global_scope,
                 dt.display_type_id,
                 mt.mime_type_id
           FROM catalog_gi
           CROSS JOIN mt
           CROSS JOIN dt
           CROSS JOIN doi
           LEFT JOIN ctrg.attachment_dict ad ON concat(catalog_gi.img_name, '|', catalog_gi.attribute1) = ad.dur_uk
           LEFT JOIN ctrg.attachment_blob_dict abd ON concat(catalog_gi.img_name, '|', catalog_gi.attribute1) = abd.dur_uk
           JOIN ctrg.attachment_group ag ON doi.data_origin_id = ag.data_origin_id AND ag.dur_uk::text = 'NISSAN-GI'
        UNION ALL
         SELECT ag.attachment_group_id,
                ad.attachment_dict_id,
                abd.attachment_blob_dict_id,
                concat(price_book_gi.img_name, '|', price_book_gi.attribute1) AS dur_uk,
                price_book_gi.img_name AS flex1,
                0 AS null_attachment,
                doi.data_origin_id,
                price_book_gi.sort_seq AS alphanum_sort_seq,
                1 AS global_scope,
                dt.display_type_id,
                mt.mime_type_id
           FROM price_book_gi
             CROSS JOIN mt
             CROSS JOIN dt
             CROSS JOIN doi
             LEFT JOIN ctrg.attachment_dict ad ON concat(price_book_gi.img_name, '|', price_book_gi.attribute1) = ad.dur_uk
             LEFT JOIN ctrg.attachment_blob_dict abd ON concat(price_book_gi.img_name, '|', price_book_gi.attribute1) = abd.dur_uk
             JOIN ctrg.attachment_group ag ON doi.data_origin_id = ag.data_origin_id AND ag.dur_uk::text = 'NISSAN_PRICE_BOOK'
        UNION ALL
            SELECT ag.attachment_group_id,
                   ad.attachment_dict_id,
                   abd.attachment_blob_dict_id,
                   concat(accessory_catalog_gi.img_name, '|', accessory_catalog_gi.attribute1) AS dur_uk,
                   accessory_catalog_gi.img_name AS flex1,
                   0 AS null_attachment,
                   doi.data_origin_id,
                   accessory_catalog_gi.sort_seq AS alphanum_sort_seq,
                  1 AS global_scope,
                  dt.display_type_id,
                   mt.mime_type_id
           FROM accessory_catalog_gi
           CROSS JOIN mt
           CROSS JOIN dt
           CROSS JOIN doi
           LEFT JOIN ctrg.attachment_dict ad ON concat(accessory_catalog_gi.img_name, '|', accessory_catalog_gi.attribute1) = ad.dur_uk
           LEFT JOIN ctrg.attachment_blob_dict abd ON concat(accessory_catalog_gi.img_name, '|', accessory_catalog_gi.attribute1) = abd.dur_uk
             JOIN ctrg.attachment_group ag ON doi.data_origin_id = ag.data_origin_id AND ag.dur_uk::text = 'NISSAN_ACCESSORY_CATALOG'
        UNION ALL
         SELECT ag.attachment_group_id,
                ad.attachment_dict_id,
                abd.attachment_blob_dict_id,
                concat(at_links.url_name, '|', at_links.group_name) AS dur_uk,
                at_links.url_name AS flex1,
                0 AS null_attachment,
                doi.data_origin_id,
                at_links.sort_seq AS alphanum_sort_seq,
                1 AS global_scope,
                dt.display_type_id,
            mtl.mime_type_id
           FROM at_links
             CROSS JOIN mtl
             CROSS JOIN dt
             CROSS JOIN doi
             LEFT JOIN ctrg.attachment_dict ad ON concat(at_links.url_name, '|', at_links.group_name) = ad.dur_uk
             LEFT JOIN ctrg.attachment_blob_dict abd ON concat(at_links.url_name, '|', at_links.group_name) = abd.dur_uk
             JOIN ctrg.attachment_group ag ON doi.data_origin_id = ag.data_origin_id AND ag.dur_uk::text = 'Links') a;



