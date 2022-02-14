clear;
clc;
clf;
clear all;
%%%%%%%%%%%%%%%ONLY_READ%%%%%%%%%%%%%
OFZ_DEPTH = 2^12;
ANC_DEPTH = 2^12;
FILTER_LENGTH =126;
rand('seed',10);
format default;
% %%%%%%%%%%%%%%%OFZ%%%%%%%%%%%%%
Pw=fir1(FILTER_LENGTH-1,0.3);

Sw =fir1(FILTER_LENGTH-1,0.3);

% 固定的随机白噪声1ad6
OFZ_vn = 2^(16)*(rand(1,OFZ_DEPTH)-0.5);
OFZ_dn = filter(Sw,1,OFZ_vn);
OFZ_vn = bitsRound(OFZ_vn,16);
OFZ_dn = bitsRound(OFZ_dn,16);

% Sw=bitsRound(Sw*2^20,20);

% my_table3=readtable('D:\06, Matlab\TXT\R1.txt');
% my_table3=readtable('D:\06, Matlab\TXT\I2S_24_2.txt');
% [my_data5,my_data6]=displayIIS24(my_table3);
% OFZ_dn = my_data5(1:OFZ_DEPTH)/2^19*2^16;
% OFZ_dn(1:500) = 0;

%{ 
        Here is the OFZ process
%}
OFZ_yn    = zeros(1, OFZ_DEPTH);
OFZ_Sh_Sz = zeros(OFZ_DEPTH,FILTER_LENGTH); 
OFZ_en    = zeros(1, OFZ_DEPTH);
OFZ_Sh_vn = zeros(1,FILTER_LENGTH); 
mu       = 2^(-5); 



for k=1:OFZ_DEPTH-1
    %shift
    OFZ_Sh_vn=[OFZ_vn(k) OFZ_Sh_vn(1:FILTER_LENGTH-1)]; 
    
    OFZ_yn(k)=dot(OFZ_Sh_vn,OFZ_Sh_Sz(k,:));
    OFZ_yn(k)=bitsRound(OFZ_yn(k),36);

    OFZ_en(k)=OFZ_dn(k)-OFZ_yn(k);
    OFZ_en(k)=bitsRound(OFZ_en(k),36); 

    OFZ_Sh_Sz(k+1,:) = OFZ_Sh_Sz(k,:) + mu * OFZ_en(k) * OFZ_Sh_vn*2^(-32);
    OFZ_Sh_Sz(k+1,:) = bitsRound(2^20*OFZ_Sh_Sz(k+1,:),20)/2^20; 

    
end

figure(1);
subplot(4,4,1)
plot((1:OFZ_DEPTH), OFZ_vn)
xlabel('Discrete time k');
hold on;
plot((1:OFZ_DEPTH), OFZ_dn)
hold off;

subplot(4,4,2)
plot((1:OFZ_DEPTH), OFZ_en)
title('f(n)');

subplot(4,4,3)
% stem(Sw)
hold on;
plot(OFZ_Sh_Sz(OFZ_DEPTH-1,:))
hold off;
title('S(z) & S(w)');

subplot(4,4,4)
plot((1:OFZ_DEPTH), OFZ_yn)
title('OFZ y(n)');

figure(2);
subplot(1,1,1)
hold on;
for k=20:60
    plot((1:length(OFZ_Sh_Sz(:,2))), OFZ_Sh_Sz(:,k))
end
hold off;
title('OFZ_Sh_Sz');


%{ 
        Here is the ANC process
%}

% ANC_xn = bitsRound((rand(1,ANC_DEPTH)-0.5),16);  
fsin = (2^16-1)*createSin(51200/ANC_DEPTH*10,51200,ANC_DEPTH,0.5);
% fsin = 0.5*createSin(20000/ANC_DEPTH*30,50000,ANC_DEPTH,0.5);
ANC_xn = bitsRound(fsin,16);  
ANC_pn = bitsRound(filter(Pw,1,ANC_xn),16);

ANC_Sh_xn = [ANC_xn(1) zeros(1,FILTER_LENGTH-1)];
ANC_Sh_yn = zeros(1,FILTER_LENGTH);
ANC_Sh_sn = zeros(1,FILTER_LENGTH);

ANC_yn      = zeros(ANC_DEPTH,1);
ANC_wz      = zeros(ANC_DEPTH-1,FILTER_LENGTH);
ANC_yn_s    = zeros(ANC_DEPTH-1,1);
ANC_en      = zeros(ANC_DEPTH,1);
ANC_sn      = zeros(ANC_DEPTH,1);
ANC_mu      = 2^(-12);

for k=1:ANC_DEPTH-1

ANC_yn(k) = dot(ANC_wz(k,:),ANC_Sh_xn);
% ANC_yn(k) = bitsRound(ANC_yn(k),40);

ANC_Sh_yn = [ANC_yn(k) ANC_Sh_yn(1:FILTER_LENGTH-1)];

ANC_yn_s(k)  = dot(ANC_Sh_yn,Sw);
% ANC_yn_s(k) = bitsRound(ANC_yn_s(k),40);



ANC_en(k) = ANC_pn(k) - ANC_yn_s(k);
% ANC_en(k) = ANC_en(k)*0.7;
% ANC_en(k) = bitsRound(ANC_en(k),16);

ANC_sn(k) = dot(ANC_Sh_xn,Sw);
% ANC_sn(k) = bitsRound(ANC_sn(k),40);

ANC_Sh_sn = [ANC_sn(k) ANC_Sh_sn(1:FILTER_LENGTH-1)];

ANC_wz(k+1,:) = ANC_wz(k,:) + ANC_mu*ANC_en(k)*ANC_Sh_sn*2^(-32);
% ANC_wz(k+1,:) = bitsRound(ANC_wz(k+1,:),20);

%     if(k==10)
%         hexDisplay(ANC_yn(k)*2^40,40);
%     end
ANC_Sh_xn = [ANC_xn(k+1) ANC_Sh_xn(1:FILTER_LENGTH-1)];
end

figure(1);
subplot(4,4,5)
plot(1:ANC_DEPTH,ANC_yn)
title('ANC yn');

subplot(4,4,6)
plot(1:length(ANC_en),ANC_en)
title('ANC en');

subplot(4,4,7)
hold on;
plot(1:length(ANC_xn),ANC_xn)
% plot(1:length(ANC_pn),ANC_pn)
hold off;
title('ANC xn');

subplot(4,4,8)
hold on;
stem(ANC_wz(ANC_DEPTH-1,:), 'r*')
hold off;
title('S(z) & S(w)');
% %-----------------------Write mif file-------------------------%
% writeMifFile('D:\06, Matlab\MIF/sz_rom.mif',2^20*bitsRound(Sw,20),20,FILTER_LENGTH); 
% writeMifFile('D:\06, Matlab\MIF/vn_rom.mif',bitsRound((2^16)*OFZ_vn,16),16,OFZ_DEPTH); 
% writeMifFile('D:\06, Matlab\MIF/dn_rom.mif',(2^16)*OFZ_dn,16,OFZ_DEPTH) ;
% writeMifFile('D:\06, Matlab\MIF/xn_rom.mif',(2^16)*ANC_xn,16,ANC_DEPTH) ;
% writeMifFile('D:\06, Matlab\MIF/en_rom.mif',(2^16)*ANC_en,16,ANC_DEPTH) ;
