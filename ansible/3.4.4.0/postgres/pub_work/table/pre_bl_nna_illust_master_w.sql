CREATE TABLE IF NOT EXISTS pub_work.pre_bl_nna_illust_master_w(               
      illust_no 			varchar(2000),
      order_date 			varchar(2000),  
      delivery_date 		varchar(2000),  
      delivery_plan_date 	varchar(2000), 
      illust_co_code	 	varchar(2000),    
      model 				varchar(2000),
      model_year	 		varchar(2000),
      dest_code 			varchar(2000),
      sec 					varchar(2000),
      sec_dif 				varchar(2000),
      illust_size_ind 		varchar(2000),
      rec_date 				varchar(2000), 
      prerelease_ind        varchar(2000), 
      field0 				varchar(2000), 
      field1 				varchar(2000),
      field2 				varchar(2000),
      field3				varchar(2000),
      field4				varchar(2000),
	  file_line_num         numeric,
	  filename              varchar(2000),
	  row_create_ts timestamptz NULL DEFAULT now(),
      row_create_user_id varchar NULL DEFAULT CURRENT_USER,
      row_last_update_ts timestamptz NULL,
      row_last_update_user_id varchar NULL,
      row_create_pe_session int4 NULL,
      row_last_update_pe_session int4 NULL,
	  constraint pre_bl_nna_illust_master_w_pkey PRIMARY KEY (file_line_num)
    );
	
	COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.illust_no is 'hold the illust_no values.';
    COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.order_date is 'hold the order_date values.';
    COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.delivery_date is 'hold the delivery_date values.';
	COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.delivery_plan_date is 'hold the delivery_plan_date values.';
    COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.illust_co_code is 'hold the illust_co_code values.';
    COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.model is 'hold the model values.';	
	COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.model_year is 'hold the model_year values.';
	COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.dest_code is 'hold the dest_code values.';
	COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.sec is 'hold the sec values.';
	COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.sec_dif is 'hold the sec_dif values.';
	COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.illust_size_ind is 'hold the illust_size_ind values.';	
	COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.rec_date is 'hold the rec_date values.';
	COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.prerelease_ind is 'hold the prerelease_ind values.';
	COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.field0 is 'hold the field0 values.';
	COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.field1 is 'hold the field1 values.';
	COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.field2 is 'hold the field2 values.';
	COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.field3 is 'hold the field3 values.';
	COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.field4 is 'hold the field4 values.';	
    COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.row_create_ts is 'date/time the row was inserted.';
    COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.row_create_user_id is 'date/time the row was last updated.';
    COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.row_last_update_ts is 'user who first created this row';
    COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.row_last_update_user_id is 'user who last updated this row';
    COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.row_create_pe_session is 'Publishing execution session that first created this row.';
    COMMENT ON COLUMN pub_work.pre_bl_nna_illust_master_w.row_last_update_pe_session is 'Publishing execution session that last updated this row';
    COMMENT ON TABLE pub_work.pre_bl_nna_illust_master_w is 'this table contains bl nna illustration master data.';