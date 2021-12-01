function data_out=isOriCode(data,bits)
%To determine whether a number is a source or complement, 1 is true
if(data>=2^(bits-1)) 
    data_out=0;
else
    data_out=1;
end
