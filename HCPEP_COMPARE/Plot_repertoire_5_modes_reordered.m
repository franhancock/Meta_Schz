function Plot_repertoire_5_modes_reordered
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

Smax=5;
Cmax=Smax-1;
CondMax=3;
n_rows=7;

PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_COMPARE/';
Rmax=4;

PAR='AAL116';
Parcellation='AAL116';
load yeoOrder.mat

for cond=1:CondMax

    switch cond
        case 1
            COND='CON';
        case 2
            COND='PAP';
        case 3
            COND='PAP';
    end

    for run=1:Rmax

        load(['/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_' COND '/RUN' num2str(run) '/LEiDA_for_stats.mat'],'LT', 'P'); 
        load (['/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/HCPEP_' COND '/RUN' num2str(run) '/LEiDA_Kmeans_results'],'Kmeans_results');
        
        %
        % Reorder the modes as in the stats modules CON
        %
        % Run 1: 1 2 4 3 5
        % Run 2: 1 2 5 3 4
        % Run 3: 1 2 4 3 5
        % Run 4: 1 2 3 4 5

                %
        % Reorder the modes as in the stats modules PAP
        %
        % Run 1: 1 2 4 3 5
        % Run 2: 1 2 3 5 4
        % Run 3: 1 2 4 3 5
        % Run 4: 1 2 3 4 5
    
        VLeida=Kmeans_results{Cmax}.C;


        switch cond
            case 1 % CON
                switch run
                    case 1 
                        VLeida([3 4],:)= VLeida([4 3],:);
                    case 2
                        VLeida([3 4 5],:)= VLeida([5 3 4],:);
                    case 3
                        VLeida([3 4],:)= VLeida([4 3],:);
                    case 4
                        VLeida=VLeida;
                end
                        
            case 2 % PAP
                    case 1 
                        VLeida([3 4],:)= VLeida([4 3],:);
                    case 2
                        VLeida([4 5],:)= VLeida([5 4],:);
                    case 3
                        VLeida([3 4 ],:)= VLeida([4 3],:);
                    case 4
                        VLeida=VLeida;
                
            case 3 % NAP
                VLeida=VLeida;
        end
            
        
        RSN_names = {'\psi_1','\psi_2','\psi_3','\psi_4','\psi_5'};
        PSI_map=[ .7 .7 .7; 0 0 1 ; 1 0 0 ; 1 0.5 0;  0 1 1];
        YeoColor = [120 18 134; 70 30 180; 0 118 14; 196 58 250; 220 248 164; 230 148 34; 205 62 78; 0 0 256; 0 0 0]./256;
        Yeo_names={'VIS','SMT','DAT','VAT','LBC','FPA','DMN','SC','CB'};
            
        %%
        N_areas=116;
    %     Order=[1:2:N_areas N_areas:-2:2];
        Order=yeoOrder;
    
        Volume=struct2array(load('SUPPLIED_FILES/ParcelsMNI2mm',['V_' Parcellation]));
        Brain_Mask=niftiread('SUPPLIED_FILES/MNI152_T1_2mm_brain_mask.nii');
        scortex=smooth3(Brain_Mask>0);
            
        load(['SUPPLIED_FILES/AAL116_labels.mat'], 'AAL116_labels');
        load(['SUPPLIED_FILES/Yeo_AAL116_mask']); 
        
        
        AAL116_labels_no_padding=cellstr([AAL116_labels,repmat('',N_areas,1)]);
        
        
        figure
        
        for mode=1:Smax
            subplot(n_rows,Smax,[mode Smax+mode 4*Smax+mode])
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
        end
%             %
%             % Plot OCC and DUR
%     
%             % Plot Occupancy bars
%             subplot(n_rows,Smax,5*Smax+mode)
%             Pc=squeeze(P(:,Cmax,mode));  % Vector containing Prob of mode
%             
%             bar([mean(Pc) ],'EdgeColor','w','FaceColor',[.5 .5 .5])
%             hold on
%             % Error bar containing the standard error of the mean
%             errorbar([mean(Pc)],[std(Pc)/sqrt(numel(Pc)) ],'LineStyle','none','Color','k')
%             set(gca,'XTickLabel',[],'Fontsize',10)
%             %xtickangle(60)
%             if mode==1
%                 ylabel('Occurrence')
%                 
%             end
%             ylim([0 0.4])
%             box off
%     %         xlim([0.3 2.8])
%             
%             % Plot Lifetime Bars
%             subplot(n_rows,Smax,6*Smax+mode)
%             Lc=squeeze(LT(:,Cmax,mode));  % Vector containing Prob of c
%             
%             bar([mean(Lc)],'EdgeColor','w','FaceColor',[.5 .5 .5])
%             hold on
%             % Error bar containing the standard error of the mean
%             errorbar([ mean(Lc)],[std(Lc)/sqrt(numel(Lc))],'LineStyle','none','Color','k')
%             set(gca,'XTickLabel',[],'Fontsize',10)
%             %xtickangle(60)
%             if mode==1
%                 ylabel('Duration (s)')            
%             end
%             ylim([0 15])
%     %         xlim([0.3 2.8])
%             box off
%             
  
        set(gcf, 'units','normalized','outerposition',[0 0 0.3 1]);
        
        sgtitle(['HCPEP CONDITION ' COND ' RUN' num2str(run) ' Eigenvectors' newline],'FontSize',24,'FontWeight','bold')
        saveas(gcf, ['Figures/' COND '_RUN' num2str(run) '_Vectors'],'jpg');
    end
end

