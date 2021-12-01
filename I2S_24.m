clc;
clear;
my_table=readtable('D:\06, Matlab\TXT\I2S_24_1.txt');

[my_data1,my_data2]=I2S_Inv_24(my_table);

% my_data1=(my_data1)*1.7;

% my_data1=floor((my_data1)/2^6)
max(abs(my_data1))
% my_data2=(my_data2)/2^6;
subplot(2,1,1)
plot(1:length(my_data1),my_data1)
axis([0,length(my_data2),-165535-1000,165535+1000])
title('Left channel')

subplot(2,1,2)
plot(1:length(my_data2),my_data2)
axis([0,length(my_data2),-165535-1000,165535+1000])
title('Right channel')
