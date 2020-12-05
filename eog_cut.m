function [ Y ] = eog_cut( X )
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明

N=6;[C,L]=wavedec(X,N,'sym3');%sym3的小波函数与EOG的波形最相似
cd1=detcoef(C,L,1);%101.25-200Hz
cd2=detcoef(C,L,2);%50.875-101.25Hz
cd3=detcoef(C,L,3);%25.6875-50.875hz
cd4=detcoef(C,L,4);%13.09375-25.6825Hz
cd5=detcoef(C,L,5);%6.796875-13.09375Hz
cd6=detcoef(C,L,6);%3.65-6.79Hz
ca6=appcoef(C,L,'sym3',6);%0.5-3.65Hz
% Y6=wrcoef('d',C,L,'sym3',6);
% Y5=wrcoef('d',C,L,'sym3',5);

% if((mean(abs(Y6))>20)) 
%    cd6=changewavedec(cd6',length(cd6),1.5,0.2)';
% end
% if((mean(abs(Y5))>20)) 
%    cd5=changewavedec(cd5',length(cd5),1.5,0.2)';
% end

Cc=[ca6 cd6 cd5 cd4 cd3 cd2 cd1];
% Cc=[ca6
%     cd6
%     cd5
%     cd4
%     cd3
%     cd2
%     cd1];
Y6=wrcoef('d',Cc,L,'sym3',6);
Y5=wrcoef('d',Cc,L,'sym3',5);
Y4=wrcoef('d',Cc,L,'sym3',4);
Y3=wrcoef('d',Cc,L,'sym3',3);
Y=Y3+Y4+Y5+Y6;
end

