clc;clear;close all;

root_path = 'D:\myproj\eeg\数据（处理1221）\数据（处理1221）\黑白\';
flist = dir(root_path);
fnum = length(flist)-2;




EN_T_cnt = [];
EN_T = [];
% figure;
for i=1:fnum
    load([root_path,flist(i+2).name]); % load one mat file
    s_en = size(En_all_channels);
    EN_T_cnt = [EN_T_cnt;s_en(1)];
    EN_T = [EN_T;En_all_channels];
    % do process
%     plot(En_all_channels(:,1)+i*2);hold on;
for band = 1:4
    for ch=1:15
        imf0=pEMDandFFT(E4(:,ch,band),250/200);close;
        E4(:,ch,band) =E4(:,ch,band) -imf0(1,:)'-imf0(2,:)';
    end
end
% figure;
% for j =1:32
%     subplot(4,8,j);
%     myTopograph(En_all_channels(floor(s_en(1)/33)*j,:));hold on;
% end
E4(E4<0)=0;
Z = (E4(:,:,2)+E4(:,:,4))./E4(:,:,3);
Z(abs(Z)>20)=nan;
Z= fillmissing(Z,'previous');
figure(1);
    plot(sum(Z,2)+100*i);hold on;
    
end

%     imf0=pEMDandFFT(E4(:,1,1),250/200);%close;
%     input=imf0(3,:)+imf0(4,:)+imf0(5,:);
% %     imf1=pEMDandFFT(input,250/200);%close;
% 
% contourf(En_all_channels(:,:));hold on;