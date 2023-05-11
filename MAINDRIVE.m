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
for files=1:3
for number=7

% Load EEG signals
clearvars -except number files sub1MI sub1MIO sub1MIS sub2MI sub2MIO sub2MIS MIfeatureplot Otherfeatureplot Selffeatureplot  ; close all 
savefeature=[];test=1;
addpath(genpath('../'))    
filename = {cat(2,'s',num2str(number),'_MI'),cat(2,'s',num2str(number),'_OtherHand'),cat(2,'s',num2str(number),'_SelfHand')};

%================================
disp(["Using" string(filename(files))])
[EEGDATA,LABELS,Info] = extraction(string(filename(files)));
[EEG,LABELS] = load_filteredEEG(string(filename(files)),[7 30]);

% %=====Randomize values===========
a=EEG;b=LABELS;

    y=[2 17 1 16 4 19 3 18 6 21 5 20 8 23 7 22 10 25 9 24 12 27 11 26 14 29 13 28 15 30];
    for i=1:30
    EEG(:,:,i)=a(:,:,y(i)); LABELS(i,:)=b(y(i),:);
    end
    clear a b i y
%================================
%========Swapping cases==========

if size(EEG,1)>=30
   EEG=permute(EEG,[2,1,3]);
end
% ================================
%%                      Leave-One-Out Crossvalidation 

% Load crossvalidation indices
nfold = 30; Nofeat = 2; indices = 1:30; Predcv = cell(nfold,1);

    for i = 1:nfold
        
        testidx = (indices == i); trainidx = ~testidx; gndtrain = LABELS(trainidx); gndtest = LABELS(testidx);
        
        % Extract CSP features 
        features = CSPfeature(EEG,trainidx,gndtrain,Nofeat); 
        
        featrain = features(trainidx,:); featest = features(testidx,:);
             
% % %         Train LDA classifier
% % %         odrIdx = rankingFisher(features(trainidx,:),gndtrain);
% % %         odrIdxsel = odrIdx(1:Nofeat); features = features(:,odrIdx);
        featrain = features(trainidx,:);featest = features(testidx,:);       
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
       %fprintf('%d-%d, ACC (training-test) %.4f-%.4f\n',1,i,acct);
       Predcv{i} = predicted;
       
       ACC(i) = acct;

     if isreal(features) == 0
         features = abs(features);
     end
     
       savefeature = cat(1,savefeature,features);

    end

        if contains(string(filename(files)),'MI')
            featplots = tsne(savefeature);
            MIfeatureplot(:,:) = featplots;
            
        elseif contains(string(filename(files)),'OtherHand')
             featplots = tsne(savefeature);
             Otherfeatureplot(:,:) = featplots;
             
        elseif contains(string(filename(files)),'SelfHand')
             featplots = tsne(savefeature);
             Selffeatureplot(:,:) = featplots;
        end

%           Evaluate accuracy
% % % % %     Pred = cell2mat(Predcv);
% % % % %     [foe,idx] = sort(indices);
% % % % %     [foe,idx] = sort(idx);
% % % % %     acctest = mean(Pred(idx) == LABELS);
% % % % %      fprintf('Run %d \t 10-fold ACC %.4f\n',1,acctest)
% % % % %  % MC Performance   

%%                  POST-PROCESSING


if contains(string(filename(files)),'MI')
    MI(number)=100*mean(ACC);
    fprintf('CSP Accuracy (%%) %2.2f +/- %2.2f\n',100*mean(ACC),std(100*ACC))
    %mean(MI)
elseif contains(string(filename(files)),'OtherHand')
    MIO(number)=100*mean(ACC);
    fprintf('CSP Accuracy (%%) %2.2f +/- %2.2f\n',100*mean(ACC),std(100*ACC))
    %mean(MIO)
elseif contains(string(filename(files)),'SelfHand')
    MIS(number)=100*mean(ACC);
    fprintf('CSP Accuracy (%%) %2.2f +/- %2.2f\n',100*mean(ACC),std(100*ACC))
    %mean(MIS)
end

%========================================================
%=======Organizing files=================================
if exist([convertStringsToChars(string(filename(files))),'_flt.mat'])==2
    try
        movefile([convertStringsToChars(string(filename(files))),'_flt.mat'],'Data set/testdata/savedfile/')
        movefile([convertStringsToChars(string(filename(files))),'_10foldidx.mat'],'Data set/testdata/savedfile/')
    end
end
%=======================================================

end
rmdir('Data set/testdata/savedfile/','s')
mkdir('Data set/testdata/savedfile/')
end
% Copyright by Anh Huy Phan and Andrzej Cichocki, 2010