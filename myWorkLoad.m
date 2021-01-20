function [CLI] = myWorkLoad(reref_data,win_width,fold)
L = length(reref_data);
t = 1:win_width-fold:L-win_width;
disp(length(t));
CLI = zeros(1,length(t));
for i = 1:length(t)
    Sig = reref_data(5,t(i):t(i)+win_width-1);
    [~,THETA,~,~,~] = myEwavelet(Sig);close;
    Sig = reref_data(12,t(i):t(i)+win_width-1);
    [~,~,ALPHA,~,~] = myEwavelet(Sig);close;
    
    CLI(1,i) = THETA/ALPHA;
end

end

