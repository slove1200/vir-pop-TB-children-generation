# - author:      Yu-Jou Lin
# - title:       Virtual population for children
# - date:        May 18, 2026
# - description: Children growth curve incorporation

# WHO recommended dosing

#### Load libraries ####
library(mrgsolve)
library(dplyr)
library(tidyr)
library(ggplot2)
library(grid)
library(gridExtra)
library(DT)

working.directory <- "..."
setwd(working.directory)

# Read in simpop (SEX = 1 (male) and 2 (female), AGE in months, WT in kg in simtab_WT_15.tab)
pop <- read.table(paste0(working.directory, "simtab_WT_15.tab"),
                  header = T) %>% select(-DV)

## Common model covariates
# 1. "WTSIM" based on LMS fit
source("LMS_approximation.R")

#### create dataset for mrgsolve simulation ####
# Example of creating dosing dataset (WT/AGE change check at day 0 and then every month (4 weeks))
data1 <- tibble(ID = rep(1:40000, each = 7),
                time = rep(c(168*0, 168*4, 168*8, 168*12, 168*16, 168*20, 168*24), times = 40000)) %>% full_join(pop) %>%
  mutate(AGE2 = AGE+time/(24*7*4),      # AGE in month, AGE2 in month, time in hour
         AGE3 = AGE/12+time/(24*7*52))  # AGE in month, AGE3 in year, time in hour

data1 <- data1 %>% group_by(row_number()) %>% 
  mutate(WTSIM = LMS_parameter(SEX, AGE2, ZSCORE)) %>% 
  ungroup() %>% select(-`row_number()`)

# Identify IDs that meet the exclusion criteria at time 0, in this case excluding the individuals with base baseline weight > 80 kg
excluded_ids <- data1 %>%
  filter(time == 0 & WTSIM > 80) %>%
  pull(ID) %>%
  unique()

# Filter out all records for those identified IDs
data1 <- data1 %>%
  filter(!ID %in% excluded_ids)