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
- ensrec - event indicator (0 - censoring, 1- death or relapse)

# Clinical

```{R}
survey <- readRDS('data/clinical.rds')
```

The RTCGA data with gathered clinical information about patients suffering from: Breast Cancer or Head&Neck Canser.
The clinical data is joined with rnaseq (genes' expressions) data. Overall the data.frame contains:

- times - time in days under which the patient was under the observation
- bcr_patient_barcode - the BCR code used to join data within multiple sources
- patient.vital_status - patient vital status (0 - alive, 1 - dead)
- histological_type - the histological type of the cancer
- country - the country of the residence of the patient
- gender - the gender of the patient
- cohort - whether patient suffer from BRCA (Breast Cancer) or HNSC (Head&Neck Cancer)
- ABDC4 - ABDC4 gene expression
- ARL16 - ARL16 gene expression
- TP53INP1 - TP53INP1 gene expression

# Survey

```{R}
survey <- readRDS('data/survey.rds')
```

The dataset collected during the survey. Customers of the online retailers were
asked to remind themselves for how long they were the subscription-based customers
for the online retailer.

- subscribed - whether a customer is an active subscriber of the subscription
- `How long did you keep your subscription before you cancelled?` the life-time of the subscription
- `How long ago did you begin your subscription?` the start point of the subscription for active customers

# Transactional

```{R}
transactional <- readRDS('data/transactional.rds')
```

The dataset extracted from the online retailer database.

- free_trial_started_at - the date on which the free trial started
- ended_at - the date at which the patient resigned from the shop
- paid_order_count - the amount of orders that a customer paid for during his life-cycle
- gender - the registered gender of the customer

# Mstate data

Online retailer database snapshot. Subscription based products.

```{r}
msdata <- readRDS('data/msdata.rda')
```

- id  - id of the customer
- st2 - state 2 time of entering
- st2.s - state 2 status    
- st3 - state 3 time of entering
- st3.s - state 3 status
- st4 - state 4 time of entering
- st4.s - state 4 status
- st5 - state 5 time of entering
- st5.s - state 5 status
- year - year of registration at the online retailer
- age - age buckets of the customer
- discount - whether ever a customer got a discount 
- gender - the registered gender of the customer

# Cadences

Subscription based data

```{R}
cadence <- readRDS('data/cadence.rds')
```

Online retailer selling shaving products. One could start the subscrpition that
had cadence of length 30, 60, 90, 120 or 180 days. 

- user_id - the id of the customer
- timestamp - the date of a specific event
- state - to which state the customer moved
- notes - notes about the state
- basket_addition_or_update - the number of basket additions or updates between the last and this state
- basket_removal - the number of basket removal between the last and this state
- cadence_delayed - the number of cadence delays between the last and this state
- first_opened - the number of e-mails opened between the last and this state
- order - the number of e-mails opened between the last and this state
- one_time_additions - the number of one time additions between the last and this state
- gender - the registered gender of the customer
- channel - the channel during which the customer entered the subscription
- starting_cadence - the length of the subscription cadence at start
- starting_basket - the basket for the initial subscription

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

