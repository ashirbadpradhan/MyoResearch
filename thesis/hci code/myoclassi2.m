close all
datatt = csvread('testing2.csv');
data = csvread('features2.csv');
data2 = csvread('features2_2.csv');
data3 = csvread('features2_3.csv');
data4 = csvread('no_sample3.csv');
data5 = csvread('features2_open1.csv');
data6 = csvread('features2_left1.csv');

% labels = [1 1 1, 2 2 2]';
a = prdataset(data,genlab([11 9 10 0]));
b = prdataset(data2,genlab([10 10 11 0]));
d = prdataset(data3,genlab([11 11 8 0]));
c = prdataset(data4,genlab([0 0 0 600]));
d1 = prdataset(data5,genlab([0 0 14 0]));
d2 = prdataset(data6,genlab([4 0 0 0]));

length=size(datatt,1);
test = prdataset(datatt,genlab([0 0 0 length]));

train = [a;b;c;d;d1;d2]
train = setname(train,'movement');
train = setlablist(train,char('left','right','open','no movement'));
train = setfeatlab(train,char('mav3','mav7','rms3','rms7','var3','var7', 'wl3', 'wl7', 'zc3','zc7'));

% d = setname(d,'movement');
% d = setlablist(d,char('left','right','open'));
% d = setfeatlab(d,char('mav3','mav7','rms3','rms7','var3','var7', 'wl3', 'wl7', 'zc3','zc7'));

test = setname(test,'movement');
test = setlablist(test,char('left','right','open','no movement'));
test = setfeatlab(test,char('mav3','mav7','rms3','rms7','var3','var7', 'wl3', 'wl7', 'zc3','zc7'));

% q = setname(q,'movement');
% q = setlablist(q,char('left','right','open'));
% q = setfeatlab(q,char('mav3','mav7','rms3','rms7','var3','var7', 'wl3', 'wl7', 'zc3','zc7'));


%scatterdui(a)


% scatterdui(a*ldc)


% delfigs;       % delete existing figures
% gridsize(300); % make accurate scatterplots
% randreset;     % set fized seed for random generator for reporducability

% generate 2d 8-class training set
% train = gendatm(250)*cmapm([1 2],'scale');
% % generate test set
% test  = gendatm(1000)*cmapm([1 2],'scale');
% % rename PRTools qdc, include regularisation
% [train,test]=gendat(c,0.7);
% qda   = setname(qdc([],[],1e-6),'QDA')*classc;

% figure;
% scatterd(train);    % show the training set
% axis equal;


% plotc(w);           % show decision boundaries
% title([getname(w) ' (' num2str(e,'%5.3f)')])
% 

% figure;
% scatterd(train);    % show the training set
% axis equal;
% plotc(w,'col');     % show class domains
% title([getname(w) ' (' num2str(e,'%5.3f)')])

scatterdui([train;test]);
% figure;%libsvm
% scatterd(train);    % show the training set
% axis equal;
% w = train*libsvc;   % train by LIBSVM
% e = test*w*testc;   % find classification error
% plotc(w,'col');     % show class boundaries
% title([getname(w) ' (' num2str(e,'%5.3f)')])

% figure;%one against rest
% scatterd(train);    % show the training set
% axis equal;
% w = train*fisherc;  % train by FISHERC
% e = test*w*testc;   % find classification error
% plotc(w,'col');     % show class domains
% title([getname(w) ' (' num2str(e,'%5.3f)')])







w = train*ldc;      % train by fisherc
conf = test*w;
confmat(conf)
%err = test*w*testd   % find classification error
% 
% labels_pred = conf*labeld;
% labels_true = getlabels(conf);
% 
% L = labcmp(labels_pred,labels_true)


