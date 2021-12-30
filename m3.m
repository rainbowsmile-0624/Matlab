clear;
clc;
warning off;
%%%%%%%%%%%%%%%ONLY_READ%%%%%%%%%%%%%
ANC_DEPTH = 2^11;
FILTER_LENGTH =226;
FILTER_ACCR =20;


% Sw=xlsread("D:\06, Matlab\Excel\sz.xlsx");
Sw =fir1(FILTER_LENGTH-1,0.3);
Sw=bitsRound(Sw*2^FILTER_ACCR,FILTER_ACCR);

File_xn = load ('D:\06, Matlab\Excel\ANC_xn.mat');
File_en = load ('D:\06, Matlab\Excel\ANC_en.mat');
ANC_xn = floor(File_xn.ANC_xn*2^16);
ANC_en = floor(File_en.ANC_en*2^16);ANC_en = ANC_en';
ANC_xn = [ANC_xn ANC_xn ANC_xn ANC_xn ANC_xn...
    ANC_xn ANC_xn ANC_xn ANC_xn ANC_xn ANC_xn...
    ANC_xn ANC_xn ANC_xn ANC_xn];
ANC_en = [ANC_en ANC_en ANC_en ANC_en ANC_en...
    ANC_en ANC_en ANC_en ANC_en ANC_en ANC_en...
    ANC_en ANC_en ANC_en ANC_en];

EXTENDED_ANC_DEPTH = ANC_DEPTH*15;
ANC_Sh_xn = [ANC_xn(1) zeros(1,FILTER_LENGTH-1)];
ANC_Sh_sn = zeros(1,FILTER_LENGTH);

ANC_yn      = zeros(EXTENDED_ANC_DEPTH,1);
ANC_wz      = zeros(EXTENDED_ANC_DEPTH-1,FILTER_LENGTH);
ANC_sn      = zeros(EXTENDED_ANC_DEPTH,1);
ANC_mu      = 2^(-5);

for k=1:EXTENDED_ANC_DEPTH-1
    
%     for i=1:FILTER_LENGTH
%         ANC_yn(k) = ANC_yn(k) + ANC_wz(k,i)*ANC_Sh_xn(i);
%     end
    ANC_yn(k)=dot(ANC_wz(k,:),ANC_Sh_xn);
    ANC_yn(k) = bitsRound(ANC_yn(k),44);
    
%     for i=1:FILTER_LENGTH
%         ANC_sn(k) = ANC_sn(k) + Sw(i)*ANC_Sh_xn(i);
%     end
    ANC_sn(k)=dot(Sw,ANC_Sh_xn);
    ANC_sn(k) = bitsRound(ANC_sn(k),44);
    
    %shift
    ANC_Sh_sn = [ANC_sn(k) ANC_Sh_sn(1:FILTER_LENGTH-1)];
    
    ANC_wz(k+1,:) = ANC_wz(k,:) + ANC_mu * ANC_Sh_sn * ANC_en(k) * 2^(-32);
	ANC_wz(k+1,:) = bitsRound(ANC_wz(k+1,:),28);
    
    %shift
    
    if k==2048*0+670
    	hexDisplay(ANC_yn(k),40)
        hexDisplay(ANC_sn(k),40)
        hexDisplay(ANC_wz(k+1,:),20)
    end
    
    ANC_Sh_xn = [ANC_xn(k+1) ANC_Sh_xn(1:FILTER_LENGTH-1)];
end


figure(1);
subplot(4,4,5)
plot(1:length(ANC_yn),ANC_yn)
title('ANC yn');

subplot(4,4,6)
plot(1:length(ANC_en),ANC_en)
title('ANC en');

subplot(4,4,7)
hold on;
plot(1:length(ANC_xn),ANC_xn)
hold off;
title('ANC xn');

subplot(4,4,8)
hold on;
stem(Sw/2^20)
stem(ANC_wz(EXTENDED_ANC_DEPTH-1,:)/2^20, 'r*')
hold off;
title('S(z) & S(w)');

% %-----------------------Write mif file-------------------------%
% writeMifFile('D:\06, Matlab\MIF/sz_rom.mif',2^20*roundHex(Sw,20),20,FILTER_LENGTH); 
% % writeMifFile('D:\06, Matlab\MIF/vn_rom.mif',(2^16)*OFZ_vn,16,OFZ_DEPTH); 
% % writeMifFile('D:\06, Matlab\MIF/dn_rom.mif',(2^16)*OFZ_dn,16,OFZ_DEPTH) ;
% writeMifFile('D:\06, Matlab\MIF/xn_rom.mif',ANC_xn,16,ANC_DEPTH) ;
% writeMifFile('D:\06, Matlab\MIF/en_rom.mif',ANC_en,16,ANC_DEPTH) ;
