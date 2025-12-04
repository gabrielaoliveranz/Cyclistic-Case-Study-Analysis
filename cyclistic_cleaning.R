# ================================================================
# Cyclistic Case Study - Data Cleaning & Preparation (RStudio)
# ================================================================
# Purpose:
# This script prepares and cleans the Cyclistic trip data
# (2019 Q1 and 2020 Q1) to support the key business question:
# "How do annual members and casual riders use Cyclistic bikes differently?"
#
# The goal is to document every step clearly so that stakeholders
# without technical experience can understand the decisions,
# transformations, and logic behind the analysis.
# ================================================================

# --- Load tidyverse (Explanation for stakeholders) ----------------
# tidyverse is a collection of packages used for data cleaning,
# manipulation, and exploration. It allows us to handle large
# datasets efficiently and ensures a consistent, reliable workflow.
install.packages("tidyverse")
library(tidyverse)

# --- Step 1: Read the CSV files for Q1 2019 and Q1 2020 ---
# We use read_csv() from the readr package (part of tidyverse) because it's fast and keeps column types consistent.

# Set working directory to the folder with your CSVs
setwd("/cloud/project/cyclistic")

# Now you can read them directly
q1_2019 <- read_csv("Divvy_Trips_2019_Q1.csv")
q1_2020 <- read_csv("Divvy_Trips_2020_Q1.csv")


# --- Step 2: Combine the two datasets into a single dataframe ---
# bind_rows() stacks the rows of both dataframes. This way we have one full dataset for analysis.

cyclistic <- bind_rows(q1_2019, q1_2020)

# --- Step 3: Check the structure of the combined dataset ---
# glimpse() shows the columns, data types, and gives a quick view of the first few rows.
glimpse(cyclistic)

# --- Optional: see the first 10 rows for a quick preview ---
head(cyclistic, 10)

# -------------------------------------------------------------------
# Overview of what we've done so far:
# 1. Set the working directory to the project folder to ensure R can find the CSV files.
# 2. Loaded the Q1 2019 and Q1 2020 Cyclistic trip data using read_csv(), converting them into tibbles (R dataframes).
# 3. Combined both datasets into a single dataframe (cyclistic) using bind_rows() to facilitate comparative analysis across years.
# 4. Used glimpse() to quickly inspect the structure, column types, and sample data, identifying missing values and inconsistencies.
# 5. Used head() to review the first 10 rows and confirm the dataset has been loaded and combined correctly.
# 
# Notes for stakeholders:
# - Some columns are NA because their counterparts exist only in one year (e.g., 'usertype' vs 'member_casual').
# - Next steps: clean column names, calculate ride_length, and prepare day_of_week/month variables for analysis.
# -------------------------------------------------------------------

# --- Step 4: Standardize Columns using coalesce -------------------
# Purpose: Create consistent column names across both datasets (2019 Q1 and 2020 Q1)
# This ensures we have a single set of columns for analysis:
#   - ride_id      : unique identifier for each trip
#   - started_at   : start time of the trip
#   - ended_at     : end time of the trip
#   - member_casual: user type (Annual Member or Casual Rider)
# coalesce(a, b) returns the first non-NA value between a and b

cyclistic <- cyclistic %>%
  mutate(
    ride_id = coalesce(as.character (ride_id), as.character(trip_id)), # Convert both to character # Use ride_id if exists; otherwise use trip_id from 2019
    started_at = coalesce(started_at, start_time), # Standardize start time column
    ended_at = coalesce(ended_at, end_time),       # Standardize end time column
    member_casual = coalesce(member_casual, usertype) # Standardize user type column
  )

# --- Step 5: Remove old/duplicate columns --------------------------
# Purpose: Keep dataset clean and avoid confusion/duplicates
cyclistic <- cyclistic %>%
  select(-trip_id, -start_time, -end_time, -usertype)


# --- Step 6: Calculate ride length, extract day of week and month ----------------
# ride_length: difference between end and start times in minutes
# day_of_week: name of the day to analyse weekly patterns
# month: name of the month to analyse monthly trends

cyclistic <- cyclistic %>%
  mutate(
    ride_length = as.numeric(difftime(ended_at, started_at, units = "mins")), # Ride duration in minutes
    day_of_week = weekdays(started_at),    # Returns Monday, Tuesday, etc.
    month = format(started_at, "%B")       # Returns full month name
  )

# Step 7: Remove invalid or extreme ride lengths
cyclistic <- cyclistic %>%
  filter(ride_length > 0 & ride_length <= 1440)  # Keep only rides >0 mins and <= 24 hours


# --- Step 8: Quick Check After Cleaning --------------------------------
# glimpse() lets us verify that ride_length, day_of_week, and month are ready for analysis.
glimpse(cyclistic)

# Optional: preview first 10 rows to ensure cleaning worked
head(cyclistic, 10)

# -----------------------------------------------------------------------
# Dataset Overview & Notes for Stakeholders
#
# - Column names are now consistent for member type and ride identifiers across 2019 Q1 and 2020 Q1.
# - ride_length is in minutes, allowing direct comparison between casual riders and annual members.
# - day_of_week and month variables enable analysis of weekly and monthly trends.
# - Invalid or extreme rides have been removed to avoid skewing the analysis.
# - Some columns contain missing values (NA), such as rideable_type or columns present only in 2019 data. 
#   These are expected due to differences in the original datasets and do not affect the main analysis.
# - The dataset is now clean, consistent, and ready for further analysis (Step 9 onwards), 
#   where we will explore how annual members and casual riders use Cyclistic bikes differently.
# -----------------------------------------------------------------------

# --- Step 9: Optional Separation of Date and Time --------------------
# The 'started_at' and 'ended_at' columns currently contain both date and time in a single datetime format.
# For certain analyses or visualisations (e.g., trips by hour of day, or trips per calendar date),
# it can be useful to have separate columns for date and time.
# These new columns do NOT replace the original datetime columns; they are additional fields for analysis convenience.

cyclistic <- cyclistic %>%
  mutate(
    start_date = as.Date(started_at),                     # Extract only date
    start_time_only = format(started_at, "%H:%M:%S"),    # Extract only time
    end_date = as.Date(ended_at),                         # Extract only date
    end_time_only = format(ended_at, "%H:%M:%S")         # Extract only time
  )

# --- Step 10: Inspect the cleaned dataset visually -----------------
# Use View(cyclistic) to open the full dataset in a spreadsheet-like window.
# This allows us to see all columns and rows interactively, check for missing values,
# confirm that the ride_length, day_of_week, and month columns were created correctly,
# and verify that date-time columns (started_at, ended_at) are properly formatted.
View(cyclistic)

# --- Step 11: Exploratory Data Analysis (EDA) -----------------------
# Purpose: To explore usage patterns and identify differences between
# annual members and casual riders.
# We will look at ride length, day of week usage, monthly trends,
# and other insights that can answer the key business question.

# Example 1: Average ride length by user type
cyclistic %>%
  group_by(member_casual) %>%
  summarise(avg_ride_length = mean(ride_length)) %>%
  arrange(desc(avg_ride_length))

# Example 2: Number of rides by day of week and user type
cyclistic %>%
  group_by(member_casual, day_of_week) %>%
  summarise(num_rides = n()) %>%
  arrange(member_casual, day_of_week)

# Example 3: Number of rides by month and user type
cyclistic %>%
  group_by(member_casual, month) %>%
  summarise(num_rides = n()) %>%
  arrange(member_casual, month)

# Optional: use View() to see results interactively
# View() can help stakeholders check counts, averages, and trends.

# --- Step 12: Classify days as Weekday or Weekend -------------------
cyclistic <- cyclistic %>%
  mutate(
    day_type = ifelse(day_of_week %in% c("Saturday", "Sunday"), "Weekend", "Weekday")
  )

# --- Analysis: Number of rides by day type and user type -------------
cyclistic %>%
  group_by(member_casual, day_type) %>%
  summarise(num_rides = n()) %>%
  arrange(member_casual, day_type)

# --- Optional: Average ride length by day type and user type ---------
cyclistic %>%
  group_by(member_casual, day_type) %>%
  summarise(avg_ride_length = mean(ride_length)) %>%
  arrange(member_casual, day_type)

# --- Step 12: Group Users into Broad Categories --------------------
# Purpose: For clearer analysis, we combine similar user types into two main groups:
#   - 'Casual': includes 'casual' and 'Customer'
#   - 'Annual': includes 'member' and 'Subscriber'
# This allows us to directly compare casual riders vs annual members in trends and metrics.
# Note: This step is done after cleaning and calculating ride metrics to ensure accurate classification.

cyclistic <- cyclistic %>%
  mutate(
    user_type_group = ifelse(member_casual %in% c("casual", "Customer"), "Casual", "Annual")
  )

# Quick check: see the distribution of new groups
cyclistic %>%
  group_by(user_type_group) %>%
  summarise(num_rides = n(),
            avg_ride_length = mean(ride_length)) %>%
  arrange(desc(num_rides))

# --- Step 13: Comparative Analysis by User Type and Day/Month ----------------
# Purpose: Compare usage patterns between Casual and Annual riders.
# This helps Cyclistic understand how different user types behave over time and plan marketing, bike availability, or promotions accordingly.

# 1. Aggregate by day type (Weekday vs Weekend)
cyclistic <- cyclistic %>%
  mutate(
    user_type_group = ifelse(member_casual %in% c("Customer", "casual"), "Casual", "Annual")
  )

day_type_summary <- cyclistic %>%
  group_by(user_type_group, day_type) %>%
  summarise(
    num_rides = n(),
    avg_ride_length = mean(ride_length),
    .groups = "drop"
  ) %>%
  arrange(user_type_group, day_type)

day_type_summary
# Notes for stakeholders:
# - Compares total rides and average ride length between weekdays and weekends.
# - Shows if casual riders tend to ride more on weekends, and annual riders more on weekdays.

# 2. Aggregate by day of the week
day_of_week_summary <- cyclistic %>%
  group_by(user_type_group, day_of_week) %>%
  summarise(
    num_rides = n(),
    avg_ride_length = mean(ride_length),
    .groups = "drop"
  ) %>%
  arrange(user_type_group, day_of_week)

day_of_week_summary
# Notes:
# - Gives a more granular view than day_type (separate days: Monday, Tuesday, ...).
# - Helps identify peak days for each user type.

# 3. Aggregate by month
month_summary <- cyclistic %>%
  group_by(user_type_group, month) %>%
  summarise(
    num_rides = n(),
    avg_ride_length = mean(ride_length),
    .groups = "drop"
  ) %>%
  arrange(user_type_group, month)

month_summary
# Notes:
# - Shows monthly trends and seasonality.
# - Important for planning marketing campaigns or maintenance during high usage months.

# Optional: view summaries
View(day_type_summary)
View(day_of_week_summary)
View(month_summary)

# --- Step 14: Comprehensive Visualisations for Stakeholders ----------------
# Purpose: Provide clear insights into Cyclistic usage patterns.
# We compare Annual vs Casual riders for decision-making.
# Analyses include: trips by day type, day of the week, average ride duration, and monthly trends.

library(ggplot2)

# 1) Total Trips: Weekday vs Weekend
ggplot(cyclistic, aes(x = day_type, fill = user_type_group)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Number of Trips by User Type and Day Type",
    x = "Day Type",
    y = "Number of Trips",
    fill = "User Type"
  ) +
  theme_minimal()

# 2) Average Ride Duration: Weekday vs Weekend
ggplot(cyclistic, aes(x = day_type, y = ride_length, fill = user_type_group)) +
  stat_summary(fun = mean, geom = "bar", position = "dodge") +
  labs(
    title = "Average Ride Duration by User Type and Day Type",
    x = "Day Type",
    y = "Average Ride Length (minutes)",
    fill = "User Type"
  ) +
  theme_minimal()

# 3) Total Trips by Day of the Week
ggplot(cyclistic, aes(x = day_of_week, fill = user_type_group)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Number of Trips by User Type and Day of the Week",
    x = "Day of the Week",
    y = "Number of Trips",
    fill = "User Type"
  ) +
  theme_minimal()

# 4) Average Ride Duration by Day of the Week
ggplot(cyclistic, aes(x = day_of_week, y = ride_length, fill = user_type_group)) +
  stat_summary(fun = mean, geom = "bar", position = "dodge") +
  labs(
    title = "Average Ride Duration by User Type and Day of the Week",
    x = "Day of the Week",
    y = "Average Ride Length (minutes)",
    fill = "User Type"
  ) +
  theme_minimal()

# 5) Total Trips by Month
ggplot(cyclistic, aes(x = month, fill = user_type_group)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Number of Trips by User Type and Month",
    x = "Month",
    y = "Number of Trips",
    fill = "User Type"
  ) +
  theme_minimal()

# 6) Average Ride Duration by Month
ggplot(cyclistic, aes(x = month, y = ride_length, fill = user_type_group)) +
  stat_summary(fun = mean, geom = "bar", position = "dodge") +
  labs(
    title = "Average Ride Duration by User Type and Month",
    x = "Month",
    y = "Average Ride Length (minutes)",
    fill = "User Type"
  ) +
  theme_minimal()


# --- Step 15: Analyse Trips by Hour of Day --------------------
# Purpose: Understand peak usage hours for Annual vs Casual riders

# Extract hour from 'started_at' (0-23)
cyclistic <- cyclistic %>%
  mutate(start_hour = as.numeric(format(started_at, "%H")))

# Total Trips by Hour
ggplot(cyclistic, aes(x = start_hour, fill = user_type_group)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Number of Trips by Hour and User Type",
    x = "Hour of Day",
    y = "Number of Trips",
    fill = "User Type"
  ) +
  theme_minimal()

# Average Ride Duration by Hour
ggplot(cyclistic, aes(x = start_hour, y = ride_length, fill = user_type_group)) +
  stat_summary(fun = mean, geom = "bar", position = "dodge") +
  labs(
    title = "Average Ride Duration by Hour and User Type",
    x = "Hour of Day",
    y = "Average Ride Length (minutes)",
    fill = "User Type"
  ) +
  theme_minimal()

# ================================================================
# Step 16: Final Save & Wrap-Up
# ================================================================

# Purpose:
# This step finalises the cleaned Cyclistic dataset and summarises key insights for stakeholders.
# It ensures that all data transformations are documented and that the dataset is ready for further analysis
# or dashboard creation.

# --- 1. Save the cleaned dataset ---------------------------------
# Save the fully cleaned and enriched dataset as a CSV file for future analysis or visualization.
write_csv(cyclistic, "cyclistic_cleaned_Q1_2019_2020.csv")

# --- 2. Summary of Key Insights ----------------------------------
# 1. Annual vs Casual Usage:
#    - Annual riders take significantly more rides overall, but with shorter durations (~11–12 minutes).
#    - Casual riders take fewer rides, but trips are longer on average (~36–41 minutes).

# 2. Weekday vs Weekend:
#    - Annual riders ride mostly on weekdays, indicating commuting patterns.
#    - Casual riders ride more on weekends, suggesting recreational usage.

# 3. Day-of-Week Patterns:
#    - Annual: steady weekday usage with slight peaks on Tuesday and Thursday.
#    - Casual: peak activity on weekends (Saturday and Sunday), low activity on weekdays.

# 4. Monthly Trends:
#    - Both user types ride more in March compared to January/February, showing seasonal trends.
#    - Casual riders show a strong increase in spring/summer months.

# 5. Hour-of-Day Patterns:
#    - Annual riders: peak rides around 7–9 AM and 5–7 PM (commuting hours).
#    - Casual riders: peak rides late morning to afternoon (recreational use).

# --- 3. Business Recommendations --------------------------------
# - Fleet Management: allocate more bikes to stations during high-demand periods (commuting hours for Annual, late mornings/afternoons for Casual).
# - Marketing Opportunities: target Casual riders with weekend promotions or day-pass campaigns.
# - Maintenance Planning: schedule bike maintenance during low-usage hours to minimise disruptions.
# - Seasonal Planning: prepare for increased ridership in spring/summer months, especially among Casual riders.

# -----------------------------------------------------------------
# The Cyclistic dataset is now fully cleaned, enriched, and ready for
# analysis, visualizations, and actionable insights to support business decisions.
# ================================================================


