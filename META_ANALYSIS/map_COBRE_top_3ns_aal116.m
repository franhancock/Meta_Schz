function map_COBRE_top_3ns_aal116
%
% function to map the TOP ns term to each AAL116 region
%
% Fran Hancock
% July 2022
% fran.hancock@me.com
%
PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/META_ANALYSIS/';
CondMax=3;
run=4;
Smax=5;
Cmax=Smax-1;
Rmax=4;
Thres=2; % 3.1 as for 24 topics from Marglies
Thresh_txt='2';

N_regions=116;
ntop=3;

con_col=[0 0.4470 0.7410];
pap_col=[0.9290 0.6940 0.1250];
nap_col=[1 1 1]/2;

ns=struct2array(load('neurosynth'));
lab=struct2array(load('aal116_ns_labels'));


map=table('Size',[N_regions 7],'VariableTypes',{'double';'double';'string';'double';'string';'double';'string'},'VariableNames',{'AALRegion';'Weight1';'Topic1';'Weight2';'Topic2';'Weight3';'Topic3'});


for n=1:N_regions
    [synth_sorted,Idx] = sort(ns(n,:),"descend");      
    Topic_sorted(:) = lab(Idx);

   %[what,where]=max(ns(n,:));
    map{n,'AALRegion'} = n;
    map{n,'Weight1'} = synth_sorted(1);
    map{n,'Topic1'} = Topic_sorted(1,1);
    map{n,'Weight2'} = synth_sorted(2);
    map{n,'Topic2'} = Topic_sorted(1,2);
    map{n,'Weight3'} = synth_sorted(3);
    map{n,'Topic3'} = Topic_sorted(1,3);
%         topic_list(n,:)= lab(where);
%         topic_weight(n,:) = what;
    
end

save([PROJECT 'ns_map'],"map")

% make test cloud
for cond=1:2
    figure
    switch cond
        case 1
            COND='CON_COBRE';
            COND_PROJECT=['/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/COBRA_COMPLEXITY_PHASE_FD/RUN1/' ];
        case 2
            COND='SCHZ';
            COND_PROJECT=['/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/COBRA_COMPLEXITY_PHASE_FD/RUN2/'];            

    end
        

    load([COND_PROJECT 'LEiDA_Kmeans_results.mat'],'Kmeans_results');

    VLeida=Kmeans_results{Cmax}.C;
    
    if Smax~=2
    switch cond
        case 1 % CON  % 1 4 2 3 5
              VLeida([1 2 3 4 5],:)= VLeida([1 2 4 3 5],:);

        case 2 % LO    % 1 5 2 3 4
              VLeida([1 2 3 4 5],:)= VLeida([1 2 3 4 5],:);
    end
    end
    mode_topic={};

    for mode=2:Smax
        centroids=VLeida(mode,:);
        %centroid_mask_idx=centroids > 0;
        i=1;
        for r=1:N_regions
            if centroids(1,r)>0
                mode_topic{i}=map{r,'Topic1'};
                if map{r,'Weight1'} <Thres
                    mode_weight(i)=0;
                else
                    mode_weight(i)=map{r,'Weight1'};
                end
                i=i+1;
                mode_topic{i}=map{r,'Topic2'};
                if map{r,'Weight2'} <Thres
                    mode_weight(i)=0;
                else
                    mode_weight(i)=map{r,'Weight2'};
                end
                i=i+1;
                mode_topic{i}=map{r,'Topic3'};
                if map{r,'Weight3'} <Thres
                    mode_weight(i)=0;
                else
                    mode_weight(i)=map{r,'Weight3'};
                end
                i=i+1;

            end
        end
        
        mode_map=table('Size',[size(mode_topic,2) 2],'VariableTypes',{'double';'string'},'VariableNames',{'Weight';'Topic'});

        for i=1:size(mode_topic,2)
            mode_map{i,'Topic'}=mode_topic(i);
            mode_map{i,'Weight'}=mode_weight(i);
        end
%        writetable(mode_map,[PROJECT 'results/Mode_map_R' num2str(run) '_' COND '_M' num2str(mode) '.xlsx' ],'WriteRowNames',true)
        subplot(4,1,mode-1)
        switch cond
            case 1
                wordcloud(mode_map,'Topic','Weight','Color',con_col,'HighLightColor','blue')                            
            case 2
                wordcloud(mode_map,'Topic','Weight','Color',nap_col,'HighLightColor','black')
        end
        title(['COBRE MODE ' num2str(mode) newline])
        clear mode_map;
        clear mode_topic

    end
    set(gcf, 'units','normalized','outerposition',[0 0 .15 .5]);
    set(findall(gcf,'-property','FontSize'),'FontSize',20)
    saveas(gcf,[PROJECT 'Figures/Topics3_wc_' COND '_' Thresh_txt],'jpg')
end
