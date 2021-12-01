clear;
clc;
%%%%%%%%%%%%%%%ONLY_READ%%%%%%%%%%%%%
OFZ_DEPTH = 2^11;
ANC_DEPTH = 2^11;
FILTER_LENGTH =126;
% rand('seed',10);
format long


% %%%%%%%%%%%%%%%OFZ%%%%%%%%%%%%%
Pw=fir1(FILTER_LENGTH-1,0.7);
% Sw=xlsread("D:\06, Matlab\Excel\sz.xlsx");
Sw=fir1(FILTER_LENGTH-1,0.3);
% Sw=roundHex(Sw,20);
% Pw=Sw*2;
% 固定的随机白噪声1ad6
OFZ_vn = roundHex((rand(1,OFZ_DEPTH)-0.5),16); 
OFZ_dn = roundHex(filter(Sw,1,OFZ_vn),16);  

% my_table3=readtable('D:\06, Matlab\TXT\R1.txt');
% my_table3=readtable('D:\06, Matlab\TXT\I2S_24_2.txt');
% [my_data5,my_data6]=displayIIS24(my_table3);
% OFZ_dn = my_data5(1:OFZ_DEPTH)/2^20;
% OFZ_dn(1:500) = 0;


%{ 
        Here is the OFZ process
%}
OFZ_Sh_yn = zeros(1, OFZ_DEPTH);
OFZ_Sh_Sz = zeros(OFZ_DEPTH,FILTER_LENGTH); 
OFZ_en = zeros(1, OFZ_DEPTH);
OFZ_Sh_dn = OFZ_dn;
OFZ_Sh_vn=[OFZ_vn(1) zeros(1,FILTER_LENGTH-1)]; 


mu=2^(-8); % ???
for k=1:OFZ_DEPTH-1 % ???? k

OFZ_Sh_yn(k)=dot(OFZ_Sh_vn,OFZ_Sh_Sz(k,:));
OFZ_Sh_yn(k)=roundHex(OFZ_Sh_yn(k),32); 

OFZ_en(k)=OFZ_Sh_dn(k)-OFZ_Sh_yn(k);
OFZ_en(k)=roundHex(OFZ_en(k),32); 

OFZ_Sh_Sz(k+1,:) = OFZ_Sh_Sz(k,:) + mu * OFZ_en(k) * OFZ_Sh_vn;
OFZ_Sh_Sz(k+1,:) = roundHex(OFZ_Sh_Sz(k+1,:),20); 
% 
%     if(k==10)
%        hex_display(OFZ_Sh_yn(k),36,36)
%        hex_display(OFZ_Sh_dn(k),16,16)
%        hex_display(OFZ_en(k),36,36)
%        hex_display(OFZ_Sh_vn,16,16)
%        hex_display(OFZ_Sh_Sz(k,:),20,20)
%     end
OFZ_Sh_vn=[OFZ_vn(k+1) OFZ_Sh_vn(1:FILTER_LENGTH-1)]; 
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
stem(Sw)
hold on;
stem(OFZ_Sh_Sz(OFZ_DEPTH-1,:), 'r*')
hold off;
title('S(z) & S(w)');

subplot(4,4,4)
plot((1:OFZ_DEPTH), OFZ_Sh_yn)
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

% ANC_xn = roundHex((rand(1,ANC_DEPTH)-0.5),16);  
% fsin = 0.1*createSin(50000/ANC_DEPTH*30,50000,ANC_DEPTH,0.5) +...
%        0.1*createSin(55000/ANC_DEPTH*30,50000,ANC_DEPTH,0.5) +...
%        0.1*createSin(60000/ANC_DEPTH*30,50000,ANC_DEPTH,0.5) +...
%        0.1*createSin(65000/ANC_DEPTH*30,50000,ANC_DEPTH,0.5) +...
%        0.1*createSin(45000/ANC_DEPTH*30,50000,ANC_DEPTH,0.5);
fsin = 0.5*createSin(20000/ANC_DEPTH*30,50000,ANC_DEPTH,0.5);
ANC_xn = roundHex(fsin,16);  
ANC_pn = roundHex(filter(Pw,1,ANC_xn),16);


ANC_Sh_xn = [ANC_xn(1) zeros(1,FILTER_LENGTH-1)];
ANC_Sh_yn = zeros(1,FILTER_LENGTH);
ANC_Sh_sn = zeros(1,FILTER_LENGTH);

ANC_yn      = zeros(ANC_DEPTH,1);
ANC_wz      = zeros(ANC_DEPTH-1,FILTER_LENGTH);
ANC_yn_s    = zeros(ANC_DEPTH-1,1);
ANC_en      = zeros(ANC_DEPTH,1);
ANC_sn      = zeros(ANC_DEPTH,1);
ANC_mu      = 2^(-8);

for k=1:ANC_DEPTH-1

ANC_yn(k) = dot(ANC_wz(k,:),ANC_Sh_xn);
% ANC_yn(k) = roundHex(ANC_yn(k),40);

ANC_Sh_yn = [ANC_yn(k) ANC_Sh_yn(1:FILTER_LENGTH-1)];

ANC_yn_s(k)  = dot(ANC_Sh_yn,Sw);
% ANC_yn_s(k) = roundHex(ANC_yn_s(k),40);



ANC_en(k) = ANC_pn(k) - ANC_yn_s(k);
ANC_en(k) = ANC_en(k);
% ANC_en(k) = roundHex(ANC_en(k),16);

ANC_sn(k) = dot(ANC_Sh_xn,Sw);
% ANC_sn(k) = roundHex(ANC_sn(k),40);

ANC_Sh_sn = [ANC_sn(k) ANC_Sh_sn(1:FILTER_LENGTH-1)];

ANC_wz(k+1,:) = ANC_wz(k,:) + ANC_mu*ANC_en(k)*ANC_Sh_sn;
% ANC_wz(k+1,:) = roundHex(ANC_wz(k+1,:),20);

%     if(k==180)
%        hex_display(ANC_en(k),16,16)
%        hex_display(ANC_yn(k),36,40)
%        hex_display(ANC_sn(k),36,40)
%        
%        hex_display(ANC_Sh_sn(8),36,40)
%        hex_display(ANC_en(k)*ANC_Sh_sn(8),52,60)
%         
%         a=ANC_en(k)*ANC_sn(k)/2^40;
%         hex_display(a,20,20)
%         hex_display(a+ANC_wz(k,8),20,20)
%        
%        hex_display(ANC_wz(k,:),20,20)
%        hex_display(ANC_wz(k+1,:),20,20)
%        hex_display(Sw,20,20)
%        hex_display(ANC_Sh_xn,16,16)
%        
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
plot(1:ANC_DEPTH,ANC_xn)
plot(1:ANC_DEPTH,ANC_pn)
hold off;
title('ANC xn');

subplot(4,4,8)
hold on;
stem(Pw)
stem(ANC_wz(ANC_DEPTH-1,:), 'r*')
hold off;
title('S(z) & S(w)');
% %-----------------------Write mif file-------------------------%
% writeMifFile('D:\06, Matlab\MIF/sz_rom.mif',2^20*roundHex(Sw,20),20,FILTER_LENGTH); 
% % writeMifFile('D:\06, Matlab\MIF/vn_rom.mif',(2^16)*OFZ_vn,16,OFZ_DEPTH); 
% % writeMifFile('D:\06, Matlab\MIF/dn_rom.mif',(2^16)*OFZ_dn,16,OFZ_DEPTH) ;
% writeMifFile('D:\06, Matlab\MIF/xn_rom.mif',(2^16)*ANC_xn,16,ANC_DEPTH) ;
% writeMifFile('D:\06, Matlab\MIF/en_rom.mif',(2^16)*ANC_en,16,ANC_DEPTH) ;