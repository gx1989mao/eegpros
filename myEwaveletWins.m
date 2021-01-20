function [CLI] = myEwaveletWins(input,win_width,fold)
L = length(input);
t = 1:win_width-fold:L-win_width;
disp(length(t));
CLI = zeros(1,length(t));
for i = 1:length(t)
    Sig = input(1,t(i):t(i)+win_width-1);%%%  注意这里只用了第一通道  ！！！！
    [E_delta,E_theta,E_alpha,E_beta,E_gamma] = myEwavelet(Sig);close;
    CLI(1,i) = (E_theta+E_beta)./E_alpha;
    
end
end

