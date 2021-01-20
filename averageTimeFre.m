clc;
clear;
close all;

%% 全局参数
Fs = 250;
% win_step = 2000;       % 窗口步进点个数
win_width = Fs*5;  % 30s 一个窗口
V_count = 1.2* 8388607.0 * 1.5 * 51.0;
ch = 6;

root_path = 'D:\myproj\eeg\数据（处理1221）\ori\黑白\黑白\';
flist = dir(root_path);
fnum = length(flist)-2;

BB = zeros(fnum,500,2000);
CC = zeros(fnum,2000);
RES =  zeros(fnum,2000);
%%
load('reref.mat');
%% 
load([root_path,flist(3).name]);

INPUT = zeros(15,length(signals));
for i=3:17

% % 对该通道全部信号用emd无耻的滤波
% imf0=pEMDandFFT(signals(i,:),Fs);
% INPUT(i-2,:)= imf0(3,:)./V_count;
    % 基础滤波
    res = signals(i,:);
    [n,Wn] = buttord(2*0.5/Fs,2*0.3/Fs,1,20);
    [bb,aa] = butter(n,Wn,'high');
    res = filter(bb,aa,res);
    [n,Wn] = buttord(2*45/Fs,2*48/Fs,1,20);
    [bb,aa] = butter(n,Wn,'low');
    INPUT(i-2,:) = filter(bb,aa,res)/V_count/1e-6;
%     imf0=pEMDandFFT(INPUT(i-2,:),Fs);
end

tmp = find(signals(1,:)==12);
INPUT(:,1:tmp(1))=[]; % 强行截掉没有实验的部分 对齐
%%  平均重参考 和eeglab的功能验证过 ok
figure;
for i=1:15
    INPUT_reref = INPUT-mean(INPUT,1);
    plot(INPUT_reref(i,:)-i*20);hold on;
%     plot(INPUT(i,:)-i*20+10);hold on;
end
%% 删掉波动巨大的数据段




%%

for i=1:1
    figure(100);
    plot(reref_data(i,:)-20*i);hold on;ylim([-320 0]);
    
%     figure(101);
    [mgs,f]=marginalSpec(reref_data(i,:),Fs);close;
    MGS = 10*log10(abs(mgs.^2)/length(f))/2;
%     plot(f,MGS);hold on;
    MGS(MGS==-inf)=-20;
%     [n,Wn] = buttord(2*10/Fs,2*12/Fs,1,20);
%     [bb,aa] = butter(n,Wn,'low');
%     MGS = filter(bb,aa,MGS);
    MGS =  medfilt1(MGS,20);
    figure(102);
    plot(f,MGS);hold on;
%     imf0=pEMDandFFT(MGS(:,1),Fs);
myFFTplot(reref_data(i,1:10*Fs),103);hold on;
end



%%

for i = 1:15

fold = 800;
[psbjp1,~] = spectrogrambjp(INPUT,win_width,fold,Fs);hold on;clc;
psbjp1(500:end,:)=[];
psbjp1(1:20,:)=[];
psbjp1(:,1:10)=[];
psbjp1 = psbjp1-max(max(psbjp1)); % 归一化
% [CLI] = myEwaveletWins(reref_data,win_width,fold);
[CLI] = myWorkLoad(INPUT,win_width,fold);
figure;
% surface(psbjp1);hold on;view(0,90);grid off;%caxis([-30 0]);
% subplot(211);
contourf(psbjp1);hold on;

% subplot(212);
plot(medfilt1(CLI,20)*250,'w-','linewidth',1);hold on;


end



