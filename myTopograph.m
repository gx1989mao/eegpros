function [] = myTopograph(InputChannels,remove_ch)
if nargin==1
    remove_ch=[];
end
x = [-0.5,0.5,-1.5,-0.8,  0,0.8,1.5,-2,  0,2,-1.5,0,  1.5,-0.5,0.5];
y = [2,2,1.2,1.1,  1,1.1,1.2,0,   0,0,-1.2,-1,  -1.2,-2,-2];

x(remove_ch) = [];y(remove_ch) = [];InputChannels(remove_ch) = [];

    R = 2.2;

    z =InputChannels;
    [xi,yi] = meshgrid(-3:0.02:3);
    zi=griddata(x,y,z,xi,yi,'v4');
    zi(xi.^2+yi.^2>R^2)=nan;
    line([-0.5,0],[2,2.5],'LineWidth',3,'Color','k');hold on;   % ×îµ×²ã
    line([0.5,0],[2,2.5],'LineWidth',3,'Color','k');hold on; 
    rectangle('Position', [-2.3,-0.7,0.3,1.4], 'Curvature', [0.8 1],'LineWidth',3,'EdgeColor',[0,0,0]);hold on;
    rectangle('Position', [2,-0.7,0.3,1.4], 'Curvature', [0.8 1],'LineWidth',3,'EdgeColor',[0,0,0]);hold on;
    
    
    contourf(xi,yi,zi,35); hold on;
    caxis([-1 1]);
    
    % »­Ô² 
    r =2*R;%°ë¾¶
    a = 0;%ºá×ø±ê
    b = 0;%×Ý×ø±ê
    para = [a-r/2, b-r/2, r, r];
    rectangle('Position',para,'Curvature',[1,1],'LineWidth',3,'EdgeColor',[0,0,0]);hold on;
    
    axis([-3, 3, -3, 3]);
    plot(x,y,'k.','MarkerSize',20);hold on;
    view(0,90);grid off; 

    axis off;

end

