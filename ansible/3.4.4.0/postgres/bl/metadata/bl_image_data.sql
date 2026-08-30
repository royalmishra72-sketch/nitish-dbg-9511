update bl.bl_image_data 
set attribute2='TIF_THUMB'
where attribute1='NISTHUMBNAIL' and attribute2 is null;

update bl.bl_image_data 
set attribute2='TIF'
where attribute1='NIS_ILLUSTRATIONS' and attribute2 is null;

analyze verbose bl.bl_image_data;