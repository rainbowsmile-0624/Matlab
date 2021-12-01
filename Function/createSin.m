function data=createSin(f,fs,length,amp)
%f: frequency
%fs=1000000/32;
%length: Expected sine wave points
%amp: amplitude
N=0:length-1;
t=N/fs;
data=amp*sin(2*pi*f*t);


