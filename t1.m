clear;
clc;
% b=bitsRound(0,16)
% b=bitsRound(1,16)
% b=bitsRound(-1,16)
% b=bitsRound(65536,16)
% b=bitsRound(-65536,16)
% b=bitsRound(-32768,16)
% b=bitsRound(-32769,16)
% hexDisplay(b,16);
% hexDisplay(b,16);

% a=-6;
% b=39;
% c=5;
% d=110;
% x=bitsRound(a*b,8)
% x=bitsRound(x*c,8)
% x=bitsRound(x*d,8)
% 
% x=bitsRound(a*b*c*d,8)FEBD76A2D8

convertToOriCode(hex2dec('FACB56A2D8'),40)
convertToOriCode(hex2dec('FEBD76A2D8'),40)
q0=convertToOriCode(hex2dec('FCC45D82EE'),40)
q1=convertToOriCode(hex2dec('80025'),20)
q2=convertToOriCode(hex2dec('3f22'),16)
q3=convertToOriCode(bitand(q1*q2+2^40,2^40-1),40)
hexDisplay(q0+q3,40)
File_xn = load ('D:\06, Matlab\Excel\xn.mat');
File_wz = load ('D:\06, Matlab\Excel\Sw.mat');
xn=File_xn.a
Wz=File_wz.b
c=0;
    for i=1:126
        c = c + Wz(i)*xn(i);
        c = bitsRound(c,40);
        i
        hexDisplay(xn(i),16)
        hexDisplay(Wz(i),20)
        hexDisplay(c,40)
    end
    
    bitsRound(524325,20)
    