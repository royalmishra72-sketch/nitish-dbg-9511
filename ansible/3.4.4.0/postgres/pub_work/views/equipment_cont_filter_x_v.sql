drop view if exists equipment_cont_filter_x_v;

create or replace view equipment_cont_filter_x_v as
with dod as (
	select data_origin_id from ctrg_support.data_origin where dur_uk = 'NIS|ALL'
),
part_item_appl_filter as (
	select  piaw.catalog_model,piaw.filter_item_code,piaw.filter_group_code 
	from pub_work.part_item_appl_filter_w piaw
	inner join bl.bl_f31db153_filter mf 
		on (piaw.catalog_model = mf.catalog_model
			and piaw.filter_item_code = mf.name_element)
),
tc_bc_filters as (
	select distinct 
		catalog_model, 
		unnest(array[trim_color, body_color]) as filter_item_code,
		unnest(array[(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Trim Color'),
			(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Body Color')
		]) as filter_group_code
	from vin_catalog_map_w
	union
	select catalog_model,filter_item_code,filter_group_code from part_item_non_appl_filter_w where filter_group_code in ('TC','BC')
),
other_filters as (
	select
		catalog_model,
		filter_item_code,
		filter_group_code
	from (
		select distinct
			catalog_model,
			unnest(array[body,engine,seat_count,emission,drive,fabric,grade,transmission,speed,susp,save_gas,length,"style",battery,roof,fuel,"type",series,door]) as filter_item_code,
			unnest(array[(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Body'),
				(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Engine'),
				(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Seat Count'),
				(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Emission'),
				(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Drive'),
				(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Fabric'),
				(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Grade'),
				(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Transmission'),
				(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Speed'),
				(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Suspension'),
				(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Save Gas'),
				(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Length'),
				(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Style'),
				(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Battery'),
				(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Roof'),
				(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Fuel'),
				(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Type/Payload'),
				(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Series'),
				(select filter_group_code from bl.bl_sbs_filter_group where filter_group_desc = 'Door')
			]) as filter_group_code
		from vin_filters_w
	) a
	where filter_item_code <> '-'
	union
	select ff.catalog_model,name_element,mf.filter_group  from bl.bl_f31db153_filter ff
	inner join bl.bl_sbs_meta_filter_code mf 
		on (ff.catalog_model = mf.catalog_model
			and ff.name_element = mf.filter_item_code)
)
select
    /*
     * <SBS_PROLOG>
     * Project:  NISSAN DATA PUBLISHING
     * Purpose:  This view is used in the population of the EQUIPMENT_CONT_FILTER_X table.
     *
     * PL/SQL Objects Used:
     *   <Object Type> - <Schema Owner> - <Object Name>
     *===========================================================
     * Revision History
     *   Ref #  Date         Revisor      Comment
     *   1      25-09-2015   SD          Initial revision
     *   2      06-06-2023   PR          View Updated according to postgres
     * 	 3		18-08-2023	 RS			 NSPUB-462 : Logic rewritten to reduce the complexity.
     * 	 4		06-03-2026	 CB			 NSPUB-1395 : CTE nf_feed_filters added to remove dependency on bl_sbs_meta_filter_code
	 *   5      27-03-2026   NKM         Updated filter derivation logic to use part_item_appl_filter_w instead of feed based mappings
     *===========================================================
     * Revisor
     *   SD            SUMAN DESMUKH
     *   PR            PAWAN RAJAK
     *   RS			   RAMINDER SINGH
	 *   CB            Chandan Bhatia
	 *   NKM           Nitish K Mishra
     *===========================================================
     * </SBS_PROLOG>
     * <SBS_SRCTAB owner="BL" name="BL_SBS_CATALOG" />
     * <SBS_SRCTAB owner="BL" name="BL_F31DB153_FILTER" />
     * <SBS_SRCTAB owner="BL" name="BL_SBS_FILTER_GROUP" />
     * <SBS_SRCTAB owner="BL" name="BL_SBS_YEAR_CODE" />
     * <SBS_SRCTAB owner="BL" name="bl_sbs_meta_filter_code" />
     * <SBS_SRCTAB  owner="CTRG_SUPPORT" name="DATA_ORIGIN" />
     * <SBS_SRCTAB  owner="PUB_WORK" name="VIN_FILTERS_W" />
     * <SBS_DESTTAB owner="CDR" name="EQUIPMENT_CONT_FILTER_X" />
     */
	eki.equipment_id as equipment_id,
	fiki.filter_item_id as filter_item_id,
	null as ref_label,
	dod.data_origin_id as data_origin_id,
	false as archivable_ind,
	true as valid_for_media_ind,
	null sort_seq
from (	
	select catalog_model,filter_item_code,filter_group_code from tc_bc_filters
	union
	select catalog_model,filter_item_code,filter_group_code from other_filters
	union 
	select catalog_model,filter_item_code,filter_group_code from part_item_appl_filter
) f
cross join dod
inner join bl.bl_sbs_catalog c
	on c.model = f.catalog_model
inner join bl.bl_sbs_year_code y
	on (y.year >= c.from_date
		and y.year <= c.to_date
		and c.status = 'Y')
inner join ctrg.equipment eki
	on (eki.dur_uk = concat(y.year,'|',f.catalog_model))
inner join ctrg.filter_item fiki
	on (fiki.dur_uk = concat(catalog_model,'|',filter_group_code,'|',filter_item_code));