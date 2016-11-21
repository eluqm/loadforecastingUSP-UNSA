clear all; 

inputs=load('source/14321000monthly.dly.txt');

input=inputs(:,3)
%splitData(input,year_prediction)
[input,test]=splitData(input,1);

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
        [inputSequence,outputSequence]=normNN(xlog1,2);
        %train neural network
        %[net,perfNN]=penNN(i,t,hidden);
        %%%% generate an esn 
        nForgetPoints = 0 ;
        nPlotPoints = 100 ; 
        nInputUnits = 2; nInternalUnits = 30; nOutputUnits = 1; 
        % 
        [net,perfNN] = penESN(inputSequence,outputSequence,nInputUnits,nInternalUnits,nOutputUnits)
        %test_esn([-0.48 -0.49],  net, nForgetPoints) 
       % test_esn([1.06 2.27],net, nForgetPoints)
        
        %test input
        inputlasttwo =inputm1
        predictserie=0;
        for m=1:12
            Yvtn=test_esn(inputlasttwo,net,nForgetPoints)
            Rvtn=detranslogone(inputstand,xlog1,input,Yvtn,m);
            Rvtn=abs(Rvtn);
            
            predictserie(m,1)=Rvtn;
            Rvtn2=translogone(input,Rvtn,m);
            inputlasttwo=[inputlasttwo(1,2) Rvtn2];
            
        end
        

%%%%compute NRMSE training error
%trainError = compute_NRMSE(predictedTrainOutput, trainOutputSequence); 
%disp(sprintf('train NRMSE = %s', num2str(trainError)))

%%%%compute NRMSE testing error
%testError = compute_NRMSE(predictedTestOutput, testOutputSequence); 
%disp(sprintf('test NRMSE = %s', num2str(testError)))
        
        