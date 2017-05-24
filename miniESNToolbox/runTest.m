clear all;
seed=rng;
inputs=xlsread('source/Datos_Pruebas.xls');
%inputs=load('source/03179000bluestoneM.dly.txt');
%inputs=load('source/03364000EastForkWhiteMonth.dly.txt');
%inputs=load('source/03054500TygartMonthly.dly.txt');
% case : Mopex hydrologic data :1 +> mean areal precipitation (mm) 
% case : Mopex hydrologic data :2 +> climatic potential evaporation (mm)
% case : Mopex hydrologic data :3 +> daily streamflow discharge (mm)

property=4;
input=inputs(:,property);

configurationvalue=100000;
configuration=[];
bestNet=struct;
year=2;

%% max values of spectral radious and reservoir size
reservoirNumber=70; %max value
spectral_radious=0.9; %max value
nForgetPoints = 11 ; %value
%% different configurations of internal random weighs 
random_times=1;

%% Esn configuration
nInputUnits = 2; %nInternalUnits = 30; 
nOutputUnits = 1; 
bestFinal=struct('error',00.1,'networkESN',struct);        
configuration=struct('error',00.1,'net',struct); 

%% neural network based architectures are prepared; 
        [input,test]=splitData(input,year);
        [inputstand,xlog1]=translog(input);
       
        %% [scaledinput,PS]=mapminmax(input');
        [scaledinput,PS]=mapminmax(inputstand');
        
        [inputSequence,outputSequence]=normNN(scaledinput',1);
        inputSequence= [ones(size(inputSequence,1),1) inputSequence];

count=1;
count2=1;
count3=1;

for n=10:reservoirNumber
   for esp=0.1:0.1:spectral_radious
   %% creating and training ESN with multiple random configuration
    for i=1:random_times
     [net,perfNN] = generate_esnTRIALERROR(inputSequence,outputSequence,nInputUnits,n,nOutputUnits,esp);
      configuration(count)=struct('error',perfNN,'net', net);
      if perfNN < configurationvalue
            configurationvalue=perfNN;
            bestNet=net;        
      end
    count=count+1;
    end
    rng(seed);
   end
    bestFinal(count2)=struct('error',configurationvalue,'networkESN', bestNet);
    count2=count2+1;
    
    fprintf('%d <<--reservoir.\n',n);
    %display('espectral radious %d',esp);
end

train_fraction = 0.6
[trainInputSequence, testInputSequence] = ...
    split_train_test(inputSequence,train_fraction);
[trainOutputSequence,testOutputSequence] = ...
    split_train_test(outputSequence,train_fraction);
predictedTestOutput = test_esn(testInputSequence,  bestNet, nForgetPoints) ; 
predictedTrainOutput = test_esn(trainInputSequence, bestNet, nForgetPoints);
nPlotPoints = size(trainOutputSequence,1)-nForgetPoints; 
plot_sequence(trainOutputSequence(nForgetPoints+1:end,:), predictedTrainOutput, nPlotPoints,...
    'training: teacher sequence (red) vs predicted sequence (blue)');
nPlotPoints = size(testOutputSequence,1)-nForgetPoints; 
plot_sequence(testOutputSequence(nForgetPoints+1:end,:), predictedTestOutput, nPlotPoints, ...
    'testing: teacher sequence (red) vs predicted sequence (blue)') ; 
%save_esn(esn, '11413000monthly.esn');


