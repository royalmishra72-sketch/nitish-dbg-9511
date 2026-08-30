INSERT INTO pub_admin.pba_param_t (param_nm, param_value_txt, param_dsc) 
VALUES('REPORT_FUNCTION', 'pub_work.fnc_generic_report', 'Function name used for RDVT specific report generation.')ON CONFLICT DO NOTHING;

analyze verbose pub_admin.pba_param_t;

