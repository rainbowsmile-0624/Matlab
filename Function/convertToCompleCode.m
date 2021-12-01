function data_out=convertToCompleCode(data,bits)
%data: Decimal number
%bits: Maximum bit width to convert

if(data>(2^(bits-1)-1) || data<-2^(bits-1))
    error('parameter ''bits'' is not correct');
end

if(abs(data)<1 && data~=0) 
    error('Cannot convert decimal numbers. Please multiply this number by 2^bits');
else
    if(data<0)
        data_out = data+2^bits;
    else
        data_out = data;
    end
end
data_out = dec2hex(data_out);


