function sin=createSin(f,fs,length)
% 
%fs=1000000/32;
%length: Expected sine wave points

N=fs/f;
n=0:length-1;
t=n/fs;%时间序列
y=0.5*sin(2*pi*f1*t);
plot(n,y);%画图