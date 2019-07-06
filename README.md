# Introduction to Survival Analysis with Use Cases

> Workshop during [Data Science Summer School](https://dssummer.aua.am/) at Akian College of Science & Engineering

During the lecture I'm more than excited to walk participants through basics and definitions of survival analysis. We will walk step by step by the most crucial parts of the data analysis procedure in the scenario of time-dependent data and areas of censored information. There will be a place to learn diagnostic plots used in the formulation and verification of cox proportional hazards model, which is the most know procedure applied to churn analytics. If there is a time, we can consider model for multi-state nature of the survival analysis.

- **Tools:** R, RStudio
- **Necessary skills to participate in the course:** basic idea of R usage and basic knowledge about linear models (like linear regression)
- **Instructor:** Marcin Kosinski, Poland, Statistician at [Gradient Metrics LLC](https://www.gradientmetrics.com/)

# Exercises

- Part 1 - Survival Curves
    * What are the potential sources of survival data
        * How to prepare data for survival analysis?
          * Clinical data
          * Transacional data
          * Survey data
        * What the censoring means and what issues it creates?
    * Understand the logic under survival curves, risk set tables and the Kaplan-Meier estimates
        * Calculate Kaplan-Meier estimates of survival function on your own
    * Learn about Log-rank test
    * Get familiar with techniques used to dichotomize continuous data in survival plots
        * Based on maxstat (maximally selected statistics) and Log-rank test write the
    binarization process on your own
- Part 2 - Cox Proportional Hazards Model (for 1 event)
    * What's a Cox model?
    * What are the assumptions?
    * How to prepare the data?
    * How to verify model assumptions?
    * What's stratification?
    * How to fit the model?
    * How to understand model results?
    * How to make predictions based on the model?
    * How to diagnose the model's goodness of fit?
- Part 3 - Multi-state Cox Proportional Hazards Model (n events)
    * Situations with more than 1 event
    * Techniques to build risk set tables
    * Techniques to handle censoring
    * Functions to run model for multi-state scenario
- Part 4 - When Cox assumptions are not met
    * Accelerated Failure Time models
  
# Projects

- [Survival curves](https://github.com/MarcinKosinski/DSS_AUA_2019/tree/master/projects/01_curves)
- [Cox Proportional Hazards Model](https://github.com/MarcinKosinski/DSS_AUA_2019/tree/master/projects/02_cox)
- [Multi-state Cox model](https://github.com/MarcinKosinski/DSS_AUA_2019/tree/master/projects/03_mchurn)
- [Parametric models (AFT) case](https://github.com/MarcinKosinski/DSS_AUA_2019/tree/master/projects/04_aft)

# Extra materials

- survminer
    * During classes we will extensively use [survminer](https://github.com/MarcinKosinski/DSS_AUA_2019/tree/master/extra_materials/survminer) package, that contains tools to perform survival analysis and create diagnostic plots, including survival curves. 
- RTCGA
    * Clinical data used during classes (next to other data sources) comes from the *The Cancer Genome Atlas* (TCGA) project, which is broadly described in [RTCGA](https://github.com/MarcinKosinski/DSS_AUA_2019/tree/master/extra_materials/RTCGA) directory.
- data
    * Other data sources are described in the [data](https://github.com/MarcinKosinski/DSS_AUA_2019/tree/master/data) folder.

![](extra_materials/photos/city.JPG)
