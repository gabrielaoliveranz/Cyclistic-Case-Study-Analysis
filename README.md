# Cyclistic Annual Membership Conversion Strategy

## 🎯 Project Overview & Business Goal

This case study was conducted as part of the Google Data Analytics Professional Certificate. It was commissioned by the marketing director of Cyclistic, a fictional bike-share company.

The primary objective is to **convert casual riders into annual members** by understanding how the two user groups (`Annual` members and `Casual` riders) use the bike-share service differently. The analysis focuses on identifying key behavioural patterns to support strategic marketing and operational decisions.

## 🛠️ Tools & Deliverables

This project uses a combination of R for rigorous data analysis and Tableau for interactive, executive-level visualisations.

| Deliverable | Tool Used | Repository Files |
| :--- | :--- | :--- |
| **Data Cleaning & Preparation** | **R (Tidyverse)** | `cyclistic_cleaning.R` |
| **Statistical Analysis & Reporting** | **R Markdown** | `Cyclistic-Case-Study--...Rmd` and the final PDF report. |
| **Interactive Visualisation** | **Tableau Public** | [Link to Dashboard] (See below) |

---

## 📊 Data Source & Cleaning Process

### Data Source

The analysis is based on historical ride data provided by Cyclistic for **Q1 2019 and Q1 2020** (January to March). The dataset has been consolidated and cleaned to ensure accuracy.

### Key Cleaning Steps

The data was prepared using R and the Tidyverse package set. The key steps, detailed in the `cyclistic_cleaning.R` script, included:

* **Standardising User Types:** Consolidating legacy user designations (`Customer` + `casual`) into `Casual` and (`member` + `Subscriber`) into `Annual` for clear comparison.
* **Feature Engineering:** Calculating trip duration (`ride_length`) in minutes.
* **Outlier Removal:** Filtering out invalid rides (zero or negative duration) and extreme rides (e.g., over 24 hours), which typically indicate errors.
* **Time Feature Extraction:** Deriving `day_of_week`, `month`, and `start_hour` to support trend analysis.

The resulting dataset, `cyclistic_cleaned_Q1_2019_2020.csv`, is the primary source for the analysis.

---

## 📈 Key Findings & Strategic Recommendations

### Core Insights

The analysis identified clear differences in usage:
* **Duration:** Annual members take significantly shorter, utility-focused rides (~11 min). Casual riders take longer, leisure-focused rides (~36 min).
* **Temporal Peaks:** Annual use peaks during weekday commuting hours (7-9 a.m., 4-6 p.m.). Casual use peaks strongly on weekends and during late morning/afternoon recreational hours.
* **Seasonality:** Both groups show strong growth in **March**, indicating the most opportune time to launch conversion campaigns.

### Recommendations 

The following actions are recommended to convert casual riders into annual members:

1.  **Marketing & Conversion Strategy:** Shift the focus from general promotion to **Annual Membership Conversion**.
    * **Incentivise** Casual riders by promoting the cost savings and convenience of short, routine weekday commutes.
    * Offer special weekend perks (e.g., discounted day passes) to convert current leisure users.

2.  **Seasonal Planning:** Prepare for the spring surge. **Initiate conversion campaigns and increase fleet rotation in March** to **capitalise** on the strong seasonal growth of casual riders.

3.  **Fleet Management:** Allocate more bikes to central, high-demand stations during Annual riders' peak commuting hours: 7:00-9:00 a.m. and 4:00-6:00 p.m. (Monday to Friday).

---

## 🔗 Interactive Data Visualisation

For a dynamic and granular view of the data, the analysis is supported by a comprehensive Tableau Dashboard:

**Click here to view the full interactive dashboard:**
[https://public.tableau.com/views/CyclisticQ1UsageStrategyDashboard/ExecutiveSummary?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link]
