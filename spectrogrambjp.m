function [ps,f] = spectrogrambjp(input,win_width,fold,Fs)
L = length(input);
t = 1:win_width-fold:L-win_width;
disp(length(t));
ps = zeros(1251,length(t));
for i = 1:length(t)
    Sig = input(1,t(i):t(i)+win_width-1);
    [mgs,f]=marginalSpec(Sig,Fs);close;
%     mgs =  medfilt1(mgs,5);
    MGS = 10*log10(abs(mgs.^2)/length(f))/2;
    MGS(MGS==-inf)=nan;
    MGS = fillmissing(MGS,'movmean',5);
    MGS = fillmissing(MGS,'previous');
    MGS =  medfilt1(MGS,20);
%     figure;plot(input);
%     res(res<1e-6)=1e-3;
%     res = 10*log10(abs(res.^2)/length(f))/2; %单边谱 所以除以二 统一做成双边谱
    ps(:,i) = MGS(:);
end

end

