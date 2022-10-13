function sc_stats_for_R
%
% Function to prepare data for processing in R
%
% Fran Hancock
% July 2021
% fran.hancock@kcl.ac.uk
%
%
PROJECT = '/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_COMPARE/';

Rmax=4;
CondMax=3;
con_subj=53;
pap_subj=30;
nap_subj=82;
n_subs=con_subj+nap_subj;

MODE=4;

% Subcortical regions
sc = [37:38 41:42 71:78];
sc_labels = {'Hippocampus_L','Hippocampus_R','Amygdala_L','Amygdala_R','Caudate_L','Caudate_R','Putamen_L','Putamen_R','Pallidum_L','Pallidum_R','Thalamus_L','Thalamus_R'};

data_labels={ 'SUB','COND','RUN','Hippocampus_L','Hippocampus_R','Amygdala_L','Amygdala_R','Caudate_L','Caudate_R','Putamen_L','Putamen_R','Pallidum_L','Pallidum_R','Thalamus_L','Thalamus_R'};

% sc = [71:78];
% sc_labels = {'Caudate_L','Caudate_R','Putamen_L','Putamen_R','Pallidum_L','Pallidum_R','Thalamus_L','Thalamus_R'};
% 
% data_labels={ 'SUB','COND','RUN','Caudate_L','Caudate_R','Putamen_L','Putamen_R','Pallidum_L','Pallidum_R','Thalamus_L','Thalamus_R'};
regtable=table('Size',[Rmax*n_subs numel(data_labels)],'VariableTypes',{'single', 'categorical','categorical','double','double','double','double','double','double', 'double','double','double','double','double','double'},'VariableNames',data_labels);

% just mode 4 cause we are interested in basal ganglia differences

ASUB=[1:n_subs];
SUB=[ASUB ASUB ASUB ASUB]';
SUB=reshape(SUB,[],1);

RUN1=repmat('RUN1' ,n_subs,1);
RUN2=repmat('RUN2' ,n_subs,1);
RUN3=repmat('RUN3' ,n_subs,1);
RUN4=repmat('RUN4' ,n_subs,1);

RUN=cat(1,RUN1,RUN2,RUN3,RUN4);

cond_con = repmat('CON',con_subj,1);
cond_pap = repmat('PAP',pap_subj,1);
cond_nap = repmat('NAP',nap_subj,1);
COND_INST = [cond_con;cond_nap];
COND = [COND_INST;COND_INST;COND_INST;COND_INST];
%COND = reshape(COND,[],1);

regtable.SUB=SUB;
regtable.COND=COND;
regtable.RUN=RUN;

for run=1:Rmax

    mode4_values = struct2array(load([PROJECT 'RUN' num2str(run) '_Mode' num2str(MODE) '_V1_all_subj'],'V1_all_subj'));
    switch run
        case 1
            sc_values(1:n_subs,:)=squeeze(mode4_values(:,sc));
        case 2
            sc_values(n_subs+1:2*n_subs,:)=squeeze(mode4_values(:,sc));
        case 3
            sc_values(2*n_subs+1:3*n_subs,:)=squeeze(mode4_values(:,sc));
        case 4
            sc_values(3*n_subs+1:4*n_subs,:)=squeeze(mode4_values(:,sc));
    end
    
end

regtable{:,4:15} = sc_values;

writetable(regtable,[PROJECT 'SC_coupling.csv'])
