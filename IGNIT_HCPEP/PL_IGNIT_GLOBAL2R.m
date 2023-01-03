function PL_IGNIT_ALL_PID_RAW
% Function to prepare the regression table for Linear Mixed-Effects Regression Model
% in R
% The metric variables are d here
%
% Fran Hancock
% Dec 2021
% fran.hancock@kcl.ac.uk
%
%
% Function to investigate the relationships between time varying measures
% of CHI OCC HC and PID and the random effect of RUN
% 
%
%%%%%%%
%
% Set up the paths to the functions, libraries etc
%
%
PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/IGNIT_HCPEP/';
SOURCE1_PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_CON/';
SOURCE2_PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_NAP/';

Smax=5;
Rmax=2;
% speed_state=input('Which speed state');
% metric_state=input('which metric state');
n_CON_subjects=53;
n_NAP_subjects=82;


PAR='AAL116';
Cmax=Smax-1;


 
GINT1=struct2array(load([PROJECT 'phase_synchronization_results_1.mat'],'integ'));
GINT2=struct2array(load([PROJECT 'phase_synchronization_results_2.mat'],'integ'));

GINT=cat(1,GINT1', GINT2');

SPAT1=struct2array(load([PROJECT 'phase_synchronization_results_1.mat'],'Q'));
SPAT2=struct2array(load([PROJECT 'phase_synchronization_results_2.mat'],'Q'));

SPAT=cat(1,SPAT1', SPAT2');

TVAR1=struct2array(load([PROJECT 'phase_synchronization_results_1.mat'],'meta'));
TVAR2=struct2array(load([PROJECT 'phase_synchronization_results_2.mat'],'meta'));

TVAR=cat(1,TVAR1', TVAR2');

VAR1=struct2array(load([SOURCE1_PROJECT '/RUN2/LEiDA_KOP_ALL_RUN2.mat'],'ICN_EV_ALL_MEAN'));
VAR2=struct2array(load([SOURCE2_PROJECT '/RUN2/LEiDA_KOP_ALL_RUN2.mat'],'ICN_EV_ALL_MEAN'));

VAR1=squeeze(VAR1(:,:,Cmax));
VAR2=squeeze(VAR2(:,:,Cmax));

MEAN_VAR1=mean(VAR1,2);
MEAN_VAR2=mean(VAR2,2);
VAR=cat(1,MEAN_VAR1, MEAN_VAR2);

TRANS1=struct2array(load([SOURCE1_PROJECT '/RUN2/LEiDA_KOP_ALL_RUN2.mat'],'TRANSITIONS'));
TRANS2=struct2array(load([SOURCE2_PROJECT '/RUN2/LEiDA_KOP_ALL_RUN2.mat'],'TRANSITIONS'));
TRANS=cat(2,TRANS1,TRANS2);

META1=struct2array(load([SOURCE1_PROJECT 'RUN2/LEiDA_KOP_ALL_RUN2'] ,'RSN_META_ALL'));
META1=squeeze(META1(:,:,Cmax));

META2=struct2array(load([SOURCE2_PROJECT 'RUN2/LEiDA_KOP_ALL_RUN2'] ,'RSN_META_ALL'));
META2=squeeze(META2(1:n_NAP_subjects,:,Cmax));

MEAN_META=mean(cat(1,META1,META2),2);

TRANS=reshape(TRANS',[],1);

RUN1=repmat('CON' ,n_CON_subjects,1);
RUN2=repmat('NAP' ,n_NAP_subjects,1);


RUN=cat(1,RUN1,RUN2);

SUB=[1:n_CON_subjects+n_NAP_subjects];

%
% Standardize the variables for each run
%

META=MEAN_META;



data_labels={ 'SUB','COND','GINT', 'FSEG','TVAR','META','VAR','TRANS'};
%
% Set up the regression table

regtable=table('Size',[(n_CON_subjects+n_NAP_subjects) numel(data_labels)],'VariableTypes',{'double','categorical','double','double','double','double','double','double'},'VariableNames',data_labels);
regtable.COND=RUN;
regtable.SUB = SUB';
regtable.GINT=GINT;
regtable.FSEG=SPAT;
regtable.TVAR=TVAR;
regtable.META=META;
regtable.VAR=VAR;
regtable.TRANS=TRANS;
%
% Save the regression table for processing in R
%
writetable(regtable,[PROJECT 'IGNIT_Regtable_RAW.csv'])
