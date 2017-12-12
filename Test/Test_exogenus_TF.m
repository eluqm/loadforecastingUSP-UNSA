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

%% set time series
%inputs=xlsread('source/Datos_Pruebas.xls');

%input=inputs(:,4);

%% select hidrological variable

%% select exogenous variable 
input_exoge_SST=inputs_exo(:,9);
input_exoge_ASST=inputs_exo(:,10);

%% set the horizon of prediction
years=3; 

%% Split data from horizon prediction
[input_exoge_SST,test_exoge_SST]=splitData(input_exoge_SST,years);
%[input,test]=splitData(input,years);
[input_exoge_ASST,test_exoge_ASST]=splitData(input_exoge_ASST,years);

%% input for T. Fiering model and PEN and index_SST
       % T_1_TF=inputstand(size(inputstand,1),:);
     %   T_1_NN=T_1_TF;
%% A transformation is required if a time series is not normally distributed
        % It aims to remove the seasonality from the mean and the variance,
        % if skewness coefficients are biased. Therefore, a transformation to reduce this skewness closer to zero was needed.
        % The skewness of the observed data is reduced using log-transformation
        %[inputstand,xlog1]=translog(input);
        %fprintf('skewness log+seasonaly+flow time serie: %s\n',num2str(skewness(inputstand)));
        %fprintf('skewness flow time serie: %s\n',num2str(skewness(input)));
        
        [inputstand_exoge_SST,log_exoge_SST]=translog(input_exoge_SST);
        %fprintf('skewness log+seasonaly+exogenous+SST: %s\n',num2str(skewness(inputstand_exoge1)));
       % [trans,lambda]=boxcox(input_exoge)
       
       
         [inputstand_exoge_ASST_log,log_exoge_ASST_log] =transSTDsgn(input_exoge_ASST);
         [inputstand_exoge_ASST] =transSTD(input_exoge_ASST);
         %fprintf('skewness log+seasonaly+exogenous+ASST: %s\n',num2str(skewness(inputstand_exoge3)));
         %fprintf('skewness seasonaly+exogenous+ASST: %s\n',num2str(skewness(input_exoge2)));
        % [data]=detransSTDsgn(inputstand_exoge_ASST,log_exoge_ASST);
         %skewness(xi);
%% Before training, it is often useful to scale the inputs and targets 
        % so that they always fall within a specified range. 
        % The function mapminmax scales inputs and targets so that they fall in the range [–1,1]. 
        %[scaledinput,PS]=mapminmax(input');
        %[scaledinput,PS]=mapminmax(inputstand');
        %% index value
        %[scaledinput_exoge,PS_exoge]=mapminmax(input_exoge');
        
        %[inputSequence,outputSequence]=normNN(scaledinput',1);
       % [inputSequence_exoge,outputSequence_exoge]=normNN(scaledinput_exoge',1);%short time delay memory = 2 , without bias
      %  [inputSecuenceNN,outputSecuenceNN]=normNN(scaledinput',2);      %time delay of 2 steps to feedfordward neural network 
      % inputSequence_exo=[ones(size(inputSequence,1),1) inputSequence_exoge inputSequence];
     %   inputSequence= [ones(size(inputSequence,1),1) inputSequence];   %input for ESN with bias = 1
     
     
 %% Set the number of sintetic time series
        %numofseries=100;
        numofseries=5;
        %% utils vars
        count=1;
        MATGEN3=[];
        THOMAS_FIERING2=[];
        NEURAL_PEN=[];
        neural_pred_pen=[];
        NEURAL_ANFIS=[];
        neural_pred_anfis=[];
        ASST=[];
        ASST_log=[];
        SST=[];
 for ij=1:num_rep
     
     %% Reset Series 
       NEURAL_PEN(:,:,:)=[]; 
       NEURAL_ANFIS(:,:,:)=[];
       %MATGEN2(:,:,:)=[]; 
       MATGEN3(:,:,:)=[];
       ASST(:,:,:)=[];
       ASST_log(:,:,:)=[];
       SST(:,:,:)=[];
       ser=1;
      %% generating syntetics series   
      while ser <= numofseries
          
           %% Exogenus initialit...
          T_1_EXO=inputstand_exoge_ASST(size(inputstand_exoge_ASST,1),:);
          T_2_EXO=inputstand_exoge_ASST_log(size(inputstand_exoge_ASST_log,1),:);
          T_3_EXO=inputstand_exoge_SST(size(inputstand_exoge_SST,1),:);
          
          for y=1:years                          
                 for m=1:12
                    mi=m;
                    if m==1 
                        mi=13;
                    end
                    if m==2
                        mi=14;
                    end
                     %% Random index Component and TF 
                    Ivt_asst_rdn= tomasandfieringNOLOG(-1,input_exoge_ASST,mi);
                    Ivt_asst_rdn_log=randomVar(input_exoge_ASST,mi);
                    
                    Ivt= tomasandfiering(-1,input_exoge_SST,mi);
                    Itf=Thomas_and_FIering_method(Ivt,input_exoge_SST,mi,T_3_EXO);
                    T_3_EXO=Itf;
                    Ivtf=detranslogone(inputstand_exoge_SST,log_exoge_SST,input_exoge_SST,Itf,m);
                    
                    
                    Itf_asst=Thomas_and_FIering_methodNOLOG(Ivt_asst_rdn,input_exoge_ASST,mi,T_1_EXO);
                    Itf_asst_log=Thomas_and_Fiering_ASST(Ivt_asst_rdn_log,input_exoge_ASST,mi,T_2_EXO);
                    T_2_EXO=Itf_asst;
                    T_1_EXO=Itf_asst_log;
                    %Ivtf=detranslogone(inputstand_exoge,xlog1_exoge,input_exoge,Itf,m);
                     %% getting value using T.Fiering model
                    %Ytf=Thomas_and_FIering_method(Rvt ,input,mi,T_1_TF);
                    %T_1_TF=Ytf;
                    
                    
                     %% reverse of LOG transformation
                   % Rvtn=detranslogone(inputstand,xlog1,input,Rvt,m);
                    Yvtf_asst_log=detransSTDsgnone(log_exoge_ASST_log,Itf_asst_log,m);
                    Yvtf_asst=detransSTDone(inputstand_exoge_ASST,input_exoge_ASST,Itf_asst,m);
                    Yvtf_asst_rand=detransSTDone(inputstand_exoge_ASST,input_exoge_ASST, Ivt_asst_rdn,m);
                    Yvtf_asst_rand_log=detransSTDone(inputstand_exoge_ASST,input_exoge_ASST, Ivt_asst_rdn_log,m);
                    %Ivt_asst=detransSTDsgnone(log_exoge3,Itf_asst,m);
                     %% Compute matrix of states for syntethic serie "n" for
                    %[out,stateCollectMat,totalstate]=compute_statematrix_nserie(stateCollectMat,totalstate,in,[], net_ESN, nForgetPoints,count+nForgetPoints);                                                                             
                   % MATGEN2(m,ser,y)=Rvtn;
                   ASST_log(m,ser,y)=Yvtf_asst_log; 
                   SST(m,ser,y)=Ivtf;
                  % THOMAS_FIERING2(m,ser,y)=Yvtf;
                   ASST(m,ser,y)=Yvtf_asst;
                   ASST_rand(m,ser,y)=Yvtf_asst_rand;
                   ASST_rand_log(m,ser,y)=Yvtf_asst_rand_log;
                  count=count+1;
                 end
          end
           ser=ser+1;
      end
      
     % [RMSE(3,ij),MSE(3,ij),MAD(3,ij),NRMSE(3,ij),MPE(3,ij),NSE(3,ij)]=plotPEN(MATGEN4,test,'ESN',0);
      %  [RMSE(4,ij),MSE(4,ij),MAD(4,ij),NRMSE(4,ij),MPE(4,ij),NSE(4,ij)]=plotPEN(NEURAL_PEN,test,'PEN',0);
      %  [RMSE(5,ij),MSE(5,ij),MAD(5,ij),NRMSE(5,ij),MPE(5,ij),NSE(5,ij)]=plotPEN(NEURAL_ANFIS,test,'ANFIS',0);
      [RMSE(3,ij),MSE(3,ij),MAD(3,ij),NRMSE(3,ij),MPE(3,ij),NSE(3,ij)]=plotPEN(ASST_log,test_exoge_ASST,'ESN',0);
      % diff_to_ESN=(NRMSE(1,ij)-NRMSE(3,ij)) + ...
      %             (NRMSE(2,ij)-NRMSE(3,ij)) + ...
       %            (NRMSE(4,ij)-NRMSE(3,ij)) + ...
      %             (NRMSE(5,ij)-NRMSE(3,ij));
      %   if  diff_to_ESN > BestNRMSE 
      %      BestNRMSE = diff_to_ESN;
      %      Brute_BestNRMSE = NRMSE(3,ij);
      %      Best_to_plot1=MATGEN2;
            %Best_to_plot2=THOMAS_FIERING2;
            Best_to_plotASST_log=ASST_log;
            Best_to_plotASST=ASST;
            Best_to_plotSST=SST;
      %      Best_to_plot3= MATGEN4;
      %      Best_to_plot4=NEURAL_PEN;
      %      Best_to_plot5=NEURAL_ANFIS;
            
      
        fprintf('iteration n: %s\n',num2str(ij));
 end
