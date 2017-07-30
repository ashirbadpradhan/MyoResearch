
close all
%50 percent files not required
% datatt = csvread('features4_day4.csv');
data_left = csvread('features4_train_left.csv');
data_right = csvread('features4_train_right.csv');
data_open = csvread('features4_train_open.csv');
data_left_50 = csvread('features4_train_left_50.csv');
data_right_50 = csvread('features4_train_right_50.csv');
data_open_50 = csvread('features4_train_open_50.csv');
data_no = csvread('features4_train_no.csv');
% labels = [1 1 1, 2 2 2]';
%lengths
length_left=size(data_left,1);
length_right=size(data_right,1);
length_open=size(data_open,1);
length_no=size(data_no,1);
length_left_50=size(data_left_50,1);
length_right_50=size(data_right_50,1);
length_open_50=size(data_open_50,1);

%prtools
%generate labels ( n labels with the value 1/2/3/4)
a = prdataset(data_left,genlab([length_left 0 0 0]));
b = prdataset(data_right,genlab([0 length_right 0 0]));
c = prdataset(data_open,genlab([0 0 length_open 0]));
d = prdataset(data_no,genlab([0 0 0 length_no]));
e = prdataset(data_left_50,genlab([length_left_50 0 0 0]));
f = prdataset(data_right_50,genlab([0 length_right_50 0 0]));
g = prdataset(data_open_50,genlab([0 0 length_open_50 0]));

%prtools
% p = prdataset(datatt,genlab([6 5 5]));
% [c,test]=gendat(p,0.5);
%change the names of features
train = [a;b;c;d;e;f;g]
train = setname(train,'movement');
train = setlablist(train,char('left','right','open','no movement'));
train = setfeatlab(train,char('mav1','mav3','mav5','mav7','rms1','rms3','rms5','rms7','var1','var3','var5','var7', 'wl1','wl3','wl5', 'wl7', 'zc1','zc3','zc5','zc7'));

% 
% test = setname(test,'movement');
% test = setlablist(test,char('left','right','open','no movement'));
% test = setfeatlab(test,char('mav3','mav7','rms3','rms7','var3','var7', 'wl3', 'wl7', 'zc3','zc7'));
% prtools
scatterdui([train])%;test]);

%prtools
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

%erik's code 
lda=trainLDA(train,labels)
%
wwww=lda.W
cccc=lda.C


