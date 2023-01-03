function PL_IGNIT_MODES_PID_RAW
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
n_subjects=82;
n_CON_subs=53; % will start the subject numbering from n_CON_subs+1

n_rows=5;
n_cols=2;
PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/IGNIT_HCPEP/';
SOURCE1_PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_CON/';
SOURCE2_PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_NAP/';

PAR='AAL116';
Cmax=Smax-1;

for run=1:1


    if run==1
        GINT1=struct2array(load([PROJECT 'mode_phase_synchronization_results_1.mat'],'sub_integ'));
        FSEG1=struct2array(load([PROJECT 'mode_phase_synchronization_results_1.mat'],'sub_Q'));
        META=struct2array(load([SOURCE1_PROJECT 'RUN2/LEiDA_KOP_ALL_RUN2'],'RSN_META_ALL'));
        VAR=struct2array(load([SOURCE1_PROJECT 'RUN2/LEiDA_KOP_ALL_RUN2'],'ICN_EV_ALL_MEAN'));


    else
        GINT2=struct2array(load([PROJECT 'mode_phase_synchronization_results_2.mat'],'sub_integ'));
        FSEG2=struct2array(load([PROJECT 'mode_phase_synchronization_results_2.mat'],'sub_Q'));
        META=struct2array(load([SOURCE2_PROJECT 'RUN2/LEiDA_KOP_ALL_RUN2'],'RSN_META_ALL'));
        VAR=struct2array(load([SOURCE2_PROJECT 'RUN2/LEiDA_KOP_ALL_RUN2'],'ICN_EV_ALL_MEAN'));

    end

% switch the order of the modes



% Run 1: 1 2 5 3 4 (CON)
% Run 2: 1 2 3 4 5 (NAP)
    switch run
        case 1
            META5(1:n_CON_subs,:)=squeeze(META(1:n_CON_subs,:,Cmax));
            VAR5(1:n_CON_subs,:)=squeeze(VAR(1:n_CON_subs,:,Cmax));
            GINT5=GINT1;
            FSEG5=FSEG1;

            META5(1:n_CON_subs,[1 2 3 4 5])=META5(1:n_CON_subs,[1 2 5 3 4]);            
            VAR5(1:n_CON_subs,[1 2 3 4 5])=VAR5(1:n_CON_subs,[1 2 5 3 4]);

            GINT5(:,[1 2 3 4 5])=GINT5(:,[1 2 5 3 4]);
            FSEG5(:,[1 2 3 4 5])=FSEG5(:,[1 2 5 3 4]);
            

        case 2
            META5(1:n_subjects,:)=squeeze(META(1:n_subjects,:,Cmax));
            VAR5(1:n_subjects,:)=squeeze(VAR(1:n_subjects,:,Cmax));
            GINT5=GINT2;
            FSEG5=FSEG2;

    end


 
    META=META5;
    VAR=VAR5;
    GINT=GINT5;
    FSEG=FSEG5;


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
    
    %MODE=['MODE1';'MODE2';'MODE3';'MODE4';'MODE5'];
    %MODE=repmat(MODE,Rmax,1);

    
    META=reshape(META,[],1);
    VAR=reshape(VAR,[],1); 
    GINT=reshape(GINT,[],1);
    FSEG=reshape(FSEG,[],1);

    data_labels={ 'SUB','COND','MODE', 'META','VAR','GINT','FSEG'};
    %
    % Set up the regression table
    if run==1
        regtable=table('Size',[Smax*n_CON_subs numel(data_labels)],'VariableTypes',{'single','categorical','double','double','double','double','double'},'VariableNames',data_labels);
    else
        regtable=table('Size',[Smax*n_subjects numel(data_labels)],'VariableTypes',{'single','categorical','double','double','double','double','double'},'VariableNames',data_labels);
    end

    regtable.SUB=SUB;
    regtable.COND=COND;
    regtable.MODE=MODE;
    
    regtable.META=META;
    regtable.VAR=VAR;
    regtable.GINT=GINT;
    regtable.FSEG=FSEG;
    
    %
    % Save the regression table for processing in R
    %
 
    writetable(regtable,[PROJECT 'RUN' num2str(run) '/PL_IGNIT_Regtable_MODES_RAW.csv'])
       
end