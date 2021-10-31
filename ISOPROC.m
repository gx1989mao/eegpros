function [Z] = ISOPROC(IDX,w)
IDX1 = IDX_ApEn;
figure;
for i=1:7  
  IDX1(i,:) = medfilt1(IDX(i,:),w);
  plot(IDX1(i,4:end));hold on;
end
IDX1(:,1:w)=[];
IDX1(:,end-w:end)=[];
%%
X = IDX1';
k=30;

%% Isomap 
%% step1: Calculate the k nearest distance 
[m, ~] = size(X); %d<~
D = zeros(m);
for i =1 : m
    xx = repmat(X(i, :), m, 1);
    diff = xx - X;
    dist = sum(diff.* diff, 2);
    [dd, pos] = sort(dist);
    index = pos(1 : k + 1)';
    index2 = pos(k + 2 : m);
    D(i,index) = sqrt(dd(index));
    D(i, index2) = inf;
end
%% step2: recalculate shortest distant matrix
 
for k=1:m
    for i=1:m
        for j=1:m
            if D(i,j)>D(i,k)+D(k,j)
                D(i,j)=D(i,k)+D(k,j);
            end
        end
    end
end

for i = 1 : m
    for j = 1 : m
        if D(i,j) == inf
            if D(j,i)~=inf
                D(i,j) = D(j,i);
            else
                D(i,j) = 2;
            end
            
        end
    end
end

%%
Z = MDS(D, 1);
end

