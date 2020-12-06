clear;
clc;
close all;

load('D:\myproj\eeg\����\����\�Ե�\2020_11_20_16_43_54-raw.mat');
% ȫ�ֲ���
Fs = 250;
win_step = 200;       % ���ڲ��������
win_width = Fs*30;  % 30s һ������
total_time = length(signals)-win_width-1; % ����Ȥ�źų���
win_N = floor((total_time-win_width+1)/win_step); % �ܴ���
FFT_points_N = win_width/2+1;% 0��50Hz��Ƶ�׵���
V_count = 1.2* 8388607.0 * 1.5 * 51.0;

En_all_channels = zeros(win_N,15);
E4 = zeros(win_N,15,4);

% �˲�
% ���޳ܵ�emd�����˲� û������
% Sig = signals(channel,signals(1,:)==10);
% imf0=pEMDandFFT(signals(channel,:),Fs);close;
% input = zeros(1,length(signals));
% input(1,:)= imf0(3,:);
tic;
for ch =3:17
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
        Sig = res(i+(i-1)*win_step:i+(i-1)*win_step+win_width-1); % ��һ������epoch ����ΪSig
        En_all_channels(i,ch-2) = SampEn1(Sig(800:6700),0.12*std(Sig(800:6700))); % �����ͨ������ֵ
        [E4(i,ch-2,1),E4(i,ch-2,2),E4(i,ch-2,3),E4(i,ch-2,4)] =  myEwavelet(Sig); % �����ͨ�����ĸ�Ƶ�ʷ����������
        if (mod(i,20)==0)
            disp([num2str(i),'/',num2str(win_N)]); % ���������ʾ
        end
    end
end


toc;


% %% �۲��źŷ�Ƶ��
% x = input; %��������
% 
% FF=2*abs(fft(x,length(x)))/length(x);
% f=(0:length(x)/2)*(Fs/length(x));
% figure(1);plot(f,FF(1:length(x)/2+1));title('�����źŵ�Ƶ��');
% 
% %% С�����ֽ�
% order = 6;
% wpt=wpdec(x,order,'db10'); %����3��С�����ֽ�
% % plot(wpt); %����С������
% 
% nodesNum = 2^(order+1)-2;  % 3��Ϊ����������ڵ�  �ڶ��� 1 2  ������ 3 4 5 6 ������ 7 8 9 10 11 12 13 14
% nodes = nodesNum-2^order+1:nodesNum;
% nodes_ord = wpfrqord(nodes'); % �����������
% 
% rex = zeros(length(x),2^order);
% 
% for i=1:2^order
% 
%     x = wprcoef(wpt,[3 nodes_ord(i)-1]); %ʵ�ֶԽڵ�С���ڵ�����ع�
%     rex(:,i) = x;  % store temp result
%     
%     if order<4
%         figure(200);
%         subplot(2,2^order/2,i);
%         FF=2*abs(fft(x,length(x)))/length(x);
%         f=(0:length(x)/2)*(Fs/length(x));
%         plot(f,FF(1:length(x)/2+1));title('�����źŵ�Ƶ��');hold on;
%         xlim([0 125]);title([num2str(nodes_ord(i)-1),'�ڵ��ź�Ƶ��']);
%         for j=1:8
%             plot(j*Fs/2/2^order,0,'ro'); hold on;
%         end
%     
% %     figure(201);
% %     subplot(2,4,i);
% %     imf=pEMDandFFT(x,Fs);close;
% %     [mgs,f]=marginalSpec(imf,Fs);close;
% % %     mgs = 10*log10(abs(mgs.^2)/length(f))/2; %������ ���Գ��Զ� ͳһ����˫����
% %     plot(f,mgs);hold on;
% %     xlim([0 125]);title([num2str(nodes_ord(i)-1),'�ڵ��źű߼���']);
%     end
% end
% 
% %% С���ֽ�ĸ��ڵ��������
% E_wavelet = wenergy(wpt);
% E_wavelet(:) = E_wavelet(nodes_ord(:)); % ˳�������
% 
% figure;
% plot(E_wavelet);
% 
% E_delta = sum(E_wavelet(1:2));
% E_theta = sum(E_wavelet(3:4));
% E_alpha = sum(E_wavelet(5:7));
% E_beta = sum(E_wavelet(8:13));
