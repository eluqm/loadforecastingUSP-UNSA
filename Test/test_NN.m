clear all;
inputs=load('03054500TygartMonthly.dly.txt');
% case : Mopex hydrologic data :1 +> mean areal precipitation (mm) 
% case : Mopex hydrologic data :2 +> climatic potential evaporation (mm)
% case : Mopex hydrologic data :3 +> daily streamflow discharge (mm)
property=3;
input=inputs(:,property);

configurationvalue=100000;
%configuration=[];
bestNet=struct;
year=2;
hidden_max=20;
bestFinal=struct('error',00.1,'networkESN',struct);        
configuration=struct('error',00.1,'net',struct); 
%neural network based architectures are prepared; 
        [input,test]=splitData(input,year);
        [scaledinput,PS]=mapminmax(input');
        [inputSequence,outputSequence]=normNN(scaledinput',1);%short time delay memory = 2 , without  bias
      %  inputSequence= [ones(size(inputSequence,1),1) inputSequence];
%% split the data into train and test

train_fraction = 0.6 ; % use 50% in training and 50% in testing
[trainInputSequence, testInputSequence] = ...
    split_train_test(inputSequence,train_fraction);
[trainOutputSequence,testOutputSequence] = ...
    split_train_test(outputSequence,train_fraction);
      
%%
count=1;
count2=1;
for hidden=2:hidden_max
    %for n=10:reservoirNumber
[net,perfNN]=penNN(trainInputSequence,trainOutputSequence,hidden);
predictedTestOutput=sim(net,testInputSequence');
perfNN = compute_NRMSE(predictedTestOutput', testOutputSequence); 
configuration(count)=struct('error',perfNN,'net', net);
      if perfNN < configurationvalue
         configurationvalue=perfNN;
          bestNet=net;        
      end
    count=count+1;
    
   % end
end
bestFinal(count2)=struct('error',configurationvalue,'networkESN', bestNet);
    