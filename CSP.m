function W = CSP(EEG,LABELS,Nobases)
% Seek spatial feature subspace for EEG ( channel x samples x trial)
% Phan Anh Huy, 2010
EEG = bsxfun(@rdivide,EEG,sqrt(sum(sum(EEG.^2,2)))); %normalize EEG's power
In = size(EEG);

[labset,i,j] = unique(LABELS);
EEG1 = reshape(EEG(:,:,j == 1),In(1),[]);
C1 = EEG1*EEG1'/sum(j == 1); C1 = max(C1,C1');

EEG2 = reshape(EEG(:,:,j == 2),In(1),[]);
C2 = EEG2*EEG2'/sum(j == 1); C2 = max(C2,C2');
Ct = C1+C2;

% Find bases W
[W,D] = eig(C1,Ct); 
[D,index]=sort(diag(D));
W = W(:,index([end:-1:end-Nobases/2+1 1:Nobases/2]));
W = bsxfun(@rdivide,W,sqrt(sum(W.^2)));
W = W';
return