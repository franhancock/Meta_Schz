# Meta_Schz
Code and data for 'Metastability as a neuromechanistic marker for schizophrenia pathology'

The folder structure here just reflects what the code expects.

### Data: 
**Cobre** data is openly available from http://fcon_1000.projects.nitrc.org/indi/retro/cobre.html

**Human Connectome Project - Early Psychosis** data is restricted  doi:10.15154/1524263 https://nda.nih.gov/edit_collection.html?id=2914).  A Data Use Certification (DUC) is required to access the HCPEP on the NIMH Data Archive (NDA).

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

## Data in HCPEP_COMPARE

SC_coupling.csv - derived data for analysis and figures for basal ganglia contribution

## Data in HCPEP_CON and HCPEP_NAP

Regtable_RAW.csv - derived data for analysis and figures for global measures

Regtable_MODES_RAW.csv - derived data for analysis and figures for local measures



