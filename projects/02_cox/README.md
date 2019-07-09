# GBSCS

The `gbcs_short.dta` files contain data on 686 patients with breast cancer
operated and treated with chemotherapy. Some of the women also received hormone therapy.
The files contain the following variables:

```{r}
library(foreign)
surv_data <- read.dta("data/gbcs_short.dta")
```

- id - ID of the patient
- meno - menopausal index (1 - no, 2 - yes)
- horm - indicator of the use of hormone therapy (1 - no, 2 - yes)
- prog - indicator of progesterone receptors (0 - negative, 1 - positive)
- estr - estrogen receptor index (0 - negative, 1 - positive)
- grade - the degree of cancer cell differentiation (1-high, 2-medium, 3-low)
- size - tumor size (in cm)
- nodes - the number of lymph nodes with tumor metastases
- rectime - time of survival without relapse (days)
- censrec - event indicator (0 - censoring, 1- death or relapse)

We are interested in the question of which variables affect the survival time without recurrence of the disease?
Conduct an appropriate data analysis using the previously known methods of analysis
survival. If you use the proportional hazard model, rate the model fit to
data, fulfillment of relevant assumptions, etc. For the model considered as final, provide estimates
coefficients and their interpretation.
In the report (up to 5 A4 pages, including 1 page on syntax), use the syntax you need, and the necessary graphs
results and their interpretation.

# 1. read data
# 2. plots survival curves for the categorical data (try pval = TRUE)
# 3. fit the model
# 4. use ggcoxxph to check the assumption of coefficients stability over time
# 5. use ggcoxfunctional to verify the fuctional form of continuos variables
# 6. use ggcoxdiagnostics to plot the diagnostic plots (look out for outliers)
# 7. if all god with 4), 5) and 6) then interpret the results

# NOTE if for one of the vars the assumptions are not met, put it as a strata(var)
# into the formula
# coxph(Surv(time, event) + var1 + var2 + strata(var3) ...., data = )


# extra - RTCGA

One can also extend the `clinical` data creation prepared in `scripts/clinical_data_preparations.R` and fit the model for
a broader list of variables. Consider continuous variables with the binarized (`survminer::surv_cutpoint()`) and non-binarized (original) versions.