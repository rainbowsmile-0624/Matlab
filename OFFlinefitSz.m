clear

%%%%%%%%%%%%%%%ONLY_READ%%%%%%%%%%%%%
DEPTH = 44444;
T=DEPTH;
rand('seed',10);
format short
Pw=[0.1 0.02 0.15 0.8 0.2 0.25 0.5 0.04 0.25 0.5 ...
    0.8 0.5 0.25 0.1 0.1 0.1 0.02 0.8 0.15 0.15 ...
    0.2 0.2 0.25 0.5 0.8 0.5 0.25 0.1 0.3 0.4];
Sw=Pw*0.23;

OFZ_vn = hex_round(rand(1,DEPTH)-0.5,16);  
OFZ_dn = hex_round(filter(Sw,1,OFZ_vn),16);     
ANC_xn = hex_round(rand(1,DEPTH)-0.5,16);      
ANC_pn = hex_round(filter(Pw,1,ANC_xn),16);
% ANC_pn = ANC_xn*0.8+hex_round(rand(1,DEPTH)-0.5,16)*0.2; 
% Write_mif('D:\06, Matlab\MIF/vn_rom.mif',(2^16)*OFZ_vn,16,DEPTH); 
% Write_mif('D:\06, Matlab\MIF/dn_rom.mif',(2^16)*OFZ_dn,16,DEPTH); 
% Write_mif('D:\06, Matlab\MIF/xn_rom.mif',(2^16)*ANC_xn,16,DEPTH); 
% Write_mif('D:\06, Matlab\MIF/en_rom.mif',(2^16)*ANC_en,16,DEPTH); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Sh_yn = zeros(1, T);
Sh_sz = zeros(1,30); 
Sh_en = zeros(1, T);
Sh_dn = OFZ_dn;
Sh_vn = flip(OFZ_vn(DEPTH/2-30+1:DEPTH/2));


mu=2^(-2); % ???
for k=1:DEPTH/2-1 % ???? k

Sh_vn=[OFZ_vn(k) Sh_vn(1:29)]; 

Sh_yn(k)=dot(Sh_vn,Sh_sz);
Sh_yn(k)=hex_round(Sh_yn(k),32); 

Sh_en(k)=Sh_dn(k)-Sh_yn(k);
Sh_en(k)=hex_round(Sh_en(k),32); 

Sh_sz   =Sh_sz + mu * Sh_en(k) * Sh_vn;
Sh_sz   =hex_round(Sh_sz,16); 


% hex_display(Sh_vn,16,16)
% hex_display(Sh_en(k),32,36)
% % Sh_sz
% a=Sh_sz*2^16
% Sh_sz=floor(a)
% Sh_sz=Sh_sz/2^16;

      

end




subplot(4,4,2)

plot((1:T), Sh_en)

ylabel('Amplitude');

xlabel('Discrete time k');



subplot(4,4,4)

plot((1:T), Sh_yn)

ylabel('Amplitude');

xlabel('Discrete time k');




subplot(4,4,3)

stem(Sw)

subplot(4,4,7)

stem(Sh_sz, 'r*')


%%%%%%%%%%%%%ANC%%%%%%%%%%
Shift_xn_30 = zeros(1,30);
Shift_yn_30 = zeros(1,30);
Shift_sn_30 = zeros(1,30);

ANC_yn      = zeros(DEPTH,1);
ANC_wz      = zeros(DEPTH-1,30);
ANC_yn_s    = zeros(DEPTH-1,1);
ANC_en      = zeros(DEPTH,1);
ANC_sn      = zeros(DEPTH,1);
ANC_mu      = 2^(-3);

for k=1:DEPTH-1
Shift_xn_30 = [ANC_xn(k) Shift_xn_30(1:29)];
% 内积代码
ANC_yn(k) = dot(ANC_wz(k,:),Shift_xn_30);

Shift_yn_30 = [ANC_yn(k) Shift_yn_30(1:29)];

ANC_yn_s(k)  = dot(Shift_yn_30,Sw);

ANC_en(k)  = ANC_pn(k) - ANC_yn_s(k);

ANC_sn(k) = dot(Shift_xn_30,Sh_sz);

Shift_sn_30 = [ANC_sn(k) Shift_sn_30(1:29)];

ANC_wz(k+1,:) = ANC_wz(k,:) + ANC_mu*ANC_en(k)*Shift_sn_30;

end

subplot(4,4,5)
plot(1:DEPTH,ANC_yn)
title('ANC yn');

subplot(4,4,6)
plot(1:length(ANC_en),ANC_en)
title('ANC en');

subplot(4,4,10)
plot(1:DEPTH-1,ANC_yn_s)
title('ANC yn s');

subplot(4,4,11)
plot(1:DEPTH,ANC_pn)
title('ANC pn');

subplot(4,4,12)
plot(1:DEPTH,ANC_xn)
title('ANC xn');