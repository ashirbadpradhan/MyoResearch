clear all
close all
clc

filename='states-1.csv'  % Enter the filename to be analyzed including the extensions
data=csvread(filename,1,0);
left=data(:,6);
right=data(:,7);
plot(data(:,6:7));
