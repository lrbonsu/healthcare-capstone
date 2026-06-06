
# Healthcare Patient Readmission Analysis

## Business Problem
Hospital readmissions cost the US healthcare system over $26 billion annually.
CMS (Centers for Medicare & Medicaid Services) penalizes hospitals up to 3%
of their Medicare payments for excessive readmission rates. This project
analyzes 70,000 real patient records from 130 US hospitals to identify the
key drivers of readmission and build a predictive model that flags high-risk
patients at discharge — enabling early intervention before readmission occurs.

---

## Tools & Technologies
- **Python** — data cleaning, feature engineering, machine learning
- **SQL (SQLite)** — patient segmentation, risk profiling, window functions
- **Tableau Public** — interactive clinical dashboard with risk tier visualization
- **Libraries** — pandas, numpy, matplotlib, seaborn, scikit-learn,
  imbalanced-learn (SMOTE)

---

## Dataset
- **Source:** Diabetes 130-US Hospitals dataset via Kaggle
- **Size:** 100,000 records → 70,000 unique patients after deduplication
- **Scope:** 130 US hospitals | 10 years (1999-2008) | 50 features
- **Target variable:** Any hospital readmission (Yes/No)
- **Known challenge:** 30-day readmission prediction on this dataset produces
  ROC-AUC scores of 0.52-0.57 in published literature — consistent with
  initial model results. Target was broadened to any readmission to produce
  more clinically actionable predictions.

---

## Project Structure

    healthcare-capstone/
    │
    ├── data/
    │   ├── diabetic_data.csv           # Raw Kaggle dataset
    │   ├── patients_clean.csv          # Cleaned patient data
    │   ├── healthcare.db               # SQLite database
    │   ├── tableau_patients.csv        # Tableau patient source
    │   └── tableau_models.csv          # Tableau model comparison source
    │
    ├── notebooks/
    │   ├── 01_setup.ipynb              # Data cleaning & feature engineering
    │   ├── 02_sql_analysis.ipynb       # SQL queries & patient segmentation
    │   ├── 03_eda.ipynb                # Exploratory data analysis
    │   └── 04_ml_models.ipynb          # ML models & business impact
    │
    ├── sql/
    │   └── healthcare_queries.sql      # All SQL queries
    │
    ├── dashboard/
    │   └── [chart exports]             # PNG exports from Python
    │
    └── README.md

---

## Methodology

### 1. Data Cleaning & Feature Engineering
Loaded 100,000 real patient records and handled missing values represented
as question marks throughout the dataset. Dropped three columns with
excessive missingness — weight (97% missing), payer code (40%), and
medical specialty (49%). Removed duplicate patients keeping first encounter
only — reducing to 70,000 unique patients.

Created five clinically meaningful engineered features:
- **n_meds_changed** — count of medications adjusted during stay
- **total_procedures** — lab and non-lab procedures combined
- **service_utilization** — outpatient + emergency + inpatient visits
- **age_numeric** — age bucket converted to numeric midpoint
- **high_risk_diag** — flag for circulatory and respiratory diagnoses

### 2. SQL Analysis
Wrote 10 queries covering patient KPIs, readmission by age and race,
length of stay analysis, insulin and A1C impact, high risk patient
profiling using CTEs and UNION ALL, and patient risk ranking using
RANK and NTILE window functions.

### 3. Exploratory Data Analysis
Generated 7 visualisations identifying key readmission drivers including
age group patterns, length of stay correlation, medication count impact,
insulin usage, A1C results, feature correlations, and engineered feature
distributions comparing readmitted vs non-readmitted patients.

### 4. Machine Learning
Built and compared three classification models to predict any readmission:

- **Logistic Regression** — interpretable baseline model
- **Random Forest** — ensemble model capturing non-linear relationships
- **Gradient Boosting** — sequential ensemble — best overall performance

Applied SMOTE oversampling to the training set to address class imbalance
before model training. Models were evaluated on accuracy, ROC-AUC, recall,
and precision with recall prioritised — missing a high-risk patient is more
costly than a false alarm.

---

## Key Findings

| Finding | Detail |
|---|---|
| Overall readmission rate | ~46% of patients were readmitted at some point |
| Highest risk age group | Patients aged 70-80 show highest readmission rates |
| Length of stay | Longer hospital stays correlate with higher readmission risk |
| Medications | More medications = higher complexity = higher readmission risk |
| Insulin usage | Patients with insulin dose changes show higher readmission rates |
| Service utilization | Prior emergency and inpatient visits are strong risk predictors |

---

## Model Results

| Model | Accuracy | ROC-AUC | Recall | Precision |
|---|---|---|---|---|
| Logistic Regression | 59.7% | 0.592 | 0.406 | 0.495 |
| Random Forest | 61.8% | 0.643 | 0.443 | 0.526 |
| Gradient Boosting | 62.8% | 0.656 | 0.471 | 0.538 |

**Gradient Boosting** achieved the strongest performance across all metrics.
A recall of 0.471 means the model correctly identifies 47% of patients who
will be readmitted — enabling clinical teams to intervene before discharge.

**Note on model performance:** ROC-AUC scores of 0.55-0.65 are consistent
with published academic literature on this dataset. The weak predictive signal
reflects genuine clinical complexity — readmission is influenced by factors
not captured in the available features such as social determinants of health,
post-discharge care access, and patient compliance.

---

## Business Impact

At $1,500 per avoided readmission penalty Gradient Boosting catches
significantly more at-risk patients than the baseline logistic regression model.
Deploying this model as a discharge screening tool enables clinical teams to:

1. Prioritise follow-up care for high-risk patients before discharge
2. Reduce CMS readmission penalties through proactive intervention
3. Improve patient outcomes through targeted post-discharge support

---

## Business Recommendations

1. Deploy the Gradient Boosting model as a discharge risk scoring tool —
   flag any patient with a risk score above 0.3 for follow-up care planning

2. Focus intervention resources on the 70-80 age group which shows the
   highest readmission rates across all diagnoses

3. Review insulin management protocols — patients with insulin dose changes
   during their stay show elevated readmission risk and may benefit from
   additional diabetes education before discharge

4. Invest in collecting social determinants of health data — insurance status,
   living situation, and care access are known readmission predictors not
   currently in the dataset. Adding these features in a future model iteration
   could meaningfully improve predictive performance

---

## Dashboard
View the interactive Tableau dashboard here:
[Healthcare Patient Readmission Analysis](https://public.tableau.com/app/profile/
lynnetta.bonsu/viz/HealthcarePatientReadmissionAnalysis/HealthcarePatientReadmissionAnalysis)

---

## How to Run This Project

1. Clone the repo:

    git clone https://github.com/lrbonsu/healthcare-capstone.git
    cd healthcare-capstone

2. Install dependencies:

    pip install pandas numpy matplotlib seaborn scikit-learn imbalanced-learn

3. Download the dataset from Kaggle and place in data/diabetic_data.csv:

    kaggle.com/datasets/brandao/diabetes

4. Run notebooks in order:
   - 01_setup.ipynb
   - 02_sql_analysis.ipynb
   - 03_eda.ipynb
   - 04_ml_models.ipynb

5. View the live Tableau dashboard at the link above

---

## Author
Lynnetta — [LinkedIn](https://www.linkedin.com/in/lrbonsu/) | 
[Tableau Public](https://public.tableau.com/app/profile/lynnetta.bonsu/vizzes) | [GitHub](https://github.com/lrbonsu)
