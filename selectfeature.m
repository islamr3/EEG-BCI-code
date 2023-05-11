function features = selectfeature(Feat,featype,trainidx,gndtrain,Nofeat)
% Select dominant features from n-way features.
% Copyright by Anh Huy Phan, 2010
features = [];N = ndims(Feat);
for kf = find(featype)
    feat =[];
    switch kf
        case 1
            feat = reshape(Feat,[],size(Feat,N))';
            % Sort according to Fisher's discriminality
            odrIdx = rankingFisher(feat(trainidx,:),gndtrain);
            odrIdxsel = odrIdx(1:Nofeat);
            feat = feat(:,odrIdxsel);
            
        case 2 % CSP NWay 1
            feat = permute(Feat,[3 setdiff(1:N,3)]);
            feat = reshape(feat,size(feat,1),[],size(feat,N));
            feat = squeeze(sum(feat.^2,2))';
            feat = log(diag(1./sum(feat,2))* feat);
            
        case 3 % CSP NWay2
            feat = permute(Feat,[3 setdiff(1:N,3)]);
            feat = reshape(feat,size(feat,1),[],size(feat,N));
            feat= CSPfeature(feat,trainidx,gndtrain,...
                min(Nofeat,floor(size(feat,1)/2)));            
    end
    features = [features feat];
end