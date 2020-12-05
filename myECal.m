function [E] = myECal(Sig,P1,P2,S1,S2)

Fs = 250;

[n,Wn] = buttord([2*P1/Fs,2*P2/Fs],[2*S1/Fs,2*S2/Fs],1,20);
[bb,aa] = butter(n,Wn,'bandpass');
% [h,f]=freqz(bb,aa,1000,'whole',Fs);       % 1000ΪƵ�ʷֱ��ʽ�Fs��Ƶ�η�̯��1000����   �����ֵ�ͨ�˲�����Ƶ����Ӧ,ʹ��n����������������λԲ����Ƶ����Ӧ
% figure(200);plot(f(1:501),20*log10(abs(h(1:501))),'b');hold on;
Sig = filter(bb,aa,Sig);

E = myTotalFFTenergy(Sig);
end

