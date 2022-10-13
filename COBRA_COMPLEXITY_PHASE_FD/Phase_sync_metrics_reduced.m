function Phase_sync_metrics_reduced


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% LEADING EIGENVECTOR DYNAMICS ANALYSIS
%
%
% Function to compute the META and VAR
% anaysis for all subjects
%
%
% Fran Hancock
% Oct 2022
% fran.hancock@kcl.ac.uk
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run seperately for run1 (CON) and run2 (SCHZ) as there are different number of
% subjects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set up the paths to the functions, libraries etc
%
%
PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/COBRA_COMPLEXITY_PHASE_FD/';
HCP_MAT_DATA=[PROJECT 'COBRE_MAT_R'];

Tmax=150; % Number of TRs per scan (if different in each scan, set maximum) first and last scan removed
TR=2;
N_areas=116; % AAL116 parcellation

Smax=5;
Cmax=Smax-1;
Rmax=2;


for run=2:2

	switch run
	    case 1
		    MAT_FOLDER = [HCP_MAT_DATA num2str(run) '/'];
		    MET_FOLDER='RUN1/';
	    case 2
		    MAT_FOLDER = [HCP_MAT_DATA num2str(run) '/'];
		    MET_FOLDER='RUN2/';
    
	    end	
	
        load([PROJECT MET_FOLDER 'LEiDA_Kmeans_results'],'Kmeans_results')
        V1_all=struct2array(load([PROJECT MET_FOLDER 'LEiDA_EigenVectors.mat'],'V1_all'));
        Time_sessions = struct2array(load([PROJECT MET_FOLDER 'LEiDA_EigenVectors.mat'],'Time_sessions'));
        %
        % Create empty variables to save patterns 
        % Define total number of scans that will be read
        Data_info=dir([MAT_FOLDER 'AAL*Sub*.mat']);
        total_scans=size(Data_info,1);
                
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
            for Cluster=1:Cmax
        
                Centroids=Kmeans_results{Cluster}.C;
                state_idx=Time_sessions==sub;
                Smax=size(Centroids,1);
        
                for state=1:Smax
                    % get only the regions with positive centroids
                    if state==1     % this is the global state and will have all negatives 
        
                        [~, ind_state]=find(Centroids(state,:));  
                        STATE_IDX{state}.idx=ind_state;
        
                    else
                        [~, ind_state]=find(Centroids(state,:)>0);   % get the parcel index of positive eigenvectors
                        STATE_IDX{state}.idx=ind_state;
                    end

                    % cacluate the varinace of the eigenvectors for each
                    % state 17.8.2022
                    V1_sub = V1_all(state_idx,:);
                    if state==1
                        for t=1:Tmax-2
                            MAGRatio(sub,t) = (size(find(V1_sub(t,:)>=0)))/(size(find(V1_sub(t,:)<0)));
                        end       
                         TRANSITIONS(sub) = size(find(MAGRatio(sub,:) >=1),2);
                    end

                    ICN_EV_MEAN(sub,state,:) = mean(var(V1_sub(:,ind_state),1));
                    ICN_EV_AVG(sub,state,:) = mean(V1_sub(:,ind_state),2); % mean Eigenvector value
                    
        
                    ICN_OP(sub,state,:) = abs(sum(exp(1i*tsignal(ind_state,:)))/(numel(ind_state))); % abs(mean(sum of e itheta(t)))
                    
                    RSN_META(sub,state) = std(ICN_OP(sub,state,:));

                
                end 
                ICN_OP_ALL(sub,1:state,Cluster,:)=ICN_OP(sub,1:state,:);
        end  
     
        RSN_META_ALL(sub,1:state,Cluster)=RSN_META(sub,1:state);
        ICN_EV_ALL_MEAN(sub,1:state,Cluster) = ICN_EV_MEAN(sub,1:state,:);
        ICN_EV_ALL_AVG(sub,1:state,Cluster,:) = ICN_EV_AVG(sub,1:state,:);
    end


    save([PROJECT MET_FOLDER 'LEiDA_KOP_ALL_RUN' num2str(run) ], 'RSN_META_ALL',...
        'ICN_OP_ALL','ICN_EV_ALL_MEAN','STATE_IDX','MAGRatio','TRANSITIONS','ICN_EV_ALL_AVG');
     
    disp(['Kuramoto results saved successfully in ' MET_FOLDER ' as ' 'LEiDA_KOP_ALL_RUN' num2str(run)])

end
%%%%%%%%%%

