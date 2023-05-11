function Feat=entropyFeatureMIBCI(sig1)
fs=250;
IS=0.5; %Initial Silence in second
W=fix(.3*fs); %Window length is 50 ms
SP=0.3; %shifting percentage
wnd=hamming(W);
%signal=squeeze(sig(:,1,1,1));
Feat=[];
for i=1:size(sig1,3) %Extract Trail
    Trail=squeeze(sig1(:,:,i))';
    ChFN=[];
    for ch=1:size(sig1,1) %Extract channel
        Temp=Trail(:,ch);
        y=segment(Temp,W,SP,wnd); %Sigment
        EN=[];
        for ep=1:size(y,2)
            Epoch=y(:,ep)';
            saen = SampEn( 2, 0.2*std(Epoch), Epoch, 1);
            EN=[EN,saen];
        end
        ChFN=[ChFN;EN];
    end
    Feat(:,:,i)=ChFN;
end
%y=segment(signal,W,SP,wnd);
% %Calculate Sample point
% SP=size(sig,1);
% %Number of Channels
% C=size(sig,2);
