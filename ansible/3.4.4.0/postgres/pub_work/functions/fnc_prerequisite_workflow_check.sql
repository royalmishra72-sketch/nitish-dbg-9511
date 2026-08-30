CREATE OR REPLACE FUNCTION pub_work.fnc_prerequisite_workflow_check()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_table_name text;
    v_exists     boolean;
    v_sql        text;
    v_msg        text := '';
BEGIN

    -- Check PDF download
    IF NOT EXISTS (
        SELECT 1
        FROM pub_admin.dr_datarcpt_file_v
        where datasrc_nm = 'DOWNLOAD_CATALOG_PDF'
  		and receiptstatus = 'Completed'
  		and to_char(to_date(replace(datarcpt_rltv_drctry_path_name,'/',''),'YYMMDD'),'YYYYMM')::numeric = to_char(CURRENT_DATE,'YYYYMM')::numeric
    ) THEN
        v_msg := 'Current Month Catalog PDF Not Downloaded From Infacing SFTP';
    END IF;

    -- Check prerequisite reports
    FOR v_table_name IN
        SELECT concat('report_', report_name)
        FROM bl.bl_sbs_report_meta
        WHERE report_group = 'prerequisite_reports'
    LOOP

        v_sql := format(
            'SELECT EXISTS (
                SELECT 1
                FROM pub_work.%I
                WHERE rpt_exctn_tm >= date_trunc(''month'', current_date)
                  AND rpt_exctn_tm < date_trunc(''month'', current_date) + interval ''1 month''
            )',
            v_table_name
        );

        EXECUTE v_sql INTO v_exists;

        IF NOT v_exists THEN
            IF v_msg <> '' THEN
                v_msg := v_msg || ', ';
            END IF;

            v_msg := v_msg || format('Report %s not Executed For the Current Month', v_table_name);
        END IF;

    END LOOP;

    IF v_msg = '' THEN
        RETURN 'GO AHEAD';
    ELSE
        RETURN v_msg;
    END IF;

END;
$function$
;

REVOKE EXECUTE ON FUNCTION pub_work.fnc_prerequisite_workflow_check() FROM PUBLIC;