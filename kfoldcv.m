%stratified k-fold cross-validation
function cvid=stra_kfoldcv(group,nfold) 
N = size(group,1);
cvid = 1 + mod((1:N)',nfold);
idrand = group + rand(N,1);
[ignore,idx] = sort(idrand);
cvid = cvid(idx);
end