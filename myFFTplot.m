function [] = myFFTplot(Sig,figureNum)
Fs = 250;
f=abs(fftshift(fft(Sig.^2)));             
f = 10*log(f)/log(10);
w=linspace(-Fs/2,Fs/2,length(Sig));  
figure(figureNum);
plot(w,abs(f)); % hold on;
xlim([0,60]);
end

