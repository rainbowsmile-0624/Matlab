function writeHexFile(ADDR,data,WIDTH,DEPTH) 
% ADDR: The absolute path to write to a file object
% data: The data to be written, the decimal number
% WIDTH: Width of data
% DEPTH: Depth of data
if(max(data)>=2^WIDTH) 
    error('The data does not meet the requirements');
end

data(data<0)=data(data<0)+2^WIDTH;

fild = fopen(ADDR,'w+');
for i = 1:DEPTH
    fprintf(fild, '%04x\n',data(i));
end
fclose(fild);