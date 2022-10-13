function plot_mode_eigenvectors
%
% Function to plot an individuals mode eigenvector trajectories over time
% and map to the k-means centoid assigned
%
% Fran Hancock
% Aug 2022
%
% fran.hancock@kcl.ac.uk
%
PROJECT = '/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/COBRA_COMPLEXITY_PHASE_FD/';
CON_PROJECT = [PROJECT 'RUN1'];
NAP_PROJECT = [PROJECT 'RUN2'];

n_rows=27;
n_cols=1;
Cmax=4;

load([PROJECT 'SUPPLIED_FILES/YeoColors.mat'])
load([PROJECT 'SUPPLIED_FILES/yeoOrder.mat'])

cmap_region=YeoColors(yeoOrder,:);

RSN_names = {'\psi_1','\psi_2','\psi_3','\psi_4','\psi_5'};
%  YeoColor = [120 18 134; 70 30 180; 0 118 14; 196 58 250; 220 248 164; 230 148 34; 205 62 78; 0 0 256; 0 0 0]./256;
%  Yeo_names={'VIS','SMT','DAT','VAT','LBC','FPA','DMN','SC','CB'};
    
cmap=[211 211 211; 205 62 78; 196 58 250; 1 0 0 ; 120 18 134; ]./256;

mode1_txt=['MODE \psi_1'];
mode2_txt=['MODE \psi_2'];
mode3_txt=['MODE \psi_3'];
mode4_txt=['MODE \psi_4'];
mode5_txt=['MODE \psi_5'];

sub=input("Which subject (1-59) : ");

V1_con=struct2array(load([CON_PROJECT '/LEiDA_EigenVectors.mat'],'V1_all'));
V1_nap=struct2array(load([NAP_PROJECT '/LEiDA_EigenVectors.mat'],'V1_all'));

time_con=struct2array(load([CON_PROJECT  '/LEiDA_EigenVectors.mat'],'Time_sessions'));
time_nap=struct2array(load([NAP_PROJECT  '/LEiDA_EigenVectors.mat'],'Time_sessions'));

VAR_con=struct2array(load([CON_PROJECT  '/LEiDA_KOP_ALL_RUN1.mat'],'ICN_EV_ALL_MEAN'));
VAR_nap=struct2array(load([NAP_PROJECT  '/LEiDA_KOP_ALL_RUN2.mat'],'ICN_EV_ALL_MEAN'));

EV_con=struct2array(load([CON_PROJECT '/LEiDA_KOP_ALL_RUN1.mat'],'ICN_EV_ALL_AVG'));
EV_nap=struct2array(load([NAP_PROJECT '/LEiDA_KOP_ALL_RUN2.mat'],'ICN_EV_ALL_AVG'));

mode_con=struct2array(load([CON_PROJECT '/LEiDA_KOP_ALL_RUN1.mat'],'STATE_IDX'));
mode_nap=struct2array(load([NAP_PROJECT '/LEiDA_KOP_ALL_RUN2.mat'],'STATE_IDX'));

kmeans_con=struct2array(load([CON_PROJECT '/LEiDA_Kmeans_results.mat'],'Kmeans_results'));
kmeans_nap=struct2array(load([NAP_PROJECT '/LEiDA_Kmeans_results.mat'],'Kmeans_results'));

idx_con=kmeans_con{1,4}.IDX(time_con==sub);
idx_nap=kmeans_nap{1,4}.IDX(time_nap==sub);

sub_V1_con=V1_con(time_con==sub,:);
sub_V1_nap=V1_nap(time_nap==sub,:);

sub_VAR_con=(VAR_con(sub,:,Cmax));
sub_VAR_nap=(VAR_nap(sub,:,Cmax));

sub_EV_con=squeeze(EV_con(sub,:,Cmax,:));
sub_EV_nap=squeeze(EV_nap(sub,:,Cmax,:));

Tslices_con=size(sub_V1_con,1);
Tslices_nap=size(sub_V1_nap,1);

% swap around the modes for CON 


figure
%
% first plot CON
%


ax=subplot(n_rows,n_cols,[1 7]);

for mode=1:Cmax+1

    ax.ColorOrder = cmap;
    mode_sub_V1_con=sub_V1_con(:,mode_con{mode}.idx);
    
    if mode==1
        for t=1:size(idx_con,2)
            % calculate the 'magnetization' ratio P Hellyer
            %
            magRatio(:,t) = (size(find(mode_sub_V1_con(t,:)>=0)))/(size(find(mode_sub_V1_con(t,:)<0)));
        end
    end
 % for i=1:size(cmap_region(mode_con{mode}.idx(1,:),:),1)
        hold on
        plot(sub_EV_con(mode,:),'LineWidth',2)

end
xlim([1 Tslices_con])
xticks(0:20:440)
ylim([-0.15 0.15])
yticks([-0.15 0 0.15])
yline(0,'-.')
hy=ylabel('Mean cos(\Delta\omega)','FontSize',18,'FontWeight','bold');
hy.Position(1)=-4;

%title(['RUN ' num2str(run) ' CONTROL SUB ' num2str(sub) ' Mode Eigenvector timeseries VAR=' num2str(sub_VAR_con(1),'%.3f')],'FontSize',18);
title(['Cobre CONTROL SUB ' num2str(sub)],'FontSize',18);

%ubplot(n_rows,n_cols,[8 (n_rows)/2 - 2])
subplot(n_rows,n_cols,[9 10])
plot(magRatio,'Color','k','LineWidth',1)

xlim([1 Tslices_con])
xticks([])
ylim([0 1.10])

hy=ylabel('MAG','FontSize',18,'FontWeight','bold');
hy.Position(1)=-4;

subplot(n_rows,n_cols, 11 )
%subplot(n_rows,n_cols, (n_rows)/2 -1 )
plot(1:Tslices_con,1)
ymax=1;
xlim([1 Tslices_con])
yticklabels([])
xticks([])
xticklabels([])

hy=ylabel(['M'],'FontSize',18,'FontWeight','bold');
hy.Position(1)=-4;
hy.Position(2)=0.5;


for t=1:Tslices_con
    x=[t t+1 t+1 t];
    y=[0 0 ymax ymax];
    p=patch(x,y,'r');

    switch idx_con(t)
        case 1
            reIdx=1;
        case 2
            reIdx=2;
        case 3
           reIdx=4;
        case 4
            reIdx=3;
        case 5
            reIdx=5;
    end
    set(p,'LineStyle','none','FaceColor',cmap(reIdx,:));
end

%
% now plot NAP
%


ax=subplot(n_rows,n_cols,[15 21]);
for mode=1:Cmax+1

    ax.ColorOrder = cmap;
    mode_sub_V1_nap=sub_V1_nap(:,mode_nap{mode}.idx);
    
    if mode ==1
        for t=1:size(idx_con,2)
            % calculate the 'magnetization' ratio P Hellyer
            %
            magRatio(:,t) = (size(find(mode_sub_V1_nap(t,:)>=0)))/(size(find(mode_sub_V1_nap(t,:)<0)));
        end
    end
    hold on
    plot(sub_EV_nap(mode,:),'LineWidth',2)

end

xlim([1 Tslices_nap])
xticks(0:20:440)
ylim([-0.15 0.15])
yticks([-0.15 0 0.15])
yline(0,'-.')
hy=ylabel('Mean cos(\Delta\omega)','FontSize',18,'FontWeight','bold');
hy.Position(1)=-4;
%title(['RUN ' num2str(run) ' NAP SUB ' num2str(sub) ' Mode Eigenvector timeseries VAR=' num2str(sub_VAR_nap(1),'%.3f')],'FontSize',18);
title(['Cobre NAP SUB ' num2str(sub)],'FontSize',18);


subplot(n_rows,n_cols, [23 24])
plot(magRatio,'Color','k','LineWidth',1)
xlim([1 Tslices_con])
xticks([])
ylim([0 1.10])
hy=ylabel('MAG','FontSize',18,'FontWeight','bold');
hy.Position(1)=-4;

subplot(n_rows,n_cols, 25)
plot(1:Tslices_nap,1)
ymax=1;
xlim([1 Tslices_nap])
xticks([])
xticklabels([])
yticklabels([])
xticks([])
hy=ylabel(['M'],'FontSize',18,'FontWeight','bold');
hy.Position(1)=-4;
hy.Position(2)=0.5;


for t=1:Tslices_nap
    x=[t t+1 t+1 t];
    y=[0 0 ymax ymax];
    p=patch(x,y,'r');

    switch idx_nap(t)
        case 1
            reIdx=1;
        case 2
            reIdx=2;
        case 3
           reIdx=3;
        case 4
            reIdx=4;
        case 5
            reIdx=5;
    end
    set(p,'LineStyle','none','FaceColor',cmap(reIdx,:));
end

subplot(n_rows,n_cols,27)
text(0,1,mode1_txt, 'Color', cmap(1,:), 'FontSize', 18,'FontWeight','b')
text(0.05,1,mode2_txt, 'Color', cmap(2,:), 'FontSize', 18,'FontWeight','b')
text(0.1,1,mode3_txt, 'Color', cmap(3,:), 'FontSize', 18,'FontWeight','b')
text(0.15,1,mode4_txt, 'Color', cmap(4,:), 'FontSize', 18,'FontWeight','b')
text(0.2,1,mode5_txt, 'Color', cmap(5,:), 'FontSize', 18,'FontWeight','b')

axis off

set(gcf, 'units','normalized','outerposition',[0 0 1 .5]);
saveas(gcf,[PROJECT 'Figures/EIGS/mode_eigenvectors_sub_' num2str(sub)],'jpeg')
