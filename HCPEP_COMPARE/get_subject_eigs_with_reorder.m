function get_subject_eigs_with_reorder
%
% Function to extract individual eigenvectors (mean) and store them for
% visualization with t-SNE. Need to reorder the modes in each run and
% condition as in LEiDA_reliability_across_conditions
%
% Fran Hancock
% May 2022
%
% fran.hancock@me.com
%
PROJECT = '/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_COMPARE/';
CON_PROJECT = '/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_CON/';
PAP_PROJECT = '/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_PAP/';
NAP_PROJECT = '/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_NAP/';

CondMax=3;
mode = 4;
Rmax=4;
Smax=5;
Cmax=Smax-1;
Tmax=408;
con_subj=53;
pap_subj=30;
nap_subj=82;

start=1;
n_areas=116;
stop=116;

% ordered from clustering
V1_all_con = zeros(Rmax,Smax,con_subj,n_areas); % because there are a different number of subjects in each cohort
V1_all_pap = zeros(Rmax,Smax,pap_subj,n_areas);
V1_all_nap = zeros(Rmax,Smax,nap_subj,n_areas);

% reordered
V1_all_CON = zeros(Rmax,Smax,con_subj,n_areas); % because there are a different number of subjects in each cohort
V1_all_PAP = zeros(Rmax,Smax,pap_subj,n_areas);
V1_all_NAP = zeros(Rmax,Smax,nap_subj,n_areas);

V1_all_subj = zeros(Smax,con_subj+pap_subj+nap_subj,n_areas);

for run=1:Rmax % 1:Rmax

    for cond=1:CondMax
        switch cond
            case 1
                COND='CON';
                kmeans=struct2array(load([CON_PROJECT 'RUN' num2str(run) '/LEiDA_Kmeans_results'],'Kmeans_results'));
                v1_all=struct2array(load([CON_PROJECT 'RUN' num2str(run) '/LEiDA_EigenVectors'],'V1_all'));
                Time_sessions=struct2array(load([CON_PROJECT 'RUN' num2str(run) '/LEiDA_EigenVectors'],'Time_sessions'));
            case 2
                COND='PAP';
                kmeans=struct2array(load([PAP_PROJECT 'RUN' num2str(run) '/LEiDA_Kmeans_results'],'Kmeans_results'));
                v1_all=struct2array(load([PAP_PROJECT 'RUN' num2str(run) '/LEiDA_EigenVectors'],'V1_all'));
                Time_sessions=struct2array(load([PAP_PROJECT 'RUN' num2str(run) '/LEiDA_EigenVectors'],'Time_sessions'));
            case 3
                COND='NAP';
                kmeans=struct2array(load([NAP_PROJECT 'RUN' num2str(run) '/LEiDA_Kmeans_results'],'Kmeans_results'));
                v1_all=struct2array(load([NAP_PROJECT 'RUN' num2str(run) '/LEiDA_EigenVectors'],'V1_all'));
                Time_sessions=struct2array(load([NAP_PROJECT 'RUN' num2str(run) '/LEiDA_EigenVectors'],'Time_sessions'));
    
        end
        
        idx_subj = kmeans{Cmax}.IDX;
        num_subj= size(idx_subj,2)/Tmax;
        
        for mode=1:Smax
            vec_ctr=1;

            switch cond
                case 1
                    for subj=1:num_subj
                     % get the mean eigvec values for mode m
                        eigs_sub = v1_all(Time_sessions==subj,:);
                        eigs_sub = eigs_sub(idx_subj(Time_sessions==subj)==mode,:);
                        if isnan(mean(eigs_sub,1))
                            V1_all_con(run,mode,vec_ctr,:)=0;                    
                        else
                            V1_all_con(run,mode,vec_ctr,:)=mean(eigs_sub,1);
                        end
                        vec_ctr=vec_ctr+1;
                    end 
                case 2
                    for subj=1:num_subj
                     % get the mean eigvec values for mode m
                        eigs_sub = v1_all(Time_sessions==subj,:);
                        eigs_sub = eigs_sub(idx_subj(Time_sessions==subj)==mode,:);
                        if isnan(mean(eigs_sub,1))
                            V1_all_pap(run,mode,vec_ctr,:)=0;                    
                        else
                            V1_all_pap(run,mode,vec_ctr,:)=mean(eigs_sub,1);
                        end
                        vec_ctr=vec_ctr+1;
                    end 
                case 3
                    for subj=1:num_subj
                     % get the mean eigvec values for mode m
                        eigs_sub = v1_all(Time_sessions==subj,:);
                        eigs_sub = eigs_sub(idx_subj(Time_sessions==subj)==mode,:);
                        if isnan(mean(eigs_sub,1))
                            V1_all_nap(run,mode,vec_ctr,:)=0;                    
                        else
                            V1_all_nap(run,mode,vec_ctr,:)=mean(eigs_sub,1);
                        end
                        vec_ctr=vec_ctr+1;
                    end             
            end
        end  
    end
end

% now sort the modes in each run for each condition

for run=1:Rmax   
    for cond=1:CondMax
        switch cond
            case 1 % CON
                
                switch run
                    case 1 
                        V1_all_tmp=squeeze(V1_all_con(run,:,:));
                        V1_all_tmp([3 4],:)=V1_all_tmp([4 3],:);
                        V1_all_CON(run,:,:)=V1_all_tmp;
                    case 2
                        V1_all_tmp=squeeze(V1_all_con(run,:,:));
                        V1_all_tmp([3 4 5],:)=V1_all_tmp([5 3 4],:);
                        V1_all_CON(run,:,:)=V1_all_tmp;
    
                    case 3
                        V1_all_tmp=squeeze(V1_all_con(run,:,:));
                        V1_all_tmp([3 4],:)=V1_all_tmp([4 3],:);
                        V1_all_CON(run,:,:)=V1_all_tmp;
                    case 4
                        V1_all_CON(run,:,:)=V1_all_con(run,:,:);                     
                end
    
    
            case 2 % PAP
               
                switch run
                    case 1 
                        V1_all_tmp=squeeze(V1_all_pap(run,:,:));
                        V1_all_tmp([3 4],:)=V1_all_tmp([4 3],:);
                        V1_all_PAP(run,:,:)=V1_all_tmp;
                    case 2
                        V1_all_tmp=squeeze(V1_all_pap(run,:,:));
                        V1_all_tmp([4 5],:)=V1_all_tmp([5 4],:);
                        V1_all_PAP(run,:,:)=V1_all_tmp;
                    case 3
                        V1_all_tmp=squeeze(V1_all_pap(run,:,:));
                        V1_all_tmp([3 4],:)=V1_all_tmp([4 3],:);
                        V1_all_PAP(run,:,:)=V1_all_tmp;
                   case 4
                        V1_all_PAP(run,:,:)=V1_all_pap(run,:,:);
                end
    
            case 3 % NAP
                V1_all_NAP=V1_all_nap;
        end
    end
end

for run=1:Rmax
    for mode=1:Smax
        con_tmp=squeeze(V1_all_CON(run,mode,:,:));
        pap_tmp=squeeze(V1_all_PAP(run,mode,:,:));
        nap_tmp=squeeze(V1_all_NAP(run,mode,:,:));
        V1_all_subj = cat(1, con_tmp,nap_tmp);        
        save([PROJECT 'RUN' num2str(run) '_Mode' num2str(mode) '_V1_all_subj'],'V1_all_subj')
    end
end


