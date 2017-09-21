clear all;

%% number of repetitons
num_rep=10;

%% indicators 
NRMSE = [];
MAD=[];
RMSE=[];
MSE=[];
MPE=[];
NSE=[];

%% matrix to plot
BestNRMSE=-Inf;
Best_to_plot1=[];
Best_to_plot2=[];
Best_to_plot3=[];
Best_to_plot4=[];
Best_to_plot5=[];

%% set time series
inputs_exo=load('source/ersst4.indices.txt');



%% select hidrological variable

input_exoge=inputs_exo(:,10);

%% set the horizon of prediction
years=3; 

%% Split data from horizon prediction
[input_exoge,test_exoge]=splitData(input_exoge,years);
%% input for T. Fiering model and PEN and index_SST
        T_1_TF=inputstand(size(inputstand,1),:);
        T_1_NN=T_1_TF;

