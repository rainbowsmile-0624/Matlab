function data=bitsRound(data,bits)
    for i = 1:length(data)
        %be sure input is integer
        data(i) = floor(data(i));

        %be sure input is a positive number
        if data(i)<0
            while data(i)<0
                data(i) = data(i) + 2^bits;
            end
        end

        %Cut number
        if data(i)>(2^bits-1)
            data(i)=bitand(data(i),2^bits-1);
        end

        %Now,the number is a number of range [0,2^bits-1] 
        if data(i)>=2^(bits-1)
            data(i)=data(i)-2^bits;
        end
    end
end