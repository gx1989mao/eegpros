clc;clear;
%%
A = xlsread('D:\python.xlsx',1,'I2:I70');
factor=5;
B = floor(randn(69,1)*5);
C = A+B;

C = floor(C/5)*5;
%%
A = xlsread('D:\python.xlsx',1,'K2:K70');

%%
xlswrite('D:\python.xlsx',C,1,'J2:J70');
%%
xlswrite('D:\python.xlsx',A,3,'K2:K70');
%%
figure;
plot(A,'b');
hold on;
% plot(B,'r');
% hold on;
% 
% plot(C,'bo');
% hold on;

%%
figure;
bar(sort(A));

%%

ALL = xlsread('D:\python.xlsx',3,'K2:K70');
% figure;
% plot(ALL,'b');
% hold on;
SS = {'E2:E70','F2:F70','G2:G70','H2:H70','I2:I70','J2:J70'};
for j=1:6
for i =1:length(ALL)
    ALL(i) = ALL(i)+(unidrnd(3)-2)*5;
    if ALL(i)<60
        ALL(i)=60;
    end
    if ALL(i)>95
        ALL(i)=90;
    end
end
xlswrite('D:\python.xlsx',ALL,3,SS{j});
end
