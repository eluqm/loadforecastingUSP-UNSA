%% script to compare random orth connectivity with random sparse  
clear all;
seed=rng;
%inputs=xlsread('source/Datos_Pruebas.xls');

inputs=load('source/03054500TygartMonthly.dly.txt');
%inputs=load('source/03179000bluestoneM.dly.txt');
%inputs=load('source/03364000EastForkWhiteMonth.dly.txt');
%inputs=load('source/01541500CLEARFIELDMonth.dly.txt');
% case : Mopex hydrologic data :1 +> mean areal precipitation (mm) 
% case : Mopex hydrologic data :2 +> climatic potential evaporation (mm)
% case : Mopex hydrologic data :3 +> daily streamflow discharge (mm)

flag =1;         %0 in case sparse matrix, othercase orthonormal matrix ( flag = 1)  
property=3;
input=inputs(:,property);

configurationvalue=100000;
configuration=[];
bestNet=struct;
year=2;
standar_status=0;       % 0 or 1 whether data input is no-standardized or standardized 

%% max values of spectral radious and reservoir size
reservoirNumber=70;     %max value
spectral_radious=0.9;   %max value
nForgetPoints = 11 ;    %value
%% different configurations of internal random weighs 
random_times=16;
C_array=[8:0.5:9.5];
%% Esn configuration
nInputUnits = 2;        %nInternalUnits = 30; 
nOutputUnits = 1; 
bestFinal=struct('error',00.1,'networkESN',struct);        
configuration=struct('error',00.1,'net',struct); 
configuration_color_map=zeros(spectral_radious*10,(reservoirNumber-10)+1);
configuration_by_sparce=zeros(random_times,1);
%% neural network based architectures are prepared; 
        [input,test]=splitData(input,year);
        scaledinput=[];
        if standar_status>0
            [inputstand,xlog1]=translog(input);
            [scaledinput,PS]=mapminmax(inputstand');
        else
            [scaledinput,PS]=mapminmax(input');
        end
        [inputSequence,outputSequence]=normNN(scaledinput',1);
        inputSequence= [ones(size(inputSequence,1),1) inputSequence];

count=1;
count2=0;
count3=1;
connectivity_vs_prob=[];
localBestNet=struct;
localBestPerfNN=0;
configurationLocal=100000;
for C=1:size(C_array,2)
     %% creating and training ESN with multiple random configuration
    for connectivity=0.1:0.01:0.9
        fprintf('%d connec\n',connectivity);
     for i=1:random_times
     [net,perfNN] = generate_esnTRIALERROR_orth(inputSequence,outputSequence,nInputUnits,30,nOutputUnits,0.9,connectivity,flag);
      configuration(count)=struct('error',perfNN,'net', net);
      configuration_by_sparce(i)=perfNN;
      if perfNN < configurationLocal
          localBestPerfNN = perfNN;
          localBestNet = net; 
           
      end
      if perfNN < C_array(1,C)*power(10,-1)
          count2=count2+1;
      end
      if perfNN < configurationvalue
            configurationvalue=perfNN;
            bestNet=net;        
      end
      count=count+1;
     end
     %% problem with mod function in 3.0 connectivity instead we use rem function, solution: convert string to num
     repair_data=ceil(connectivity);
     strconnect = sprintf('%f', connectivity);
     strconnectint= str2num(strconnect);
     
     if rem(strconnectint*10,repair_data) == 0
            fprintf('%d interger connection.\n',connectivity);
            
            saveMatrix(localBestNet.internalWeights,strcat('matrix_orth_connec_',num2str(C),'_',num2str(connectivity)));
     end
     connectivity_vs_prob(C,count3) = count2/random_times;
     count3=count3+1;
     count2=0;
     configurationLocal=100000;
     localBestNet=struct;
     localBestPerfNN = 0;
    %fprintf('%s will be %d this year.\n',connec);
    end
    count3=1;
end
    best=sort(configuration_by_sparce);
   % configuration_color_map(uint8(esp*10),(n-10)+1)=best(1,1);
    configuration_by_sparce=[];
    rng(seed);
  
   % bestFinal(count2)=struct('error',configurationvalue,'networkESN', bestNet);
   % count2=count2+1;
    
    
    %display('espectral radious %d',esp);


%train_fraction = 0.6
%[trainInputSequence, testInputSequence] = ...
%    split_train_test(inputSequence,train_fraction);
%[trainOutputSequence,testOutputSequence] = ...
%    split_train_test(outputSequence,train_fraction);
%predictedTestOutput = test_esn(testInputSequence,  bestNet, nForgetPoints) ; 
%predictedTrainOutput = test_esn(trainInputSequence, bestNet, nForgetPoints);
%nPlotPoints = size(trainOutputSequence,1)-nForgetPoints; 
%plot_sequence(trainOutputSequence(nForgetPoints+1:end,:), predictedTrainOutput, nPlotPoints,...
%    'training: teacher sequence (red) vs predicted sequence (blue)');
%nPlotPoints = size(testOutputSequence,1)-nForgetPoints; 
%plot_sequence(testOutputSequence(nForgetPoints+1:end,:), predictedTestOutput, nPlotPoints, ...
%    'testing: teacher sequence (red) vs predicted sequence (blue)') ; 
%save_esn(esn, '11413000monthly.esn');

%hold off;