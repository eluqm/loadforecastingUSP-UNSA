function outputWeights =ridge_regression(stateCollectMat, teachCollectMat)

% computes ESN output weights from collected network states and collected 
% teacher outputs. Mathematically this is a linear regression. 
% 
%
%these models relied on regularisation by the ridge regression
%method for good generalisation ability. Using trial-and-error
%testing, a good value of the regularisation parameter α (see
%Eq. 8) was found to be 0.1.

% Created may 2017,Edson L

%outputWeights = ridge(teachCollectMat,stateCollectMat,0.1)';
outputWeights = inv(stateCollectMat'*stateCollectMat+(0.01)*eye(size(stateCollectMat,2)))...
    *(stateCollectMat'*teachCollectMat);
outputWeights=outputWeights';
end