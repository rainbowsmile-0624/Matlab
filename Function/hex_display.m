function a=hex_display(hex_data,WIDTH,bits) %???
%WIDTH??????LSB?2^(-WIDTH)
%bits???????

hex_data=floor((2^WIDTH)*hex_data);


hex_data(hex_data<0)=hex_data(hex_data<0)+2^bits;


a=[dec2hex(hex_data,bits/4)];

