function data_out=convertToOriCode(data,bits)
%data: A hexadecimal number
%bits: The biggest bits wide


if(length(data)>(bits/4))
    error('length(data)>(bits/4)');
end

data=hex2dec(data);

if(data>=2^(bits-1))
    data_out=data-2^bits;
else 
    data_out=data;
end