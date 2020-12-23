clc;
clear;
close all;

% load('E_all_bands-wavelet-200step.mat');
load('D:\myproj\eeg\数据（处理1221）\数据（处理1221）\黑白\2020_11_02_20_04_37-feature.mat')

E4_copy = E4;
timepoint = 200;


SS = size(E4_copy);
I = zeros(SS(2),1);

for i=1:4
    subplot(2,2,i);
    I(:,1) = E4_copy(timepoint,:,i);
    myTopograph(I);
    
end













