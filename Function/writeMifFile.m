function writeMifFile(ADDR,data,WIDTH,DEPTH) 
%example: Write_mif('D:\Matlab\MIF\sin.mif',sin(x),16,256);


data(data<0)=data(data<0)+2^WIDTH; 

fild = fopen(ADDR,'w+');
fprintf(fild, '%s%d;\n','WIDTH=',WIDTH);
fprintf(fild, '%s%d;\n\n','DEPTH=',DEPTH);
fprintf(fild, '%s\n','ADDRESS_RADIX=DEC;');
fprintf(fild, '%s\n\n','DATA_RADIX=HEX;');
fprintf(fild, '%s\t','CONTENT');
fprintf(fild, '%s\n','BEGIN');
for i = 1:DEPTH
    % addr    :    data;
    fprintf(fild, '\t%g\t',i-1);
    fprintf(fild, '%s\t',':');
    fprintf(fild, '%08x',data(i));
    fprintf(fild, '%s\n',';');
end
fprintf(fild, '%s\n','END');
fclose(fild);
