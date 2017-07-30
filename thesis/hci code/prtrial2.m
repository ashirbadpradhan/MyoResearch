close all

data = rand(6,2);
labels = [1 1 1, 2 2 2]';
a = prdataset(data,labels)


% Generate in 2 dimensions 3 normally distributed classes
% of 20 objects for each class
a = prdataset(randn(60,2),genlab([20 20 20]))
a = setfeatlab(a,char('size','intensity'))
figure;scatterd(a);
a(1:20,:) = a(1:20,:)*0.5;
a(21:40,1) = a(21:40,1)+4;
a(41:60,2) = a(41:60,2)+4;
figure; scatterd(a);


% create a subset of the second class
b = a(21:40,:)
% add 4 to the second feature of this class
b(:,2) = b(:,2) + 4*ones(20,1)

% concatenate this set to the original dataset
c = [a;b]
figure; scatterd(c);

c = setname(c,'Fruit dataset');
c = setlablist(c,char('apple','banana','cherry'));
c = setfeatlab(c,char('size','weight'));
figure; scatterd(c)

