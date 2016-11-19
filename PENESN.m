function[trainedEsn,testError] = penESN(inputSequence,outputSequence,nInputUnits,nInternalUnits,nOutputUnits)
%%%% generate an esn 
nInputUnits; nInternalUnits; nOutputUnits; 
% 
esn = generate_esn(nInputUnits, nInternalUnits, nOutputUnits, ...
    'spectralRadius',0.5,'inputScaling',[0.1;0.1],'inputShift',[0;0], ...
    'teacherScaling',[0.3],'teacherShift',[-0.2],'feedbackScaling', 0, ...
    'type', 'plain_esn'); 


esn.internalWeights = esn.spectralRadius * esn.internalWeights_UnitSR;


%%%% split the data into train and test

train_fraction = 0.7 ; % use 50% in training and 50% in testing
[trainInputSequence, testInputSequence] = ...
    split_train_test(inputSequence,train_fraction);
size(trainInputSequence)
size(testInputSequence)
[trainOutputSequence,testOutputSequence] = ...
    split_train_test(outputSequence,train_fraction);
size(testOutputSequence)
%%%% train the ESN
nForgetPoints = 100 ; % discard the first 100 points
[trainedEsn stateMatrix] = ...
    train_esn(trainInputSequence, trainOutputSequence, esn, nForgetPoints) ; 

nPoints = 200 ; 
plot_states(stateMatrix,[1 2 3 4 5 6 7 8 9 10 11 12], nPoints, 1, 'traces of first 4 reservoir units') ;

% compute the output of the trained ESN on the training and testing data,
% discarding the first nForgetPoints of each
nForgetPoints = 0 ;
%predictedTestOutput = test_esn(testInputSequence,  trainedEsn, nForgetPoints) ;
% create input-output plots
%nPlotPoints = 100 ;
%plot_sequence(testOutputSequence(nForgetPoints+1:end,:), predictedTestOutput, nPlotPoints, ...
  %  'testing: teacher sequence (red) vs predicted sequence (blue)') ; 
predictedTestOutput = test_esn(testInputSequence,  trainedEsn, nForgetPoints) ; 

%predicTest=test_esn([1.06 2.27],  trainedEsn, nForgetPoints)
%predicTest1=test_esn([1.06 2.27],  trainedEsn, nForgetPoints)
%predicTest2=test_esn([1.06 2.27],  trainedEsn, nForgetPoints)
%%%%compute NRMSE testing error
testError = compute_NRMSE(predictedTestOutput, testOutputSequence); 
disp(sprintf('test NRMSE = %s', num2str(testError)))
end