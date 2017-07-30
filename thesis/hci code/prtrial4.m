A = gendatb; % The banana set
scatterd(A); % Show a scatterplot
struct(A)
+A
+A(1:5,:)
hold on; scatterd(A(1:5,:),'o');
W1 = A*fisherc;
A*W1*testc
plotc(W1)

W2 = A*polyc([],fisherc,3);
plotc(W2,'r')
A*W2*testc

[AT,AS] = gendat(A,0.5)
W = AT*{fisherc,polyc([],fisherc,3)}
testc(AS,W)   