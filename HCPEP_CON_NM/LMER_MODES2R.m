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
%
% Run 1: 1 2 4 3 5
% Run 2: 1 2 5 3 4
% Run 3: 1 2 4 3 5
% Run 4: 1 2 3 4 5
%%%%%%%
%
% Set up the paths to the functions, libraries etc
%
%

Smax=7;
Rmax=4;
% speed_state=input('Which speed state');
% metric_state=input('which metric state');
n_subjects=53;

n_rows=5;
n_cols=2;
PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_CON_NM/';

PAR='AAL116';
Cmax=Smax-1;

for run=1:Rmax
    META(run,:,:,:)=struct2array(load([PROJECT 'RUN' num2str(run) '/LEiDA_KOP_ALL_RUN' num2str(run)],'RSN_META_ALL'));
    SYNC(run,:,:,:)=struct2array(load([PROJECT 'RUN' num2str(run) '/LEiDA_KOP_ALL_RUN' num2str(run)],'RSN_SYNC_ALL'));
    VAR(run,:,:,:)=struct2array(load([PROJECT 'RUN' num2str(run) '/LEiDA_KOP_ALL_RUN' num2str(run)],'ICN_EV_ALL_MEAN'));
end

% switch the order of
% the modes

% META5(:,:,:)=squeeze(META(:,:,:,Cmax));
% SYNC5(:,:,:)=squeeze(SYNC(:,:,:,Cmax));
% VAR5=squeeze(VAR(:,:,:,Cmax));

% Run 1: 1 2 4 3 5
% Run 2: 1 2 5 3 4
% Run 3: 1 2 4 3 5
% Run 4: 1 2 3 4 5

% P5(1,:,[4 3])=P5(1,:,[3 4]);
% P5(2,:,[3 4 5])=P5(2,:,[5 3 4 ]);
% P5(3,:,[4 3]) =P5(3,:,[3 4]);
% 
% LT5(1,:,[4 3])=LT5(1,:,[3 4]);
% LT5(2,:,[3 4 5])=LT5(2,:,[5 3 4 ]);
% LT5(3,:,[4 3]) =LT5(3,:,[3 4]);
% 
% MEAN_SPEED5(1,:,[4 3])=MEAN_SPEED5(1,:,[3 4]);
% MEAN_SPEED5(2,:,[3 4 5])=MEAN_SPEED5(2,:,[5 3 4 ]);
% MEAN_SPEED5(3,:,[4 3]) =MEAN_SPEED5(3,:,[4 3]);
% 
% META5(1,:,[4 3])=META5(1,:,[3 4]);
% META5(2,:,[3 4 5])=META5(2,:,[5 3 4 ]);
% META5(3,:,[4 3]) =META5(3,:,[3 4]);
% 
% SYNC5(1,:,[4 3])=SYNC5(1,:,[3 4]);
% SYNC5(2,:,[3 4 5])=SYNC5(2,:,[5 3 4 ]);
% SYNC5(3,:,[4 3]) =SYNC5(3,:,[3 4]);
% 
% VAR5(1,:,[4 3])=VAR5(1,:,[3 4]);
% VAR5(2,:,[3 4 5])=VAR5(2,:,[5 3 4 ]);
% VAR5(3,:,[4 3]) =VAR5(3,:,[3 4]);
% 
% 
% P=P5;
% LT=LT5;
% MEAN_SPEED=MEAN_SPEED5;
% META=META5;
% SYNC=SYNC5;
% OCC=P5;
% DWELL=LT5;
% VAR=VAR5;

%load([ORG_PROJECT 'AAL116_IPC_MODE_GStats_R2R3']); % load MEAN_xxx


SUB=[1:n_subjects];
ASUB=repmat(SUB(:,:),Smax,1);
SUB=[ASUB ASUB ASUB ASUB]';
SUB=reshape(SUB,[],1);

COND=repmat('CON', Smax*Rmax*n_subjects,1);

RUN1=repmat('RUN1' ,n_subjects,1);
RUN2=repmat('RUN2' ,n_subjects,1);
RUN3=repmat('RUN3' ,n_subjects,1);
RUN4=repmat('RUN4' ,n_subjects,1);

RUN=cat(1,RUN1,RUN2,RUN3,RUN4);
RUN=repmat(RUN,Smax,1);

MODE1=repmat('MODE1' ,Rmax*n_subjects,1);
MODE2=repmat('MODE2' ,Rmax*n_subjects,1);
MODE3=repmat('MODE3' ,Rmax*n_subjects,1);
MODE4=repmat('MODE4' ,Rmax*n_subjects,1);
MODE5=repmat('MODE5' ,Rmax*n_subjects,1);
MODE6=repmat('MODE6' ,Rmax*n_subjects,1);
MODE7=repmat('MODE7' ,Rmax*n_subjects,1);


MODE= [MODE1;MODE2;MODE3;MODE4;MODE5;MODE6;MODE7];

META=squeeze(cat(2,META(1,:,:),META(2,:,:), META(3,:,:),META(4,:,:)));
META=reshape(META,[],1);

SYNC=squeeze(cat(2,SYNC(1,:,:),SYNC(2,:,:), SYNC(3,:,:),SYNC(4,:,:)));
SYNC=reshape(SYNC,[],1);

VAR=squeeze(cat(2,VAR(1,:,:),VAR(2,:,:), VAR(3,:,:),VAR(4,:,:)));
VAR=reshape(VAR,[],1);

%data_labels={ 'src_subject_id','SUB','COND','RUN','MODE', 'PHI','OCC','DUR','META','SYNC','SPEED','VAR'};
data_labels={ 'SUB','COND','RUN','MODE','META','SYNC','VAR'};

%
% Set up the regression table

regtable=table('Size',[Rmax*Smax*n_subjects numel(data_labels)],'VariableTypes',{'single', 'categorical','categorical','double','double','double','double'},'VariableNames',data_labels);
%regtable.src_subject_id=SUB_ID;
regtable.SUB=SUB;
regtable.COND=COND;
regtable.RUN=RUN;
regtable.MODE=MODE;

regtable.META=META;
regtable.SYNC=SYNC;
regtable.VAR=VAR;


%
% Save the regression table for processing in R
%
writetable(regtable,[PROJECT 'Regtable_MODES_RAW.csv'])
