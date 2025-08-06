{{ config(
    materialized='table',
    database='HEALTHCARE_ANALYTICS',
    schema='gold'
) }}

SELECT 
    se.facility_name,
    se.state,
    COUNT(*) as total_days,
    ROUND(AVG(se.total_nursing_hours_per_patient), 2) as avg_hours_per_patient,
    ROUND(AVG(ea.contract_percentage), 1) as avg_contract_percentage,
    ROUND(AVG(wd.rn_percentage), 1) as avg_rn_percentage,
    ROUND(AVG(sc.patient_census), 0) as avg_patient_census,
    ROUND(AVG(wd.total_nursing_hours), 0) as avg_total_hours
FROM {{ ref('silver_staffing_efficiency') }} se
JOIN {{ ref('silver_employment_analysis') }} ea 
    ON se.facility_id = ea.facility_id AND se.work_date = ea.work_date
JOIN {{ ref('silver_workload_distribution') }} wd 
    ON se.facility_id = wd.facility_id AND se.work_date = wd.work_date
JOIN {{ ref('silver_nursing_staffing_cleaned') }} sc 
    ON se.facility_id = sc.facility_id AND se.work_date = sc.work_date
GROUP BY se.facility_name, se.state