# BASED ON EXERCISES: 1 and 2
# 0. Load necessary libraries
library(survminer) # ggsurvplot
library(survival)  # Surv, survfit
library(foreign)   # read.dta
# 1. read data (description of the set is in /data/README.md)
surv_data <- read.dta("data/gbcs_short.dta")

# 2. plot survival curves for the categorical data (try pval = TRUE)

fit_general <- survfit(Surv(rectime, censrec) ~ 1,     data = surv_data)
fit_horm    <- survfit(Surv(rectime, censrec) ~ horm,  data = surv_data)
fit_meno    <- survfit(Surv(rectime, censrec) ~ meno,  data = surv_data)
# no curves for  size, since it's continuous variable
fit_grade   <- survfit(Surv(rectime, censrec) ~ grade, data = surv_data)
# no curves for nodes, since it's a continuous variable
fit_prog    <- survfit(Surv(rectime, censrec) ~ prog,  data = surv_data)
fit_estr    <- survfit(Surv(rectime, censrec) ~ estr,  data = surv_data)

ggsurvplot(fit_general,  risk.table = TRUE) # SMALL AMOUNT OF PATIENTS AFTER 2000 days
ggsurvplot(fit_general,  risk.table = TRUE, xlim = c(0, 2000), break.x.by = 250) 

ggsurvplot(fit_horm,  pval = TRUE) # curves do not cross, the pvalue states the are significantly different = ALL GOOD 
ggsurvplot(fit_meno,  pval = TRUE) # curves DO CROSS, assumption about the proportion of hazards within levels of this variables is not satisfied!
ggsurvplot(fit_grade, pval = TRUE, risk.table = TRUE) # curves do not cross, the pvalue states the are significantly different = ALL GOOD 
ggsurvplot(fit_prog,  pval = TRUE, risk.table = TRUE, xlim = c(0, 2000)) # curves do not cross, the pvalue states the are significantly different = ALL GOOD 
ggsurvplot(fit_estr,  pval = TRUE, risk.table = TRUE, xlim = c(0, 2000), break.x.by = 250) # curves do not cross, the pvalue states the are significantly different = ALL GOOD 

# 3. use ggcoxfunctional to verify the fuctional form of continuos variables

# before we fit the model, we need to find out the functional forms of continuous variables
ggcoxfunctional(coxph(Surv(rectime, censrec) ~ size + log(size) + sqrt(size), data = surv_data)) # THE MOST LINEAR SHAPE IS OBSERVED FOR THE LOG TRANSFORMATION
ggcoxfunctional(coxph(Surv(rectime, censrec) ~ nodes + log(nodes) + sqrt(nodes), data = surv_data)) # THE MOST LINEAR SHAPE IS OBSERVED FOR THE LOG TRANSFORMATION

# 4. fit the model
# NOTE: since the assumptions for meno are not satisfied we'll but that variable
# as a stratification variable, which means the model is fitted within levels of the
# variable and the the summary of models is provided as a final model.
# with this approach at least we've got the impact of the meno variable in the model,
# even though we will not get coefficients for this variable in the end.

model <- coxph(Surv(rectime, censrec) ~ strata(meno) + log(nodes) + log(size) + as.factor(grade) + horm + prog + estr, 
               data = surv_data)

# 5. use cox.zph to check the assumption of coefficients stability over the time
model_zph <- cox.zph(model, transform = "identity")
model_zph # p-values of schoenfeld test states there is no reason to say the assumption of coefficients stability over the time is not met - ALL GOOD

# 6. use ggcoxdiagnostics to plot the diagnostic plots (look out for outliers)

# there are many possible residuals that can be used to diagnose the model fit
# from the liner models theory we should observe the randomly distributed residuals
# for various observations, without any clear patern and without any extreme values (betweeen [-3,3] is fine)
ggcoxdiagnostics(model, type = 'deviance', linear.predictions = FALSE)

# 7. interpret the results

# all is good: the model is properly fit, 
# with the satisfied assumptions of
# a) proportional hazards
# b) proper functional form of continuous variables
# c) constant form of coefficients across the time
# so we can go to the summary to interpret the results.
summary(model)
# In the created model, statistically significant variables at the level of significance at 0.05 are:
# horm, prog, as.factor(grade)2, log(nodes). 
# The model coefficients for these variables are: $ -0.40, -0.67, 0.50, 0.47 $ respectively. 
# This means that if hormone therapy is used, the gambling hazard of death or recurrence is reduced to $ \ exp (-0.40) = 0.66 $ times against non-hormonal therapy (when all other variables are the same). 
# If the progesterone receptor ratio changes from negative to positive, then gambling will change by $ \ exp (-0.67) = 0.5 $ times, 
# whereas if the logarithm of lymph node metastases increases by 1, gambling will increase $ \ exp (0.47 ) = 1.61 $ times. 
# Change from grade (the degree of cancer cell differentiation (1-high, 2-mean) from 1 to 2 increases gambling $ \ exp (0.5) = 1.65 $ times, when all other variables remain at the same level.

# Likelihood, Wald and Score tests give p-value less than 0.05 (assumed significance level), 
# which indicates that we reject the null hypothesis in favor of the alternative hypothesis, 
# therefore the matched model is significantly better than the empty model.