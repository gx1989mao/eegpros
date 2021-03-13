w = 5;
load('iosIDX_BW.mat');
ISOB = ISOPROC(IDX,w);
load('iosIDX_C.mat');
ISOC = ISOPROC(IDX,w);

%%

figure;
plot(ISOC,'r');hold on;
plot(ISOB,'b');hold on;
line([0,400],[0,0]);hold on;
