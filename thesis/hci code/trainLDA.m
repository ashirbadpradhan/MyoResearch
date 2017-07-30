%%
% Train an LDA classifier
%
%	Inputs: data,       			- Training data arranged in columns
%			target                  - Target classes arranged in columns 
%                                    (assumes targets are in range 1:nClasses)
%           priors (optional)       - prior probabilities of class distributions
%	Outputs: 
%            lda.Wg,Cg              - LDA weights 
%            lda.numPat             - Number of patterns of each class
%
% (c) Erik Scheme (2017)
%
%%

function lda = trainLDA(data,target,priors)


try
    nClasses = max(target);
    nFeats = size(data,1);
    
    if nargin<3
        priors = repmat(1/nClasses,1,nClasses);
    else
        assert(length(priors) == nClasses);
    end

    %%-- Compute the means and the pooled covariance matrix     
    C = zeros(nFeats,nFeats);
    numPat = zeros(1,nClasses);
    dataMean = zeros(nFeats,nClasses);

    for iClass = 1:nClasses
        idx = find(target==iClass);
        numPat(iClass) = length(idx);
        dataMean(:,iClass) = mean(data(:,idx),2)';
        C = C + priors(iClass) * cov(data(:,idx)');
    end

    Cinv = C\eye(nFeats);

    W = Cinv*dataMean;
    C = -1/2*dot(dataMean,W) + log(priors);

    lda.numPat = numPat;
    lda.W = W;
    lda.C = C;
    lda.Average = dataMean;
    
catch lasterr
    errordlg(['Error training LDA: ' lasterr],'LDA Error','modal');
    lda.numPat = [];
    lda.W = [];
    lda.C = [];
end
