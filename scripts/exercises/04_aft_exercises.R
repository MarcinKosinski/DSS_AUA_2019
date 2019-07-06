# In order to check what factors have a statistically significant impact on time to an event which is death 
# when analyzing breast cancer data, it was proposed to check if parametric models assuming the form of time 
# distribution to the event are adequate in a given medical problem.

library(foreign)
gbsc <- read.dta("data/gbcs_short.dta")
library(survival)
library(flexsurv)
library(rms)

# AFT MODELS

# Checking the parametric form for the AFT model, 
# it was decided to choose a distribution from a rich family of generalized F distributions. 
# We used the `flexsurv` package to match the Weibull, Log-logistic, Log-normal, 
# Generalized Gamma and Generalized F.

AFT.GG      <- flexsurvreg(Surv(rectime,censrec)~horm+prog+estr+as.factor(grade)+meno+size+nodes, 
                           data = gbsc, dist="gengamma")
AFT.GF      <- flexsurvreg(Surv(rectime,censrec)~horm+prog+estr+as.factor(grade)+meno+size+nodes, 
                           data = gbsc, dist="genf")
AFT.LL      <- flexsurvreg(Surv(rectime,censrec)~horm+prog+estr+as.factor(grade)+meno+size+nodes, 
                           data = gbsc, dist="genf", inits=c(3,0.2,0,1,0,0,0,0,0,0,0,0), 
                      fixedpars = c(3,4))
AFT.Weibull <- flexsurvreg(Surv(rectime,censrec)~horm+prog+estr+as.factor(grade)+meno+size+nodes, 
                           data = gbsc, dist="weibull")
AFT.LN      <- flexsurvreg(Surv(rectime,censrec)~horm+prog+estr+as.factor(grade)+meno+size+nodes, 
                           data = gbsc, dist="lnorm")

# In order to assess which model is adequate and sufficient, likelihood ratio tests were performed as below.

# Logarithm values of the reliability function of the analyzed models:

matrix( c(AFT.GG$loglik,                # loglik generalized G 
          AFT.GF$loglik,                # loglik generalized F
          AFT.LL$loglik,                # logik log-logistic
          AFT.Weibull$loglik,           # logik Weibull
          AFT.LN$loglik), ncol=1) ->logliks # logik log-normal

rownames(logliks) <- c("Gen Gamma", "Gen F", "Log-logistic", "Weibull", "Log-normal")
colnames(logliks) <- "loglik"
#p-values of tests:
matrix(round(c(1-pchisq(2*(AFT.GF$loglik-AFT.GG$loglik),2),
               1-pchisq(2*(AFT.GG$loglik-AFT.LL$loglik),2),
               1-pchisq(2*(AFT.GG$loglik-AFT.Weibull$loglik),2), 
               1-pchisq(2*(AFT.GG$loglik-AFT.LN$loglik),2)), digits=4), ncol=1) -> comparisons
rownames(comparisons) <- c("GF vs GG", "GG vs LL", "GG vs Wei", "GG vs LN")
colnames(comparisons) <- "p-value"

# Testing the possibility of using a given distribution, first a test for generalized gamma and generalized F was performed. 
# It was found at the significance level alpha = 0.05, after Bonferroni correction including 4 tests, i.e. 
# at the significance level for a single test equal to $ alpha_i = 0.0125, i = 1,2,3,4 $, 
# that there are no reasonss for rejecting the null hypothesis in the test that the from smaller family of generalized gamma distributions
# is correct in comparison to the model from a larger family of generalized F distributions Next, 
# for the distribution from the generalized family of gamma distributions, 
# 3 tests were carried out to check if the models from the smaller family (log-normal, log-logistic, Weibull) 
# are proper in comparison to the distribution from the generalized family of gamma distributions. 
# Only in the case of a log-normal distribution there is no basis for to reject the hypothesis 
# that this distribution is appropriate in the comparison of to distribution from a wider 
# family of generalized gamma distributions. For the logistic and Weibull distribution, 
# the null hypothesis was rejected that these distributions are correct in relation to the 
# distribution from a wider family of generalized gamma distributions.

# Therefore, in the further part of the report, we check the matching of the log-normal model.

logNorx1 <- psm(Surv(rectime,censrec)~horm+prog+estr+as.factor(grade)+meno+size+nodes, 
                data = gbsc, dist = "lognormal") 

# In the next step, it was verified whether the rest of the model behaves like a censored sample from a log-normal distribution.
# It can be seen from the graph that there are no visible deviations between the curves, which may indicate a good model fit. 
# The parametric assumption that the rest comes from a log-normal distribution seems to be fulfilled

res.LogN1 <- resid(logNorx1,type="cens")
survplot(npsurv(res.LogN1 ~1),conf="none",ylab="Survival probability", xlab="Residual")
lines(res.LogN1)

# The variables important in the model are `horm`,` prog`, both levels of the `grade` variable relative to the reference level and` nodes`.
# The model coefficients for these variables are 0.3339, 0.4995, -0.4396, -0.4780, -0.0483, respectively. 
# This means that the time to relapse by hormone therapy is longer $ e ^ {0.3339} = 1.4 $ 
# once compared to the situation when hormonal therapy is not used, assuming the stability of the other variables. 
# The time to relapse with a positive progesterone index is longer $ e ^ {0.4995} = 1.6 $ 
# once compared to when the patient has a negative progesterone level indicator, assuming the stability of the other variables. 
# Time to recurrence of the disease with an average degree of tumor cell differentiation is shorter than $ e ^ {- 0.4396} = 0.64 $ 
# once compared to a situation where the patient has a high degree of cancer cell differentiation, assuming the stability of the other variables. 
# However, when the patient has a low degree of tumor differentiation, the time to relapse is shorter than $ e ^ {- 0.4780} = 0.62 $ 
# when compared to when the patient has a high degree of cancer cell differentiation, assuming the stability of the other variables. 
# The time to recurrence of the disease with the increase in the number of lymph nodes with tumor metastasis 
# by one is shorter $ e ^ {- 0.0483} = 0.95 $ once, assuming the stability of the other variables.

logNorx1