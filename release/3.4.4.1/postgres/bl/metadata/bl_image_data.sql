
-- DML

-- Chapter
update   bl.bl_image_data 
set     attribute2 = 'CHAPTER'
where   attribute2 is null
and     attribute1 = 'NISSAN-GROUP';

-- Model
update   bl.bl_image_data 
set     attribute2 = 'MODEL'
where   attribute2 is null
and     attribute1 = 'NISSAN-MODEL';

-- Attachment
update   bl.bl_image_data 
set     attribute2 = 'ATTACHMENT'
where   attribute2 is null
and     attribute1 in ( 'NISSAN-GI','NISSAN_PRICE_BOOK');


-- Not used
update   bl.bl_image_data 
set     attribute2 = 'NOT_USED'
where   attribute2 is null
and     attribute1 = 'NISSAN_ACCESSORY_CATALOG_NOT_USED';




