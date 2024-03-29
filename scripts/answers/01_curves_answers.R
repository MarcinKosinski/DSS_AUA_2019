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

summary(survival::survfit(Surv(times, patient.vital_status) ~ 1, data = clinical))

ggsurvplot(
  survival::survfit(Surv(times, patient.vital_status) ~ 1, data = clinical),
  risk.table = TRUE
  )

transactional2 <-
  transactional %>%
  mutate(time = ifelse(is.na(ended_at),
                       difftime(max(ended_at, na.rm = TRUE), free_trial_started_at, units = 'days'),
                       difftime(ended_at, free_trial_started_at, units = 'days'))) %>%
  mutate(status = (!is.na(ended_at)) %>% as.integer) %>%
  select(-c(1:2))


# Can below snippet can help with the survey data?
survey2 <-
  survey %>%
  mutate(event = 
           (subscribed =='Subscribed to this brand/company in the past, but cancelled my subscription to this brand/company') %>% as.integer) %>%
  select(-subscribed) %>% 
  mutate(time = ifelse(is.na(`How long did you keep your subscription before you cancelled?`),
                       `How long ago did you begin your subscription?`,
                       `How long did you keep your subscription before you cancelled?`
  )) %>%
  select(-c(1:2)) %>%
  mutate(id = 1:nrow(.)) %>%
  group_by(id) %>%
  mutate(
    time = case_when(
      time == "Less than 5 months"     ~  runif(n = 1, min = 1, max = 150),
      time == "Between 5 and 6 months" ~  runif(n = 1, min = 150, max = 180), 
      time == "Between 6 and 7 months" ~  runif(n = 1, min = 180, max = 210),
      time == "Between 7 and 8 months" ~  runif(n = 1, min = 210, max = 240),
      time == "Between 8 and 9 months" ~  runif(n = 1, min = 240, max = 270),
      time == "Between 9 and 10 months" ~ runif(n = 1, min = 270, max = 300),
      time == "Between 10 and 11 months" ~runif(n = 1, min = 300, max = 330),
      time == "Between 11 and 12 months" ~runif(n = 1, min = 330, max = 365),
      time == "Between 1 and 2 years" ~   runif(n = 1, min = 365, max = 365*2),
      time == "Between 2 and 3 years" ~   runif(n = 1, min = 365*2, max = 365*3), 
      time == "Between 3 and 4 years" ~   runif(n = 1, min = 365*3, max = 365*4),
      time == "Between 4 and 5 years" ~   runif(n = 1, min = 365*4, max = 365*5)
    )
  ) %>% 
  select(-id)


# 1.2 Do every survey respondent can have different value of time?


# exercise 2 --------------------------------------------------------------

# Use survminer::ggsurvplot function to show survey and transactional data on one 
# survival plot, and the clinical data with risk set table on the other plot.

survey_transactional <-
  bind_rows(
        survey2 %>% ungroup %>% select(time, event) %>% mutate(source = 'survey'),
    transactional2 %>% select(time, event = status) %>% mutate(source = 'transactional')
  )

# 2.0 Bind survey and transactional data.
clinical_fit      <- survival::survfit(Surv(times, patient.vital_status) ~ 1, data = clinical)
transactional_fit <- survival::survfit(Surv(time, status)                ~ 1, data = transactional2)
survey_fit        <- survival::survfit(Surv(time, event)                 ~ 1, data = survey2)
gathered_fit      <- survival::survfit(Surv(time, event)                 ~ source, data = survey_transactional)

ggsurvplot(
  gathered_fit, 
  data = survey_transactional
)

ggsurv <- 
  ggsurvplot(
    gathered_fit, 
    data = survey_transactional, 
    size = 1,                 # change line size
    palette = 
      c("#E7B800", "#2E9FDF"),# custom color palettes
    conf.int = TRUE,          # Add confidence interval
    pval = TRUE,              # Add p-value
    risk.table = TRUE,        # Add risk table
    risk.table.col = "strata",# Risk table color by groups
    legend.labs =
      c("Survey", "Transactional"),    # Change legend labels
    risk.table.height = 0.25, # Useful to change when you have multiple groups
    ggtheme = theme_bw()      # Change ggplot2 theme
  )

# 2.1 Try setting `xlim` and `break.time.by` parameters to adjust the OX axis.

ggsurv2 <- 
  ggsurvplot(
    xlim = c(0, 500),
    break.time.by = 100,
    gathered_fit, 
    data = survey_transactional, 
    size = 1,                 # change line size
    palette = 
      c("#E7B800", "#2E9FDF"),# custom color palettes
    conf.int = TRUE,          # Add confidence interval
    pval = TRUE,              # Add p-value
    risk.table = TRUE,        # Add risk table
    risk.table.col = "strata",# Risk table color by groups
    legend.labs =
      c("Survey", "Transactional"),    # Change legend labels
    risk.table.height = 0.25, # Useful to change when you have multiple groups
    ggtheme = theme_bw()      # Change ggplot2 theme
  )


# 2.2 Remove censoring marks from the plot.

ggsurv3 <- 
  ggsurvplot(
    censor = FALSE,
    xlim = c(0, 500),
    break.time.by = 100,
    gathered_fit, 
    data = survey_transactional, 
    size = 1,                 # change line size
    palette = 
      c("#E7B800", "#2E9FDF"),# custom color palettes
    conf.int = TRUE,          # Add confidence interval
    pval = TRUE,              # Add p-value
    risk.table = TRUE,        # Add risk table
    risk.table.col = "strata",# Risk table color by groups
    legend.labs =
      c("Survey", "Transactional"),    # Change legend labels
    risk.table.height = 0.25, # Useful to change when you have multiple groups
    ggtheme = theme_bw()      # Change ggplot2 theme
  )

# 2.3 Is the plot more informative when having `median survival pointer` (surv.median.line = "hv")

ggsurv4 <- 
  ggsurvplot(
    surv.median.line = "hv",
    censor = FALSE,
    xlim = c(0, 500),
    break.time.by = 100,
    gathered_fit, 
    data = survey_transactional, 
    size = 1,                 # change line size
    palette = 
      c("#E7B800", "#2E9FDF"),# custom color palettes
    conf.int = TRUE,          # Add confidence interval
    pval = TRUE,              # Add p-value
    risk.table = TRUE,        # Add risk table
    risk.table.col = "strata",# Risk table color by groups
    legend.labs =
      c("Survey", "Transactional"),    # Change legend labels
    risk.table.height = 0.25, # Useful to change when you have multiple groups
    ggtheme = theme_bw()      # Change ggplot2 theme
  )

# 2.4 Let's remove text labels from risk set table legend and append them with colour bars

ggsurv5 <- 
  ggsurvplot(
    risk.table.y.text.col = T,# colour risk table text annotations.
    risk.table.y.text = FALSE,# show bars instead of names in text annotations
    surv.median.line = "hv",
    censor = FALSE,
    xlim = c(0, 500),
    break.time.by = 100,
    gathered_fit, 
    data = survey_transactional, 
    size = 1,                 # change line size
    palette = 
      c("#E7B800", "#2E9FDF"),# custom color palettes
    conf.int = TRUE,          # Add confidence interval
    pval = TRUE,              # Add p-value
    risk.table = TRUE,        # Add risk table
    risk.table.col = "strata",# Risk table color by groups
    legend.labs =
      c("Survey", "Transactional"),    # Change legend labels
    risk.table.height = 0.25, # Useful to change when you have multiple groups
    ggtheme = theme_bw()      # Change ggplot2 theme
  )

# risk.table.y.text.col = T,# colour risk table text annotations.
# # risk.table.height = 0.25, # the height of the risk table
# risk.table.y.text = FALSE,# show bars instead of names in text annotations

parameters <-
  list(
    risk.table.y.text.col = T,# colour risk table text annotations.
    risk.table.y.text = FALSE,# show bars instead of names in text annotations
    surv.median.line = "hv",
    censor = FALSE,
    xlim = c(0, 500),
    break.time.by = 100,
    gathered_fit, 
    data = survey_transactional, 
    size = 1,                 # change line size
    palette = 
      c("#E7B800", "#2E9FDF"),# custom color palettes
    conf.int = TRUE,          # Add confidence interval
    pval = TRUE,              # Add p-value
    risk.table = TRUE,        # Add risk table
    risk.table.col = "strata",# Risk table color by groups
    legend.labs =
      c("Survey", "Transactional"),    # Change legend labels
    risk.table.height = 0.25, # Useful to change when you have multiple groups
    ggtheme = theme_bw()      # Change ggplot2 theme
  )

do.call(ggsurvplot, parameters)

parameters[['pval']] <- FALSE
do.call(ggsurvplot, parameters)

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

clinical_fit      <- survival::survfit(Surv(times, patient.vital_status) ~ med_ABCD4,
                                       data = clinical %>% mutate(med_ABCD4 = ABCD4 > median(ABCD4, na.rm = T)))
ggsurvplot(clinical_fit)
# 5.3 Use survminer::surv_cutpoint and surv::surv_categorize to divide continuous variable with the maxstat method.

clinical_divided <-
  survminer::surv_cutpoint(data = clinical, 
                           time = "times",
                           event = "patient.vital_status", 
                           variables = "ABCD4") %>%
  surv_categorize()

clinical_divided_fit      <- survival::survfit(Surv(times, patient.vital_status) ~ ABCD4, data = clinical_divided)

# 5.4 Create your own code for the maxstat:
# a) cut continuous variable to, e.g., N pieces
# b) for each cutpoint calculate the logrank test (survival::survdiff)
# c) select the point that maximizes the statistic in the logrank test
