clc;
clear all;
close all;
load('D:\myproj\eeg\����\����\�Ե�\2020_11_20_16_43_54-raw.mat');

load('E_all_bands-wavelet-200step.mat');
Fs = 250;
%% ȫ�ֲ���
win_step = 200;       % ���ڲ��������
win_width = Fs*30;  % 30s һ������
total_time = length(signals)-win_width-1; % ����Ȥ�źų���
% total_time = 10000;
win_N = floor((total_time-win_width+1)/win_step); % �ܴ���
E_type_N = 20;      % ��Ҫ�������������
FFT_points_N = win_width/2+1;% 0��50Hz��Ƶ�׵���
V_count = 1.2* 8388607.0 * 1.5 * 51.0;
channel = 5;
tmp = find(signals(1,:)==10);
M1 = tmp(1)/win_step;
M2 = tmp(end)/win_step;

%% �Ը�ͨ��ȫ���ź���emd�޳ܵ��˲�
% imf0=pEMDandFFT(signals(channel,:),Fs);
% input = zeros(1,length(signals));
% input(1,:)= imf0(3,:);
%% ��ʱ����Ҷ�任ʱƵͼ 
% figure(2);
% [ps] = spectrogram(input,win_width,7300,win_width,Fs,'yaxis');hold on;
% mesh(10*log10(abs(ps)/win_width));grid on;
% tmp = find(signals(1,:)==10);
% % plot3(tmp(1)/Fs/60,-1,100,'ro');hold on;
% % plot3(tmp(end)/Fs/60,-1,100,'ro');hold on;
% % ylim([-1,30]);
% colormap Jet;
%% HHT�߼���ʱƵͼ
% [psbjp] = spectrogrambjp(input,win_width,7300,Fs);hold on;
% figure(3);
% mesh(10*log10(abs(psbjp)/win_width));grid on;
% colormap Jet;


%% �����¼���ע�ֶμ���߼���
% for i=[0,10,12]
%     
%     Sig = signals(channel,signals(1,:)==i);
% %     Sig = signals(channel,i+(i-1)*win_step:i+(i-1)*win_step+win_width-1);
% 
% %     % �����˲�
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
%     mgs = 10*log10(abs(mgs.^2)/length(f))/2; %������ ���Գ��Զ� ͳһ����˫����
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


%% ��ͨ�� ��ֵ ��Ƶ��������� ��ͼ

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



%% meshͼ ����۲�����
% 
% E4(:,9,:)=[];
% En_all_channels(:,9)=[];

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
CLI = zeros(size(En_all_channels));
CLI(:,:) = (E4(:,:,2)+E4(:,:,4))./E4(:,:,3);
figure;
mesh(CLI);hold on;title('CLI');
plot3([0,0],[M1,M1],[0,max(max(CLI))],'r-','linewidth',4);hold on;
plot3([0,0],[M2,M2],[0,max(max(CLI))],'r-','linewidth',4);hold on;
figure;
mesh(En_all_channels);hold on;title('en');
plot3([0,0],[M1,M1],[0,max(max(En_all_channels))],'r-','linewidth',4);hold on;
plot3([0,0],[M2,M2],[0,max(max(En_all_channels))],'r-','linewidth',4);hold on;

%% emd������֪��������CLI
CLI_emd = CLI;
figure;
for ch=1:15
    imf_CLI=pEMDandFFT(CLI(:,ch),Fs);close;
    CLI_emd(:,ch)= sum(imf_CLI(3:end,:));
    plot(CLI_emd(:,ch));hold on;
    title('CLI curves');
end

figure;
surface(CLI_emd); hold on;
plot3([0,0],[M1,M1],[0,max(max(CLI))],'r-','linewidth',4);hold on;
plot3([0,0],[M2,M2],[0,max(max(CLI))],'r-','linewidth',4);hold on;
title('CLI_emd');




