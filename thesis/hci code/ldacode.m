

clear all
close all

tic
datatt = csvread('testing2.csv');
data = csvread('features2.csv');
data2 = csvread('features2_2.csv');
data3 = csvread('features2_3.csv');
data4 = csvread('no_sample3.csv');


% labels = [1 1 1, 2 2 2]';
a = prdataset(data,genlab([11 9 10 0]));
b = prdataset(data2,genlab([10 10 11 0]));
d = prdataset(data3,genlab([11 11 8 0]));
c = prdataset(data4,genlab([0 0 0 600]));


length=size(datatt,1);
test = prdataset(datatt,genlab([0 0 0 length]));

train = [a;b;c;d]
train = setname(train,'movement');
train = setlablist(train,char('left','right','open','no movement'));
train = setfeatlab(train,char('mav3','mav7','rms3','rms7','var3','var7', 'wl3', 'wl7', 'zc3','zc7'));

test = setname(test,'movement');
test = setlablist(test,char('left','right','open','no movement'));
test = setfeatlab(test,char('mav3','mav7','rms3','rms7','var3','var7', 'wl3', 'wl7', 'zc3','zc7'));

featlist=getfeat(train);
labels=train.nlab;
train = +train;
test = +test;

train=train.';
labels=labels.';
test=test.';

lda=trainLDA(train,labels)

wwww=lda.W
cccc=lda.C
% mmmm=lda.Average
% lda.numPat 

toc
