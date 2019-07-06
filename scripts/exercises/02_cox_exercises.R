######################################## Part 2 #####################################


# exercise 6 --------------------------------------------------------------

# The Cox proportional hazards model makes several assumptions. 
# Thus, it is important to assess whether a fitted Cox regression model adequately describes the data.

# Here, we’ll disscuss three types of diagonostics for the Cox model:
# - Testing the proportional hazards assumption.
# - Examining influential observations (or outliers).
# - Detecting nonlinearity in relationship between the log hazard and the covariates.
# In order to check these model assumptions, Residuals method are used. The common residuals for the Cox model include:
# - Schoenfeld residuals to check the proportional hazards assumption
# - Martingale residual to assess nonlinearity
# - Deviance residual (symmetric transformation of the Martinguale residuals), to examine influential observations

# 6.1 Go over the cox ph diagnostics code.

library("survival")
res.cox <- coxph(Surv(time, status) ~ age + sex + wt.loss, data =  lung)
res.cox

#### The proportional hazards (PH) assumption can be checked using statistical 
# tests and graphical diagnostics based on the scaled Schoenfeld residuals.
test.ph <- cox.zph(res.cox)
test.ph

ggcoxzph(test.ph)
# In principle, the Schoenfeld residuals are independent of time. 
# A plot that shows a non-random pattern against time is evidence of violation of the PH assumption.

#### Testing influential observations
# To test influential observations or outliers, we can visualize either:
# - the deviance residuals or
# - the dfbeta values
ggcoxdiagnostics(fit, type = , linear.predictions = TRUE)
# linear.predictions: a logical value indicating whether to show linear predictions for observations (TRUE)
# or just indexed of observations (FALSE) on X axis.

ggcoxdiagnostics(res.cox, type = "dfbeta",
                 linear.predictions = FALSE, ggtheme = theme_bw())
# The above index plots show that comparing the magnitudes of the largest dfbeta values 
# to the regression coefficients suggests that none of the observations is terribly 
# influential individually, even though some of the dfbeta values for age and wt.loss
# are large compared with the others.

#### Testing non linearity
# Often, we assume that continuous covariates have a linear form. However, this assumption should be checked
ggcoxfunctional(Surv(time, status) ~ age + log(age) + sqrt(age), data = lung)


# exercise 7 --------------------------------------------------------------

# 7.1 Based on the diagnostic for example `lung` datasets, provide diagnostic 
# of cox model assumptions for survey+transactional and clinical datasets.


# exercise 8 --------------------------------------------------------------

# Plot the baseline survival function
ggsurvplot(survfit(res.cox), color = "#2E9FDF", ggtheme = theme_minimal())
# Having fit a Cox model to the data, it’s possible to visualize the predicted survival
# proportion at any given point in time for a particular risk group. 
# The function survfit() estimates the survival proportion, by default at the mean values of covariates.


# What about survey+transactional and clinical datasets.

# exercise 9 --------------------------------------------------------------

# Based on the predict code for the lung example, create the predict for survey+transactional and clinical datasets.
# Create the new data  
sex_df <- with(lung,
               data.frame(sex = c(1, 2), 
                          age = rep(mean(age, na.rm = TRUE), 2),
                          ph.ecog = c(1, 1)
               )
)
sex_df
# Survival curves
fit <- survfit(res.cox, newdata = sex_df)
ggsurvplot(fit, conf.int = TRUE, legend.labs=c("Sex=1", "Sex=2"), ggtheme = theme_minimal())



# exercise 10 --------------------------------------------------------------

# Fit complex survival curves

fit2 <- survfit( Surv(time, status) ~ sex + rx + adhere, data = colon )
ggsurv <- ggsurvplot(fit2, fun = "event", conf.int = TRUE, ggtheme = theme_bw())

ggsurv$plot + 
  theme_bw() + 
  theme (legend.position = "right")+
  facet_grid(rx ~ adhere)

# Based on the above code, prepare the same splits for survey+transactional and clinical datasets.


# exercise 11 -------------------------------------------------------------

# After fitting the model describe which drivers are driving the hazard ratio
# and which are reducing the hazard ratio?
