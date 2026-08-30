drop view if exists bl_f31db153_filter_v;

CREATE or REPLACE VIEW pub_work.bl_f31db153_filter_v  as 
   with regexp_tab as
   (
  select element_code as regexp_replace_stmt from bl.bl_sbs_meta_header 
  where group_name='REPLACE_NON_PRINTABLE'
  )
   select 
	/**
     * <SBS_PROLOG>
     * Project: NISSAN NG DATA PUBLISHING
     * Purpose:  Stagging to BL View for PRE_BL_F31DB153_FILTER_W.
     *
     * PL/SQL Objects Used:
     *   <Object Type> - <Schema Owner> - <Object Name>
     *===========================================================
     * Revision History
     *   Ref #  Date           Revisor      Comment
     *   001    17-JULY-23      NKM          Initial Create
     *===========================================================
     * Revisor
	 *   NKM -  Nitish Kumar Mishra 
     *===========================================================
     * </SBS_PROLOG>
     * <SBS_SRCTAB   owner="PUB_WORK" name="PRE_BL_F31DB153_FILTER_W"/>
	 * <SBS_SRCTAB   owner="BL" name="BL_SBS_CHAR_TO_SCRUB"/>
     * <SBS_DESTTAB  owner="BL"  name="BL_F31DB153_FILTER"/>
     * Insert all other tag comments that are relevant
     */
	  destination,
	  catalog_model,
	  place,
	  name_element,
	  display_order,
	  regexp_replace (upper(meaning),rx.regexp_replace_stmt,'','g')as meaning,
	  latest_update_date,
	  latest_update_time,
	  latest_update_user
	  from pub_work.pre_bl_f31db153_filter_w 
	  cross join regexp_tab rx;