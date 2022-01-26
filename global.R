library(shiny)
library(dplyr)
library(tidyr)

#########
# SETUP #
#########

# Read in cutoff data
cutoffs <- read.csv("cutoffs.csv", fileEncoding="UTF-8-BOM")
date_template <- read.csv("templates/date-template.csv", fileEncoding="UTF-8-BOM")
ga_template <- read.csv("templates/ga-template.csv", fileEncoding="UTF-8-BOM")

#############
# FUNCTIONS #
#############

# Determine gestational age (GA) at birth from due date and DOB
calculate_ga <- function(duedate, dob) {
  
  diff_days <- duedate - dob    # >0 if born before due date, <0 if born after due date
  diff_weeks <- diff_days/7     # Convert from days to weeks
  ga_weeks <- 40 - diff_weeks   # Subtract from 40
  ga_weeks_round <- round(ga_weeks, digits=2)
  
  return(ga_weeks_round)
}

# Look up cutoff for SGA based on GA (numeric) and sex (string)
determine_cutoff <- function(ga, sex) {
  
  # Check whether calculated GA is valid
  if (ga > 45 | ga < 22.57) {
    cutoff_val <- "Out of range!"
    return(cutoff_val)
  } 
  
  cutoff_row <- cutoffs %>% filter(numeric == ga)       
  cutoff_val <- ifelse(sex == "Female", cutoff_row[,4],
                   ifelse(sex == "Male", cutoff_row[,5], 
                          cutoff_row[,6]))
  
  return(cutoff_val)
}

# Determine whether birth weight is above or below 10th percentile
compare_weight <- function(cutoff_val, observed_weight) {
  if (observed_weight >= cutoff_val) {
    result <- "AGA (at or above 10th percentile)"
  } else {
    result <- "SGA (below 10th percentile)"
  }
  return(result)
}

