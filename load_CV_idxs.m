function Kfoldidx = load_CV_idxs(filename,nfold,LABELS)
% Load indices for n-fold crossvalidation
%  Copyright by Anh Huy Phan, 2010
fidx =sprintf('%s_%dfoldidx.mat',filename,nfold);
if exist(fidx,'file') ~= 2
    Kfoldidx = zeros(numel(LABELS),100);
    for i=1:100
        Kfoldidx(:,i) = kfoldcv(LABELS(:),nfold);
    end
    save(fidx,'Kfoldidx')
else
    load(fidx)
end