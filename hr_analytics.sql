DROP TABLE IF EXISTS raw_hr_data;

CREATE TABLE raw_hr_data (
  EmployeeNumber INT,
  Age INT,
  Gender VARCHAR,
  Department VARCHAR,
  JobRole VARCHAR,
  DistanceFromHome INT,
  MonthlyIncome INT,
  Education INT,
  EnvironmentSatisfaction INT,
  JobInvolvement INT,
  JobSatisfaction INT,
  PerformanceRating INT,
  RelationshipSatisfaction INT,
  WorkLifeBalance INT,
  Attrition VARCHAR,
  OverTime VARCHAR,
  MaritalStatus VARCHAR,
  BusinessTravel VARCHAR,
  YearsAtCompany INT,
  YearsInCurrentRole INT,
  YearsWithCurrManager INT,
  TotalWorkingYears INT,
  TrainingTimesLastYear INT,
  NumCompaniesWorked INT,
  StockOptionLevel INT
);

DROP TABLE IF EXISTS cleaned_hr;

CREATE TABLE cleaned_hr AS
SELECT
  EmployeeNumber,
  Age,
  Gender,
  Department,
  JobRole,
  DistanceFromHome,
  MonthlyIncome,
  Education,
  CASE Education
    WHEN 1 THEN 'Below College'
    WHEN 2 THEN 'College'
    WHEN 3 THEN 'Bachelor'
    WHEN 4 THEN 'Master'
    WHEN 5 THEN 'Doctor'
  END AS EducationLevel,
  EnvironmentSatisfaction,
  CASE EnvironmentSatisfaction
    WHEN 1 THEN 'Low'
    WHEN 2 THEN 'Medium'
    WHEN 3 THEN 'High'
    WHEN 4 THEN 'Very High'
  END AS EnvironmentSatisfactionLabel,
  JobInvolvement,
  CASE JobInvolvement
    WHEN 1 THEN 'Low'
    WHEN 2 THEN 'Medium'
    WHEN 3 THEN 'High'
    WHEN 4 THEN 'Very High'
  END AS JobInvolvementLabel,
  JobSatisfaction,
  CASE JobSatisfaction
    WHEN 1 THEN 'Low'
    WHEN 2 THEN 'Medium'
    WHEN 3 THEN 'High'
    WHEN 4 THEN 'Very High'
  END AS JobSatisfactionLabel,
  PerformanceRating,
  CASE PerformanceRating
    WHEN 1 THEN 'Low'
    WHEN 2 THEN 'Good'
    WHEN 3 THEN 'Excellent'
    WHEN 4 THEN 'Outstanding'
  END AS PerformanceRatingLabel,
  RelationshipSatisfaction,
  CASE RelationshipSatisfaction
    WHEN 1 THEN 'Low'
    WHEN 2 THEN 'Medium'
    WHEN 3 THEN 'High'
    WHEN 4 THEN 'Very High'
  END AS RelationshipSatisfactionLabel,
  WorkLifeBalance,
  CASE WorkLifeBalance
    WHEN 1 THEN 'Bad'
    WHEN 2 THEN 'Good'
    WHEN 3 THEN 'Better'
    WHEN 4 THEN 'Best'
  END AS WorkLifeBalanceLabel,
  Attrition,
  OverTime,
  MaritalStatus,
  BusinessTravel,
  YearsAtCompany,
  YearsInCurrentRole,
  YearsWithCurrManager,
  TotalWorkingYears,
  TrainingTimesLastYear,
  NumCompaniesWorked,
  StockOptionLevel
FROM raw_hr_data;


--If NumCompaniesWorked is missing, treat as zero.

SELECT
	EMPLOYEENUMBER,
	COALESCE(NUMCOMPANIESWORKED, 0) AS COMPANIESWORKED,
	ATTRITION
FROM
	CLEANED_HR
ORDER BY
	COMPANIESWORKED DESC;

-- Attrition by Job Role

CREATE VIEW attrition_by_jobrole AS
SELECT
  JobRole,
  COUNT(*) AS NumEmployees,
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS NumAttrition,
  ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS AttritionRate
FROM cleaned_hr
GROUP BY JobRole
ORDER BY AttritionRate DESC;


--Average MOnthly Income by Education & Attrition

CREATE VIEW income_by_education_attrition AS
SELECT
  EducationLevel,
  Attrition,
  ROUND(AVG(MonthlyIncome), 2) AS AvgMonthlyIncome
FROM cleaned_hr
GROUP BY EducationLevel, Attrition
ORDER BY EducationLevel, Attrition;


--Distance from Home by Job Role & Attrition

CREATE VIEW distance_by_jobrole_attrition AS
SELECT
  JobRole,
  Attrition,
  ROUND(AVG(DistanceFromHome), 2) AS AvgDistance
FROM cleaned_hr
GROUP BY JobRole, Attrition
ORDER BY JobRole, Attrition;


--Top Factors for High Attrition Roles

CREATE VIEW high_attrition_job_roles AS
SELECT 
  JobRole,
  ROUND(AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS AttritionRate,
  ROUND(AVG(EnvironmentSatisfaction), 2) AS AvgEnvironmentSatisfaction,
  ROUND(AVG(JobInvolvement), 2) AS AvgJobInvolvement,
  ROUND(AVG(WorkLifeBalance), 2) AS AvgWorkLifeBalance
FROM cleaned_hr
GROUP BY JobRole
ORDER BY AttritionRate DESC;

--Above-Average Earners in High Attrition Roles

CREATE VIEW high_income_high_attrition AS
SELECT 
  EmployeeNumber,
  JobRole,
  MonthlyIncome,
  Attrition
FROM cleaned_hr
WHERE 
  JobRole IN (
    SELECT JobRole
    FROM cleaned_hr
    GROUP BY JobRole
    HAVING AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) > 0.15
  )
  AND MonthlyIncome > (
    SELECT AVG(MonthlyIncome) FROM cleaned_hr
  )
ORDER BY JobRole, MonthlyIncome DESC;


--Attrition Rate by Tenure Buckets
CREATE VIEW attrition_by_tenure_bucket AS
SELECT
  CASE 
    WHEN YearsAtCompany < 2 THEN 'New (0-1 yrs)'
    WHEN YearsAtCompany BETWEEN 2 AND 5 THEN 'Early (2-5 yrs)'
    WHEN YearsAtCompany BETWEEN 6 AND 10 THEN 'Mid (6-10 yrs)'
    ELSE 'Long Tenure (>10 yrs)'
  END AS TenureBucket,
  COUNT(*) AS NumEmployees,
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS NumAttrition,
  ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS AttritionRate
FROM cleaned_hr
GROUP BY TenureBucket
ORDER BY AttritionRate DESC;

--High Performers Who Quit

CREATE VIEW attrition_by_performance AS
WITH perf_attrition AS (
  SELECT
    PerformanceRatingLabel,
    Attrition,
    COUNT(*) AS CountAttrition
  FROM cleaned_hr
  GROUP BY PerformanceRatingLabel, Attrition
)
SELECT 
  *,
  RANK() OVER (PARTITION BY PerformanceRatingLabel ORDER BY CountAttrition DESC) AS RankWithinPerf
FROM perf_attrition
ORDER BY PerformanceRatingLabel, RankWithinPerf;


--Likely to Quit (Churn Risk Flag)
CREATE VIEW likely_quit_flag AS
SELECT 
  EmployeeNumber,
  Age,
  DistanceFromHome,
  JobSatisfactionLabel,
  OverTime,
  WorkLifeBalanceLabel,
  CASE
    WHEN JobSatisfactionLabel = 'Low' 
      AND OverTime = 'Yes'
      AND WorkLifeBalanceLabel IN ('Bad', 'Good')
    THEN 'Likely to Quit'
    ELSE 'Low Risk'
  END AS ChurnRisk
FROM cleaned_hr
ORDER BY ChurnRisk DESC;


--Satisfaction + Involvement + Work-Life Balance (by Department)

CREATE VIEW high_satisfaction_departments AS
SELECT 
  Department,
  ROUND(AVG(EnvironmentSatisfaction), 2) AS AvgEnvSatisfaction,
  ROUND(AVG(JobInvolvement), 2) AS AvgJobInvolvement,
  ROUND(AVG(WorkLifeBalance), 2) AS AvgWorkLifeBalance
FROM cleaned_hr
GROUP BY Department
ORDER BY Department;











