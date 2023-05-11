function [algorithm,featype] = enc_algfeat(featcode)
% Copyright by Anh Huy Phan, 2010
dbas = 10^floor(log10(featcode));
algorithm = floor(featcode/dbas);
featype = mod(featcode,dbas);