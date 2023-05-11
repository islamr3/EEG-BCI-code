function fea = feaCSP(X,W)
Ntrials = size(X,3);
X = reshape(X,size(X,1),[]);
fea = reshape(W*X,size(W,1),[],Ntrials);
fea = squeeze(sum(fea.^2,2))';
fea = bsxfun(@rdivide,fea,sum(fea,2));
fea = log(fea);