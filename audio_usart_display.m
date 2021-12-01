clear
Fs=22228;
Mg=23706;
fild=fopen('D:\06, Matlab\TXT\audio\11.txt','r');
data=fscanf(fild,'%x');
data_hex=dec2hex(data);
a=zeros(1,fix((length(data)/3)));

for i = 1:(length(data)/3)
   a(i)=CompleCode2OriCode(string([data_hex(i*3-2,1) data_hex(i*3-2,2) data_hex(i*3-1,1) data_hex(i*3-1,2)]),16);
end
%53点  每2个间隔439.4Hz
%17760
a=a/Mg;
plot(1:length(a),a)
min(a)
fclose(fild);
