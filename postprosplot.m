clc;
clear all;
close all;
load('D:\myproj\eeg\数据\数据\脑电\2020_11_20_16_43_54-raw.mat');
Fs = 250;

win_step = 100;       % 窗口步进点个数
win_width = Fs*30;  % 30s 一个窗口
total_time = length(signals)-win_width-1; % 感兴趣信号长度
% total_time = 10000;
win_N = floor((total_time-win_width+1)/win_step); % 总窗数
E_type_N = 20;      % 需要计算的能量种类
FFT_points_N = win_width/2+1;% 0到50Hz的频谱点数
V_count = 1.2* 8388607.0 * 1.5 * 51.0;
channel = 5;


imf0=pEMDandFFT(signals(channel,:),Fs);
input = zeros(1,length(signals));
input(1,:)= imf0(3,:);

figure(2);
[ps] = spectrogram(input,win_width,6000,win_width,Fs,'yaxis');hold on;
mesh(10*log10(abs(ps)/win_width));grid on;
tmp = find(signals(1,:)==10);
% plot3(tmp(1)/Fs/60,-1,100,'ro');hold on;
% plot3(tmp(end)/Fs/60,-1,100,'ro');hold on;
% ylim([-1,30]);
colormap Jet;

[psbjp] = spectrogrambjp(input,win_width,6000,Fs);hold on;
figure(3);
mesh(10*log10(abs(psbjp)/win_width));grid on;
colormap Jet;


figure();
plot(signals(1,:));
% 
% for i=[0,10,12]
%     
%     Sig = signals(channel,signals(1,:)==i);
%     
%     
% %     Sig = signals(channel,i+(i-1)*win_step:i+(i-1)*win_step+win_width-1);
% 
% %     % filter
% %     res = Sig;
% %     [n,Wn] = buttord(2*0.5/Fs,2*0.3/Fs,1,20);
% %     [bb,aa] = butter(n,Wn,'high');
% %     res = filter(bb,aa,res);
% %     [n,Wn] = buttord(2*45/Fs,2*48/Fs,1,20);
% %     [bb,aa] = butter(n,Wn,'low');
% %     Sig = filter(bb,aa,res);
% 
%     % emd 
%     imf=pEMDandFFT(Sig,Fs);
%     input = zeros(1,length(Sig));
%     input(1,:)= imf(3,:);
% %     input = sum(imf);  
% %     figure();
% %     plot(input/V_count);
% 
%     % bjp
%     [mgs,f]=marginalSpec(input,Fs);
%     mgs =  medfilt1(mgs,5);
%     mgs(mgs<1e-6)=1e-4;
%     mgs = 10*log10(abs(mgs.^2)/length(f))/2; %单边谱 所以除以二 统一做成双边谱
%     figure(10);
%     plot(f,mgs);hold on;
%     xlim([0,30]);
% 
% 
%     Sig = input;
%     F = abs(fftshift(fft(Sig.^2,length(Sig))));             
%     F = 10*log10(F/length(Sig));
%     w = linspace(-Fs/2,Fs/2,length(Sig));  
%     figure(11);
%     plot(w,abs(F)); hold on;
%     xlim([0,60]);
% 
% end





