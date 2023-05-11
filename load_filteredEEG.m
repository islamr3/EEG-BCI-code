function [EEG,LABELS,Fs] = load_filteredEEG(filename,freqband)
% File filename consists of EEG signals saved as a 3-D tensor channels x
% times x trials.
% f: frequency band
% Copyright by Anh Huy Phan, 2010
% if contains==1
%     erase(filename,'testdata/')
%end

fn = sprintf('%s_flt.mat',filename);
if exist(fn,'file')~=2
    load(filename)
    if exist('Fs','var') ~= 1 
        if exist('Info','var') == 1 
            Fs = Info.srate;
        elseif exist('Info','var') == 1 
            Fs = Info.fs;
        elseif exist('fs','var') == 1 
            Fs = fs;
        end
    end
    if exist('EEGDATA','var') == 1 
        EEG = eeg_filt(EEGDATA,Fs,freqband);
    elseif exist('EEG','var') == 1
        EEG = eeg_filt(EEG,Fs,freqband);
    end
    
    save(fn,'EEG','LABELS','Fs')
else
    load(fn)
    if (exist('EEG','var') ~= 1) && (exist('EEGDATA','var') == 1)
        EEG = EEGDATA;
    end
end