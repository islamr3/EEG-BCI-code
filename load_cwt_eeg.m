function [WT,Fa,time,LABELS] = load_cwt_eeg(filename,options)
% This function transforms EEG signals to CWT data, or load CWT spectral
% tensors if they are already availble.
% 
% options: structure of parameters
%    .selchans:         EEG channels to be used to transform.
%    .fb:  f_b in CMOR transformation
%    .freqband  [f1 f2]: frequency range of spectral tensors
%    .freqres          : linear distance between consecutive frequencies
%                        for spectral tensors 
%    .framewidth       : frame width of time frames.
%         if framewidth == 1/Fs, Matlab function cwt will be used.
%         otherwise, the function fastwavelet.m (ERPWAVElAB) will be used.
% 
% CMOR spectral tensor will be saved in a mat file CWT_file_f1f2_fb.mat
%
% Anh Huy Phan, 2011

cwtfile = sprintf('CWT_%s_f%d%d_b%.0d.mat',filename,options.freqband(1),...
    options.freqband(2),options.fb);
if exist(cwtfile,'file')~=2
    load(filename)
    if exist('Fs','var') ~= 1 
        if exist('Info','var') == 1 
            Fs = Info.srate;
        elseif exist('nfo','var') == 1 
            Fs = nfo.fs;
        elseif exist('fs','var') == 1 
            Fs = fs;
        end
    end
    if exist('EEGDATA','var')==1
        EEG = EEGDATA; clear EEGDATA;
    end
    if isfield(options,'selchans')
        if ~isempty(options.selchans)
            EEG = EEG(options.selchans,:,:);
        end
    end
   
    %[EEG,LABELS,Fs] = load_filteredEEG(filename,options.freqband);
    EEG = bsxfun(@minus,EEG,mean(EEG,2));
    [Nch, Nsamples,Ntrials] = size(EEG);
    
    Fa = options.freqband(1):options.freqres:options.freqband(2); 
    Fc = 1;scales = Fc*Fs./Fa;
    
    %options.framewidth = 1/Fs;
    time =  1:ceil(Fs * options.framewidth):Nsamples; % frame width 20mseconds
    
    WT = nan(numel(Fa),numel(time),Nch,Ntrials);
    for k =1:Ntrials
        if options.framewidth == 1/Fs;
            try 
                wname = sprintf('cmor%d-%d',2*options.fb^2,1);
                for kch = 1:Nch
                    WT(:,:,kch,k) = abs(cwt(EEG(kch,:,k)',scales,wname));
                end
            catch
                WT(:,:,:,k) = abs(fastwavelet(EEG(:,:,k)',scales,'cmor',options.fb, time));
            end
        else
            WT(:,:,:,k) = abs(fastwavelet(EEG(:,:,k)',scales,'cmor',options.fb, time));
        end
    end
    % SAVE WT
    save(cwtfile,'WT','Fa','time','LABELS')
else
    load(cwtfile);
    if ~isreal(WT),   WT = abs(WT); end
    if exist('time','var') ~= 1
       if exist('tim','var') == 1 
           time = tim;
       end
    end 
end