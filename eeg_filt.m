function EEG = eeg_filt(EEGDATA,Fs,freqband)
% Ref: use function "load_filteredEEG" to filter EEG signals.
% The results will be saved to be reloaded for later analysis.
[B,A] = butter(3,freqband/Fs*2);  % freqband = [f1 f2]
for i=1:size(EEGDATA,3)
    EEG(:,:,i) = filtfilt(B,A,double(EEGDATA(:,:,i)))';
end
