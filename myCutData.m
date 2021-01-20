function [res,cut] = myCutData(input,th)
res = input;
win_width = 20;
cut=1:20;
for i=win_width:length(input)
    if max(max(abs(input(:,i-win_width+1:i))))>th
        cut = [cut,i];
    end
end

res(:,cut)=[];
% res(:,1:20)=[];
end

