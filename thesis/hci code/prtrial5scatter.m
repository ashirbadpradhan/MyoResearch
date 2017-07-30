% A = gendatb; scatterd(A); plotc(A*dtc);
% A = gendatb([1000,1000]); scatterd(A); plotc(A*knnc);
% 
% 
% A = gendatb; scatterd(A); plotc(A*{fisherc,qdc,knnc,dtc})
% 
% 
% % namechange for plots
% A = gendatb;
% W1 = A*fisherc;
% W2 = A*qdc; W2 = setname(W2,'qdc');
% W3 = A*knnc;
% W4 = A*dtc; W4 = setname(W4,'dtc');
% scatterd(A);
% plotc({W1,W2,W3,W4});
% 
% 
% %density
% A = gendatgauss(100,[0 0]); % generate a 2D Gaussian distribution
% W = A*gaussm;               % estimate the density from the data
% scatterd(A);                % scatter plot of the data
% plotm(W);                   % plot the estimated density
% 
% 
% 
% delfigs          % PRTools routine for deleting all figures
% A = gendatb; scatterd(A);
% plotm(A*knnc); title('Gaussian densities')
% figure; scatterd(A);
% plotm(A*dtc); title('Parzen densities')
% showfigs  
% 
% delfigs
% A = gendatm;
% scatterd(A);
% plotc(A*qdc)
% 
% figure; scatterd(A)
% gridsize(100);
% plotc(A*qdc,'col')
% showfigs


delfigs
prdatasets; 
A = iris
scatterd(A*pcam(A,2)); title('PCA')



delfigs
figure; scatterd(A(:,[1 2])); title('1 2');
figure; scatterd(A(:,[1 3])); title('1 3');
figure; scatterd(A(:,[1 4])); title('1 4');
figure; scatterd(A(:,[2 3])); title('2 3');
figure; scatterd(A(:,[2 4])); title('2 4');
figure; scatterd(A(:,[3 4])); title('3 4');
showfigs


delfigs; scatterdui(A)

scatterdui(A*pcam(A))