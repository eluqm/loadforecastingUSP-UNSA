clear all; 

inputs=load('source/14321000monthly.dly.txt');

input=inputs(:,3)
%splitData(input,year_prediction)
years=2
[input,test]=splitData(input,years);

inputSequence=0
outputSequence=0
MATGEN=0;
inputstand=0;
        % A transformation is required if a time series is not normally distributed
        % It aims to remove the seasonality from the mean and the variance,
        % if skewness coefficients are biased. Therefore, a transformation to reduce this skewness closer to zero was needed.
        % The skewness of the observed data is reduced using log-transformation
        inputm1(1,2)=translogone(input,2.27,12);
        inputm1(1,1)=translogone(input,1.06,11);
        %inputm1()
        
        %log-transformation and standarization of data 
        [inputstand,xlog1]=translog(input);
        
        % A step before training the neural networkk, 
        % it is often useful to scale the inputs and targets so that they always fall within a specified range. 
        % in this project, the data were scaled in the range of [-1, +1] using the equation:
        inputlogg=xlog1;
        [yi,PS]=mapminmax(inputstand');
        datainputstart=mapminmax('apply',inputm1,PS);
        
        %neural network based architectures are prepared; 
        % the model (ANN2) generates the inflow of the present month utilizing inflows of two previous months.
        %[i,t]=normNN(yi',2);
        [inputSequence,outputSequence]=normNN(input,2);%short time delay memory = 2 
        %train neural network
        %[net,perfNN]=penNN(i,t,hidden);
        %%%% generate an esn 
        nForgetPoints = 36 ;
        nPlotPoints = 12 ; 
        nInputUnits = 2; nInternalUnits = 40; nOutputUnits = 1; 
        % 
        [net,perfNN] = penESN(inputSequence,outputSequence,nInputUnits,nInternalUnits,nOutputUnits)
        %test_esn([-0.48 -0.49],  net, nForgetPoints) 
        inputSequencetest=inputSequence(size(inputSequence,1)-59:size(inputSequence,1),:);
        outputSequencePredicted=test_esn(inputSequencetest,net, nForgetPoints);
       %v!!!!!!! ojo !!! delay 2 ??? 
        for i=1:3
        outputSequencePredicted=[outputSequencePredicted(size(outputSequencePredicted,1),1);outputSequencePredicted]
        outputSequencePredicted(size(outputSequencePredicted,1),:)=[]
        end
        testlog=logTransformation(test,input);
        
       % rawData=inverseLogTransformation(outputSequencePredicted,input)
      %  outputSequencePredicted=detranslog(inputstand,xlog1,outputSequencePredicted);
        %test input
     %   inputlasttwo =inputm1
     %   predictserie=0;
       % for m=0:(12*years)-1
      %      Yvtn=test_esn(inputlasttwo,net,nForgetPoints)
       %    outputSequencePredicted(mod(m,12)+1,1)=detranslogone(inputstand,xlog1,input,outputSequencePredicted(mod(m,12)+1,1),mod(m,12)+1);
           
           % Rvtn=abs(Rvtn);
      %      predictserie(m,1)=Yvtn
      %      inputlasttwo=[inputlasttwo(1,2) Yvtn]
           % predictserie(m,1)=Rvtn;
          %  Rvtn2=translogone(input,Rvtn,m);
          %  inputlasttwo=[inputlasttwo(1,2) Rvtn2];
            
      %  end
        
        

%%%%compute NRMSE training error
%trainError = compute_NRMSE(predictedTrainOutput, trainOutputSequence); 
%disp(sprintf('train NRMSE = %s', num2str(trainError)))

%%%%compute NRMSE testing error
testError = compute_NRMSE(outputSequencePredicted, test); 
disp(sprintf('test NRMSE = %s', num2str(testError)))
%plot_sequence(test(nForgetPoints+1:end,:), outputSequencePredicted, nPlotPoints, ...
 %   'testing: teacher sequence (red) vs predicted sequence (blue)') ;
% testlog=inverseLogTransformation(testlog,input);
% outputSequencePredicted=inverseLogTransformation(outputSequencePredicted,input);
 plot([1:12*years],outputSequencePredicted,'-ro',[1:12*years],test,'-bd')
        hleg2= legend('media','real');
        