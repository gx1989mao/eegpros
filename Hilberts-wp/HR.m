clear;
clc;
% load('HR1.mat');
load('RGB.mat');
sig = b(1,1:250);
Fs = 20;

[n,Wn] = buttord(2*3/Fs,2*5/Fs,1,20);
[bb,aa] = butter(n,Wn,'low');
sig = filter(bb,aa,sig);
    
imf0 = pEMDandFFT(sig,Fs);
% HR = sig-imf0(1,:);
% imf0 = pEMDandFFT(HR,Fs);
% marginalSpec(imf0,Fs);
% alpha=2000;  % alpha   - 惩罚因子
% tol=1e-6;    % tol     - 收敛容差，是优化的停止准则之一，可以取 1e-6~5e-6
% K=3;         % K
% [imfv,CenFs] = pVMD(sig,Fs, alpha, K, tol);

%%
hrsig  = imf0(1,:)+imf0(2,:);
L = 250;
f = Fs*(0:(L/2))/L;
figure;
Y = fft(hrsig);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
plot(f,P1);hold on;




%% 
L = 250;
f = Fs*(0:(L/2))/L;
figure;
for i=1:6
imf1 = imf0(i,:);
Y = fft(imf1);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
plot(f,P1);hold on;
xlim([0,3]);
end
%%
L = 250;
f = Fs*(0:(L/2))/L;
figure;
Y = fft(HR);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
plot(f,P1);hold on;
