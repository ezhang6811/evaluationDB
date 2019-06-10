# TODO - Fill out this documentation
* Brief overview of evaluation system and links to documentation
    + number of rating categories
    + year implemented 
    + consequences
    + components (value-added / observations)
* Description of data source and link
    + Data quality notes
    + Imputation notes

## Connecticut (to clean)
* Evaluation System Overview
    + Rating Categories
    + Years Implemented
    + Consequences
    + Components
* Data 
    + Source
    + Quality Notes
    + Imputation: 


## Florida
* Evaluation System Overview
    + Rating Categories
    + Years Implemented
    + Consequences
    + Components
* Data 
    + Source
    + Quality Notes
    + Imputation: No imputation, no suppression.

## Indiana
* Evaluation System Overview
    + Rating Categories
    + Years Implemented
    + Consequences
    + Components
* Data 
    + Source
    + Quality Notes
    + Imputation: There is no imputation, all results are suppressed for districts with less than 10 teachers. 

## Louisiana (to clean)
* Evaluation System Overview
    + Rating Categories
    + Years Implemented
    + Consequences
    + Components
* Data 
    + Source
    + Quality Notes
    + Imputation
    
## Massachussettes (to clean)
* Evaluation System Overview
    + Rating Categories
    + Years Implemented
    + Consequences
    + Components
* Data 
    + Source
    + Quality Notes
    + Imputation

## New Jersey
* Evaluation System Overview
    + Rating Categories
    + Years Implemented
    + Consequences
    + Components
* Data 
    + Source
    + Quality Notes
    + Imputation: suppresses the count in any rating category with <10 teachers, and the next lowest category, but reports the total number of teachers rated. I compare the reported total to the sum of the unsuppressed categories. If they match I replace nas with 0 and do not flag imputation. If only e1 and e2 are missing, I impute the difference between the reported total and the sum to e2.
    
## New York
* Evaluation System Overview
    + Rating Categories
    + Years Implemented
    + Consequences
    + Components
* Data 
    + Source
    + Quality Notes
    + Imputation: NY reports data at the anonymized teacher level with arbitrary teacher suppression. I aggregate to the teacher level with counts in each category and count suppressed. No imputation.

## North Carolina (to clean)
* Evaluation System Overview
    + Rating Categories
    + Years Implemented
    + Consequences
    + Components
* Data 
    + Source
    + Quality Notes
    + Imputation
    
## Ohio
* Evaluation System Overview
    + Rating Categories
    + Years Implemented
    + Consequences
    + Components
* Data 
    + Source
    + Quality Notes
    + Imputation: Ohio reports any categories with <3 teachers as <3, I impute zeros and flag the replacement. 
