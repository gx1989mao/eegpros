clc;
clear;



load('D:\myproj\eeg\实验数据\实验数据\脑电\2020_11_02_18_40_34-raw.mat');

Fs = 250;  V_count = 1.2* 8388607.0 * 1.5 * 51.0;

Sig = signals(10,4e4:5e4);

Sig = myFilter(Sig);
Sig = Sig(3e3:end);
% Sig = eog_cut(Sig');
% Sig(abs(Sig)>0.8e-5)=0;


myFFTplot(Sig,100);


figure(1);
% subplot(2,1,1);
plot(Sig);ylim([-1e-5,1e-5]);
% figure(2);
imf = emd(Sig,'Display',1);

figure(3);
% subplot(2,1,2);
hht(imf,Fs,'FrequencyLimits',[0 40]);