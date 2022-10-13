function LMER_ALL_PID_RAW_reduced
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
PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/COBRA_COMPLEXITY_PHASE_FD/';

Smax=5;
Rmax=2;
% speed_state=input('Which speed state');
% metric_state=input('which metric state');
n_CON_subjects=71;
n_NAP_subjects=59;


PAR='AAL116';
Cmax=Smax-1;

VAR1=struct2array(load([PROJECT '/RUN1/LEiDA_KOP_ALL_RUN1.mat'],'ICN_EV_ALL_MEAN'));
VAR2=struct2array(load([PROJECT '/RUN2/LEiDA_KOP_ALL_RUN2.mat'],'ICN_EV_ALL_MEAN'));

VAR1=squeeze(VAR1(:,:,Cmax));
VAR2=squeeze(VAR2(:,:,Cmax));

MEAN_VAR1=mean(VAR1,2);
MEAN_VAR2=mean(VAR2,2);

VAR=cat(1,MEAN_VAR1, MEAN_VAR2);

TRANS1=struct2array(load([PROJECT '/RUN1/LEiDA_KOP_ALL_RUN1.mat'],'TRANSITIONS'));
TRANS2=struct2array(load([PROJECT '/RUN2/LEiDA_KOP_ALL_RUN2.mat'],'TRANSITIONS'));

TRANS=cat(2,TRANS1,TRANS2);


META1=struct2array(load([PROJECT 'RUN1/LEiDA_KOP_ALL_RUN1'] ,'RSN_META_ALL'));
META1=squeeze(META1(:,:,Cmax));


META2=struct2array(load([PROJECT 'RUN2/LEiDA_KOP_ALL_RUN2'] ,'RSN_META_ALL'));
META2=squeeze(META2(1:n_NAP_subjects,:,Cmax));

MEAN_META=mean(cat(1,META1,META2),2);

TRANS=reshape(TRANS',[],1);

RUN1=repmat('CONT' ,n_CON_subjects,1);
RUN2=repmat('SCHZ' ,n_NAP_subjects,1);

RUN=cat(1,RUN1,RUN2);

SUB=[1:n_CON_subjects+n_NAP_subjects];

%
% Standardize the variables for each run
%
META=MEAN_META;

data_labels={ 'SUB','COND','META','VAR','TRANS'};
%
% Set up the regression table

regtable=table('Size',[(n_CON_subjects+n_NAP_subjects) numel(data_labels)],'VariableTypes',{'double','categorical','double','double','double'},'VariableNames',data_labels);
regtable.COND=RUN;
regtable.SUB = SUB';
regtable.META=META;
regtable.VAR=VAR;
regtable.TRANS=TRANS;
%
% Save the regression table for processing in R
%
writetable(regtable,[PROJECT 'Regtable_RAW.csv'])
