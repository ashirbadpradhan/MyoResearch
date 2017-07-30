
close all
% datatt = csvread('features2_day4.csv');
data_left = csvread('features2_train_left.csv');
data_right = csvread('features2_train_right.csv');
data_open = csvread('features2_train_open.csv');
data_left_50 = csvread('features2_train_left_50.csv');
data_right_50 = csvread('features2_train_right_50.csv');
data_open_50 = csvread('features2_train_open_50.csv');
data_no = csvread('features2_train_no.csv');
% labels = [1 1 1, 2 2 2]';
%lengths
length_left=size(data_left,1);
length_right=size(data_right,1);
length_open=size(data_open,1);
length_no=size(data_no,1);
length_left_50=size(data_left_50,1);
length_right_50=size(data_right_50,1);
length_open_50=size(data_open_50,1);


a = prdataset(data_left,genlab([length_left 0 0 0]));
b = prdataset(data_right,genlab([0 length_right 0 0]));
c = prdataset(data_open,genlab([0 0 length_open 0]));
d = prdataset(data_no,genlab([0 0 0 length_no]));
e = prdataset(data_left_50,genlab([length_left_50 0 0 0]));
f = prdataset(data_right_50,genlab([0 length_right_50 0 0]));
g = prdataset(data_open_50,genlab([0 0 length_open_50 0]));


% p = prdataset(datatt,genlab([6 5 5]));
% [c,test]=gendat(p,0.5);
train = [a;b;c;d;e;f;g]
train = setname(train,'movement');
train = setlablist(train,char('left','right','open','no movement'));
train = setfeatlab(train,char('mav3','mav7','rms3','rms7','var3','var7', 'wl3', 'wl7', 'zc3','zc7'));

% 
% test = setname(test,'movement');
% test = setlablist(test,char('left','right','open','no movement'));
% test = setfeatlab(test,char('mav3','mav7','rms3','rms7','var3','var7', 'wl3', 'wl7', 'zc3','zc7'));
% 
scatterdui([train])%;test]);


w = train*ldc;      % train by fisherc
%conf = test*w;
%confmat(conf)
% err = test*w*testc   % find classification error
featlist=getfeat(train);
labels=train.nlab;
train = +train;
% test = +test;

train=train.';
labels=labels.';
% test=test.';

lda=trainLDA(train,labels)

wwww=lda.W
cccc=lda.C


