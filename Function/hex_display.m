function a=hex_display(hex_data,bits) %???

hex_data(hex_data<0)=hex_data(hex_data<0)+2^bits;

a=dec2hex(hex_data,bits/4);

