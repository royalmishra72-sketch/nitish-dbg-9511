drop view if exists current_month_catalog_name_v;

CREATE or REPLACE VIEW current_month_catalog_name_v  AS 
select/*
          * <SBS_PROLOG>
          * Project:  NISSAN DATA PUBLISHING
          * Purpose:  This view is used to Generate Downloaded Catalog PDFs Name and it's count
          * PL/SQL Objects Used:
          *   <Object Type> - <Schema Owner> - <Object Name>
          *===========================================================
          * Revision History
          *   Ref #  Date          Revisor      Comment
          *   1      19-12-2025    NKM          Initial revision
          *===========================================================
          * Revisor
          *   NKM                  Nitish K Mishra
          *===========================================================
		  */
  string_agg(
    distinct split_part(gv_datarcpt_file_name, '.', 1),
    ','
  ) as catalog_list,
  count(
    distinct split_part(gv_datarcpt_file_name, '.', 1)
  ) as catalog_count
from pub_admin.dr_datarcpt_file_v a
where a.datasrc_nm = 'DOWNLOAD_CATALOG_PDF'
  and a.receiptstatus = 'Completed'
  and to_char(to_date(replace(datarcpt_rltv_drctry_path_name,'/',''),'YYMMDD'),'YYYYMM')::numeric = to_char(CURRENT_DATE,'YYYYMM')::numeric;