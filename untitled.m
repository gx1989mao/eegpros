% clear;clc;
% load('2020_11_20_16_43_54-Processed.mat');
load('2020_11_20_18_36_06-Processed.mat');
Fs = 125;

win = 5*Fs;
step = 1*Fs;
[~,len] = size(CUTSIG);
pe = zeros(15,floor((len-win)/step));
% ce = zeros(15,floor((len-win)/step));
for i=1:floor((len-win)/step)
    for ch =1:15
        sig = CUTSIG(ch,(i-1)*step+1:i*step+win);
        tmp = myPEn(sig,4,10);
%         tmpce = ssce(sig, 4);
        pe(ch,i) = tmp;
%         ce(ch,i) = tmpce;
    end
end
%%
plot(ce(15,:));

%%

Z = ISOPROC(pe,50);
Z1 = ISOPROC(PE,50);
Z = Z/max(abs(Z));
Z1 = Z1/max(abs(Z1));
wsize = 4;
b = (1/wsize)*ones(1,wsize);
a = 1;

Z = filter(b,a,Z);
Z1 = filter(b,a,Z1);
figure(1);
plot(Z,'b');hold on;
plot(Z1,'r');hold on;
%%
ce = fillmissing(ce,'previous');
CE = fillmissing(CE,'previous');
Z = ISOPROC(ce,10);
Z1 = ISOPROC(CE,10);
Z = Z/max(abs(Z));
Z1 = Z1/max(abs(Z1));
wsize = 7;
b = (1/wsize)*ones(1,wsize);
a = 1;

Z = filter(b,a,Z);
Z1 = filter(b,a,Z1);
figure(1);
plot(Z,'b');hold on;
plot(Z1,'r');hold on;

%%
blue = '#2085BE';
red  = '#D01828';

Axd = 2.5;
Ayc = 0.18;
Ayd = 0.1;
Bxd = 7;
Byc = 0.13;
Byd = 0.7;

clf;

XA = rand(1,19)*Axd;
YA = (rand(1,19)*2-1)*Ayd+Ayc;
color = blue;
plot(XA,YA,'o','LineWidth',2,'Color',color,'MarkerFaceColor',color);hold on;

XB = rand(1,19)*Bxd;
YB = (rand(1,19)*2-1)*Byd+Byc;
color = red;
plot(XB,YB,'o','LineWidth',2,'Color',color,'MarkerFaceColor',color);hold on;

% ylim([0,0.25]);

%%


