function hexDisplay(data,bits)
   data(data<0)=data(data<0)+2^bits;
   dec2hex(floor(data),bits/4)
end