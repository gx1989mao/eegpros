function [E] = myTotalFFTenergy(Sig)
f=abs(fftshift(fft(Sig.^2)));             
f = 10*log(f)/log(10);
E = sum(f(7500/2:end))*(7500/250);
end

