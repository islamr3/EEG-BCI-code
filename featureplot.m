 function featplots = featureplot(features)
     if isreal(features) == 0
         features = abs(features);
     end

    featplots = tsne(features);



% subplot(221)
% gscatter(features(1:30,1),features(1:30,2),LABELS);
% title('Features 1 & 2')
% legend('Rest','MI task','Location','northwest','NumColumns',2)
% legend('boxoff')
% 
% subplot(222)
% gscatter(features(1:30,3),features(1:30,4),LABELS);
% title('Features 3 & 4')
% 
% subplot(223)
% gscatter(features(1:30,1),features(1:30,3),LABELS);
% title('Features 1 & 3')
% 
% subplot(224)
% gscatter(features(1:30,2),features(1:30,4),LABELS);
% title('Features 2 & 4')



end