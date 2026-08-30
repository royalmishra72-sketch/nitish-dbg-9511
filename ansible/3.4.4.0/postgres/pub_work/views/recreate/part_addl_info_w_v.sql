drop view if exists part_addl_info_w_v;

CREATE or REPLACE VIEW pub_work.part_addl_info_w_v as
WITH ADDGRP
      AS ( /* <SBS_RULE> THIS CLAUSE WILL FETCH DATA ELEMENT CODE AND SEQUENCE NUMBER.ELEMENT CODE WILL BE THE NAME OF GROUP, HAVING GROUP_NAME VALUE 'ADDITIONAL_GROUP', FROM TABLE 'BL_SBS_META_HEADER' .</SBS_RULE>*/
            SELECT DISTINCT ELEMENT_CODE, SORT_SEQ
              FROM BL.BL_SBS_META_HEADER
             WHERE GROUP_NAME = 'ADDITIONAL_GROUP'
			 AND ELEMENT_CODE = 'PART'),
PAIX
     AS ( /** <SBS_RULE> THIS CLAUSE WILL FETCH PART_DUR_UK AND UNIQUE KEY FOR ADDL_INFO_VALUE_ID.</SBS_RULE>*/
		 SELECT DISTINCT 
     replace(bpn.part,'-','') as part_dur_uk ,x.dur_uk,x.values,concat(x.dur_uk,'|',x.values)as add_info_dur_uk
from bl.BL_PRICEBK_NISSAN bpn
cross join lateral (
values
('Stocking Code', bpn.STKCODE),
('Part Type Code', bpn.TYPCODE),
('OBL Return Code', bpn.OBSCODE),
('Dealer Order Multiple', bpn.ORDMULT),
('Dealer Discount Code', bpn.DISCODE),
('Part Weight', bpn.PART_WEIGHT),
('Part Length', bpn.PART_LENGTH),
('Part Width', bpn.PART_WIDTH),	
('Part Height', bpn.PART_HEIGHT)
) as x(dur_uk,values) 
where x.values <> '.00000')
SELECT /*
            * <SBS_PROLOG>
            * Project:  NISSAN DATA PUBLISHING
            * Purpose:  This view is used in the population of the PART_ADDL_INFO_W_V VIEW
            * PL/SQL Objects Used:
            *   <Object Type> - <Schema Owner> - <Object Name>
            *===========================================================
            * Revision History
            *   Ref #  Date          Revisor      Comment
            *   1      28-04-2023    PR         Initial revision  
            *   2      22-05-2023    PR         Update view according to NSPUB-466.		
            *===========================================================
            * Revisor
            *   PR                PAWAN RAJAK
            *===========================================================
            * </SBS_PROLOG>
            * <SBS_SRCTAB owner="BL" name="BL_PRICEBK_NISSAN" />
			* <SBS_SRCTAB owner="BL" name="BL_SBS_META_HEADER" />
            * <SBS_PRCGRP name="" seq=""/>
            */
       Pa.part_dur_uk, /**<SBS_RULE> PART_DUR_UK IS TAKEN FROM PAIX <SBS_RULE>**/
       ad.element_code as addl_info_group_dict_dur_uk, /**<SBS_RULE> ADDL_INFO_GROUP_DICT_DUR_UK IS TAKEN FROM BL_SBS_META_HEADER <SBS_RULE>**/
	   bsmh.element_desc as addl_info_name_dict_dur_uk, /**<SBS_RULE> ADDL_INFO_NAME_DICT_DUR_UK IS TAKEN FROM BL_SBS_META_HEADER <SBS_RULE>**/
       Pa.add_info_dur_uk as addl_info_value_dict_dur_uk,/**<SBS_RULE> ADDL_INFO_VALUE_DICT_DUR_UK IS TAKEN FROM PAIX <SBS_RULE>**/	  
	   pa.values as addl_info_value_dict_en_us,/**<SBS_RULE> ADDL_INFO_VALUE_DICT_EN_US IS TAKEN FROM PAIX <SBS_RULE>**/
	   'REGULAR' as  addl_info_display_type,
	   bsmh.element_desc as code,/**<SBS_RULE> CODE IS TAKEN FROM FROM BL_SBS_META_HEADER <SBS_RULE>**/
	   bsmh.sort_seq as sort_seq/**<SBS_RULE> SORT_SEQ IS TAKEN FROM BL_SBS_META_HEADER <SBS_RULE>**/	   
FROM PAIX Pa
CROSS JOIN ADDGRP ad
join bl.bl_sbs_meta_header bsmh
on (Pa.dur_uk = bsmh.element_desc and bsmh.group_name = 'PART');




