clc;
clear;
my_table=readtable('D:\06, Matlab\TXT\333.txt');
my_cell=table2array(my_table);
% my_cell(:,2)=[];
my_char=char(my_cell);
length(my_char);

for i=1:length(my_char)
    if(my_char(i,2)==' ') 
        my_char(i,2)=my_char(i,1);
        my_char(i,1)='0';
    end
end

my_all_char=string(1000);

channel = 1;
for k=1:200
	my_all_char(k)=[my_char((k*4-3+channel-1)*3-2,1),my_char((k*4-3+channel-1)*3-2,2),...
                    my_char((k*4-3+channel-1)*3-1,1),my_char((k*4-3+channel-1)*3-1,2),...
                    my_char((k*4-3+channel-1)*3,1),  my_char((k*4-3+channel-1)*3,2)];
end
my_all_char
for i=1:length(my_all_char)
    a(i)=hex2dec(my_all_char(i));
     if(a(i)>=2^23)
            a(i) = a(i) - 2^24;
      end
end
a
subplot(1,1,1)
plot(1:length(a),a)

