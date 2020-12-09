clc;
clear;
close all;

load('E_all_bands-wavelet-200step.mat');



x = [-0.5,0.5,-1.5,-0.8,  0,0.8,1.5,-2,  0,2,-1.5,0,  1.5,-0.5,0.5];
y = [2,2,1.2,1.1,  1,1.1,1.2,0,   0,0,-1.2,-1,  -1.2,-2,-2];
timepoint = 400;
figure;
for i=1:4
    z = E4(timepoint,:,i);
    [xi,yi] = meshgrid(-3:0.02:3);
    zi=griddata(x,y,z,xi,yi,'v4');
    zi(xi.^2+yi.^2>4)=nan;
    subplot(2,2,i);
    surf(xi,yi,zi,'EdgeColor','none');hold on;
    axis([-3, 3, -3, 3]);
    plot3(x,y,ones(15).*111,'ro');hold on;
    view(0,90);grid off; colormap(jet);axis off;
end
figure;
plot(x,y,'bo');axis([-3, 3, -3, 3]);





% z = E4(1,:,1);
% 
% [xi,yi] = meshgrid(-3:0.02:3);
% 
% zi=griddata(x,y,z,xi,yi,'v4');
% zi(xi.^2+yi.^2>4)=nan;
% 
% figure;
% plot(x,y,'bo');axis([-3, 3, -3, 3]);
% 
% figure;
% 
% surf(xi,yi,zi,'EdgeColor','none');axis([-3, 3, -3, 3]);
% view(0,90);grid off; colormap(cool);
% 
% % zi_cubic=interp2(xori,yori,z,xi,yi,'cubic');
% 















