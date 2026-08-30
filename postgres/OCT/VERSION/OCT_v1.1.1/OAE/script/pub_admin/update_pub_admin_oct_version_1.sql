
--- Update OCT Version in pub_admin table
UPDATE pba_param_t
set param_value_txt = replace(param_value_txt,'"oct_version":"1.1.0"','"oct_version":"1.1.1"')
WHERE param_nm = 'OCT';