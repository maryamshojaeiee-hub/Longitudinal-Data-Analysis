# Longitudinal Data Analysis: Alzheimer's Disease Progression
Analysis of a longitudinal cohort of 1,253 Alzheimer's patients followed annually over six years, completed as a series of three projects for the Longitudinal Data Analysis course (Master of Statistics, 2025–2026).

The projects follow one dataset through three stages: modelling a continuous outcome, modelling a binary outcome, and handling missing data from patient dropout.

This was a group project for the Longitudinal Data Analysis course at Hasselt University (2025–2026). 

# The data
Patients from multiple clinical centers were included at first diagnosis of Alzheimer's disease and measured at baseline and once a year for six years (7 time points)

| Type | Variables |
|---|---|
| Repeated outcomes | **BPRS** (Brief Psychiatric Rating Scale), **CDR-SB** (Clinical Dementia Rating, Sum of Boxes), ABPET and TAUPET (PET biomarkers) |
| Baseline covariates | age, sex, education, BMI, paid job, activities of daily living (ADL), nursing home residence |

Only 40.8% of patients remained in the study until year 6, so dropout is a central theme throughout.

The dataset is not included in this repository, as it was provided as course material.

## Repository structure

```
├── 01-continuous-outcomes/
│   ├── report.pdf
│   └── code/
├── 02-binary-outcomes/
│   ├── report.pdf
│   └── code/
└── 03-missing-data/
    ├── report.pdf
    └── code/
```

# 1. Continuous outcomes: how does BPRS evolve over time?
Question: How does BPRS change over time, and how is it related to baseline patient characteristics?

# Methods
1. Exploratory analysis of the mean, variance and correlation structure (individual profiles, smoothed variance function, semi-variogram, scatter plot matrix)
2. Summary statistics (AUC, endpoint, increment) with ANCOVA
3. Multivariate model with unstructured covariance, reduced by likelihood ratio tests
4. Two-stage analysis, with an F-meta test for linear vs. quadratic subject-specific trends
5. Linear mixed model with random intercepts and slopes; empirical Bayes estimates compared with two-stage OLS estimates

# 2. Binary outcomes: what predicts advanced dementia?
Question: Do ADL, ABPET and TAUPET affect the probability of advanced dementia (CDR-SB > 10) over time, after correcting for sex, age and BMI?

# Methods
1. Marginal model: GEE with AR(1) and unstructured working correlations, comparing robust and model-based standard errors
2. Random-effects model: logistic GLMM with random intercepts and slopes, fitted with adaptive Gaussian quadrature (checked for stability across 3–20 quadrature points)
3. Empirical Bayes predictions of the random effects

# 3. Missing data: does dropout change the conclusions?
Question: Is dropout informative, and are the earlier conclusions robust to it?

# Methods
1. Exploration of missingness patterns (all dropout was monotone) and of profiles by dropout time
2. Linear mixed model and GLMM (likelihood-based, valid under MAR)
3. Weighted GEE (inverse probability weighting) and multiple imputation followed by GEE (MI-GEE)
4. Sensitivity analysis for MNAR using pattern-mixture models with ACMV, CCMV and NCMV identifying restrictions, implemented through multiple imputation

Tools
SAS: PROC MIXED, GENMOD, GEE, NLMIXED, MI, MIANALYZE
R: tidyverse (two-stage analysis, F-meta test, figures)

Main references
1. Verbeke, G. & Molenberghs, G. (2009). Linear Mixed Models for Longitudinal Data (2nd ed.). Springer.
2. Molenberghs, G. & Verbeke, G. (2005). Models for Discrete Longitudinal Data. Springer.
3. Little, R. J. A. & Rubin, D. B. (1987). Statistical Analysis with Missing Data. Wiley.
