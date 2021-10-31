w = 5;
load('iosIDX_BW.mat');
ISOB = ISOPROC(IDX,w);
load('iosIDX_C.mat');
ISOC = ISOPROC(IDX,w);

%%
w=5;
ISOC = ISOPROC(IDX,w);
figure;
plot(ISOC,'r');hold on;
% plot(ISOB,'b');hold on;
% line([0,400],[0,0]);hold on;
% disp(zero_crossings(ISOB));
disp(zero_crossings(ISOC));







x = 60;
e = 2.717;
y = e^(3.31954*log(x)+14.6227);
