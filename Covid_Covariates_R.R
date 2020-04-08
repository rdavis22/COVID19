####Code Block 1####
##Key Questions:
#1) Which populations are at risk of contracting COVID-19?
#2) Which patient populations pass away from COVID-19?
#3) What is the incidence of infection with coronavirus among cancer patients?
#4) Which populations have contracted COVID-19 and require ventilators?
#5) Which populations have contracted COVID-19 who require the ICU?
#6) How are patterns of care changing for current patients (i.e. cancer patients)?

## Importing packages

# This R environment comes with all of CRAN and many other helpful packages preinstalled.
# You can see which packages are installed by checking out the kaggle/rstats docker image: 
# https://github.com/kaggle/docker-rstats

if(!require(tidyverse)){
  install.packages("tidyverse"); library(tidyverse)} # metapackage with lots of helpful functions
if(!require(glm2)){
  install.packages("glm2"); library(glm2)} #for logistic regressionm modeling

## Running code

# In a notebook, you can run a single code cell by clicking in the cell and then hitting 
# the blue arrow to the left, or by clicking in the cell and pressing Shift+Enter. In a script, 
# you can run code by highlighting the code you want to run and then clicking the blue arrow
# at the bottom of this window.

## Reading in files

# You can access files from datasets you've added to this kernel in the "../input/" directory.
# You can see the files added to this kernel by running the code below. 

list.files(path = "../input")

## Saving data

# If you save any files or images, these will be put in the "output" directory. You 
# can see the output directory by committing and running your kernel (using the 
# Commit & Run button) and then checking out the compiled version of your kernel.

####Code Block 2####

#For local R code#
setwd("C:/Users/rcdav/OneDrive/Documents/Duke/Research/COVID19/")

#List all the files in the "uncover folder"
#see what data you want to work with
list.files("./input/uncover")

####Code Block3####
##read in the dataframe##
#Set the file path to the diagnostics and clinical spectrum tab
path<-"./input/uncover/einstein/diagnosis-of-covid-19-and-its-clinical-spectrum.csv"

#create a tibble of the einstein data
einstein.tibble<-read_csv(path)

####Code Block 4####
###Cleaning the dataframe

#change the 'sars_cov_2_exam_result' response variable to class 'numeric' with "negative"=0 and "positive"=1
einstein.tibble$sars_cov_2_exam_result<-ifelse(is.na(einstein.tibble$sars_cov_2_exam_result), NA,
                               ifelse(grepl("negative", einstein.tibble$sars_cov_2_exam_result), 0, 1))

#change all logical columns to class 'integer' (FALSE=0, TRUE=1)
einstein.tibble<-einstein.tibble %>% mutate_if(is.logical, as.integer)

#change character vectors containing "not_detected" and "detected" to integer vectors of 0 and 1
einstein.tibble<-einstein.tibble %>% mutate_at(vars(respiratory_syncytial_virus:parainfluenza_2), 
                         list(~recode(., 'not_detected'=0, 'detected'=1)))

#chr.tibble<-einstein.tibble %>% select_if(is.character)