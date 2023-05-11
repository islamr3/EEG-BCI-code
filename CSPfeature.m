function [features,W] = CSPfeature(X,trainidx,gndtrain,Nofeat)
% Copyright of this implementation by Anh Huy Phan, 2010.
W =CSP(X(:,:,trainidx),gndtrain,2*Nofeat);
features = feaCSP(X,W);
end