T = gendatb   % generate a training set
S = gendatb   % generated a test set
W = T*fisherc % train a classifier
D = S*W % compute a classification dataset
labels_pred = D*labeld;
labels_true = getlabels(D);

L = labcmp(labels_pred,labels_true)
