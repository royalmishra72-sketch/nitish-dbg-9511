update bl.bl_sbs_meta_blctrg_alrm_cnt
set "exclude"='Y'
where table_name in (
					'bl_sbs_meta_blctrg_alrm_cnt',
					'bl_sbs_report_failures_history',
					'bl_sbs_report_failures',
					'csr_catalog',
					'bl_nnaicm_master',
					'bl_icm_master'
					);