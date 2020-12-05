function [res] = myFilter(Sig)
Fs=250;
V_count = 1.2* 8388607.0 * 1.5 * 51.0;
% Sig = Sig';
% Sig = [flipud(Sig);Sig]; %¾µÏñ

res = Sig;


[n,Wn] = buttord(2*0.5/Fs,2*0.3/Fs,1,20);
[bb,aa] = butter(n,Wn,'high');
% [h,f]=freqz(bb,aa,1000,'whole',Fs);     
% figure(200);plot(f(1:501),20*log10(abs(h(1:501))),'b');hold on;
res = filter(bb,aa,res);
% 
[n,Wn] = buttord(2*45/Fs,2*48/Fs,1,20);
[bb,aa] = butter(n,Wn,'low');
% % [h,f]=freqz(bb,aa,1000,'whole',Fs);      
% % figure(200);plot(f(1:501),20*log10(abs(h(1:501))),'b');hold on;
res = filter(bb,aa,res);




% res = movavg(res,20,20,'e');
% res = medfilt1(res,10);
res =res/ V_count;
% res = res(length(res)/2+1:end); %È¡Ò»°ë
res = res';
end

