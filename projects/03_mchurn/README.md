# Cadences

Subscription based data

```{R}
cadence <- readRDS('data/cadence.rds')
library(dplyr)
# check out the amount of people that never changed the subscription plan
# check out the amount of people that ever changed the subscription
# check out the amount of people that changed subscriptions more than once
cadence %>% count(user_id) %>% ungroup %>% count(n) %>% arrange(desc(nn))
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


For the following dataset consider multi-state analyses

- start 
    * -> moving to a higher cadence 
    * -> churn/censroing
- start 
    * -> moving to a lower cadence 
    * -> churn/censroing
- start 
    * -> moving to any other cadence once 
    * -> moving to any other cadence twice 
    * -> moving to any other cadence 3 times 
    * -> moving to any other cadence 4 times 
    * -> moving to any other cadence 5 times 
    * -> churn/censoring

> You might cut those customers that have changed subcription > 5 times

1. Prepare the data for mstate model
2. Fit the mstate model without covariates
3. Fit the mstate model with covariates
4. Plot the distribution of being in a state after a specific period of time, starting from `start` state
5. For 3. present the coefficients comparison
6. For 3. compare various clients on their life-time predictions
