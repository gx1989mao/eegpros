clc;
clear;

close all;

%% 全局参数
Fs = 125;
% win_step = 2000;       % 窗口步进点个数
win_width = Fs*20;  % 30s 一个窗口
V_count = 1.2* 8388607.0 * 1.5 * 51.0;
ch = 6;

% root_path = 'D:\myproj\eeg\数据（处理1221）\ori\黑白\黑白\';
root_path = 'D:\myproj\eeg\数据（处理1221）\ori\彩色\彩色\';
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

% 对该通道全部信号用emd无耻的滤波
imf0=pEMDandFFT(signals(i,:),Fs);close;
INPUT(i-2,:)= (imf0(3,:))./V_count/1e-6;
    % 基础滤波

%     res = signals(i,:);
%     [n,Wn] = buttord(2*0.5/Fs,2*0.3/Fs,1,20);
%     [bb,aa] = butter(n,Wn,'high');
%     res = filter(bb,aa,res);
%     [n,Wn] = buttord(2*45/Fs,2*48/Fs,1,20);
%     [bb,aa] = butter(n,Wn,'low');
%     INPUT(i-2,:) = filter(bb,aa,res)/V_count/1e-6;
%     imf0=pEMDandFFT(INPUT(i-2,:),Fs);
end

tmp = find(signals(1,:)==12);
INPUT(:,1:tmp(1))=[]; % 强行截掉没有实验的部分 对齐
%%
figure;
for i=1:15
    plot(INPUT(i,:)-i*20+10);hold on;
end

%%  平均重参考 和eeglab的功能验证过 ok

REF = INPUT;
% REF(14,:) = []; % 去掉14通道 干扰太大了

figure;
for i=1:15
    INPUT_reref = INPUT-mean(REF,1);
    plot(INPUT_reref(i,:)-i*20);hold on;
%     plot(INPUT(i,:)-i*20+10);hold on;
end

%% 删掉波动巨大的数据段
windowSize =30;
CUTSIG = INPUT_reref;
% CUTSIG = INPUT;
oriLength = length(CUTSIG);
th = 10;
ALLCHCUT = [];
for ch = [1,2,3,4,5,6,7,8,9,10,11,12,13,15]
    CUT=[];
    one_ch = CUTSIG(ch,:);
    one_ch = [one_ch,one_ch(end:-1:end-windowSize-1)]; % 镜像扩展一个窗口长度
    for i=1:oriLength
        window = one_ch(i:i+windowSize-1);
        if max(abs(window))>th
            CUT = [CUT,i];
        end
    end
    ALLCHCUT = [ALLCHCUT,CUT];
end
% figure;
% plot(CUT,one_ch(CUT));hold on;

CUTSIG(:,sort(unique(ALLCHCUT))) = [];

% 观察删除效果
figure;
for i=1:15
    plot(CUTSIG(i,:)-i*20+10);hold on;
end


%% 单通道hht频谱
% INPUT = INPUT;
INPUT  = CUTSIG;
for i=1
    figure(100);
    plot(INPUT(i,:)-20*i);hold on;ylim([-320 0]);
    
%     figure(101);
    [mgs,f]=marginalSpec(INPUT(i,:),Fs);
    MGS = 10*log10(abs(mgs.^2)/length(f))/2;
%     plot(f,MGS);hold on;
    MGS(MGS==-inf)=-20;
%     [n,Wn] = buttord(2*10/Fs,2*12/Fs,1,20);
%     [bb,aa] = butter(n,Wn,'low');
%     MGS = filter(bb,aa,MGS);
figure(102);
    plot(f,MGS);hold on;
    MGS =  medfilt1(MGS,10);
%     windowSize =10;
%     MGS=filter(ones(1,windowSize)/windowSize,1,MGS);
    
    figure(102);
    plot(f,MGS);hold on;
%     imf0=pEMDandFFT(MGS(:,1),Fs);
myFFTplot(INPUT(i,1:10*Fs),103);hold on;
end



%% 时频图
win_width = Fs*5;  % 30s 一个窗口
reref_data = CUTSIG;

for i = 5

fold = floor(0.8*win_width);
[BJP,ff,tt] = spectrogrambjp(reref_data(i,:),win_width,fold,Fs);hold on;clc;
%%
psbjp1 = BJP;
psbjp1(450:end,:)=[];
psbjp1(1:20,:)=[];
% psbjp1(:,1:10)=[];
psbjp1 = psbjp1-max(max(psbjp1)); % 归一化
% [CLI] = myEwaveletWins(reref_data,win_width,fold);
[CLI] = myWorkLoad(reref_data,win_width,fold);
end

%% 插值 画图 
interpz_scale = 5; % 插值倍数 1倍就是不插值
SS = size(psbjp1);
x = 1:SS(2);
y = 1:SS(1);
[X,Y]=meshgrid(x,y);
xx = 1:1/interpz_scale:SS(2);
yy = 1:1/interpz_scale:SS(1);
[XX,YY]=meshgrid(xx,yy);
psbjp2=interp2(X,Y,psbjp1,XX,YY,'cubic');
CLI1 = interp1(XX,CLI,'cubic');

figure;
subplot(211);
surface(XX,YY,psbjp2,'LineStyle','none');hold on;view(0,90);grid off;%caxis([-30 0]);

% contourf(XX,YY,psbjp1);hold on;

subplot(212);
plot(medfilt1(CLI1,1)*250,'b-','linewidth',1);hold on;


% end

% %% kmeans
% win_width = Fs*5;  % 30s 一个窗口
% fold = floor(0.8*win_width);
% IDX = [];
% for ch = 1:2
%      [Ewavelet] = myEwaveletWins(CUTSIG(ch,:),win_width,fold);
%      [Idx,C]=kmeans(Ewavelet',2);
%      IDX = [IDX,Idx];
% end
% 
% 
% %%
% figure(1001);
% III = IDX';
% for ch=1:2
% plot(III(ch,:)+ch*2.5);hold on;
% 
% end
% %%
% figure(1001);
% plot(III(1,:)+1*2.5);hold on;
% plot(III(2,:)+2*2.5);hold on;

%% wavelet feature
win_width = Fs*5;  
fold = floor(0.8*win_width);
IDX = [];
for ch = [13,15]
     [Ewavelet] = myEwaveletWins(CUTSIG(ch,:),win_width,fold);
     IDX = [IDX;Ewavelet(3,:)];
end
for ch = 8:9
     [Ewavelet] = myEwaveletWins(CUTSIG(ch,:),win_width,fold);
     IDX = [IDX;Ewavelet(4,:)];
end
for ch = [1,3,10]
     [Ewavelet] = myEwaveletWins(CUTSIG(ch,:),win_width,fold);
     IDX = [IDX;Ewavelet(5,:)];
end

