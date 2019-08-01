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
        - Available 2013-14 through 2017-18
    + Consequences
    + Components
* Data 
    + Source
    + Quality Notes
        - Data provided only as percents, no counts of teachers
        - Final score and component sub scores
        - School level also available (not cleaned)
    + Imputation
        - Suppression when less than 1%, but can impute suppressed category using 1 - sum(other categories)
        - p1 and p2 imputed in this manner
    
## Massachussettes
* Evaluation System Overview
    + Rating Categories
    + Years Implemented
        - Available 2012-13 through 2016-17
    + Consequences
    + Components
* Data 
    + Source
    + Quality Notes: 
        - Only final evaluation scores are available, there are no sub scores. 
        - There are three different codings for missing values.
            - NA: no data is available for this district beyond the ID and name. Currently assuming this means the district was not required or did not implement evaluations. 
            - NI: There is a total count of teachers, but no actual evaluation numbers. Currently assuming this means the district was supposed to implement evaluations but either did not do so, or did not report results back to the state. 
            - '-': There is a count of teachers to be evaluated, as well as the number that were evaluated, but all actual evaluation numbers are replaced with '-'. Currently assuming that this coding is for cases where districts did implement evaluations and report the results to the state, but that the results were suppressed to protect teacher privacy.
    + Imputation: no imputation was done. 

## Michigan (to clean)
* Brief overview of evaluation system and links to documentation
    + number of rating categories
    + year implemented 
        - available 2011-12 through 2016-17
    + consequences
    + components (value-added / observations)
* Description of data source and link
    + Raw data is in poor shape. Why would you differentiate schools from districts by using tabs at the start of the entry??? Seem to have files for individual years and aggregated files. Need to look for source documentation. 
    + Imputation notes

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
        - available 2011 through 2017
    + Consequences
    + Components
* Data 
    + Source
    + Quality Notes
        - Need to find documentation. File is not intuitive. Seems to be standard by school by evaluation percentages. No counts available that I can see. 
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
