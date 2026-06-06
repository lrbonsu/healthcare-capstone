
-- ============================================================
-- HEALTHCARE PATIENT READMISSION ANALYSIS — SQL Queries
-- Database: data/healthcare.db | Table: patients
-- ============================================================

-- 1. BUSINESS SUMMARY
SELECT
    COUNT(*)                                AS total_patients,
    SUM(readmitted_30)                      AS readmitted_30_day,
    ROUND(SUM(readmitted_30) * 100.0
          / COUNT(*), 1)                    AS readmission_rate_pct,
    ROUND(AVG(time_in_hospital), 1)         AS avg_days_in_hospital
FROM patients;

-- 2. READMISSION BY AGE GROUP
SELECT
    age,
    COUNT(*)                                AS total_patients,
    ROUND(SUM(readmitted_30) * 100.0
          / COUNT(*), 1)                    AS readmission_rate_pct
FROM patients
GROUP BY age
ORDER BY age;

-- 3. HIGH RISK PATIENT PROFILE (CTE + UNION)
WITH high_risk AS (
    SELECT * FROM patients WHERE readmitted_30 = 1
),
low_risk AS (
    SELECT * FROM patients WHERE readmitted_30 = 0
)
SELECT
    'High Risk' AS patient_group,
    ROUND(AVG(age_numeric), 1) AS avg_age,
    ROUND(AVG(time_in_hospital), 1) AS avg_days,
    ROUND(AVG(num_medications), 1) AS avg_medications
FROM high_risk
UNION ALL
SELECT
    'Low Risk',
    ROUND(AVG(age_numeric), 1),
    ROUND(AVG(time_in_hospital), 1),
    ROUND(AVG(num_medications), 1)
FROM low_risk;

-- 4. PATIENT RISK RANKING (WINDOW FUNCTION)
WITH patient_risk AS (
    SELECT encounter_id, age,
           ROUND((time_in_hospital * 0.3) +
                 (num_medications  * 0.2) +
                 (service_utilization * 0.3) +
                 (number_diagnoses * 0.2), 1) AS risk_score,
           readmitted_30
    FROM patients
)
SELECT
    encounter_id, age, risk_score, readmitted_30,
    RANK() OVER (ORDER BY risk_score DESC) AS risk_rank,
    NTILE(4) OVER (ORDER BY risk_score DESC) AS risk_quartile
FROM patient_risk
ORDER BY risk_score DESC
LIMIT 20;
