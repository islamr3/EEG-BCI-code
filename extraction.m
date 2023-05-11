function [EEGDATA,LABELS,Info] =extraction(filename)
load(filename);

Restdata = data(:,1:400,:);
MIdata = data(:,1001:1400,:);   
EEGDATA=cat(3,Restdata, MIdata);
LABELS=[1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2];
clear Restdata MIdata
Info.srate = 256;
Info.class = {'Rest', 'MI'};
Info.channels={'Fp1','Fp2', 'AF3', 'F3', 'Fz', 'F4', 'FC5', 'FC1', 'FC2', 'FC6', 'T7', 'C3', 'Cz','C4', 'T8', 'CP5', 'CP1', 'CP2', 'CP6', 'P3', 'Pz', 'P4', 'PO3', 'PO4', 'O1', 'O2' };
    save(['Data set/testdata/',convertStringsToChars(filename)],'LABELS','EEGDATA','Info','data')
end