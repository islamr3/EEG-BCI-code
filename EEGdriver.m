%%                      CSP analysis for Clyde's project

% Datasets consists of 15 trials of BCI EEG motor
% imagery for subjects. All EEG signals were recorded in a duration of 3
% seconds at a sampling frequency of 256 Hz over 26 channels by gTec. Each
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
% EEG signals first go through a bandpass filter (7-30 Hz).
 
for number=[1 2 4 5 6 7 8 9 10 11 12 13 14 15]

% Load EEG signals
clearvars -except number MI MIO MIS MIfeatureplot Otherfeatureplot Selffeatureplot  ; close all 

test=1;
%cv='KFOLD';
cv='LOO';
% parallel_on
addpath(genpath('../'))
%========Choosing what datasets to use===========
if test ==1
    
           filename = ['s',num2str(number),'_MI'];
%           filename = ['s',num2str(number),'_OtherHand'];
%           filename = ['s',num2str(number),'_SelfHand'];
      
else
    %filename = 'SubA_6chan_2LR_s1'; % filename (subject)
    %filename = 's1_MI';
    %filename = 's1_OtherHand';
    %filename = 's1_SelfHand';
end
%================================
disp(["Using" filename])
[EEGDATA,LABELS,Info] = extraction(filename,test);
[EEG,LABELS] = load_filteredEEG(filename,[7 30]);

% %=====Randomize values===========
a=EEG;
b=LABELS;

    y=[1 16 2 17 3 18 4 19 5 20 6 21 7 22 8 23 9 24 10 25 11 26 12 27 13 28 14 29 15 30];
    for i=1:30
    EEG(:,:,i)=a(:,:,y(i));    
    LABELS(i,:)=b(y(i),:);
    end
    clear a b i y


%================================
%=====Swapping cases=============

if size(EEG,1)>=30
   EEG=permute(EEG,[2,1,3]);
end
% ================================

if strcmpi('KFOLD',cv)
     %%                 Ten-fold Crossvalidation Analysis

% Indices for 10-fold cross-validation can be randomly generated. However,
% in order to a fair comparison with other methods, those indices were
% generated and saved in a "_Kfoldidx.mat" file. We can delete this file,
% and generate another file for Monte-Carlo analysis.

% Load crossvalidation indices
    nfold = 10;
    NoMC = 10;
    Nofeat = 2;
    Kfoldidx = load_CV_idxs(filename,nfold,LABELS);


 % Monte-Carlo repetitions of cross-validation analyses.
    for ktrial = 1:NoMC
        indices = Kfoldidx(:,ktrial);
        %indices = kfoldcv(LABELS,nfold);
        Predcv = cell(nfold,1);

    %% 10-fold crossvalidation
        for i = 1:nfold
            testidx = (indices == i); 
            trainidx = ~testidx;
            gndtrain = LABELS(trainidx); 
            gndtest = LABELS(testidx);
        
        % Extract CSP features 
            features = CSPfeature(EEG,trainidx,gndtrain,Nofeat);
            featrain  = features(trainidx,:); 
            featest = features(testidx,:);
            features = tsne(features);        
            
%        Train LDA classifier
            odrIdx = rankingFisher(features(trainidx,:),gndtrain);
% %         odrIdxsel = odrIdx(1:Nofeat);
            features = features(:,odrIdx);
            featrain  = features(trainidx,:);
            featest = features(testidx,:);
            [predicted,err] = classify(featest,featrain,gndtrain');
        %[predicted] = knnclassify(featest,featrain,gndtrain',3,'cosine');
            acct = mean(predicted == gndtest);             
        % training accuracy
%         predicted = classify(modelLDA',featest,gndtest);
%         acc = mean(predicted == gndtest);                   
% test accuracy
            %%%fprintf('%d-%d, ACC (training-test) %.4f-%.4f\n',ktrial,i,acct);
            Predcv{i} = predicted;
        end
    % Evaluate accuracy
        Pred = cell2mat(Predcv);
        [foe,idx] = sort(indices);
        [foe,idx] = sort(idx);
        acctest = mean(Pred(idx) == LABELS);
       % fprintf('Run %d \t 10-fold ACC %.4f\n',ktrial,acctest)
        ACC(ktrial) = acctest;

    end   
%MC Performance
    %fprintf('CSP Accuracy (%%) %2.2f +/- %2.2f\n',100*mean(ACC),std(100*ACC))

elseif strcmpi('LOO',cv)
%% =====================Leave-One-Out Crossvalidation=========================
% Load crossvalidation indices
nfold = 30;
Nofeat = 2;

    indices = 1:30;
    %indices = kfoldcv(LABELS,nfold);
    Predcv = cell(nfold,1);

    for i = 1:nfold
        
        testidx = (indices == i);
        trainidx = ~testidx;
        gndtrain = LABELS(trainidx); 
        gndtest = LABELS(testidx);
        
        % Extract CSP features 
        features = CSPfeature(EEG,trainidx,gndtrain,Nofeat);       
        featrain  = features(trainidx,:); 
        featest = features(testidx,:);
        
        
% % % %        Train LDA classifier
% % %         odrIdx = rankingFisher(features(trainidx,:),gndtrain);
% % % % %         odrIdxsel = odrIdx(1:Nofeat);
% % %         features = features(:,odrIdx);
        featrain  = features(trainidx,:);
        featest = features(testidx,:);       
        [predicted,err] = classify(featest,featrain,gndtrain');
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Mdl = fitcdiscr(featrain, gndtrain);
        resultLabels = predict(Mdl, featest);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %[predicted] = knnclassify(featest,featrain,gndtrain',3,'cosine');
        acct = mean(resultLabels == gndtest);  
        % training accuracy
%         predicted = classify(modelLDA',featest,gndtest);
%         acc = mean(predicted == gndtest);                   
% test accuracy
%        fprintf('%d-%d, ACC (training-test) %.4f-%.4f\n',1,i,acct);
%        Predcv{i} = predicted;
        ACC(i) = acct;

    end
    % Evaluate accuracy
% % % % %     Pred = cell2mat(Predcv);
% % % % %     [foe,idx] = sort(indices);
% % % % %     [foe,idx] = sort(idx);
% % % % %     acctest = mean(Pred(idx) == LABELS);
% % % % %      fprintf('Run %d \t 10-fold ACC %.4f\n',1,acctest)
% % % % %  % MC Performance   
 
end
%%                  POST-PROCESSING


if contains(filename,'MI')
    MI(number)=100*mean(ACC);
    fprintf('CSP Accuracy (%%) %2.2f +/- %2.2f\n',100*mean(ACC),std(100*ACC))
    %mean(MI)
elseif contains(filename,'OtherHand')
    MIO(number)=100*mean(ACC);
    fprintf('CSP Accuracy (%%) %2.2f +/- %2.2f\n',100*mean(ACC),std(100*ACC))
    %mean(MIO)
elseif contains(filename,'SelfHand')
    MIS(number)=100*mean(ACC);
    fprintf('CSP Accuracy (%%) %2.2f +/- %2.2f\n',100*mean(ACC),std(100*ACC))
    %mean(MIS)
end

%========================================================
%=======Organizing files=================================
if test==1 && exist([filename,'_flt.mat'])==2
    try
        movefile([filename,'_flt.mat'],'Data set/testdata/savedfile/')
        movefile([filename,'_10foldidx.mat'],'Data set/testdata/savedfile/')
    end
end
%=======================================================

end
%  if contains(filename,'s1_MI') || contains(filename,'s1_OtherHand') || contains(filename,'s1_SelfHand')==1
%     figure(3);gscatter(features(1:30,1),features(1:30,2),LABELS);
%  end
%     try
%         MI(:);
%         mean(MI)
%     end
%     try
%         MIO(:);
%         mean(MIO)
%     end
%     try
%         MIS(:);
%         mean(MIS)
%     end
% Copyright by Anh Huy Phan and Andrzej Cichocki, 2010
rmdir('Data set/testdata/savedfile/','s')
mkdir('Data set/testdata/savedfile/')