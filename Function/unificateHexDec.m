function data_out=unificateHexDec(data,bits)
%This procedure is used to standardize the input
%decimal and to hexadecimal input into a unified hexadecimal string form

    if isa(data,'char')
        data_out=string(data)';
    elseif isa(data,'string')
        data_out=data;
    else
        data_out=dec2hex(floor(data),bits/4);
        data_out=string(data_out)';
    end
    
end