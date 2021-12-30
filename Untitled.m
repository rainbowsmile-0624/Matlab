clc;
clear;
format long;
num=xlsread('D:\Fn.xlsx');
num(1,:)=[];
u=mean(num(:))
SE=sum(sum(num.*num,2));
SE_=SE/42;
SA=(mean(num(1,:))-u)^2+(mean(num(2,:))-u)^2+(mean(num(3,:))-u)^2;
SA_=SA/2;
ST=SE+SA;
f=SA_/SE_;

num=[num(1,:) num(2,:) num(3,:)];
std(num,0,2)


