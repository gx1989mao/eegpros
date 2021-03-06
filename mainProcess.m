%% 数据导入
clc;clear;
close all;


root_path = 'D:\myproj\eeg\数据（处理1221）\ori\彩色\彩色\';
flist = dir(root_path);
fnum = length(flist)-2;
i=1;
load([root_path,flist(i+2).name]);
% load('2020_11_21_16_22_48-raw.mat');
% load('2020_11_17_19_19_14-raw.mat')  %左耳电极太亮了 有问题
% load('2020_11_18_19_14_53-raw.mat')
% load('2020_11_19_19_30_21-raw.mat') % 缺少6
% load('2020_11_21_13_49_38-raw.mat')

% root_path = 'D:\myproj\eeg\数据（处理1221）\数据（处理1221）\黑白\';
% flist = dir(root_path);
% fnum = length(flist)-2;
% for i=1:fnum
%     load([root_path,flist(i+2).name]); % load one mat file
%     
%     % do process
% end


Fs = 250;
V_count = 1.2* 8388607.0 * 1.5 * 51.0;

flag10 = find(signals(1,:)==10);
flag12 = find(signals(1,:)==12);  % 事件打标
signals(3:17,:) = signals(3:17,:)./V_count./1e-6; % 转换为uV单位

%% 小波重构取出来感兴趣频段 这里是alpha
channels = [3,4,5,6,7,8,9,10,11,12,13,14,15,16,17];
alpha = zeros(length(channels),length(signals));  % 小波重构信号
input = alpha;                                    %原始信号 emd滤波之后

for ch=1:length(channels)

%     % EMD滤波
%     imf0=pEMDandFFT(signals(channels(ch),:),Fs);close;
%     input(ch,:)= imf0(3,:);

    % 巴特沃斯滤波
    res = signals(channels(ch),:);
    [n,Wn] = buttord(2*0.5/Fs,2*0.3/Fs,1,20);
    [bb,aa] = butter(n,Wn,'high');
    res = filter(bb,aa,res);
    [n,Wn] = buttord(2*45/Fs,2*48/Fs,1,20);
    [bb,aa] = butter(n,Wn,'low');
    res = filter(bb,aa,res);
    input(ch,:) = res;%%%%%%%%%%%%%%%%%%%%%%%
    

    Sig = input(ch,:);
    
    % 小波包分解和重构
    order = 6;
    wpt=wpdec(Sig,order,'db10'); %进行3层小波包分解

    nodesNum = 2^(order+1)-2;  % 3阶为例：不算根节点  第二层 1 2  第三层 3 4 5 6 第三层 7 8 9 10 11 12 13 14
    nodes = nodesNum-2^order+1:nodesNum;
    nodes_ord = wpfrqord(nodes'); % 格雷码编码结果

    rcfs = zeros(1,length(Sig));
    for node=1:16
        rcfs = rcfs + wprcoef(wpt,[6 nodes_ord(node)-1]);
    end
    alpha(ch,:) = rcfs;%%%%%%%%%%%%%%%%%%%%%%%%%      
end

%% 各通道信号归一化绘图
y_high = 20*16;
myALLChannelsPlot(input,10);
line([flag12(1),flag12(1)],[0,y_high],'linewidth',3,'color','r'); hold on;
line([flag12(end),flag12(end)],[0,y_high],'linewidth',3,'color','r'); hold on;
line([flag12(end),flag12(end)],[0,y_high],'linewidth',3,'color','r'); hold on;
title('预处理滤波后各通道信号');

myALLChannelsPlot(alpha,11);
line([flag12(1),flag12(1)],[0,y_high],'linewidth',3,'color','r'); hold on;
line([flag12(end),flag12(end)],[0,y_high],'linewidth',3,'color','r'); hold on;
line([flag12(end),flag12(end)],[0,y_high],'linewidth',3,'color','r'); hold on;
title('小波重构各通道信号');

%%  GFP 计算 （使用alpha）
GFP_input = alpha;
%%
myALLChannelsPlot(GFP_input,13);
myALLChannelsPlot(input,14);
%%
GFP_input = myUniformSig(GFP_input);  % 各通道归一化 标准差做到1  均值到0 等同于重参考
[GFP_input,cut] = myCutData(GFP_input,1.2); % 去掉所有大于标准差1.2倍的信号段
input = myUniformSig(input);  % 各通道归一化 标准差做到1  均值到0 等同于重参考
input(:,cut)=[];
%%
GFP = sqrt(sum((GFP_input-mean(GFP_input,2)).^2,1)./15);
% GFP = movavg(GFP,40,40,'e');
% GFP = medfilt1(GFP,20);
% GFP = sqrt(sum(tmp,1)./length(channels));

startP = flag10(1);
% startP = 74500;
endP = flag10(end);
select_sig = GFP(:);
[y,x]=findpeaks(select_sig); 

% 删掉过大的GFP点
th = 1;
x(y>th)=[];
y(y>th)=[];

figure(2);
plot(GFP);hold on;
plot(x,y,'r.');hold on;
ylim([0,th*1.5]);
title('GFP and peaks');

% 肉眼判断后删掉过于大的噪点
% x(494:503)=[];

%% kmeans 聚类前操作 归一化

raw_sig = zeros(length(channels),length(GFP_input));


% 要显示拓扑图的数据源
% raw_sig(:,:) = signals(3:17,:);
% raw_sig(:,:) = GFP_input;
raw_sig(:,:) = input;



%% 聚类
Kmean_input = zeros(length(x),15);
% 感兴趣的GFP峰值点x写进聚类输入矩阵
for i=1:length(x)
    Kmean_input(i,:) = raw_sig(:,x(i)); 
end
% 聚类 Idx存着分类标签 C存着K个类的聚类重心（可以认为是类的标准模板）
K = 4;
tic;
[Idx,C]=kmeans(Kmean_input,K,'Replicates',300);
toc;
disp('聚类完毕');

figure(4);
subplot(3,1,1);
bar(Idx);hold on;
subplot(3,1,2);
histogram(Idx);hold on;

subplot(3,1,3);
plot(select_sig);hold on;
for i=1:4
    plot(x(Idx==i),y(Idx==i),'.','MarkerSize',20);hold on;
end
% ylim([0,0.5e-6]);

%%  按聚类画图观察
index = 1;
for i=1:K
%     figure(98);
%     Idxtmp = x(Idx==i);
%     RR = randperm(numel(Idxtmp));
%     for j=x(RR(1:4)) % 从第一类中随机抽取四个
%         subplot(4,4,index);
%         myTopograph(raw_sig(:,startP-1+j));  hold on;title(['MS:',num2str(i)]);
%         index = index+1;
%     end
    
    figure(992);
    subplot(2,2,i);
    myTopograph(C(i,:));hold on;title(['Mean S:',num2str(i)]);
end


%%

Fs = 250;

win_step = 200;       % 窗口步进点个数
win_width = Fs*30;  % 30s 一个窗口
total_time = length(signals)-win_width-1; % 感兴趣信号长度
% total_time = 10000;
win_N = floor((total_time-win_width+1)/win_step); % 总窗数
E_type_N = 20;      % 需要计算的能量种类
FFT_points_N = win_width/2+1;% 0到50Hz的频谱点数


E_all_bands = zeros(win_N,E_type_N);  % 所有能量种类的时域记录
My_TF_spectrum = zeros(win_N,FFT_points_N);
En_all_channels = zeros(win_N,1);


%%
channel = 5;



for i=1:win_N
    Sig = signals(channel,i+(i-1)*win_step:i+(i-1)*win_step+win_width-1);

    Sig = myFilter(Sig);

%     myFFTplot(Sig,1); % 不要随便开 画图太多了
    E_all_bands(i,1) = myECal(Sig,0.5+0.2,3-0.2,  0.5-0.2,3+0.2);
    E_all_bands(i,2) = myECal(Sig,4+1,7-1,        4-1,7+1);
    E_all_bands(i,3) = myECal(Sig,8+1,13-1,       8-1,13+1);
    E_all_bands(i,4) = myECal(Sig,12+1,16-1,      12-1,16+1);
    E_all_bands(i,5) = myECal(Sig,18+1,30-1,      18-1,30+1);
    E_all_bands(i,6) = myECal(Sig,40+1,50-1,      40-1,50+1);
    
    My_TF_spectrum(i,:) = MySpectrum(Sig);
 En_all_channels(i,1) = SampEn1(Sig(800:6700),0.12*std(Sig(800:6700)));
     if (mod(i,20)==0)
        disp(i);
     end
end

% mesh(My_TF_spectrum);

figure();
plot(En_all_channels(:));





