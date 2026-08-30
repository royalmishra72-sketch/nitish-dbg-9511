drop view if exists bl_nna_illust_master_v;

CREATE or REPLACE VIEW bl_nna_illust_master_v AS
select 
/*******************************************************
  <SBS_PROLOG>
  * Project:  NISSAN DATA PUBLISHING
  * Purpose:  This VIEW holds bl_nna_illust_master related information.
  *
  * PL/SQL Objects Used:
  * <Object Type> - <Schema  Owner> - <Object Name>
    ===========================================================
    Revision History
    Ref #	Date			     Revisor		Comment
    [ref]	DD-MON-YYYY		[Initials]	[comment]
    1		17-02-2026		   NKM			  Initial version
    ===========================================================
    Revisor
    *   [initials]		[Full Name]
    *   NKM   			Nitish K Mishra
    ===========================================================
  </SBS_PROLOG>
  <SBS_SRCTAB owner="Work" name="pre_bl_nna_illust_master_w" />
  <SBS_DESTTAB owner="BL" name="bl_nna_illust_master" />
  *********************************************************/
illust_no,
order_date,
delivery_date,
delivery_plan_date,
illust_co_code,
model,
model_year,
dest_code,
sec,
sec_dif,
illust_size_ind,
rec_date,
prerelease_ind,
field0,
field1,
field2,
field3,
field4
from pre_bl_nna_illust_master_w 
;