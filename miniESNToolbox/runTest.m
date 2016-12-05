clear all;
%inputs=xlsread('source/Datos_Pruebas.xls');
inputs=load('03054500TygartMonthly.dly.txt');
% case : Mopex hydrologic data :1 +> mean areal precipitation (mm) 
% case : Mopex hydrologic data :2 +> climatic potential evaporation (mm)
% case : Mopex hydrologic data :3 +> daily streamflow discharge (mm)

property=3;
input=inputs(:,property);

configurationvalue=100000;
configuration=[];
bestNet=struct;
year=2;
reservoirNumber=80; %max value
spectral_radious=0.9; %max value
nForgetPoints = 11 ; %value
        
nInputUnits = 2; nInternalUnits = 30; nOutputUnits = 1; 
bestFinal=struct('error',00.1,'networkESN',struct);        
configuration=struct('error',00.1,'net',struct); 

%neural network based architectures are prepared; 
        [input,test]=splitData(input,year);
        [scaledinput,PS]=mapminmax(input');
        [inputSequence,outputSequence]=normNN(scaledinput',1);%short time delay memory = 2 , without  bias
        inputSequence= [ones(size(inputSequence,1),1) inputSequence];

count=1;
count2=1;
for esp=0.1:0.1:spectral_radious
    for n=10:reservoirNumber
   %creating and training ESN
     [net,perfNN] = generate_esnTRIALERROR(inputSequence,outputSequence,nInputUnits,n,nOutputUnits,esp);
      configuration(count)=struct('error',perfNN,'net', net);
      if perfNN < configurationvalue
         configurationvalue=perfNN;
          bestNet=net;        
      end
    count=count+1;
    end
    bestFinal(count2)=struct('error',configurationvalue,'networkESN', bestNet);
    count2=count2+1
end

%save_esn(esn, '11413000monthly.esn');


