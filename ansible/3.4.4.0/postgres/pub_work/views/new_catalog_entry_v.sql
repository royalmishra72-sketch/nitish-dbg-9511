drop view if exists new_catalog_entry_v;

create or replace view new_catalog_entry_v
as
with all_pdf_received as
			( 
			select  REPLACE(datarcpt_orgnl_file_name,'_US.pdf','') as catalog,
					to_char(to_date(replace(datarcpt_rltv_drctry_path_name,'/',''),'YYMMDD'),'YYYYMM')::numeric as rcvd_date
			from    pub_admin.dr_datarcpt_file_v
			where  datasrc_nm='DOWNLOAD_CATALOG_PDF'
			and     receiptstatus = 'Completed'
			),
 curr_cat_pdfs as 
		(
	 /* only current catalogs*/
		select catalog, rcvd_date
		from   all_pdf_received
		where  rcvd_date = to_char(CURRENT_DATE,'YYYYMM')::numeric				  
		),
 cat_part_count as (		
		select mdl_ser_code as catalog, 
			   count(1) prt_count
		from   bl.bl_f31x1470_catalog_parts bfxcp 
		group by  bfxcp.mdl_ser_code 		
		)
select    /**
		   * <SBS_PROLOG>
		   * Project:  NISSAN DATA PUBLISHING
		   * Purpose:  This view is used for new catalog entry in BL_SBS_CATALOG.
		   *
		   * PL/SQL Objects Used:
		   *   <Object Type> - <Schema Owner> - <Object Name>
		   *===========================================================
		   * Revision History
		   *   Ref #  Date          Revisor      Comment
		   *   1      19/1/2025     CB           Initial revision
		   *===========================================================
		   * Revisor
		   *   CB            CHANDAN BHATIA
		   *===========================================================
		   * </SBS_PROLOG>
		   * <SBS_SRCTAB  owner="PUB_ADMIN"  name="dr_datarcpt_file_v" />
		   * <SBS_SRCTAB  owner="BL"  name="BL_SBS_CATALOG" />
		   * <SBS_DESTTAB owner="BL" name="BL_SBS_CATALOG" />
		   * <SBS_PRCGRP  name="" seq=""/>
		   */
        'N' as make,
		ccp.catalog as model,
		coalesce(		
				(
					select max(model_desc)
					from   bl.BL_SBS_CATALOG a
					where  substr(ccp.catalog,1,4) = substr(a.model,1,4) 
					and    status = 'Y' 
					and    to_date::numeric = ( 
											select max(b.to_date::numeric)
											from   bl.BL_SBS_CATALOG b
											where  substr(ccp.catalog,1,4) = substr(b.model,1,4) 
											and    b.status = 'Y' 
											)
				),
				(
					select max(model_desc)
					from   bl.BL_SBS_CATALOG a
					where  substr(ccp.catalog,1,3) = substr(a.model,1,3) 
					and    status = 'Y' 
					and    to_date::numeric =  (
											select max(b.to_date::numeric)
											from   bl.BL_SBS_CATALOG b
											where  substr(ccp.catalog,1,3) = substr(b.model,1,3) 
											and    b.status = 'Y' 
											)
				),
				(
					select max(model_desc)
					from   bl.BL_SBS_CATALOG a
					where  substr(ccp.catalog,1,2) = substr(a.model,1,2) 
					and    status = 'Y' 
					and    to_date::numeric =  (
											select max(b.to_date::numeric)
											from   bl.BL_SBS_CATALOG b
											where  substr(ccp.catalog,1,2) = substr(b.model,1,2) 
											and    b.status = 'Y' 
											)
				),
				(
					select max(model_desc)
					from   bl.BL_SBS_CATALOG a
					where  substr(ccp.catalog,1,1) = substr(a.model,1,1) 
					and    status = 'Y' 
					and    to_date::numeric =  (
											select max(b.to_date::numeric)
											from   bl.BL_SBS_CATALOG b
											where  substr(ccp.catalog,1,1) = substr(b.model,1,1) 
											and    b.status = 'Y' 
											)
				), 
				ccp.catalog
		)
		as model_desc,
		'CXXXXX' as pub_num,
		to_char(CURRENT_DATE,'YYYY')::numeric as from_date,
		to_char(CURRENT_DATE,'YYYY')::numeric as to_date,
		'2' as format,
		case when pc.prt_count > 1000 then 'Y' else 'N' end as status
from curr_cat_pdfs ccp
left join cat_part_count pc
	on (ccp.catalog = pc.catalog)
where  ccp.catalog not in (
						select model
						from  bl.BL_SBS_CATALOG 
						);
