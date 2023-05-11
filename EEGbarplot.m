c = categorical({'subject1','subject2','subject4','subject5','subject6','subject7','subject8','subject9','subject10','subject15'});
C=reordercats(c,{'subject1','subject2','subject4','subject5','subject6','subject7','subject8','subject9','subject10','subject15'});

% subplot(1,2,1)
% bar(C,LOO)
% xlabel('Subjects') 
% ylabel('CSP Accuracy (%)') 
% legend('MI only','MI+Other','MI+Own');
% title('CSP Accuracy using Leave-One-Out Cross Validation');

%subplot(1,2,2)
bar(C,KFOLD)
xlabel('Subjects') 
ylabel('CSP Accuracy (%)') 
legend('MI only','MI+Other','MI+Own');
title('CSP Accuracy using 10-fold Cross Validation');
