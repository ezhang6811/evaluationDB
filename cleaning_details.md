# List of clean variables

## Identifiers

* state: two character state abbreviation
* year: 4 character spring year. e.g. 2012-2013 school year = 2013
* name: state used district name, all lower case
* localid: state used district id
* NCES_leaid (TODO)

## Evaluation
* e1: count of teachers receiving lowest rating  (typically ‘ineffective’)
* e2: count of teachers receiving second lowest rating (typically ‘developing’)
* e3: count of teachers receiving middle rating (typically ‘effective’)
* e4: count of teachers receiving highest rating (typically ‘highly effective’)
* eu: count of teachers district reports as unrated
* es: count of teachers with suppressed ratings
* et: total count of teachers reported by district
* e1_impute: indicator for imputed count 
* e2_impute: indicator for imputed count
* e3_impute: indicator for imputed count
* e4_impute: indicator for imputed count

# Data Imputation / Suppression
States have adopted various strategies to preserve the anonymity of teacher evaluation ratings. Some states arbitrarily suppress a fraction of ratings, others suppress all ratings in districts with less than 10 teachers, and others suppress ratings when fewer than n teachers are in that category. The _impute variables above are used to track when I have tried to fill in suppressed rating information. For more information about imputation see the state_details.md file.