drop index if exists pk_bl_image_data_index ;

alter table bl.bl_image_data
drop CONSTRAINT if exists pk_bl_image_data;

alter table bl.bl_image_data
add constraint pk_bl_image_data PRIMARY KEY (img_name, attribute1,attribute2);