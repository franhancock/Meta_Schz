
%% Script to calculate the phase-synchronization measures corrected with the surrogates
%This script calculates phase synchronization measures to study brain
%dynamics. The goal here is to describe the synchornization dynamics based
%on phase statistics. The present script computes four basic measures;
%integration, segregation, phase-interaction fluctuations and FCD.
%These measures are applied mainly in fMRI BOLD signals.

%Ane Lopez-Gonzalez (18-7-2021)

%BASIC PHASE SYNCHRONIZATION MEASURES
%See paper:'Loss of consciousness reduces the stability of brain hubs and
%the heterogeneity of brain dynamics' by Lopez-Gonzalez, A and Panda, R et al. 
%for detailed information
%------------------------------
%Integration  
%Segregation    
%Phase-interaction fluctuations
%FCD


clc
close all
clear all

clearvars

PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/IGNIT_COBRE/';
SOURCE_PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/COBRA_COMPLEXITY_PHASE_FD/';
HCP_MAT_DATA=[PROJECT 'COBRE_MAT_R'];

addpath("/Users/HDF/Dropbox/Fran/Academics/PhD/Matlab_World/dFCwalk-main/") % for community_louvain

Tmax=150; % Number of TRs per scan (if different in each scan, set maximum) first and last scan removed
N_areas=116; % AAL116

Smax=5;
Cmax=Smax-1;
Rmax=2;


%% Calculate the phase-synchronization measured from the
%real BOLD timeseries and then corrected with the surrogates
N=116;%number of regions
T=Tmax-2;%time-points

for run=1:1

	switch run
	    case 1
            dM=struct2array(load([SOURCE_PROJECT 'LEiDA_IPC_RUN1'],'IPC_all'));
            Time_sessions=struct2array(load([SOURCE_PROJECT 'LEiDA_IPC_RUN1'],'Time_sessions'));
            n_Subjects=71;
	    case 2
            dM=struct2array(load([SOURCE_PROJECT 'LEiDA_IPC_RUN2'],'IPC_all'));
            Time_sessions=struct2array(load([SOURCE_PROJECT 'LEiDA_IPC_RUN1'],'Time_sessions'));
            n_Subjects=59;
    end
    nsub1=1;
    mPLM=[];
    meta=[];
    integ=[];
    Q=[];
    matrix_CDC=[];
    CDC=[];
     for nsub = 1:n_Subjects

         disp(['Running for Subject ' num2str(nsub) '...'])
         dMsub=dM(Time_sessions==nsub,:,:);
         meandM=squeeze(mean(dMsub,1));
        
        %% Phase-interaction fluctuations
         for t = 1:T
          mPLM(nsub,t)=mean(mean(dMsub(t,:,:)));
         end
        meta(nsub)=std(mPLM(nsub,:));

        %% Integration: 

        %cc = meandM-mmdM; % Correct with the mean matrices calculated with the surrogates
        %cc = mean(dM,3);
        cc=meandM;
        cc = cc-eye(N);
        pp = 1;
        PR = 0:0.01:0.99;
        cs=zeros(1,length(PR));

        for p = PR
        A = (cc)>p;
        [~, csize] = get_components(double(A));
        cs(pp) = max(csize);
        pp = pp+1;
        end

        integ(nsub) = sum(cs)*0.01/N;

        %% The modularity (as a measure of segregation) is calculated in the mean matrix and corrected with the 
        % bined matrix given by the surrogate and imposing a threhsold of the
        % 99% percentile

        meandM=squeeze(mean(dMsub,1));
        for i=1:N
          for j=1:N
              Y=0.5;
              if meandM(i,j)>Y
              bin_M(i,j)=1;
              else 
              bin_M(i,j)=0;
              end
          end
        end

        [~, Q(nsub)] = community_louvain((bin_M));
        
%         %% FCD (phases)
%         %this part takes longer than the rest, so if you are doing a quick
%         %test you can comment it
%         Isubdiag = find(tril(ones(N,N),-1));
%         for t=1:T
%             patt=dM(:,:,t);
%             pattern(t,:)=patt(Isubdiag);
%         end
% 
%         npattmax=size(pattern,1);
%         kk3=1;
%         for t=1:npattmax-30
%             p1=mean(pattern(t:t+30,:));
%             for t2=t+1:npattmax-30
%                 p2=mean(pattern(t2:t2+30,:));
%                 phfcddata(kk3)=dot(p1,p2)/norm(p1)/norm(p2);
%                 matrixcdc(t,t2)=dot(p1,p2)/norm(p1)/norm(p2);
%                 matrixcdc(t2,t)=dot(p1,p2)/norm(p1)/norm(p2);
%                 kk3=kk3+1;
%             end
%         end 
%         CDC(nsub1,:)=phfcddata;
%         matrix_CDC(nsub1,:,:)=matrixcdc;
%     nsub1=1+nsub1;
     end
save([PROJECT 'phase_synchronization_results_',num2str(run) ],'integ','Q','meta')    
end

