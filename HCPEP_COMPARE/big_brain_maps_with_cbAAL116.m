function big_brain_maps_AAL116
%
% Function to make fig1 for the test retest paper
%
%
% Fran Hancock
% Aug 2021
% fran.hancock@kcl.ac.uk
%
% This function needs plot_nodes_in_cortex and
% MNI152_T1_10mm_brain_mask.nii aal_cog_txt
%
%%%%%%%
%
% Set up the paths to the functions, libraries etc
%
% 
PROJECT = '/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_COMPARE/';

Rmax=4;
CondMax=3;
N_areas=116;
Smax=5;
Cmax=Smax-1;
run = 3;

CON_PROJECT = '/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_CON/';
% PAP_PROJECT = '/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_PAP/';
% NAP_PROJECT = '/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_NAP/';

load(['SUPPLIED_FILES/AAL116_labels.mat'], 'AAL116_labels');
AAL116_labels_no_padding=cellstr([AAL116_labels,repmat('',N_areas,1)]);

load YeoColors.mat
load yeoOrder.mat

brain_mask_file= 'EigVecs_Vox_RUN1_AAL116';
structural=niftiread([ 'SUPPLIED_FILES/mni.nii.gz']);

VVT_mean=zeros(N_areas);
load(['SUPPLIED_FILES/EigVecs_Vox_all'],'ind_voxels', 'Brain_Mask_low');
State_Volumes=zeros(Smax,size(Brain_Mask_low,1),size(Brain_Mask_low,2),size(Brain_Mask_low,3)); % needed for anatomical view
V_state=zeros(18,22,18);

% To reorder matrix plots

n_rows=4;
n_cols=5;
c_idx=1;

figure
set(gcf, 'units','normalized','OuterPosition',[0 0 0.6 1]);
f = gcf;
p = uipanel('Parent',f,'BorderType','none'); 
p.FontSize=24;
p.FontWeight='bold';
p.AutoResizeChildren = 'off';

for run=3:3 % 1:Rmax

    for mode=1:Smax
        for cond=1:1
            switch cond
                case 1
                    COND='CON';
                    kmeans=struct2array(load([CON_PROJECT 'RUN' num2str(run) '/LEiDA_Kmeans_results'],'Kmeans_results'));
                    Run_MV=struct2array(load([CON_PROJECT 'RUN' num2str(run) '/EigVecs_Vox_RUN' num2str(run) '_AAL116'], 'Mean_Vec'));
                    RunIdx=squeeze(kmeans{Cmax}.IDX);
                    
                case 2
                    COND='PAP';
                    kmeans=struct2array(load([PAP_PROJECT 'RUN' num2str(run) '/LEiDA_Kmeans_results'],'Kmeans_results'));
                case 3
                    COND='NAP';
                    kmeans=struct2array(load([NAP_PROJECT 'RUN' num2str(run) '/LEiDA_Kmeans_results'],'Kmeans_results'));
        
            end
            
            switch cond
                case 1 % CON
                    
                    switch run
                        case 1 
                            switch mode  
                                case 1
                                    centroid =kmeans{1,4,:}.C(1,:)';
                                    mean_vec = Run_MV(:,1);
                                case 2
                                    centroid =kmeans{1,4,:}.C(2,:)';
                                    mean_vec = Run_MV(:,2);
                                case 3
                                    centroid =kmeans{1,4,:}.C(4,:)';
                                    mean_vec = Run_MV(:,4);
                                case 4
                                    centroid =kmeans{1,4,:}.C(3,:)';
                                    mean_vec = Run_MV(:,3);
                                case 5
                                    centroid =kmeans{1,4,:}.C(5,:)';
                                    mean_vec = Run_MV(:,5);
                            end
                        case 2                    
                            switch mode  
                                case 2
                                    centroid =kmeans{1,4,:}.C(2,:)';
                                case 3
                                    centroid =kmeans{1,4,:}.C(5,:)';
                                case 4
                                    centroid =kmeans{1,4,:}.C(3,:)';
                                case 5
                                    centroid =kmeans{1,4,:}.C(4,:)';
                            end
                        case 3
                            switch mode  
                                case 1
                                    centroid =kmeans{1,4,:}.C(1,:)';
                                    mean_vec = Run_MV(:,1);
                                case 2
                                    centroid =kmeans{1,4,:}.C(2,:)';
                                    mean_vec = Run_MV(:,2);
                                case 3
                                    centroid =kmeans{1,4,:}.C(4,:)';
                                    mean_vec = Run_MV(:,4);
                                case 4
                                    centroid =kmeans{1,4,:}.C(3,:)';
                                    mean_vec = Run_MV(:,3);
                                case 5
                                    centroid =kmeans{1,4,:}.C(5,:)';
                                    mean_vec = Run_MV(:,5);
                            end
                        case 4
                            switch mode  
                                case 2
                                    centroid =kmeans{1,4,:}.C(2,:)';
                                case 3
                                    centroid =kmeans{1,4,:}.C(3,:)';
                                case 4
                                    centroid =kmeans{1,4,:}.C(4,:)';
                                case 5
                                    centroid =kmeans{1,4,:}.C(5,:)';
                            end
    
                     
                    end
        
        
                case 2 % PAP
                   
                    switch run
                        case 1 
                           switch mode  
                                case 2
                                    centroid =kmeans{1,4,:}.C(2,:)';
                                case 3
                                    centroid =kmeans{1,4,:}.C(4,:)';
                                case 4
                                    centroid =kmeans{1,4,:}.C(3,:)';
                                case 5
                                    centroid =kmeans{1,4,:}.C(5,:)';
                            end
    
                        case 2
                           switch mode  
                                case 2
                                    centroid =kmeans{1,4,:}.C(2,:)';
                                case 3
                                    centroid =kmeans{1,4,:}.C(3,:)';
                                case 4
                                    centroid =kmeans{1,4,:}.C(5,:)';
                                case 5
                                    centroid =kmeans{1,4,:}.C(4,:)';
                            end
    
                        case 3
                            switch mode  
                                case 2
                                    centroid =kmeans{1,4,:}.C(2,:)';
                                case 3
                                    centroid =kmeans{1,4,:}.C(4,:)';
                                case 4
                                    centroid =kmeans{1,4,:}.C(3,:)';
                                case 5
                                    centroid =kmeans{1,4,:}.C(5,:)';
                            end
                       case 4
                            switch mode  
                                case 2
                                    centroid =kmeans{1,4,:}.C(2,:)';
                                case 3
                                    centroid =kmeans{1,4,:}.C(3,:)';
                                case 4
                                    centroid =kmeans{1,4,:}.C(4,:)';
                                case 5
                                    centroid =kmeans{1,4,:}.C(5,:)';
                            end
                    end
        
                case 3 % NAP
                    switch mode  
                        case 2
                            centroid =kmeans{1,4,:}.C(2,:)';
                        case 3
                            centroid =kmeans{1,4,:}.C(3,:)';
                        case 4
                            centroid =kmeans{1,4,:}.C(4,:)';
                        case 5
                            centroid =kmeans{1,4,:}.C(5,:)';
                    end
            end
    
                        
            % set(gcf, 'units','normalized','outerposition',[.5 .5 1 1]);
            %
           
            V_state=zeros(size(Brain_Mask_low));
               
            slice_to_plot=100;

            subplot(n_rows,n_cols,c_idx,'Parent',p)     
            ax1=gca;
            
            V_state=zeros(18,22,18); % reinitialise V_state                
            V_state(ind_voxels)=mean_vec';
    
            State_Volumes(mode,:,:,:)=V_state; % needed for anatomical view
            V_state=imresize3(V_state,3);
            if mode==1
                lim=max(abs(mean_vec));
                limall=lim;
            end
            
            
            % plot side view anatomical 
            V_state=squeeze(State_Volumes(mode,:,:,:));
            V_state=imresize3(V_state,size(structural));
    %         if mode==3
    %             slice_to_plot=120;
    %         end
    
            struc_slice=squeeze(structural(slice_to_plot,:,:))';
            imagesc(struc_slice)
            axis image       
            axis off
            axis xy
            colormap(ax1,'gray')
            c=colorbar;
            c.Color='w';
    
            imAlpha=(struc_slice>0).*0.5; %
    
            ax2=axes('Parent',p);
            ax2.Position=ax1.Position;
            
         %   plot side modes
           
    
            State_slice=squeeze(V_state(slice_to_plot,:,:))';
            imagesc(State_slice,'AlphaData',imAlpha,[-limall limall])
           
            axis image
            axis off
            axis xy
            colormap(ax2,'jet')
            colorbar
            hold on
           
            % Plot axial slice
            subplot(n_rows,n_cols,c_idx+n_cols,'Parent',p)     
            c_idx=c_idx+1;
            ax1=gca;
            
            V_state=zeros(18,22,18); % reinitialise V_state        
            V_state(ind_voxels)=mean_vec';
    
            State_Volumes(mode,:,:,:)=V_state; % needed for anatomical view
            V_state=imresize3(V_state,3);
            lim=max(abs(mean_vec));
            
            % plot side view anatomical 
            V_state=squeeze(State_Volumes(mode,:,:,:));
            V_state=imresize3(V_state,size(structural));
            if mode==4
                slice_to_plot=40;
            end
            struc_slice=squeeze(structural(:,:,slice_to_plot))';
            imagesc(struc_slice)
            axis image       
    
            axis off
            axis xy
            colormap(ax1,'gray')
            c=colorbar;
            c.Color='w';
    
            imAlpha=(struc_slice>0).*0.5; %
    
            hold on
            ax2=axes('Parent',p);
            ax2.Position=ax1.Position;
            
            % plot side modes
            
            State_slice=squeeze(V_state(:,:,slice_to_plot))';
            h=imagesc(State_slice,'AlphaData',imAlpha,[-limall limall]);        
            axis image
            
            axis off
            axis xy  
            colormap(ax2,'jet')    
            colorbar
            hold on

            centroid(centroid<0.00) = 0;        
            centroid = centroid(yeoOrder);
            fc_matrix = centroid*centroid';
            
            fc_matrix(fc_matrix<0.0005) = 0; % try thresholding to reduce the connections
            blank_label=' ';
            blank_labels=cellstr([repmat(blank_label,116,1)]);
            subplot(n_rows,n_cols,c_idx+2*n_cols-1,'Parent',p)      

            circularGraph(fc_matrix,'ColorMap',YeoColors,'label',blank_labels);
            title = [COND ' RUN' num2str(run)];
        
     
        end
    end
end

set(p,'BackgroundColor','w') 
sgtitle([COND ' RUN' num2str(run) newline],'FontSize',24,'FontWeight','bold')
% need to save the fig as jpeg directly in MATLAB - no idea why this line
% does not work
saveas(gcf, ['Figures/RUN' num2str(run) '_' COND '_brains_cb' num2str(mode)],'jpeg');

