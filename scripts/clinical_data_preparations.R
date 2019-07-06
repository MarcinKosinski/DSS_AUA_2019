# clinical data preparations ----------------------------------------------

library(dplyr) # pipes (%>%) and dplyr data munging
# installation
# source("https://bioconductor.org/biocLite.R")
# biocLite("RTCGA.clinical")
# biocLite("RTCGA.rnaseq")
library(RTCGA.clinical) # survival times
library(RTCGA.rnaseq) # genes' expression


BRCA_HNSC.surv_raw <- 
  survivalTCGA(BRCA.clinical, 
               HNSC.clinical,
               extract.cols = 
                 c('patient.clinical_cqcf.histological_type', 
                   'patient.clinical_cqcf.country',
                   'patient.gender')
               ) %>%
    filter(times > 0)

BRCA_HNSC.surv <-
  BRCA_HNSC.surv_raw %>%
  rename(gender = patient.gender,
         country = patient.clinical_cqcf.country,
         histological_type = patient.clinical_cqcf.histological_type) %>%
  mutate(country = ifelse(is.na(country), 'unknown', country)) %>%
  mutate(country = case_when(
    # country == NA_character_ ~ 'unknown',
    !(country %in% c('unknown', 'germany', 'poland', 'vietnam', 'united states')) ~ 'other',
    TRUE ~ country
  )) %>%
  mutate(histological_type = case_when(
    histological_type %in% c('head and neck squamous cell carcinoma', 
                             'infiltrating ductal carcinoma',
                             'infiltrating lobular carcinoma') ~ histological_type,
    TRUE ~ 'other'
  ))

BRCA_HNSC.rnaseq <- 
  expressionsTCGA(
    BRCA.rnaseq, HNSC.rnaseq,
    extract.cols = c("ABCD4|5826", "ARL16|339231", "TP53INP1|94241")) %>%
    rename(cohort = dataset,
           ABCD4 = `ABCD4|5826`,
           ARL16 = `ARL16|339231`,
           TP53INP1 = `TP53INP1|94241`) %>%
    filter(substr(bcr_patient_barcode, 14, 15) == "01") %>% 
    # only cancer samples
    mutate(bcr_patient_barcode = 
             substr(bcr_patient_barcode, 1, 12))

BRCA_HNSC.surv %>%
  left_join(BRCA_HNSC.rnaseq,
            by = "bcr_patient_barcode") ->
  BRCA_HNSC.surv_rnaseq

saveRDS(BRCA_HNSC.surv_rnaseq, file = 'data/clinical.rds')

# transactional -----------------------------------------------------------


