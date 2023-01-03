# Meta_Schz
Code and data for 'Metastability as a neuromechanistic marker for schizophrenia pathology'

The folder structure here just reflects what the code expects.

### Data: 
**Cobre** data is openly available from http://fcon_1000.projects.nitrc.org/indi/retro/cobre.html

**Human Connectome Project - Early Psychosis** data is restricted: NIMH Data Archive Digital Object Identifier (DOI) 10.15154/1528359. This manuscript reflects the views of the authors and may not reflect the opinions or views of the NIH or of the Submitters submitting original data to NDA.
A Data Use Certification (DUC) is required to access the HCPEP on the NIMH Data Archive (NDA).

**Human Connectome Project - Early Psychosis** - Derived Data for complete analysis

MATLAB files for parcellated data for all subjects in both datasets is available at 10.5281/zenodo.7464484.

### Code
Complete code is provided to run the analysis in the Cobre dataset

Derived data from the HCPEP dataset is provided to allow replication of the analysis and figures

## Code functionality in COBRA_COMPLEXITY_PHASE_FD

parcellate.m - parcellates pre-processed nifti files using AAL116 anatomical atlas

check_bedrosian.m - check for non-violation of the Bedrosian theorem

LEiDA_data.m - calculates instantaneous phase-locking and store the leading eigenvectors

LEiDA_cluster.m - clusters the leading eigenvectors with k-means into spatiotemporal modes

LEiDA_stats.m - calculates occurrence and duration of the spatiotemporal modes

Plot_repertoire_5_modes_reduced.m - plots the spatiotemporal modes as eigenvectors with regional contributions (corrected for order)

make_chord_plots_global.m - alternative plot to visualize the modes as connectographs

Phase_sync_metrics_reduced.s - compute Metastability and VAR

01_PERM_Global_META_and_VAR_COBRE.Rmd - permutation tests for global META and VAR

02_META_PERM_COBRE_MODES.Rmd - permutation tests for local META in the modes

03_VAR_PERM_COBRE_MODES.Rmd - permutation tests for local VAR in the modes

03_rain_clouds_META_VAR_DIST_COBRE_MODES.Rmd - plot rainclouds for META and VAR

04_COBRE_HCPEP_CONSCHZ_VAR_cat.Rmd - naive Bayes classifier for Cobre, and out-of-sample validation in HCPEP

## Data in COBRA_COMPLEXITY_PHASE_FD

Regtable_RAW.csv - derived data for analysis and figures for global measures

RUN1/Regtable_MODES_RAW.csv - derived data for analysis and figures for local measures for CON

RUN2/Regtable_MODES_RAW.csv - derived data for analysis and figures for local measures for SCHZ

### SUPPLIED FILES

Additional files that are needed for the figures

## Code functionality in HCPEP_COMPARE

get_subject_eigs_with_reorder.m - compute subject eigenvectors for each mode. Used to calculate contribution of basal ganglia regions

sc_stats_for_R.m - calculate contribution of basal ganglia regions

04_ART_CONTRIBUTIONS_HCPEP_SC.Rmd - non-parametric ANOVA - ART for sub-cortical (basal ganglia) regions

04_Rainclouds_CONTRIBUTIONS_HCPEP_SC.Rmd - plot rainclouds for basal ganglia contributions

02_ART_HCPEP_Global_META_and_VAR.Rmd - Statistics for global META and VAR

03_META_ART_CON_NAP_HCPEP_MODES.Rmd - Statistics for mode META

05_VAR_ART_CON_NAP_HCPEP_MODES.Rmd - Statistics for mode VAR

03_Rain_clouds_Modes_META_VAR_DIST_CON_NAP_HCPEP.Rmd - plot rainclouds for statistics

08_Demographics_age_sex

### Classifiers

07_HCPEP_CON_NAP_VAR_cat.Rmd

08_HCPEP_CON_NAP_META_cat.Rmd

07_HCPEP_CON_NAP_VAR_cat_UP.Rmd - upsampled

07_HCPEP_CON_NAP_VAR_SVM_cat.Rmd - SVM

07_HCPEP_CON_NAP_VAR_LR_cat.Rmd - Logistic regression

07_HCPEP_CON_NAP_VAR_cat_NM.Rmd - NeuroMark template

07_HCPEP_CON_NAP_VAR_cat_IV.Rmd - Internal validation


## Data in HCPEP_COMPARE

SC_coupling.csv - derived data for analysis and figures for basal ganglia contribution

## Data in HCPEP_CON and HCPEP_NAP

Regtable_RAW.csv - derived data for analysis and figures for global measures

Regtable_MODES_RAW.csv - derived data for analysis and figures for local measures

## Data and code functionality in IGNIT_HCPEP / IGNIT_COBRE for measures of Integration, Segmentation, and Metastability Index

PL_ignition_metrics.m

PL_IGNIT_GLOBAL2R.m

IGNIT_Regtable_RAW.csv

01_PERM_Global_IGNIT_HCPEP.rmd

01_PERM_Global_IGNIT_HCPEP_META.rmd

## Data and code functionality in HCPEP_CON_NM /HCPEP_NAP_NM /COBRE_NM for NeuroMark template

NM_ICN.mat - Brain regions assignment to NM 

Phase_sync_metrics.m - calcaule META and VAR

LMER_MODES2R.Rmd - export for r

### Derived data to run the classifiers in HCPEP_COMPARE

#### For HCPEP
Regtable_MODES_RAW.csv

#### For Cobre
RUN1/Regtable_MODES_RAW.csv  

RUN2/Regtable_MODES_RAW.csv


