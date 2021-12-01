clear;
clc;
%%%%%%%%%%%%%%%ONLY_READ%%%%%%%%%%%%%
ANC_DEPTH = 2^16;
FILTER_LENGTH =126;
rand('seed',10);
format long


% %%%%%%%%%%%%%%%OFZ%%%%%%%%%%%%%
Pw=fir1(FILTER_LENGTH-1,0.5);
Sw=fir1(FILTER_LENGTH-1,0.3);
% Pw=Sw*3;



%{ 
        Here is the ANC process
%}
vn = roundHex(0.5*(rand(1,ANC_DEPTH)-0.5),16);  
% xn = roundHex((rand(1,ANC_DEPTH)-0.5),16);
fsin = 0.1*createSin(50000/ANC_DEPTH*30,50000,ANC_DEPTH,0.5) +...
       0.1*createSin(55000/ANC_DEPTH*30,50000,ANC_DEPTH,0.5) +...
       0.1*createSin(60000/ANC_DEPTH*30,50000,ANC_DEPTH,0.5) +...
       0.1*createSin(65000/ANC_DEPTH*30,50000,ANC_DEPTH,0.5) +...
       0.1*createSin(45000/ANC_DEPTH*30,50000,ANC_DEPTH,0.5);
xn = roundHex(fsin,16);  
pn = roundHex(filter(Pw,1,xn),16);


xn_shift = zeros(1,FILTER_LENGTH); 
yn_shift = zeros(1,FILTER_LENGTH);
sn_shift = zeros(1,FILTER_LENGTH);
vn_shift = zeros(1,FILTER_LENGTH);

yn      = zeros(1,ANC_DEPTH);
sn      = zeros(1,ANC_DEPTH);
en      = zeros(1,ANC_DEPTH);

wz      = zeros(1,FILTER_LENGTH);
sz      = zeros(ANC_DEPTH,FILTER_LENGTH);

S_mu = 2^(-8);
W_mu = 2^(-9);
for k=1:ANC_DEPTH-1
%Shift    
xn_shift = [xn(k) xn_shift(1:FILTER_LENGTH-1)];
vn_shift = [vn(k) vn_shift(1:FILTER_LENGTH-1)];

%Step 1
yn(k) = dot(wz,xn_shift);
%Step 2
sn(k) = dot(sz(k,:),xn_shift);

%Shift
yn_shift = [yn(k) yn_shift(1:FILTER_LENGTH-1)];
sn_shift = [sn(k) sn_shift(1:FILTER_LENGTH-1)];

%Step 3
yn_s  = dot(yn_shift-vn_shift,Sw);

%Step 4
en(k) = pn(k) - yn_s;
%Step 5
vn_s  = dot(sz(k,:),vn_shift);
%Step 6
sz(k+1,:) = sz(k,:) + S_mu*vn_shift*(en(k)-vn_s);
%Step 7
wz = wz + W_mu*sn_shift*(en(k));
end
figure(1);

subplot(4,4,1)
hold on;
plot(1:ANC_DEPTH,xn)
plot(1:ANC_DEPTH,pn)
hold off;
title('pn');

subplot(4,4,5)
plot(1:ANC_DEPTH,yn-vn)
title('yn');

subplot(4,4,6)
plot(1:length(en),en)
title('en');

subplot(4,4,7)
hold on;
plot(1:ANC_DEPTH,xn)
plot(1:ANC_DEPTH,pn)
hold off;
title('xn');

subplot(4,4,8)
hold on;
stem(Sw)
stem(sz(ANC_DEPTH-1,:), 'r*')
hold off;
title('S(z) & S(w)');

figure(2);
subplot(1,1,1)
hold on;
for k=20:80
    plot((1:length(sz(:,2))), sz(:,k))
end
hold off;
title('sz');
