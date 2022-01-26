library(shiny)
library(dplyr)
library(tidyr)
library(stringr)

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
    result <- "Not SGA (at or above 10th percentile)"
  } else {
    result <- "SGA (below 10th percentile)"
  }
  return(result)
}

# Returns TRUE or FALSE for SGA column
is_sga <- function(result_string) {
  if (result_string == "SGA (below 10th percentile)") {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

# Apply process to input df
process_df <- function(input_df) {
  cols <- colnames(input_df)
  
  if (cols[2] == "duedate") {
    
    # Convert duedate and dob to dates
    df <- input_df %>% mutate(duedate_num = as.Date(duedate, tryFormats = c("%m-%d-%y", "%m/%d/%y")),
                              dob_num = as.Date(dob, tryFormats = c("%m-%d-%y", "%m/%d/%y")))
    
    # Calculate ga from duedate and dob
    df <- df %>% mutate(ga = calculate_ga(duedate_num, dob_num))
    
    # Parse sex
    df <- df %>% mutate(sex = ifelse(str_to_lower(sex) %in% c("female", "f"), "Female", 
                                     ifelse(str_to_lower(sex) %in% c("male", "m"), "Male", "Unknown")))
    
    # Determine cutoff
    df$cutoff <- mapply(determine_cutoff, df$ga, df$sex)
    
    # Determine result based on cutoff and weight
    df$result <- mapply(compare_weight, df$cutoff, df$weight)
    
    # Add SGA indicator
    df$sga <- mapply(is_sga, df$result)
      
    # Drop intermediate columns
    df <- df %>% select(id, duedate, dob, sex, weight, sga, result)
    
    return(df)
    
  } else if (cols[2] == "weeks") {
    
    # Convert weeks and days to ga
    df <- input_df %>% mutate(ga = round(weeks + (days/7),2))
    
    # Parse sex
    df <- df %>% mutate(sex = ifelse(str_to_lower(sex) %in% c("female", "f"), "Female", 
                                     ifelse(str_to_lower(sex) %in% c("male", "m"), "Male", "Unknown")))
    
    # Determine cutoff
    df$cutoff <- mapply(determine_cutoff, df$ga, df$sex)
    
    # Determine result based on cutoff and weight
    df$result <- mapply(compare_weight, df$cutoff, df$weight)
    
    # Add SGA indicator
    df$sga <- mapply(is_sga, df$result)
    
    # Drop intermediate columns
    df <- df %>% select(id, weeks, days, sex, weight, sga, result)
    
    #View(df)
    return(df)
    
  } else {
    
    # If the template is not recognized, return NULL
    return(NULL)
    
  }
}
