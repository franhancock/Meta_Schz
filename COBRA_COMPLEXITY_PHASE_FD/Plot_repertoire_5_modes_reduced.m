function Plot_repertoire_5_modes_reduced
%%%%%%%%
%
%  Function to plot the LEiDA as horizonetal bar plots
%
%  Joana Cabral Jan 2020
%
%	Fran Hancock Feb 2021
%  Adapted to HCPUN100 
%
%%%%%%%%%%%
% Set up the correct folders
%
PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/COBRA_COMPLEXITY_PHASE_FD/';
Smax=5;
Cmax=Smax-1;
Rmax=2;

PAR='AAL116';
Parcellation='AAL116';
N_areas=116;

load yeoOrder.mat

RSN_names = {'\psi_1','\psi_2','\psi_3','\psi_4','\psi_5'};
PSI_map=[ .7 .7 .7; 0 0 1 ; 1 0 0 ; 1 0.5 0;  0 1 1];
YeoColor = [120 18 134; 70 30 180; 0 118 14; 196 58 250; 220 248 164; 230 148 34; 205 62 78; 0 0 256; 0 0 0]./256;
Yeo_names={'VIS','SMT','DAT','VAT','LBC','FPA','DMN','SC','CB'};

Order=yeoOrder;

for run=1:Rmax
    switch run
        case 1
            load([PROJECT 'RUN1/LEiDA_for_stats.mat'], 'LT','P') 
            load([PROJECT 'RUN1/LEiDA_Kmeans_results'], 'Kmeans_results', 'rangeK')
            COND='CONTROLS';
        case 2    
            load([PROJECT 'RUN2/LEiDA_for_stats.mat'], 'LT', 'P') 
            load([PROJECT 'RUN2/LEiDA_Kmeans_results'], 'Kmeans_results', 'rangeK')
            COND='SCHZ';

    end

    VLeida=Kmeans_results{Cmax}.C;

    if run==1
        P(:,[1 2 3 4 5])=P(:,[1 2 4 3 5]);   
        LT(:,[1 2 3 4 5])=LT(:,[1 2 4 3 5]);
        VLeida([1 2 3 4 5],:)=VLeida([1 2 4 3 5],:);
     end
    %%


    Volume=struct2array(load('SUPPLIED_FILES/ParcelsMNI2mm',['V_' Parcellation]));
    Brain_Mask=niftiread('SUPPLIED_FILES/MNI152_T1_2mm_brain_mask.nii');
    scortex=smooth3(Brain_Mask>0);
        
    load AAL116_labels.mat AAL116_labels
    load Yeo_AAL116_mask 
        
    AAL116_labels_no_padding=cellstr([AAL116_labels,repmat('',N_areas,1)]);

    figure
    
    for mode=1:Smax
        subplot(4,Smax,[mode Smax+mode 2*Smax+mode])
        V=VLeida(mode,Order);
    
        V=V/max(abs(V));
        hold on
        for n=1:N_areas
            
                rsn=find(Yeo_AAL116_mask(:,Order(n))==1);
                if length(rsn)>1    
                    rsn=max(rsn);
                end
                
                barh(n,V(n),'FaceColor',PSI_map(1,:),'EdgeColor','none','Barwidth',.5)
                
                if mode==1
                   if rsn>0 
                        barh(n,V(n),'FaceColor',YeoColor(rsn,:),'EdgeColor','none','Barwidth',.5)
                    else
                       barh(n,V(n),'FaceColor',[1 1 1],'EdgeColor',[0 0 0],'Barwidth',.5)
                   end
                end
     
                if(V(n)>0)
                    if rsn>0 
                        barh(n,V(n),'FaceColor',YeoColor(rsn,:),'EdgeColor','none','Barwidth',.5)
                    else
                       barh(n,V(n),'FaceColor',[1 1 1],'EdgeColor',[0 0 0],'Barwidth',.5)
                    end
                end
        end
        set(gca,'YTick',1:N_areas,'Fontsize',8)
        if mode==1
            set(gca,'YTickLabel',AAL116_labels_no_padding(Order,:))
        else
           set(gca,'YTickLabel',[]);
        end
        set(gca,'Ydir','reverse')
        ylim([0 N_areas+1])
        xlim([-1 1])
        title({'PL Mode' ,['V_\Psi_' num2str(mode)]},'Fontsize',14)
        grid on
        
        
        %
        % plot the renderings below
        %
        V=VLeida(mode,:);
        V=V/max(abs(V));
        Centroid_Vol=zeros(size(Volume));
        % To color all areas above zero
        for n=find(V(1:116)>=0)
            Centroid_Vol(Volume==n)=1;
        end
            
        sregion=smooth3(Centroid_Vol>0);
        
        % Panel A - Render networks
        subplot(4,Smax,3*Smax+mode)
        plot_nodes_in_cortex_rsn(V,2)  
        
    
    end
    
    set(gcf, 'units','normalized','outerposition',[0 0 0.25 1]);
    
    sgtitle([PAR ' LEiDA Eigenvectors COBRE ' COND newline],'FontSize',24,'FontWeight','bold')
    saveas(gcf, ['Figures/Vectors_' COND],'jpg');
end
    

