drop view if exists image_data_w_v;

create or replace view pub_work.image_data_w_v 
as
select /**
          * <SBS_PROLOG>
          * Project:  NISSAN DATA PUBLISHING
          * Purpose:  This view is used in the population of the IMAGE_DATA_W table.
          *
          * PL/SQL Objects Used:
          *   <Object Type> - <Schema Owner> - <Object Name>
          *===========================================================
          * Revision History
          *   Ref #  Date          Revisor      Comment
          *   1      04-08-2026    CB          Initial revision
          *===========================================================
          * Revisor
		  *   CB            Chandan Bhatia 
          *===========================================================
          * </SBS_PROLOG>
		  * <SBS_SRCTAB  owner="BL" name="BL_IMAGE_DATA" /> 
          * <SBS_DESTTAB owner="PUb_WORK" name="IMAGE_DATA_W" />
          * <SBS_PRCGRP name="WORK_TABLE" seq="1"/>
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
from   bl.bl_image_data 
where  attribute1 not in ('NIS_ILLUSTRATIONS','NISTHUMBNAIL')
union all 
select Img_Name,
		Img_Hash,
		Img_Path,
		Img_Typ_Id,
		Img_Data,
		Img_Callout_Hash,
		Img_Callout_Path,
		Img_Callout_Data,
		Attribute1,
		Attribute2
from   bl.bl_image_data 
where  attribute2 in ('SVG') 
and    attribute1 in('NIS_ILLUSTRATIONS')
and 	Img_Name in (select illust_no from bl.bl_nna_illust_master)
union all
select Img_Name,
		Img_Hash,
		Img_Path,
		Img_Typ_Id,
		Img_Data,
		Img_Callout_Hash,
		Img_Callout_Path,
		Img_Callout_Data,
		Attribute1,
		Attribute2
from   bl.bl_image_data 
where  attribute2 in ('SVG_THUMB') 
and    attribute1 in('NISTHUMBNAIL')
and 	Img_Name in (select concat(illust_no,'_t') as img_name from bl.bl_nna_illust_master)
union all 
select Img_Name,
		Img_Hash,
		Img_Path,
		Img_Typ_Id,
		Img_Data,
		Img_Callout_Hash,
		Img_Callout_Path,
		Img_Callout_Data,
		Attribute1,
		Attribute2
from   bl.bl_image_data t
where  t.attribute2 in ('TIF') 
and    t.attribute1 in('NIS_ILLUSTRATIONS')
and    not exists (
				   select 1 
				   from   bl.bl_image_data s
				   where  t.img_name = s.img_name 
				   and    t.attribute1 = s.attribute1
				   and    s.attribute2 in ('SVG') 
				   and    t.Img_Name in (select illust_no from bl.bl_nna_illust_master)
					)
union all 
select Img_Name,
		Img_Hash,
		Img_Path,
		Img_Typ_Id,
		Img_Data,
		Img_Callout_Hash,
		Img_Callout_Path,
		Img_Callout_Data,
		Attribute1,
		Attribute2
from   bl.bl_image_data t
where  t.attribute2 in ('TIF_THUMB') 
and    t.attribute1 in('NISTHUMBNAIL')
and    not exists (
				   select 1 
				   from   bl.bl_image_data s
				   where  t.img_name = s.img_name 
				   and    t.attribute1 = s.attribute1
				   and    s.attribute2 in ('SVG_THUMB') 
				   and     t.Img_Name in (select concat(illust_no,'_t') as img_name from bl.bl_nna_illust_master)
					);
