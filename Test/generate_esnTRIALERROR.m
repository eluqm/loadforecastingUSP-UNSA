function[trainedEsn,testError]=generate_esnTRIALERROR(inputSequence,outputSequence,nInputUnits,nInternalUnits,nOutputUnits,spectral_radious)

%%%% generate an esn 
%original
%inputScal(1:nInputUnits,1:1)=0.1;
inputScal(1:nInputUnits,1:1)=1;
% 
esn = generate_esn(nInputUnits, nInternalUnits, nOutputUnits, ...
    'spectralRadius',spectral_radious, 'inputScaling',inputScal,...
    'teacherScaling',[1.0],'teacherShift',[1.0],'feedbackScaling', 0, ...
    'type','plain_esn','methodWeightCompute','ridge_regression');
% 'plain_esn'
%'leaky_esn','leakage',1
% 'methodWeightCompute','ridge_regression'
%% teacherscaling = [0.3]
%% teacherShift = [-0.2]
esn.internalWeights = esn.spectralRadius * esn.internalWeights_UnitSR;


%%%% split the data into train and test

train_fraction = 0.8 ; % use 50% in training and 50% in testing
[trainInputSequence, testInputSequence] = ...
    split_train_test(inputSequence,train_fraction);
[trainOutputSequence,testOutputSequence] = ...
    split_train_test(outputSequence,train_fraction);
%size(testOutputSequence)
%%%% train the ESN
nForgetPoints = 11 ; % discard the first 100 points
[trainedEsn, stateMatrix] = ...
    train_esn(trainInputSequence, trainOutputSequence, esn, nForgetPoints) ; 

%nForgetPoints = 20 ;

predictedTestOutput = test_esn(testInputSequence,  trainedEsn, nForgetPoints) ; 

%predictedTrainOutput = test_esn(trainInputSequence, trainedEsn, nForgetPoints);

% create input-output plots
%nPlotPointstrain=size(predictedTrainOutput,1);
%nPlotPointstest=size(predictedTestOutput,1);
%plot_sequence(trainOutputSequence(nForgetPoints+1:end,:), predictedTrainOutput, nPlotPointstrain,...
%    'training: teacher sequence (red) vs predicted sequence (blue)');
%plot_sequence(testOutputSequence(nForgetPoints+1:end,:), predictedTestOutput, nPlotPointstest, ...
%    'testing: teacher sequence (red) vs predicted sequence (blue)') ; 

%%%%compute NRMSE testing error
testError = compute_NRMSE(predictedTestOutput, testOutputSequence); 
%disp(fprintf('test NRMSE = %s', num2str(testError)))

end