%% ���ݵ���
clc;clear;
close all;


root_path = 'D:\myproj\eeg\���ݣ�����1221��\ori\��ɫ\��ɫ\';
flist = dir(root_path);
fnum = length(flist)-2;
i=1;
load([root_path,flist(i+2).name]);
% load('2020_11_21_16_22_48-raw.mat');
% load('2020_11_17_19_19_14-raw.mat')  %����缫̫���� ������
% load('2020_11_18_19_14_53-raw.mat')
% load('2020_11_19_19_30_21-raw.mat') % ȱ��6
% load('2020_11_21_13_49_38-raw.mat')

% root_path = 'D:\myproj\eeg\���ݣ�����1221��\���ݣ�����1221��\�ڰ�\';
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
flag12 = find(signals(1,:)==12);  % �¼����
signals(3:17,:) = signals(3:17,:)./V_count./1e-6; % ת��ΪuV��λ

%% С���ع�ȡ��������ȤƵ�� ������alpha
channels = [3,4,5,6,7,8,9,10,11,12,13,14,15,16,17];
alpha = zeros(length(channels),length(signals));  % С���ع��ź�
input = alpha;                                    %ԭʼ�ź� emd�˲�֮��

for ch=1:length(channels)

%     % EMD�˲�
%     imf0=pEMDandFFT(signals(channels(ch),:),Fs);close;
%     input(ch,:)= imf0(3,:);

    % ������˹�˲�
    res = signals(channels(ch),:);
    [n,Wn] = buttord(2*0.5/Fs,2*0.3/Fs,1,20);
    [bb,aa] = butter(n,Wn,'high');
    res = filter(bb,aa,res);
    [n,Wn] = buttord(2*45/Fs,2*48/Fs,1,20);
    [bb,aa] = butter(n,Wn,'low');
    res = filter(bb,aa,res);
    input(ch,:) = res;%%%%%%%%%%%%%%%%%%%%%%%
    

    Sig = input(ch,:);
    
    % С�����ֽ���ع�
    order = 6;
    wpt=wpdec(Sig,order,'db10'); %����3��С�����ֽ�

    nodesNum = 2^(order+1)-2;  % 3��Ϊ����������ڵ�  �ڶ��� 1 2  ������ 3 4 5 6 ������ 7 8 9 10 11 12 13 14
    nodes = nodesNum-2^order+1:nodesNum;
    nodes_ord = wpfrqord(nodes'); % �����������

    rcfs = zeros(1,length(Sig));
    for node=1:16
        rcfs = rcfs + wprcoef(wpt,[6 nodes_ord(node)-1]);
    end
    alpha(ch,:) = rcfs;%%%%%%%%%%%%%%%%%%%%%%%%%      
end

%% ��ͨ���źŹ�һ����ͼ
y_high = 20*16;
myALLChannelsPlot(input,10);
line([flag12(1),flag12(1)],[0,y_high],'linewidth',3,'color','r'); hold on;
line([flag12(end),flag12(end)],[0,y_high],'linewidth',3,'color','r'); hold on;
line([flag12(end),flag12(end)],[0,y_high],'linewidth',3,'color','r'); hold on;
title('Ԥ�����˲����ͨ���ź�');

myALLChannelsPlot(alpha,11);
line([flag12(1),flag12(1)],[0,y_high],'linewidth',3,'color','r'); hold on;
line([flag12(end),flag12(end)],[0,y_high],'linewidth',3,'color','r'); hold on;
line([flag12(end),flag12(end)],[0,y_high],'linewidth',3,'color','r'); hold on;
title('С���ع���ͨ���ź�');

%%  GFP ���� ��ʹ��alpha��
GFP_input = alpha;
%%
myALLChannelsPlot(GFP_input,13);
myALLChannelsPlot(input,14);
%%
GFP_input = myUniformSig(GFP_input);  % ��ͨ����һ�� ��׼������1  ��ֵ��0 ��ͬ���زο�
[GFP_input,cut] = myCutData(GFP_input,1.2); % ȥ�����д��ڱ�׼��1.2�����źŶ�
input = myUniformSig(input);  % ��ͨ����һ�� ��׼������1  ��ֵ��0 ��ͬ���زο�
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

% ɾ�������GFP��
th = 1;
x(y>th)=[];
y(y>th)=[];

figure(2);
plot(GFP);hold on;
plot(x,y,'r.');hold on;
ylim([0,th*1.5]);
title('GFP and peaks');

% �����жϺ�ɾ�����ڴ�����
% x(494:503)=[];

%% kmeans ����ǰ���� ��һ��

raw_sig = zeros(length(channels),length(GFP_input));


% Ҫ��ʾ����ͼ������Դ
% raw_sig(:,:) = signals(3:17,:);
% raw_sig(:,:) = GFP_input;
raw_sig(:,:) = input;



%% ����
Kmean_input = zeros(length(x),15);
% ����Ȥ��GFP��ֵ��xд�������������
for i=1:length(x)
    Kmean_input(i,:) = raw_sig(:,x(i)); 
end
% ���� Idx���ŷ����ǩ C����K����ľ������ģ�������Ϊ����ı�׼ģ�壩
K = 4;
tic;
[Idx,C]=kmeans(Kmean_input,K,'Replicates',300);
toc;
disp('�������');

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

%%  �����໭ͼ�۲�
index = 1;
for i=1:K
%     figure(98);
%     Idxtmp = x(Idx==i);
%     RR = randperm(numel(Idxtmp));
%     for j=x(RR(1:4)) % �ӵ�һ���������ȡ�ĸ�
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

win_step = 200;       % ���ڲ��������
win_width = Fs*30;  % 30s һ������
total_time = length(signals)-win_width-1; % ����Ȥ�źų���
% total_time = 10000;
win_N = floor((total_time-win_width+1)/win_step); % �ܴ���
E_type_N = 20;      % ��Ҫ�������������
FFT_points_N = win_width/2+1;% 0��50Hz��Ƶ�׵���


E_all_bands = zeros(win_N,E_type_N);  % �������������ʱ���¼
My_TF_spectrum = zeros(win_N,FFT_points_N);
En_all_channels = zeros(win_N,1);


%%
channel = 5;



for i=1:win_N
    Sig = signals(channel,i+(i-1)*win_step:i+(i-1)*win_step+win_width-1);

    Sig = myFilter(Sig);

%     myFFTplot(Sig,1); % ��Ҫ��㿪 ��ͼ̫����
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





