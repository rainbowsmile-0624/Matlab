
clear;
DEPTH=256;
WIDTH=16;
T=4;
x = 0:2*pi*T/DEPTH:2*pi*T;
y=sin(x)*2^(WIDTH-1);
for i=1:DEPTH-1
    if(y(i)==32768)
        y(i)=y(i)-1;
    end
end
y=floor(y);
max(y)
min(y)
plot(x,y), grid on
Write_mif('D:\06, Matlab\TXT\sin.mif',y,WIDTH,DEPTH) 