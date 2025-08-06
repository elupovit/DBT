{{ config(
    materialized='table',
    database='HEALTHCARE_ANALYTICS',
    schema='gold'
) }}

SELECT 
    state,
    COUNT(DISTINCT facility_id) as facility_count,
    ROUND(AVG(total_nursing_hours_per_patient), 2) as state_avg_hours_per_patient,
    ROUND(AVG(contract_percentage), 1) as state_avg_contract_pct
FROM {{ ref('silver_staffing_efficiency') }} se
JOIN {{ ref('silver_employment_analysis') }} ea USING (facility_id, work_date)
GROUP BY state
ORDER BY state_avg_hours_per_patient DESC