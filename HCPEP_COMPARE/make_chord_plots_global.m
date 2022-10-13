function make_chord_plots
%
% Function to make mode chord plots
% Fran Hancock
% July 2022
% fran.hancock@kcl.ac.uk
%
PROJECT = '/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_COMPARE/';

Rmax=4;
CondMax=3;
N_areas=116;
Smax=5;

CON_PROJECT = '/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_CON/';
PAP_PROJECT = '/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_PAP/';
NAP_PROJECT = '/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_NAP/';

con_subj=53;
pap_subj=30;
nap_subj=82;


load(['SUPPLIED_FILES/AAL116_labels.mat'], 'AAL116_labels');
AAL116_labels_no_padding=cellstr([AAL116_labels,repmat('',N_areas,1)]);

load YeoColors.mat
load yeoOrder.mat
n_rows=1;
n_cols=1;



for run=1:Rmax % 1:Rmax

    for mode=2:Smax
        for cond=1:CondMax
            switch cond
                case 1
                    COND='CON';
                    kmeans=struct2array(load([CON_PROJECT 'RUN' num2str(run) '/LEiDA_Kmeans_results'],'Kmeans_results'));
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
                                    centroid =kmeans{1,4,:}.C(5,:)';
                                case 4
                                    centroid =kmeans{1,4,:}.C(3,:)';
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
    
    
    %        centroid =kmeans{1,4,:}.C(3,:)';
            centroid(centroid<0.00) = 0;        
            centroid = centroid(yeoOrder);
            fc_matrix = centroid*centroid';
            
            fc_matrix(fc_matrix<0.000) = 0; % try thresholding to reduce the connections
    
            figure
            subplot(n_rows,n_cols,1)
            circularGraph(fc_matrix,'label',AAL116_labels_no_padding(yeoOrder),'ColorMap',YeoColors);
            title = [COND ' RUN' num2str(run)];
    
            set(gcf, 'units','normalized','outerposition',[0 0 .5 .5]);
    
            sgtitle([COND ' RUN' num2str(run) ' Coupling in Mode ' num2str(mode) newline],'FontSize',24,'FontWeight','bold')
            saveas(gcf, ['Figures/RUN' num2str(run) '_' COND '_Coupling_mode' num2str(mode) '_0005'],'jpg');
     
        end
    end
end

close all

