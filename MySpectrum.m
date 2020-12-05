function [Sp] = MySpectrum(Sig)

f=abs(fftshift(fft(Sig.^2)));             
f = 10*log(f)/log(10);
Sp = f(7500/2:end);
end

