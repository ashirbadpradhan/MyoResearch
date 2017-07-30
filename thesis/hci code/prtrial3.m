% generate 10 objects in 5D, mean is [1 2 3 4 5], small variances
    A = gauss(10,[1 3 6 4 9],0.01*eye(5));
    % show the rounded values of the mean of A
    disp(round(mean(A)));
    % select features 1, 2 and 5
    B = featsel(A,[1 2 5]);
      % show the rounded values of the mean of B
    disp(round(mean(B)));
    
    W = featsel([],[1 2 5]); B = A*W