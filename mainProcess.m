clc;clear;
load('D:\myproj\eeg\数据\数据\脑电\2020_11_20_16_43_54-raw.mat');

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





