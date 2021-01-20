function [] = myALLChannelsPlot(input,fig)
y_high = 20*16;
figure(fig);
for ch=1:15
    plot(input(ch,:)+ch*200);hold on;  % alpha –°≤®÷ÿππ
end
% line([flag10(1),flag10(1)],[0,y_high],'linewidth',3,'color','r'); hold on;
% line([flag10(end),flag10(end)],[0,y_high],'linewidth',3,'color','r'); hold on;
% line([flag12(end),flag12(end)],[0,y_high],'linewidth',3,'color','r'); hold on;
% ylim([0,y_high]);
end

