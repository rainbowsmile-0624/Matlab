function [my_data1,my_data2]=displayIIS24(my_table)

my_table(:,1)=[];
my_table(:,1)=[];
my_cell=table2array(my_table);
my_char=char(my_cell);
my_string=string(my_char);
if(contains(my_string(1),'Right'))
    my_string(1,:)=[];
end
if(contains(my_string(end),'Left'))
    my_string(end,:)=[];
end
my_string=strrep(my_string,'Left channel: 00','');
my_string=strrep(my_string,'Right channel: 00','');
my_string=strrep(my_string,' ','');

my_data1=zeros(1,length(my_string)/2);
my_data2=zeros(1,length(my_string)/2);
for i=1:length(my_string)/2
    my_data1(i)=convertToOriCode(my_string(i*2-1),24);
    my_data2(i)=convertToOriCode(my_string(i*2),24);
end