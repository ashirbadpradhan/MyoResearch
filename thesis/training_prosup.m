data=csvread('emg_myo_prosup1_ash28.csv');
labels=data(:,9);
train=data(:,1:8);

train=train.';
labels=labels.';
lda=trainLDA(train,labels)

wwww=lda.W
cccc=lda.C


