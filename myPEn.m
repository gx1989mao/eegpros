function [pe] = myPEn(y,m,t)


ly = length(y);
permlist = perms(1:m);
c(1:length(permlist))=0;

for j =1:ly-t*(m-1)
    [a,iv] = sort(y(j:t:j+t*(m-1)));
    for jj=1:length(permlist)
        if (abs(permlist(jj,:)-iv))==0
            c(jj)=c(jj)+1;
        end
    end
end
c = c(find(c~=0));
p = c/sum(c);
pe = -sum(p.*log(p));

end

