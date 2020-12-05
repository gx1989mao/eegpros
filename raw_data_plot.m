clc;
clear;

load('D:\myproj\eeg\实验数据\实验数据\脑电\2020_11_02_18_40_34-raw.mat');

Fs = 250;  V_count = 1.2* 8388607.0 * 1.5 * 51.0;
% for i=1:17
%     figure(i);
%     plot(signals(i,:));
% end


for i=10

Sig = signals(i,15240:28020);


f=abs(fftshift(fft(Sig.^2)));                  %b表示信号值data
f = 10*log(f)/log(10);
w=linspace(-Fs/2,Fs/2,length(Sig));  %根据奈奎斯特采样定理，512/2为最大频率
figure(100);
subplot(2,1,1);
plot(w,abs(f));  hold on;
xlim([-3,60]);

% 
% figure(1)
% subplot(2,1,1);
% plot(Sig/V_count);
% ylim([-1e-5,1e-5]);


Fs=250;LEN = 30*Fs;


[n,Wn] = buttord(2*0.5/Fs,2*0.3/Fs,1,20);
[bb,aa] = butter(n,Wn,'high');
[h,f]=freqz(bb,aa,1000,'whole',Fs);       % 1000为频率分辨率将Fs的频段分摊到1000个点   求数字低通滤波器的频率响应,使用n个样本点在整个单位圆计算频率响应
figure(200);plot(f(1:501),20*log10(abs(h(1:501))),'b');hold on;
Sig = filter(bb,aa,Sig);



[n,Wn] = buttord([2*16/Fs,2*24/Fs],[2*18/Fs,2*22/Fs],1,20);
[bb,aa] = butter(n,Wn,'stop');
[h,f]=freqz(bb,aa,1000,'whole',Fs);       % 1000为频率分辨率将Fs的频段分摊到1000个点   求数字低通滤波器的频率响应,使用n个样本点在整个单位圆计算频率响应
figure(200);plot(f(1:501),20*log10(abs(h(1:501))),'b');hold on;
Sig = filter(bb,aa,Sig);

[n,Wn] = buttord([2*36/Fs,2*44/Fs],[2*38/Fs,2*42/Fs],1,20);
[bb,aa] = butter(n,Wn,'stop');
[h,f]=freqz(bb,aa,1000,'whole',Fs);       % 1000为频率分辨率将Fs的频段分摊到1000个点   求数字低通滤波器的频率响应,使用n个样本点在整个单位圆计算频率响应
figure(200);plot(f(1:501),20*log10(abs(h(1:501))),'b');hold on;
Sig = filter(bb,aa,Sig);

[n,Wn] = buttord(2*45/Fs,2*48/Fs,1,20);
[bb,aa] = butter(n,Wn,'low');
[h,f]=freqz(bb,aa,1000,'whole',Fs);       % 1000为频率分辨率将Fs的频段分摊到1000个点   求数字低通滤波器的频率响应,使用n个样本点在整个单位圆计算频率响应
figure(200);plot(f(1:501),20*log10(abs(h(1:501))),'b');hold on;
Sig = filter(bb,aa,Sig);


f=abs(fftshift(fft(Sig.^2)));                  %b表示信号值data
f = 10*log(f)/log(10);
w=linspace(-Fs/2,Fs/2,length(Sig));  %根据奈奎斯特采样定理，512/2为最大频率
figure(100);
subplot(2,1,2);
plot(w,abs(f));  hold on;
xlim([-3,60]);
figure(1)
subplot(2,1,1);
plot(Sig/V_count);
ylim([-1e-5,1e-5]);

figure(1);
subplot(2,1,2);
ma = movavg(Sig/V_count,20,20,'e');   % 滑动平均 取前二十个 后二十个 做一个40个的窗口 e代表了指数平均  前一个值要小于等于后一个值 窗口大 就很平 窗口小就滤波效果一般
% ma = movavg(Sig/V_count,200,400,'e'); 
plot(ma); 
ylim([-1e-5,1e-5]);




end






