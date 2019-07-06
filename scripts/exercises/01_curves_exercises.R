######################################## Part 1 #####################################3

# load data and packages --------------------------------------------------

# install.packages(c('ggplot2', 'survminer', 'dplyr'))
library(ggplot2)
library(survminer)
library(dplyr)
library(survival)

survey <- readRDS('data/survey.rds')
transactional <- readRDS('data/transactional.rds')
clinical <- readRDS('data/clinical.rds') # created in R/999_extra_prepare_clinical_data.R

head(survey)
head(transactional)
head(clinical)

# exercise 01 -------------------------------------------------------------

# 1.1 Use survey, transactional and clinical data inputs to prepare risk set tables
# with the help of survival::survfit function and ?Surv object.

# difftime might help for transactional data

# Can below snippet can help with the survey data?

survey %>% 
  mutate(
    time = case_when(
      time == "Less than 5 months"     ~  ,
      time == "Between 5 and 6 months" ~  , 
      time == "Between 6 and 7 months" ~  ,
      time == "Between 7 and 8 months" ~  ,
      time == "Between 8 and 9 months" ~  ,
      time == "Between 9 and 10 months" ~ ,
      time == "Between 10 and 11 months" ~,
      time == "Between 11 and 12 months" ~,
      time == "Between 1 and 2 years" ~   ,
      time == "Between 2 and 3 years" ~   , 
      time == "Between 3 and 4 years" ~   ,
      time == "Between 4 and 5 years" ~   
    )
  )

# 1.2 Do every survey respondent can have different value of time?

# 1.3* extra - create survival surve for interval data (based on survey dataset)


# exercise 2 --------------------------------------------------------------

# Use survminer::ggsurvplot function to show survey and transactional data on one 
# survival plot, and the clinical data with risk set table on the other plot.

# 2.0 Bind survey and transactional data.

ggsurv <- 
  
  # Few below lines can help customize the plot
  
  ggsurvplot(
    fit, 
    data = YOUR_DATA, 
    size = 1,                 # change line size
    palette = 
      c("#E7B800", "#2E9FDF"),# custom color palettes
    conf.int = TRUE,          # Add confidence interval
    pval = TRUE,              # Add p-value
    risk.table = TRUE,        # Add risk table
    risk.table.col = "strata",# Risk table color by groups
    legend.labs = 
      c("Male", "Female"),    # Change legend labels
    risk.table.height = 0.25, # Useful to change when you have multiple groups
    ggtheme = theme_bw()      # Change ggplot2 theme
  )

# 2.1 Try setting `xlim` and `break.time.by` parameters to adjust the OX axis.

# 2.2 Remove censoring marks from the plot.

# 2.3 Is the plot more informative when having `median survival pointer` (surv.median.line = "hv")

# 2.4 Let's remove text labels from risk set table legend and append them with colour bars

risk.table.y.text.col = T,# colour risk table text annotations.
# risk.table.height = 0.25, # the height of the risk table
risk.table.y.text = FALSE,# show bars instead of names in text annotations

# 2.5 Have you ever tried calling do.call(ggsurvplot, list_of_named_parameters)?


# exercise 3 --------------------------------------------------------------

# Try changing labels and fonts of the plot

ggsurv$plot <- ggsurv$plot + labs(
  title    = "Survival curves",                     
  subtitle = "Based on Kaplan-Meier estimates",  
  caption  = "created with survminer"             
)

# Labels for Risk Table 
ggsurv$table <- ggsurv$table + labs(
  title    = "Note the risk set sizes",          
  subtitle = "and remember about censoring.", 
  caption  = "source code: website.com"        
)

ggpar(
  ggsurv,
  font.title    = c(16, "bold", "darkblue"),         
  font.subtitle = c(15, "bold.italic", "purple"), 
  font.caption  = c(14, "plain", "orange"),        
  font.x        = c(14, "bold.italic", "red"),          
  font.y        = c(14, "bold.italic", "darkred"),      
  font.xtickslab = c(12, "plain", "darkgreen"),
  legend = "top"
)


# exercise 4 --------------------------------------------------------------

# 4.1 Create your own Kaplan-Meier estimates without using survfit and Surv functions.

# 4.2 Then create your own survival curves plot using ggplot2::ggplot and ggplot2::geom_step

# exercise 5 --------------------------------------------------------------

# 5.1 Divide survival curves by a categorical variable by modifying formula in the survfit function.

# 5.2 Divide the survival curves by a continuous variables. What are the options to cut the continuous variable into groups?

# 5.3 Use survminer::surv_cutpoint and surv::surv_categorize to divide continuous variable with the maxstat method.

# 5.4 Create your own code for the maxstat:
# a) cut continuous variable to, e.g., N pieces
# b) for each cutpoint calculate the logrank test (survival::survdiff)
# c) select the point that maximizes the statistic in the logrank test

