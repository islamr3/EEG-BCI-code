function [EEG,WT,LABELS,f,time] = load_data(filename,featype,options)
% This function load EEG signals and their CMOR tensor. 
% 
% featype = 1   load EEG signals to extract CSP features. EEG signals will
% be filtered 
% featype > 1   load CMOR tensors to extract multilinear features
% 
% options: structure of parameters
%    .selchans:         EEG channels to be used to transform.
%    .fb:  f_b in CMOR transformation
%    .freqband  [f1 f2]: frequency range of spectral tensors or for
%                        bandpass filters
%    .freqres          : linear distance between consecutive frequencies
%                        for spectral tensors 
%    .framewidth       : frame width of time frames.
%         if framewidth == 1/Fs, Matlab function cwt will be used.
%         otherwise, the function fastwavelet.m (ERPWAVElAB) will be used.
%
% Output:
%
% EEG:  EEG signals are organized into 3-D arrays of size channels x times x
% trials. 
% WT:   CMOR spectral tensors of size frequency bins x time frames x
% channels x trials.
% LABELS: labels for trials.
% f, time:   scales and time frames in the time-frequency representation by
% CMOR.

% CMOR spectral tensor will be saved in a mat file CWT_file_f1f2_fb.mat
% 
% Anh Huy Phan, 2011
EEG = [];WT = [];f =[];time = [];LABELS = [];
featype = unique(featype);
%% Load EEG signals if using CSP for wave form
if any(featype<10) % using CSP features of wave forms
    [EEG,LABELS,Fs] = load_filteredEEG(filename,options.freqband);
    if isfield(options,'selchans')
        if ~isempty(options.selchans)
            EEG = EEG(options.selchans,:,:);
        end
    end
end
%% Load CWT data
if any(featype>=10)
    [WT,f,time,LABELS] = load_CWT_EEG(filename,options);
end