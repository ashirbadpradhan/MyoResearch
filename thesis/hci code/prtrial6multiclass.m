delfigs;       % delete existing figures
gridsize(300); % make accurate scatterplots
randreset;     % set fized seed for random generator for reporducability

% generate 2d 8-class training set
train = gendatm(250)*cmapm([1 2],'scale');
% generate test set
test  = gendatm(1000)*cmapm([1 2],'scale');
% rename PRTools qdc, include regularisation

qda   = setname(qdc([],[],1e-6),'QDA')*classc;

figure;
scatterd(train);    % show the training set
axis equal;
w = train*qda;      % train by QDA
e = test*w*testc;   % find classification error
plotc(w);           % show decision boundaries
title([getname(w) ' (' num2str(e,'%5.3f)')])


figure;
scatterd(train);    % show the training set
axis equal;
plotc(w,'col');     % show class domains
title([getname(w) ' (' num2str(e,'%5.3f)')])


% figure;%libsvm
% scatterd(train);    % show the training set
% axis equal;
% w = train*libsvc;   % train by LIBSVM
% e = test*w*testc;   % find classification error
% plotc(w,'col');     % show class boundaries
% title([getname(w) ' (' num2str(e,'%5.3f)')])

figure;%one against rest
scatterd(train);    % show the training set
axis equal;
w = train*fisherc;  % train by FISHERC
e = test*w*testc;   % find classification error
plotc(w,'col');     % show class domains
title([getname(w) ' (' num2str(e,'%5.3f)')])

