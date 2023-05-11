%%                ERD RESPONSE LINE PLOT
addpath(genpath('../'))
load('s1_MI.mat', 'data')
MIEEG = data;
load('s1_OtherHand.mat', 'data')
OTHEREEG = data;
load('s1_SelfHand.mat', 'data')
SELFEEG = data;

ch =1;
% MIERD = erd(ch,MIEEG);
% OTHERERD = erd(ch,OTHEREEG);
% SELFERD = erd(ch,SELFEEG);
% legend('MI only','MI+OtherAO','MI+OwnAO')
% ylabel('ERD Power (dB)')
% xlabel('time (s)')

%%                 FEATURE SCATTER PLOT
offset=0;
x=1+offset:30+offset;

subplot(321)

gscatter(sub1MI(x,1), sub1MI(x,2),cat(1,LABELS));
%,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS));
title('MI only')
xlabel('Feature 2')
ylabel('Feature 1')
legend('off')

subplot(323)
gscatter(sub1MIO(x,1),sub1MIO(x,2),cat(1,LABELS));
%,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS));
title('MI + Other Hand')
xlabel('Feature 2')
ylabel('Feature 1')
legend('off')

subplot(325)
gscatter(sub1MIS(x,1),sub1MIS(x,2),cat(1,LABELS));
%,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS));
title('MI + Self Hand')
xlabel('Feature 2')
ylabel('Feature 1')
legend('off')

subplot(322)

gscatter(sub2MI(x,1),sub2MI(x,2),cat(1,LABELS));
%,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS));
title('MI only')
xlabel('Feature 2')
ylabel('Feature 1')
legend('off')

subplot(324)

gscatter(sub2MIO(x,1),sub2MIO(x,2),cat(1,LABELS));
%,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS));
title('MI + Other Hand')
xlabel('Feature 2')
ylabel('Feature 1')
legend('off')

subplot(326)
gscatter(sub2MIS(x,1),sub2MIS(x,2),cat(1,LABELS));
%,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS,LABELS));
title('MI + Self Hand')
xlabel('Feature 2')
ylabel('Feature 1')
legend('off')

sgtitle('Subjects 1 & 2')

save('Data Visualization/featureplots.mat','sub1MI', 'sub1MIO', 'sub1MIS', 'sub2MI', 'sub2MIO', 'sub2MIS')
saveas(gcf,['Data Visualization/Feature plots/Sub12','.jpg'])
