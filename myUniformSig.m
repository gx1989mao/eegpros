function [res] = myUniformSig(input)
res = input./std(input,0,2);
res = res-mean(res,2);
end

