function LMER_MODES_PID_RAW
% Function to prepare the regression table for Linear Mixed-Effects Regression Model
% in R
%
% Fran Hancock
% Dec 2021
% fran.hancock@kcl.ac.uk
%
%
% Function to investigate the relationships between time varying measures
% of CHI OCC HC and PID and the random effect of RUN
% 
clear all

Smax=7;
Rmax=2;
% speed_state=input('Which speed state');
% metric_state=input('which metric state');
n_subjects=59;
n_CON_subjects=71;

PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/COBRE_NM/';

PAR='AAL116';
Cmax=Smax-1;

for run=1:1
    META=struct2array(load([PROJECT 'RUN' num2str(run) '/LEiDA_KOP_ALL_RUN' num2str(run)],'RSN_META_ALL'));
    SYNC=struct2array(load([PROJECT 'RUN' num2str(run) '/LEiDA_KOP_ALL_RUN' num2str(run)],'RSN_SYNC_ALL'));
    VAR=struct2array(load([PROJECT 'RUN' num2str(run) '/LEiDA_KOP_ALL_RUN' num2str(run)],'ICN_EV_ALL_MEAN'));
end

if run==1
    cond='CON';
    SUB=[1:n_CON_subjects];
else
    cond='NAP';
    SUB=[n_CON_subjects+1:n_subjects+n_CON_subjects];
end
ASUB=[SUB SUB SUB SUB SUB SUB SUB]';

SUB=ASUB;

if run==1
    COND=repmat('CON', Smax*n_CON_subjects,1);
else
    COND=repmat('NAP', Smax*n_subjects,1);
end
if run==1
    MODE1=repmat('MODE1' ,n_CON_subjects,1);
    MODE2=repmat('MODE2' ,n_CON_subjects,1);
    MODE3=repmat('MODE3' ,n_CON_subjects,1);
    MODE4=repmat('MODE4' ,n_CON_subjects,1);
    MODE5=repmat('MODE5' ,n_CON_subjects,1);
    MODE6=repmat('MODE6' ,n_CON_subjects,1);
    MODE7=repmat('MODE7' ,n_CON_subjects,1);
else
    MODE1=repmat('MODE1' ,n_subjects,1);
    MODE2=repmat('MODE2' ,n_subjects,1);
    MODE3=repmat('MODE3' ,n_subjects,1);
    MODE4=repmat('MODE4' ,n_subjects,1);
    MODE5=repmat('MODE5' ,n_subjects,1);
    MODE6=repmat('MODE6' ,n_subjects,1);
    MODE7=repmat('MODE7' ,n_subjects,1);
end

MODE= [MODE1;MODE2;MODE3;MODE4;MODE5;MODE6;MODE7];

META=reshape(META,[],1);
SYNC=reshape(SYNC,[],1);
VAR=reshape(VAR,[],1);  


%data_labels={ 'src_subject_id','SUB','COND','RUN','MODE', 'PHI','OCC','DUR','META','SYNC','SPEED','VAR'};
data_labels={ 'SUB','COND','MODE','META','SYNC','VAR'};

if run==1
    regtable=table('Size',[Smax*n_CON_subjects numel(data_labels)],'VariableTypes',{'single','categorical','double','double','double','double'},'VariableNames',data_labels);
else
    regtable=table('Size',[Smax*n_subjects numel(data_labels)],'VariableTypes',{'single','categorical','double','double','double','double'},'VariableNames',data_labels);
end
%
% Set up the regression table

regtable.SUB=SUB;
regtable.COND=COND;
regtable.MODE=MODE;    
regtable.META=META;
regtable.VAR=VAR;    
regtable.SYNC=SYNC;



%
% Save the regression table for processing in R
%
writetable(regtable,[PROJECT 'RUN' num2str(run) '/Regtable_MODES_RAW.csv'])
