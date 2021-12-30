function data=convertToCompleCode(data,bits)

    %The range of source code
    if data>(2^(bits-1)-1) || data<-2^(bits-1)
        error('parameter ''bits'' is not correct');
    end

    if data<0
        data = data+2^bits;
    end

end


