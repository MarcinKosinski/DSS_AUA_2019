# Pharynx

The "pharynx.csv" file contains data on 195 throat oral cancer patients enrolled in
a clinical trial comparing the survival time of patients treated with radiotherapy or radiotherapy and chemotherapy. 
The file contains the following variables:

- CASE ID of the patient
- INST identifier of the institution
- SEX sex
    * 1 = male, 
    * 2 = female
- TX treatment
    * 1 = radiotherapy, 
    * 2 = radiotherapy and chemotherapy
- GRADE the degree of cancer differentiation
    * 1 = high, 
    * 2 = medium, 3 = low, 
    * 9 = no data
- AGE age (in years) at the time of diagnosis
- COND patient's fitness level
    * 1 = unlimited, 
    * 2 = limited at work, 
    * 3 = requires partial care, 
    * 4 = requires total care (100% time in bed), 
    * 9 = no data
- SITE tumor location
    * 1 = palatal arch,
    * 2 = tonsil, 
    * 3 = palatal-pharyngeal muscle,
    * 4 = tongue base, 
    * 5 = back wall
- T_STAGE tumor size
    * 1 = 2 cm or less, 
    * 2 = 2-4 cm, 
    * 3 = greater than 4 cm, 
    * 4 = massive tumor with infiltration of surrounding tissues
- N_STAGE metastases to lymph nodes
    * 0 = no metastases, 
    * 1 = one occupied node less than 3 cm, mobile
    * 2 = one busy node larger than 3 cm, mobile, 
    * 3 = several occupied and / or fixed nodes
- STATUS event indicator
    * 0 = live, 
    * 1 = died
TIME survival time in days from the date of diagnosis

We are interested in the impact of treatment on the survival time of patients. 
Perform adequate data analysis. If you use models, rate their adjustment to the data,
meeting the relevant assumptions, etc. In the report (up to 4 pages A4 + 1 page on syntax) enter used syntax, necessary graphs and results and their interpretation.

1. Prove that Cox proportional hazards model is not the best model in this case.
2. Try adding INST as a cluster variable to the cox model (add + cluster(INST) to the model formula) to verify whether this variable indicate observations' correlation within the institution.
3. Try running Accelerated Failure Time model.
0. Remmber to change variables to factors.
