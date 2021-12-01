clc;
clear;

my_table=readtable('D:\06, Matlab\TXT\I2S_16.txt');
[my_data1,my_data2]=I2S_Inv_16(my_table);
subplot(4,1,1)
plot(1:length(my_data1),my_data1)
axis([0,length(my_data1),-32768-1000,32767+1000])
title('Speaker OUT')

subplot(4,1,2)
plot(1:length(my_data2),my_data2)
axis([0,length(my_data2),-32768-1000,32767+1000])
title('Right channel')





