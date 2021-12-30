function data=convertToOriCode(data,bits)

        if data<0
            error('parameter ''bits'' is not correct');
        end
        
        if data>(2^bits-1)
            error('parameter ''bits'' is not correct');
        end
    
        if data>=2^(bits-1)
            data=data-2^bits;
        end

end