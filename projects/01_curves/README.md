# World datasets

Find an intersting dataset containing survival data and prepare the most complex survival plot with the usage of 
`survminer::ggsurvplot()`. 


# extra - RTCGA

One can also extend the `clinical` data creation prepared in `scripts/clinical_data_preparations.R` and fit survival curves for
a broader list of variables. Consider continuous variables with the binarized (`survminer::surv_cutpoint()`) and non-binarized (original) versions.