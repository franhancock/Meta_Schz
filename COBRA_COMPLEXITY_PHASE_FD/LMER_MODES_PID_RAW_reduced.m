function LMER_MODES_PID_RAW_reduced
% Function to prepare the regression table for Linear Mixed-Effects Regression Model
% in R
% The metric variables are Zscored here
%
% Fran Hancock
% Dec 2021
% fran.hancock@kcl.ac.uk
%
%
% Function to investigate the relationships between time varying measures
% of CHI OCC HC and PID and the random effect of RUN
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run seperately for run1 and run2 as there are different number of
% subjects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%
%
% Set up the paths to the functions, libraries etc
%
%

clear all
Smax=5;
Rmax=2;
% speed_state=input('Which speed state');
% metric_state=input('which metric state');
n_subjects=59;
n_CON_subs=71; % will start the subject numbering from n_CON_subs+1

n_rows=5;
n_cols=2;
PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/COBRA_COMPLEXITY_PHASE_FD/';

PAR='AAL116';
Cmax=Smax-1;

for run=2:2

    META=struct2array(load([PROJECT 'RUN' num2str(run) '/LEiDA_KOP_ALL_RUN' num2str(run)],'RSN_META_ALL'));
    VAR=struct2array(load([PROJECT 'RUN' num2str(run) '/LEiDA_KOP_ALL_RUN' num2str(run)],'ICN_EV_ALL_MEAN'));

% switch the order of the modes



% Run 1: 1 2 4 3 5 (CON)
% Run 2: 1 2 5 3 4 (SCHZ)
    switch run
        case 1
            META5(1:n_CON_subs,:)=squeeze(META(1:n_CON_subs,:,Cmax));
            VAR5(1:n_CON_subs,:)=squeeze(VAR(1:n_CON_subs,:,Cmax));
                
            META5(1:n_CON_subs,[1 2 3 4 5])=META5(1:n_CON_subs,[1 2 4 3 5]);            
            VAR5(1:n_CON_subs,[1 2 3 4 5])=VAR5(1:n_CON_subs,[1 2 4 3 5]);

        case 2
            META5(1:n_subjects,:)=squeeze(META(1:n_subjects,:,Cmax));
            VAR5(1:n_subjects,:)=squeeze(VAR(1:n_subjects,:,Cmax));
    end


    META=META5;
    VAR=VAR5;


    if run==1
        cond='CON';
        SUB=[1:n_CON_subs];
    else
        cond='NAP';
        SUB=[n_CON_subs+1:n_subjects+n_CON_subs];
    end
    ASUB=[SUB SUB SUB SUB SUB]';
   
    SUB=ASUB;
    
    if run==1
        COND=repmat('CON', Smax*n_CON_subs,1);
    else
        COND=repmat('NAP', Smax*n_subjects,1);
    end
    if run==1
        MODE1=repmat('MODE1' ,n_CON_subs,1);
        MODE2=repmat('MODE2' ,n_CON_subs,1);
        MODE3=repmat('MODE3' ,n_CON_subs,1);
        MODE4=repmat('MODE4' ,n_CON_subs,1);
        MODE5=repmat('MODE5' ,n_CON_subs,1);
    else
        MODE1=repmat('MODE1' ,n_subjects,1);
        MODE2=repmat('MODE2' ,n_subjects,1);
        MODE3=repmat('MODE3' ,n_subjects,1);
        MODE4=repmat('MODE4' ,n_subjects,1);
        MODE5=repmat('MODE5' ,n_subjects,1);
    end

    MODE= [MODE1;MODE2;MODE3;MODE4;MODE5];
        
    
    META=reshape(META,[],1);
    VAR=reshape(VAR,[],1);        
    
    data_labels={ 'SUB','COND','MODE','META','VAR'};
    %
    % Set up the regression table
    if run==1
        regtable=table('Size',[Smax*n_CON_subs numel(data_labels)],'VariableTypes',{'single','categorical','double','double','double'},'VariableNames',data_labels);
    else
        regtable=table('Size',[Smax*n_subjects numel(data_labels)],'VariableTypes',{'single','categorical','double','double','double'},'VariableNames',data_labels);
    end

    regtable.SUB=SUB;
    regtable.COND=COND;
    regtable.MODE=MODE;    
    regtable.META=META;
    regtable.VAR=VAR;
    
    
    %
    % Save the regression table for processing in R
    %
 
    writetable(regtable,[PROJECT 'RUN' num2str(run) '/Regtable_MODES_RAW.csv'])
   
end