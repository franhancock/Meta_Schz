function evaluate_clustering
%
%   Function to evaluate the clustering results from the 1821 voxel space
%
%
% I would have to recluster to 2-10 to do this
%
PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/COBRA_COMPLEXITY_PHASE_FD/';
HCP_PROJECT=[PROJECT 'RUN2/'];
Cmax=9; % only clustered 2-10 for RUN1

plot_only=1;

if plot_only==1
    load([PROJECT 'Eval_10_R2_results.mat'],'evaSilh_clusters')
    figure
    plot(1:Cmax,evaSilh_clusters(1:Cmax),'k','LineWidth',4)
    ylabel('Silhouette Value'); xlabel('# of clusters');
    set(gca, 'FontSize',18)
    set(gcf, 'units','normalized','outerposition',[0 0 .23 .3]);
    saveas(gca,[PROJECT 'Figures/Silhoutte_plot'],'jpeg')
else
    load([HCP_PROJECT 'LEiDA_EigenVectors.mat'], 'V1_all' )
    load([HCP_PROJECT 'LEiDA_Kmeans_results.mat'], 'Kmeans_results' )
    
    for k=1:Cmax
        clust=Kmeans_results{k}.IDX;
    
        eva=evalclusters(V1_all,clust','Silhouette','Distance','Cosine');
        evaSilh_clusters(k) = eva.CriterionValues;
    
    end
    
    save(['Eval_' num2str(Cmax+1) '_R2_results.mat'], 'evaSilh_clusters');
end

