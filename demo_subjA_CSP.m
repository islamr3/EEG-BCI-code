%% CSP for Subject A

% Dataset 'SubA_6chan_2LR_s1' consists of 130 trials of BCI EEG motor
% imagery for subject A. All EEG signals were recorded in a duration of 3
% seconds at a sampling frequency of 256 Hz over 6 channels by gTec. Each
% trial was assigned a label according to left or right hand motor imagery.
%
% This example uses CSP to extract spatial features and trains an LDA
% classifier to classify the test data. The 10-fold cross-validation is
% employed for 10 runs to evaluate classification accuracy for this
% dataset.
% 
% Two projected (spatial) filters will be estimated for each class. That
% means there are four spatial filters for left- and righ-hand motor
% imageries to give 4 features for EEG signals in a trial.
%
% EEG signals first go through a bandpass filter (8-30 Hz).

% Load EEG signals
clear all; close all
% parallel_on
addpath(genpath('../'))

filename = 'SubA_6chan_2LR_s1'; % filename (subject)

%filename = 's1_MI';

%filename = 's1_OtherHand';

%filename = 's1_SelfHand';

disp(["Training in ", filename])
%[EEGDATA, Restdata, MIdata,LABELS] = extraction(filename) 
[EEG,LABELS] = load_filteredEEG(filename,[7 30]);



%% Ten-fold Crossvalidation Analysis
%
% Indices for 10-fold cross-validation can be randomly generated. However,
% in order to a fair comparison with other methods, those indices were
% generated and saved in a "_Kfoldidx.mat" file. We can delete this file,
% and generate another file for Monte-Carlo analysis.
% 

% Load crossvalidation indices
Nofeat = 2;
nfold=10;
Kfoldidx = load_CV_idxs(filename,nfold,LABELS);

% Monte-Carlo repetitions of cross-validation analyses.
for ktrial = 1:10
    indices = kfoldcv(LABELS,nfold);
    Predcv = cell(nfold,1);
    
    testidx = (indices == ktrial);
    trainidx = ~testidx ;
    gndtrain = LABELS(trainidx); 
    gndtest = LABELS(testidx);

    % Extract CSP features 
    features = CSPfeature(EEG,trainidx,gndtrain,Nofeat);
    featrain  = features(trainidx,:); featest = features(testidx,:);

%        Train LDA classifier
    odrIdx = rankingFisher(features(trainidx,:),gndtrain);
% %         odrIdxsel = odrIdx(1:Nofeat);
    features = features(:,odrIdx);
    featrain  = features(trainidx,:); featest = features(testidx,:);
    [predicted,err] = classify(featest,featrain,gndtrain');
    %[predicted] = knnclassify(featest,featrain,gndtrain',3,'cosine');
    acct = mean(predicted == gndtest);             % training accuracy
%         predicted = classify(modelLDA',featest,gndtest);
%         acc = mean(predicted == gndtest);                   % test accuracy
    fprintf('%d-%d, ACC (training-test) %.4f-%.4f\n',ktrial,i,acct);
    Predcv{ktrial} = predicted;
end
    % Evaluate accuracy
    Pred = cell2mat(Predcv);
    [foe,idx] = sort(indices); 
    [foe,idx] = sort(idx);
    acctest = mean(Pred(idx) == LABELS);
    fprintf('Run %d \t 10-fold ACC %.4f\n',ktrial,acctest)
    ACC(ktrial) = acctest;


% MC Performance
fprintf('CSP Accuracy (%%) %2.2f +/- %2.2f\n',100*mean(ACC),std(100*ACC))

% Copyright by Anh Huy Phan and Andrzej Cichocki, 2010