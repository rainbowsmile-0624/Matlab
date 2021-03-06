clc;
clear;
TIME_LENTH=1000;
format short

my_table1=readtable('D:\06, Matlab\TXT\I2S_16.txt');
my_table2=readtable('D:\06, Matlab\TXT\I2S_24_1.txt');
my_table3=readtable('D:\06, Matlab\TXT\I2S_24_2.txt');


[my_data1,my_data2]=displayIIS16(my_table1);
[my_data3,my_data4]=displayIIS24(my_table2);
[my_data5,my_data6]=displayIIS24(my_table3);

my_data3=floor((my_data3)/2^4);
my_data5=floor((my_data5)/2^4);
figure(1);
subplot(4,1,1)
hold on;
plot(1:length(my_data1),my_data1)
plot(1:length(my_data3),my_data3)
hold off;
axis([512,length(my_data1),-32768,32767])
figure(1);
subplot(4,1,2)
plot(1:length(my_data2),my_data2)
axis([1,length(my_data2),-32768,32767])
title('Fn')

subplot(4,1,3)
plot(1:length(my_data3),my_data3)
axis([1,length(my_data3),-32768,32767])
title('Left channel')

subplot(4,1,4)
plot(1:length(my_data5),my_data5)
axis([1,length(my_data5),-32768,32767])
title('Right channel')
figure(2)
MyFFT(my_data3,24414)
figure(3)
MyFFT(my_data5,24414)
X = sprintf('拟合分贝为%ddB',round(10*log10(max(my_data5)/rms(my_data5(3000:3500)))));
disp(X)

