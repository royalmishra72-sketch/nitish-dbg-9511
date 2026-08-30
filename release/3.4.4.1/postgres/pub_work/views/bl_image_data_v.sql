drop view if exists bl_image_data_v;

CREATE or REPLACE VIEW pub_work.bl_image_data_v as 
select 
/*
  * <SBS_PROLOG>
  * Project:  NISSAN DATA PUBLISHING
  * Purpose:  This view is used in the population of the BL_IMAGE_DATA table.
  *
  * PL/SQL Objects Used:
  *   <Object Type> - <Schema Owner> - <Object Name>
  *===========================================================
  * Revision History
  *   Ref #  Date         Revisor      Comment
  *   1      27/07/2023   NKM          Initial revision
  *   2      3/08/2026    CB	       Attribute2 populated for all images. Code to give SVG priority over SVG removed.  
  *									   Code to only publish SVG images available in bl_nna_illust_master removed. 
  *===========================================================
  * Revisor
  *   NKM            NITISH KUMAR MISHRA
  *   CB             Chandan Bhatia 
  *===========================================================
  * </SBS_PROLOG>
  * <SBS_SRCTAB owner="PUB_WORK" name="PRE_BL_IMAGE_DATA_W" />
  * <SBS_PRCGRP name="" seq=""/>
  */
Img_Name,
Img_Hash,
Img_Path,
Img_Typ_Id,
Img_Data,
Img_Callout_Hash,
Img_Callout_Path,
Img_Callout_Data,
Attribute1,
Attribute2
From
(
--NISSAN TIF ILLUSTRATIONS--
Select Trim(Img_Name)as Img_Name,
       Img_Hash as Img_Hash,
       Img_Path as Img_Path,
       Null     as Img_Typ_Id,
       Img_Data as Img_Data,
       img_Callout_Hash as Img_Callout_Hash,
       Img_Callout_Path as Img_Callout_Path,
       Img_Callout_Data as Img_Callout_Data,
       'NIS_ILLUSTRATIONS' as Attribute1,
       case when Trim(Img_Type)='illustration' then 'TIF'
            end as Attribute2
From pub_work.pre_bl_image_data_w a
Where Trim(Img_Type) in('illustration')
AND IMG_HASH IS NOT NULL
AND IMG_CALLOUT_HASH IS NOT NULL
and right(Img_Name,2) <> '_t' 
--and  not exists (select 1 from bl.bl_image_data b where a.img_name=b.img_name and b.attribute2='SVG')
union all
--NISSAN SVG ILLUSTRATIONS--
Select Trim(Img_Name)as Img_Name,
       Img_Hash as Img_Hash,
       Img_Path as Img_Path,
       Null     as Img_Typ_Id,
       Img_Data as Img_Data,
       img_Callout_Hash as Img_Callout_Hash,
       Img_Callout_Path as Img_Callout_Path,
       Img_Callout_Data as Img_Callout_Data,
       'NIS_ILLUSTRATIONS' as Attribute1,
       case when Trim(Img_Type)='svg_illustration' then 'SVG'
            end as Attribute2
From pub_work.pre_bl_image_data_w a
Where Trim(Img_Type) in('svg_illustration')
AND IMG_HASH IS NOT NULL
AND IMG_CALLOUT_HASH IS NOT NULL
and right(Img_Name,2) <> '_t'
--and Img_Name in (select illust_no from bl.bl_nna_illust_master)
union all 
--NISSAN TIF THUMBNAILS--
Select Trim(Img_Name) as Img_Name,
       Img_Hash as Img_Hash,
       Img_Path as Img_Path,
       Null     as Img_Typ_Id,
       Img_Data as Img_Data,
       img_Callout_Hash as Img_Callout_Hash,
       Img_Callout_Path as Img_Callout_Path,
       Img_Callout_Data as Img_Callout_Data,
       'NISTHUMBNAIL'   as Attribute1,
       case when Trim(Img_Type)='illustration' then 'TIF_THUMB'
            end as Attribute2
From pub_work.pre_bl_image_data_w a
Where Trim(Img_Type) in ('illustration')
AND IMG_HASH IS NOT NULL
AND IMG_CALLOUT_HASH IS NULL
and right(Img_Name,2)= '_t' 
--and not exists (select 1 from bl.bl_image_data b where a.img_name=b.img_name and b.attribute2='SVG_THUMB')
union all 
--NISSAN SVG THUMBNAILS--
Select Trim(Img_Name) as Img_Name,
       Img_Hash as Img_Hash,
       Img_Path as Img_Path,
       Null     as Img_Typ_Id,
       Img_Data as Img_Data,
       img_Callout_Hash as Img_Callout_Hash,
       Img_Callout_Path as Img_Callout_Path,
       Img_Callout_Data as Img_Callout_Data,
       'NISTHUMBNAIL'   as Attribute1,
       case when Trim(Img_Type)='svg_illustration' then 'SVG_THUMB'
            end as Attribute2
From pub_work.pre_bl_image_data_w a
Where Trim(Img_Type) in ('svg_illustration')
AND IMG_HASH IS NOT NULL
AND IMG_CALLOUT_HASH IS NULL
and right(Img_Name,2)= '_t' 
--and img_name in (select concat(illust_no,'_t') as img_name from bl.bl_nna_illust_master)
union all 
--NISSAN CHAPTER THUMBNAILS--
Select substring(img_name,1,length(img_name)-(strpos(reverse(img_name),'_'))) as Img_Name,
       Img_Hash as Img_Hash,
       Img_Path as Img_Path,
       Null     as Img_Typ_Id,
       Img_Data as Img_Data,
       Null     as Img_Callout_Hash,
       Null     as Img_Callout_Path,
       Null     as Img_Callout_Data,
       'NISSAN-GROUP' as Attribute1,
       'CHAPTER' as Attribute2
From pub_work.pre_bl_image_data_w
Where Trim(Img_Type) = 'chapter'
union all 
--NISSAN MODEL THUMBNAILS--
Select substring(img_name,1,length(img_name)-(strpos(reverse(img_name),'_'))) as Img_Name,
       Img_Hash as Img_Hash,
       Img_Path as Img_Path,
       Null     as Img_Typ_Id,
       Img_Data as Img_Data,
       Null     as Img_Callout_Hash,
       Null     as Img_Callout_Path,
       Null     as Img_Callout_Data,
       'NISSAN-MODEL' as Attribute1,
       'MODEL' as Attribute2
From pub_work.pre_bl_image_data_w
Where Trim(Img_Type) = 'model'
Union All
--ATTACHMENTS--
Select split_part(img_name,'.',1)as Img_Name,
       Img_Hash as Img_Hash,
       Img_Path as Img_Path,
       Null     as Img_Typ_Id,
       Img_Data as Img_Data,
       Null     as Img_Callout_Hash,
       Null     as Img_Callout_Path,
       Null     as Img_Callout_Data,
       case when trim(Img_Type)='pdf_gi' then 'NISSAN-GI'
			when trim(Img_Type)='pricebook' then 'NISSAN_PRICE_BOOK'
            end as Attribute1	,
       'ATTACHMENT' as Attribute2     
		From pub_work.pre_bl_image_data_w
		where Trim(Img_Type) In ('pdf_gi','pricebook')
)d;