function round_data=roundHex(data_in,bits) 

data_in=floor(data_in*2^bits);


round_data=data_in/2^bits;