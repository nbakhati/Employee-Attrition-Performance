#IBM HR Analytics Employee Attrition & Performance

This project analyzes employee attrition and performance trends using:
- PostgreSQL for data cleaning and transformation
- SQL for building advanced HR reports
- Tableau for interactive dashboards revealing employee satisfaction, tenure, income, and attrition risk insights.

# [View the Live Dashboard]([https://public.tableau.com/app/profile/narayani.bakhati6251/viz/IBM_HR_analytics_Emp_AttritionPerfrmce_dashboard/Dashboard1?publish=yes]

# Data Background

This dataset comes from Kaggle: IBM’s fictional HR Analytics dataset (https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset/data), designed to help organizations understand why employees leave and what factors drive performance.

Key features include:

- Demographics: Age, Gender, Department, Job Role, Education Level
- Job Details: Monthly Income, Years at Company, Years with Manager
- Satisfaction & Ratings: Job Satisfaction, Environment Satisfaction, Performance Rating
- Attrition Flag: Whether an employee left (Yes/No)

For this project:

- The raw data was imported into PostgreSQL
- Cleaned and transformed using SQL Views
- Satisfaction and ratings were decoded for clarity
- Advanced views were created to flag likely quit risk and reveal hidden patterns

# Key Analysis Queries
1. Attribution by Job Role:
How many employees leave in each role, plus their attrition rates.
Key insight: Roles like Sales Executive and Laboratory Technician show higher quit rates compared to roles like Research Director or Manager. This indicates some positions might have higher stress, targets, or fewer growth opportunities, requiring focused retention plans.

2. Average Income by Education & Attrition:
Average salary compared across education levels and whether employees stay or leave.
Key Insight: Higher education generally correlates with higher pay, but doesn’t guarantee retention. For example, even Doctorate holders show some attrition — implying that salary alone is not enough to keep top talent engaged.

3. Distance from Home by Job Role & Attrition:
How average commuting distance varies by job role and attrition status.
Key Insight: Roles with longer commutes (e.g., Sales Reps, Healthcare Reps) have slightly higher attrition, suggesting commute stress could push employees to quit. Remote/hybrid options might help reduce this risk.

4. High Attrition Job Roles:
Roles ranked by their attrition rate plus their average satisfaction and work-life balance scores.
Key Insight: High attrition roles often show lower satisfaction and work-life balance scores. Targeted interventions like clearer career paths, workload adjustments, or better manager support can address the root causes.

5. High Income + High Attrition
Employees earning above-average salaries who still quit.
Key Insight: A surprising number of high earners still leave, particularly in Sales Executive roles. This signals that compensation isn’t always the fix — culture, role fit, or burnout may drive exits despite good pay.

6. Attrition by Tenure Buckets:
Attrition rate grouped by how long employees have been at the company.
Key Insight: Early-tenure (2–5 years) show the highest attrition rates — a classic pattern indicating onboarding gaps, unmet role expectations, or lack of early career support.

7. Performance Rating vs Attrition:
Whether top performers quit more or less than others.
Key Insight: Some high performers (rated Excellent or Outstanding) do leave — which is costly for the company. This highlights the importance of recognizing, rewarding, and advancing top talent to keep them engaged.

8. Likely to Quit (Churn Risk Flag)
Employees flagged as ‘Likely to Quit’ based on risky combinations like low satisfaction + overtime + bad work-life balance.
Key Insight: A clear at-risk segment is identifiable for proactive HR intervention. This flag lets managers focus coaching, recognition, or flexibility where it’s needed most to prevent sudden resignations.

# Tools Used

- PostgreSQL: Data storage, cleaning, reusable SQL Views
- pgAdmin: To write and test SQL
- Tableau: For building an interactive dashboard and visual stories

# How to Use

- Run the SQL scripts (Donation.sql) in your PostgreSQL environment to create tables and views.
- Open the Tableau workbook (.twbx) and connect to your local or extracted data.
- Or, view the live dashboard directly

# Next Steps

- Add predictive modeling in Python or R to complement the SQL patterns.
- Automate churn flag alerts for HR managers.
