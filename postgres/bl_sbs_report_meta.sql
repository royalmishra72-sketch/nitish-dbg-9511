-- Drop table

-- DROP TABLE bl.bl_sbs_report_meta;

CREATE TABLE bl.bl_sbs_report_meta (
	report_group varchar(100) NOT NULL, -- Report name belong to this report group
	report_name varchar(50) NOT NULL, -- This column holds the report name that will be passed with generic_report function call.
	report_status varchar(1) NULL, -- This column holds the report status i.e. D (Done) or W (Warning).
	report_subject varchar(2000) NULL, -- This column holds the report subject to display in the report related email.
	report_body text NULL, -- This column holds the report body to display in the report related email.
	report_filename varchar(500) NULL, -- This column holds the report filename i.e. name of the attachment containing the records listed by the report.
	report_query text NULL, -- This column holds the query that gives the content to be shown in the attachment file.
	report_max_rows numeric NULL, -- This column holds the maximum number of records that we want to display in attachment.
	report_data_multilingual varchar(1) NULL, -- This column holds Y if the report content has multilingual data and N otherwise.
	report_publish_flag varchar(1) NULL, -- This column holds the report publish flag which when is Y only then report should be generated.
	report_details text NULL, -- This column holds the additional report details that developer wants to add but this will not be used in code anywhere.
	header_required varchar(1) NULL DEFAULT 'Y'::character varying, -- This column holds the Y and N, if headers are required in the report then Y else N
	report_date_required varchar(1) NULL DEFAULT 'N'::character varying, -- Y if date is needs to be appended in report's filename
	report_count_threshold numeric NULL, -- Row count threshold.
	rpt_transaction_config varchar(50) NULL, -- This column hold the TRANSACTION OPTIONS to set it on session level for optimization of report query
	row_create_ts timestamptz NULL DEFAULT now(), -- Date/time the row was inserted.
	row_create_user_id varchar NULL DEFAULT CURRENT_USER, -- User who first created this row
	row_last_update_ts timestamptz NULL, -- Date/time the row was last updated.
	row_last_update_user_id varchar NULL, -- User who last updated this row
	row_create_pe_session int4 NULL, -- Session number which first created this row
	row_last_update_pe_session int4 NULL, -- Session number which last updated this row
	rdvt_flag bpchar(1) NULL DEFAULT 'Y'::bpchar, -- Y: Report is part of RDVT
	CONSTRAINT bl_sbs_report_meta_rdvt_flag CHECK (((rdvt_flag)::text = ANY (ARRAY['Y'::text, 'N'::text]))),
	CONSTRAINT ck_transaction_config CHECK (((rpt_transaction_config)::text = ANY (ARRAY[('disable_nestloop'::character varying)::text, ('disable_hashjoin'::character varying)::text, ('disable_indexscan'::character varying)::text, ('disable_incremental_sort'::character varying)::text, ('disable_indexonlyscan'::character varying)::text, ('disable_mergejoin'::character varying)::text, ('disable_seqscan'::character varying)::text, ('disable_gathermerge'::character varying)::text, ('disable_hashagg'::character varying)::text, ('disable_parallel_append'::character varying)::text, ('disable_partition_pruning'::character varying)::text, ('disable_partitionwise_join'::character varying)::text, ('disable_material'::character varying)::text, ('disable_bitmapscan'::character varying)::text, ('enable_nestloop'::character varying)::text, ('enable_hashjoin'::character varying)::text, ('enable_indexscan'::character varying)::text, ('enable_incremental_sort'::character varying)::text, ('enable_indexonlyscan'::character varying)::text, ('enable_mergejoin'::character varying)::text, ('enable_seqscan'::character varying)::text, ('enable_gathermerge'::character varying)::text, ('enable_hashagg'::character varying)::text, ('enable_parallel_append'::character varying)::text, ('enable_partition_pruning'::character varying)::text, ('enable_partitionwise_join'::character varying)::text, ('enable_material'::character varying)::text, ('enable_bitmapscan'::character varying)::text]))),
	CONSTRAINT pk_bl_sbs_report_meta PRIMARY KEY (report_name)
);
COMMENT ON TABLE bl.bl_sbs_report_meta IS 'Table to hold the All Information related to Reports congifured in the Project.';

-- Column comments

COMMENT ON COLUMN bl.bl_sbs_report_meta.report_group IS 'Report name belong to this report group';
COMMENT ON COLUMN bl.bl_sbs_report_meta.report_name IS 'This column holds the report name that will be passed with generic_report function call.';
COMMENT ON COLUMN bl.bl_sbs_report_meta.report_status IS 'This column holds the report status i.e. D (Done) or W (Warning).';
COMMENT ON COLUMN bl.bl_sbs_report_meta.report_subject IS 'This column holds the report subject to display in the report related email.';
COMMENT ON COLUMN bl.bl_sbs_report_meta.report_body IS 'This column holds the report body to display in the report related email.';
COMMENT ON COLUMN bl.bl_sbs_report_meta.report_filename IS 'This column holds the report filename i.e. name of the attachment containing the records listed by the report.';
COMMENT ON COLUMN bl.bl_sbs_report_meta.report_query IS 'This column holds the query that gives the content to be shown in the attachment file.';
COMMENT ON COLUMN bl.bl_sbs_report_meta.report_max_rows IS 'This column holds the maximum number of records that we want to display in attachment.';
COMMENT ON COLUMN bl.bl_sbs_report_meta.report_data_multilingual IS 'This column holds Y if the report content has multilingual data and N otherwise.';
COMMENT ON COLUMN bl.bl_sbs_report_meta.report_publish_flag IS 'This column holds the report publish flag which when is Y only then report should be generated.';
COMMENT ON COLUMN bl.bl_sbs_report_meta.report_details IS 'This column holds the additional report details that developer wants to add but this will not be used in code anywhere.';
COMMENT ON COLUMN bl.bl_sbs_report_meta.header_required IS 'This column holds the Y and N, if headers are required in the report then Y else N';
COMMENT ON COLUMN bl.bl_sbs_report_meta.report_date_required IS 'Y if date is needs to be appended in report''s filename';
COMMENT ON COLUMN bl.bl_sbs_report_meta.report_count_threshold IS 'Row count threshold.';
COMMENT ON COLUMN bl.bl_sbs_report_meta.rpt_transaction_config IS 'This column hold the TRANSACTION OPTIONS to set it on session level for optimization of report query';
COMMENT ON COLUMN bl.bl_sbs_report_meta.row_create_ts IS 'Date/time the row was inserted.';
COMMENT ON COLUMN bl.bl_sbs_report_meta.row_create_user_id IS 'User who first created this row';
COMMENT ON COLUMN bl.bl_sbs_report_meta.row_last_update_ts IS 'Date/time the row was last updated.';
COMMENT ON COLUMN bl.bl_sbs_report_meta.row_last_update_user_id IS 'User who last updated this row';
COMMENT ON COLUMN bl.bl_sbs_report_meta.row_create_pe_session IS 'Session number which first created this row';
COMMENT ON COLUMN bl.bl_sbs_report_meta.row_last_update_pe_session IS 'Session number which last updated this row';
COMMENT ON COLUMN bl.bl_sbs_report_meta.rdvt_flag IS 'Y: Report is part of RDVT';

-- Permissions

ALTER TABLE bl.bl_sbs_report_meta OWNER TO bl;
