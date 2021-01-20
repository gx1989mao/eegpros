clc;
clear all;
close all;
load('D:\myproj\eeg\数据（处理1221）\ori\彩色\彩色\2020_11_02_18_40_34-raw.mat');

% load('E_all_bands-wavelet-200step.mat');



%% 全局参数
Fs = 250;
win_step = 200;       % 窗口步进点个数
win_width = Fs*2;  % 30s 一个窗口
total_time = length(signals)-win_width-1; % 感兴趣信号长度
% total_time = 10000;
win_N = floor((total_time-win_width+1)/win_step); % 总窗数
E_type_N = 20;      % 需要计算的能量种类
FFT_points_N = win_width/2+1;% 0到50Hz的频谱点数
V_count = 1.2* 8388607.0 * 1.5 * 51.0;
ch = 6;



root_path = 'D:\myproj\eeg\数据（处理1221）\数据（处理1221）\黑白\';
flist = dir(root_path);
fnum = length(flist)-2;

BJPs = zeros(500,2000);
CLIs = zeros(1,2000);
for i = 1:fnum
load([root_path,flist(i+2).name]);
fig = figure(3);
%% 对该通道全部信号用emd无耻的滤波
imf0=pEMDandFFT(signals(ch,:),Fs);close;
input = zeros(1,length(signals));
input(1,:)= imf0(3,:);

%% HHT边际谱时频图
% input = signals(channel,:);
tic;
fold = 200;
[psbjp,f] = spectrogrambjp(input,win_width,fold,Fs);hold on;
% [psbjp] = spectrogram(input,win_width,fold,win_width,Fs,'yaxis');hold on;
toc;
psbjp1 = 10*log10(abs(psbjp)/win_width);
psbjp1(500:end,:)=[];
psbjp1(:,1)=[];
sizebjp = size(psbjp1);


BJPs(:,1:sizebjp(2)) = BJPs(:,1:sizebjp(2))+psbjp1(:,:);

subplot(211);
mesh(psbjp1-max(max(psbjp1)));hold on;view(0,90);grid off;caxis([-30 0]);
ylim([0,sizebjp(1)]);
xlim([0,sizebjp(2)]);
for event = 0:14
tmp = find(signals(1,:)==event);
if (~isempty(tmp))
plot3(tmp(1)/(win_width-fold)+1,0,100,'ro');hold on;
end
end

%%
tic;
[CLI] = myEwaveletWins(input,win_width,fold);
toc;


subplot(212);
plot(CLI*30,'linewidth',1);hold on;xlim([0,sizebjp(2)]);
for event = 0:14
tmp = find(signals(1,:)==event);
if (~isempty(tmp))
plot(tmp(1)/(win_width-fold)+1,0,'ro');hold on;
end
end
% 
% frame = getframe(fig); % 获取frame
% img = frame2im(frame); % 将frame变换成imwrite函数可以识别的格式
% imwrite(img,['D:\myproj\eeg\数据（处理1221）\ori\彩色\',num2str(ch),'.png']);
% close(figure(3));

end

%% 根据事件标注分段计算边际谱
% for i=[0,10,12]
%     
%     Sig = signals(channel,signals(1,:)==i);
% %     Sig = signals(channel,i+(i-1)*win_step:i+(i-1)*win_step+win_width-1);
% 
% %     % 基础滤波
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
%     % fft
%     Sig = input;
%     F = abs(fftshift(fft(Sig.^2,length(Sig))));             
%     F = 10*log10(F/length(Sig));
%     w = linspace(-Fs/2,Fs/2,length(Sig));  
%     figure(11);
%     plot(w,abs(F)); hold on;
%     xlim([0,60]);
% end
% 

%% 多通道 熵值 四频段相对能量 绘图

% for ch=1:15
%     figure(1);
%     plot(En_all_channels(:,ch));hold on;
%     plot([M1,M1],[0,1],'r-','linewidth',4);hold on;   
%     plot([M2,M2],[0,1],'r-','linewidth',4);hold on;
%     figure(2);
%     plot(E4(:,ch,1)); hold on;
%     plot([M1,M1],[0,100],'r-','linewidth',4);hold on;
%     plot([M2,M2],[0,100],'r-','linewidth',4);hold on;
% end



%% mesh图 方便观察数据
% % 
% % E4(:,9,:)=[];
% % En_all_channels(:,9)=[];
% 
% figure;
% mesh(E4(:,:,1));hold on;title('E_delta');
% plot3([0,0],[M1,M1],[0,max(max(E4(:,:,1)))],'r-','linewidth',4);hold on;
% plot3([0,0],[M2,M2],[0,max(max(E4(:,:,1)))],'r-','linewidth',4);hold on;
% figure;
% mesh(E4(:,:,2));hold on;title('E_theta');
% plot3([0,0],[M1,M1],[0,max(max(E4(:,:,2)))],'r-','linewidth',4);hold on;
% plot3([0,0],[M2,M2],[0,max(max(E4(:,:,2)))],'r-','linewidth',4);hold on;
% figure;
% mesh(E4(:,:,3));hold on;title('E_alpha');
% plot3([0,0],[M1,M1],[0,max(max(E4(:,:,3)))],'r-','linewidth',4);hold on;
% plot3([0,0],[M2,M2],[0,max(max(E4(:,:,3)))],'r-','linewidth',4);hold on;
% figure;
% mesh(E4(:,:,4));hold on;title('E_beta');
% plot3([0,0],[M1,M1],[0,max(max(E4(:,:,4)))],'r-','linewidth',4);hold on;
% plot3([0,0],[M2,M2],[0,max(max(E4(:,:,4)))],'r-','linewidth',4);hold on;
% figure;
% mesh(E4(:,:,3)./E4(:,:,4));hold on;title('alpha/beta');
% plot3([0,0],[M1,M1],[0,max(max(E4(:,:,3)./E4(:,:,4)))],'r-','linewidth',4);hold on;
% plot3([0,0],[M2,M2],[0,max(max(E4(:,:,3)./E4(:,:,4)))],'r-','linewidth',4);hold on;
% figure;
% mesh(E4(:,:,2)./E4(:,:,4));hold on;title('theta/beta');
% plot3([0,0],[M1,M1],[0,max(max(E4(:,:,2)./E4(:,:,4)))],'r-','linewidth',4);hold on;
% plot3([0,0],[M2,M2],[0,max(max(E4(:,:,2)./E4(:,:,4)))],'r-','linewidth',4);hold on;
% CLI = zeros(size(En_all_channels));
% CLI(:,:) = (E4(:,:,2)+E4(:,:,4))./E4(:,:,3);
% figure;
% mesh(CLI);hold on;title('CLI');
% plot3([0,0],[M1,M1],[0,max(max(CLI))],'r-','linewidth',4);hold on;
% plot3([0,0],[M2,M2],[0,max(max(CLI))],'r-','linewidth',4);hold on;
% figure;
% mesh(En_all_channels);hold on;title('en');
% plot3([0,0],[M1,M1],[0,max(max(En_all_channels))],'r-','linewidth',4);hold on;
% plot3([0,0],[M2,M2],[0,max(max(En_all_channels))],'r-','linewidth',4);hold on;

%% emd处理认知负荷曲线CLI
% CLI_emd = CLI;
% figure;
% for ch=1:15
%     imf_CLI=pEMDandFFT(CLI(:,ch),Fs);close;
%     CLI_emd(:,ch)= sum(imf_CLI(3:end,:));
%     plot(CLI_emd(:,ch));hold on;
%     title('CLI curves');
% end
% 
% figure;
% surface(CLI_emd); hold on;
% plot3([0,0],[M1,M1],[0,max(max(CLI))],'r-','linewidth',4);hold on;
% plot3([0,0],[M2,M2],[0,max(max(CLI))],'r-','linewidth',4);hold on;
% title('CLI_emd');





