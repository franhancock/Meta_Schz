function parcellate

%
% Function to 
% - Load BOLD data in MNI space
% - Load the AAL template
%
% Origianl code
% Joana Cabral 
% joana.cabral@med.uminho.pt
%
% Adapted Fran Hancock
% fran.hancock@kcl.ac.uk
%
% November 2021
%
%
%%%%%%%
PROJECT='/Users/HDF/Dropbox/Fran/Academics/PhD/matlab/projects/COBRA_COMPLEXITY_PHASE/';

HCP_MAT_DATA=[PROJECT 'COBRE_MAT_R'];
HCP_DATA='~/DATA/COBRA_SCHZ/4197885/'; % directory with the EP nifti processed files

Parcellation='AAL116';
PAR='AAL116';
N_areas=116;

CondMax=2;

for cond=1:CondMax
    switch cond
        case 1
            COND='CONTROLS';
            subjects=struct2array(load('CON_SUBS'));
            n_Subjects=size(subjects);
        case 2
            COND='SCHZ';
            
            subjects=struct2array(load('SCHZ_SUBS'));
            n_Subjects=size(subjects);
    end           
    
    status=mkdir([HCP_MAT_DATA num2str(cond)]); % make the new directory

    save_folder=[HCP_MAT_DATA num2str(cond) '/'];

    V_Parcel=struct2array(load('ParcelsMNI2mm',['V_' Parcellation])); 
    sz=size(V_Parcel);


    for s=1:n_Subjects
       
            imagefile=([HCP_DATA COND '/fmri_00' num2str(subjects(s)) '_2mm.nii.gz']);

            disp([' - Subject ' num2str(s)])
            if isfile(imagefile)
                BOLD_MNI=double(niftiread(imagefile));

                T=size(BOLD_MNI,4);                           
                BOLD_AAL=zeros(N_areas,T);

                for n=1:N_areas

                    ind_voxels=find(V_Parcel==n);

                    for v=1:numel(ind_voxels)
                        [I1,I2,I3] = ind2sub(sz,ind_voxels(v));

                         if ~isnan(BOLD_MNI(I1,I2,I3,1))
                              BOLD_AAL(n,:)= BOLD_AAL(n,:) + squeeze(BOLD_MNI(I1,I2,I3,:))';                                                  
                         end
                    end
                    BOLD_AAL(n,:)= BOLD_AAL(n,:)/numel(ind_voxels);
                    BOLD_AAL(n,:)=BOLD_AAL(n,:)-mean(BOLD_AAL(n,:));
                 end
                  save([save_folder 'AAL_Sub-00' num2str(subjects(s))],'BOLD_AAL')
                  disp(s);        
            end
        end
end    

