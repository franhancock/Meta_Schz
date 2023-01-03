function Phase_sync_metrics


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% LEADING EIGENVECTOR DYNAMICS ANALYSIS
%
%
% Function to compute the Kuramoto order parameter, Synchronisation, and
% Metastability when state is dominant derived from LAU LEiDA
% anaysis for all subjects
%
%
% Fran Hancock
% Nov 2021
% fran.hancock@kcl.ac.uk
%
%
%%%%%%%
%
% Set up the paths to the functions, libraries etc
%
%
% global  HCP_MAT_DATA;
HCP_MAT_DATA='~/TESTDATA/EP_CON_MAT';
PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_CON_NM/';
ORG_PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_CON/';

Tmax=410; % Number of TRs per scan (if different in each scan, set maximum) first and last scan removed
TR=0.72;
N_areas=116; % LAU parcellation

Smax=7;
Rmax=4;



load([PROJECT 'NM_ICN.mat'])
for run=1:Rmax

	switch run
	    case 1
		    MAT_FOLDER = [HCP_MAT_DATA '_R1/'];
		    MET_FOLDER='RUN1/';
	    case 2
		    MAT_FOLDER = [HCP_MAT_DATA '_R2/'];
		    MET_FOLDER='RUN2/';
    
	    case 3
		    MAT_FOLDER = [HCP_MAT_DATA '_R3/'];
		    MET_FOLDER='RUN3/';
	    case 4
		    MAT_FOLDER = [HCP_MAT_DATA '_R4/'];
		    MET_FOLDER='RUN4/';
	end	
	

    V1_all=struct2array(load([ORG_PROJECT MET_FOLDER 'LEiDA_EigenVectors.mat'],'V1_all'));
    Time_sessions = struct2array(load([ORG_PROJECT MET_FOLDER 'LEiDA_EigenVectors.mat'],'Time_sessions'));
    %
    % Create empty variables to save patterns 
    % Define total number of scans that will be read
    Data_info=dir([MAT_FOLDER 'Sub*.mat']);
    total_scans=size(Data_info,1);
    
    t_all=0; % Index of time (starts at 0 and will be updated until n_Sub*(Tmax-2)) - flh this was missing
    
    for sub=1:total_scans
        
        disp(Data_info(sub).name)
        
        % load BOLD signals in each scan
        signal = struct2array(load([MAT_FOLDER Data_info(sub).name]));
        
        %%%%%%%%%%%%%%% Band pass filter before getting the analtical signal %%%%%%%%%%%%%%%%%
        
        high_pass=0.01;     % Bands from Glerean but with fast TR
        low_pass=0.08;
    
        for n=1:size(signal,1)
            signal(n,:)=bandpass(signal(n,:),[high_pass low_pass],1/TR);
        end
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Get the BOLD phase using the Hilbert transform
        % save with the same name to save RAM space
        for seed=1:N_areas
            %ts=detrend(signal(seed,:)-mean(signal(seed,:)));
            ts=signal(seed,:);
            signal(seed,:) = angle(hilbert(ts));
        end

        %
        % calculate the KOP metrics for this subject
        % 

        % discard first and last signals
        tsignal(:,:)=signal(:,2:Tmax-1);
        state_idx=Time_sessions==sub;
    
         for state=1:Smax %         
             ind_state=NM_ICN{state,2};  
             V1_sub = V1_all(state_idx,:);

             ICN_EV_MEAN(sub,state,:) = mean(var(V1_sub(:,ind_state),1)); % Mean variance
             ICN_EV_AVG(sub,state,:) = mean(V1_sub(:,ind_state),2); % mean Eigenvector value
    
             ICN_OP(sub,state,:) = abs(sum(exp(1i*tsignal(ind_state,:)))/(numel(ind_state))); % abs(mean(sum of e itheta(t)))

             RSN_META(sub,state) = std(ICN_OP(sub,state,:));
             RSN_SYNC(sub,state) = mean(ICN_OP(sub,state,:));  % mean for the state over time  
             
            ICN_OP_ALL(sub,1:state,:)=ICN_OP(sub,1:state,:);


            RSN_META_ALL(sub,1:state)=RSN_META(sub,1:state);
            RSN_SYNC_ALL(sub,1:state)=RSN_SYNC(sub,1:state);
            ICN_EV_ALL_MEAN(sub,1:state) = ICN_EV_MEAN(sub,1:state,:);
            ICN_EV_ALL_AVG(sub,1:state,:) = ICN_EV_AVG(sub,1:state,:);
        end
    end

    save([MET_FOLDER 'LEiDA_KOP_ALL_RUN' num2str(run) ], 'RSN_META_ALL', 'RSN_SYNC_ALL',...
    'ICN_OP_ALL','ICN_EV_ALL_MEAN','ICN_EV_ALL_AVG');
    
    disp(['Kuramoto results saved successfully in ' MET_FOLDER ' as ' 'LEiDA_KOP_ALL_RUN' num2str(run)])

end
%%%%%%%%%%

