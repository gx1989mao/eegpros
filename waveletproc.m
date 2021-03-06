clear;
clc;
close all;

load('D:\myproj\eeg\数据\数据\脑电\2020_11_20_16_43_54-raw.mat');
% 全局参数
Fs = 250;
win_step = 200;       % 窗口步进点个数
win_width = Fs*30;  % 30s 一个窗口
total_time = length(signals)-win_width-1; % 感兴趣信号长度
win_N = floor((total_time-win_width+1)/win_step); % 总窗数
FFT_points_N = win_width/2+1;% 0到50Hz的频谱点数
V_count = 1.2* 8388607.0 * 1.5 * 51.0;

En_all_channels = zeros(win_N,15);
E4 = zeros(win_N,15,5);

% 滤波
% 用无耻的emd经验滤波 没道理的
% Sig = signals(channel,signals(1,:)==10);
% imf0=pEMDandFFT(signals(channel,:),Fs);close;
% input = zeros(1,length(signals));
% input(1,:)= imf0(3,:);
tic;
for ch =5
    disp(ch);
    channel = ch;
    
    res = zeros(1,length(signals));
    res(1,:) = signals(ch,:);
    [n,Wn] = buttord(2*0.5/Fs,2*0.3/Fs,1,20);
    [bb,aa] = butter(n,Wn,'high');
    res = filter(bb,aa,res);
    [n,Wn] = buttord(2*45/Fs,2*48/Fs,1,20);
    [bb,aa] = butter(n,Wn,'low');
    res = filter(bb,aa,res);
    
    for i=1:win_N
        Sig = res(i+(i-1)*win_step:i+(i-1)*win_step+win_width-1); % 截一窗数据epoch 保存为Sig
        En_all_channels(i,ch-2) = SampEn1(Sig(800:6700),0.12*std(Sig(800:6700))); % 计算此通道的熵值
        [E4(i,ch-2,1),E4(i,ch-2,2),E4(i,ch-2,3),E4(i,ch-2,4),E4(i,ch-2,5)] =  myEwavelet(Sig); % 计算此通道的四个频率分量相对能量
        if (mod(i,20)==0)
            disp([num2str(i),'/',num2str(win_N)]); % 计算进度显示
        end
    end
end


toc;


% %% 观察信号幅频谱
% x = input; %输入数据
% 
% FF=2*abs(fft(x,length(x)))/length(x);
% f=(0:length(x)/2)*(Fs/length(x));
% figure(1);plot(f,FF(1:length(x)/2+1));title('输入信号的频谱');
% 
% %% 小波包分解
% order = 6;
% wpt=wpdec(x,order,'db10'); %进行3层小波包分解
% % plot(wpt); %绘制小波包树
% 
% nodesNum = 2^(order+1)-2;  % 3阶为例：不算根节点  第二层 1 2  第三层 3 4 5 6 第三层 7 8 9 10 11 12 13 14
% nodes = nodesNum-2^order+1:nodesNum;
% nodes_ord = wpfrqord(nodes'); % 格雷码编码结果
% 
% rex = zeros(length(x),2^order);
% 
% for i=1:2^order
% 
%     x = wprcoef(wpt,[3 nodes_ord(i)-1]); %实现对节点小波节点进行重构
%     rex(:,i) = x;  % store temp result
%     
%     if order<4
%         figure(200);
%         subplot(2,2^order/2,i);
%         FF=2*abs(fft(x,length(x)))/length(x);
%         f=(0:length(x)/2)*(Fs/length(x));
%         plot(f,FF(1:length(x)/2+1));title('输入信号的频谱');hold on;
%         xlim([0 125]);title([num2str(nodes_ord(i)-1),'节点信号频谱']);
%         for j=1:8
%             plot(j*Fs/2/2^order,0,'ro'); hold on;
%         end
%     
% %     figure(201);
% %     subplot(2,4,i);
% %     imf=pEMDandFFT(x,Fs);close;
% %     [mgs,f]=marginalSpec(imf,Fs);close;
% % %     mgs = 10*log10(abs(mgs.^2)/length(f))/2; %单边谱 所以除以二 统一做成双边谱
% %     plot(f,mgs);hold on;
% %     xlim([0 125]);title([num2str(nodes_ord(i)-1),'节点信号边际谱']);
%     end
% end
% 
% %% 小波分解的各节点相对能量
% E_wavelet = wenergy(wpt);
% E_wavelet(:) = E_wavelet(nodes_ord(:)); % 顺序调整好
% 
% figure;
% plot(E_wavelet);
% 
% E_delta = sum(E_wavelet(1:2));
% E_theta = sum(E_wavelet(3:4));
% E_alpha = sum(E_wavelet(5:7));
% E_beta = sum(E_wavelet(8:13));


% 画图出来看看5个波段的相对能量 ( 总和为100%) 
figure;
for i=1:5
    subplot(5,1,i);
    plot(E4(:,3,i));hold on;
    ylim([0,100]);
end

