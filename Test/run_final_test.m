clear all;
%% number of repetitons
num_rep=1;

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
%inputs=xlsread('source/Datos_Pruebas.xls');
%inputs=csvread('BarcelonaAeropuertomonth_ts.csv');
%inputs=load('source/03054500TygartMonthly.dly.txt');
inputs=load('source/03364000EastForkWhiteMonth.dly.txt');
%inputs=load('source/03179000bluestoneM.dly.txt');
%inputs=load('source/11413000monthly.dly.txt');
%inputs=load('source/01541500CLEARFIELDMonth.dly.txt');
%inputs=load('source/01541000Month.dly.txt');
%inputs=load('source/12413000Month.dly.txt');
%% Set trained ESN network 
%ESN03054500TygartMonthD_leaky_ramdom_ridge
        %net_ESN=load_esn('ESN03054500TygartMonthD_leaky_ramdom_ridge');
        %net_ESN=load_esn('ESN03054500TygartMonthD');
        %net_ESN=load_esn('ESN03054500Tygart_leaky_ridge_standard');
        %net_ESN=load_esn('ESNPanie_leaky_ridge_standard');
        %net_ESN=load_esn('ESN01541500CLEARFIELD_leaky_ramdom_ridge');
        %net_ESN=load_esn('ESN03364000EastForkWhiteMonthD');
        %net_ESN=load_esn('ESN03364000EasstD_leaky_ramdom_ridge');
        %net_ESN=load_esn('ESN01541500_plain_STD_nonRIDGE_rand5');
        %net_ESN=load_esn('Panie_plain_nonSTD_nonRIDGE_rand5');
        net_ESN=load_esn('ESN03364000_leaky_STD_RIDGE_rand5_80_nonScaling');
        %net_ESN=load_esn('ESN03179000bluestone_leaky_ridge_standard');
        %net_ESN=load_esn('ESN03179000bluestoneD_leaky_ramdom_ridge');


%% select hidrological variable
input=inputs(:,3);

%% 
%fprintf('skewness coefic no-log %f \n',skewness(input))

%% set the horizon of prediction
years=1; 

%% Split data from horizon prediction
[input,test]=splitData(input,years);

        %% A transformation is required if a time series is not normally distributed
        % It aims to remove the seasonality from the mean and the variance,
        % if skewness coefficients are biased. Therefore, a transformation to reduce this skewness closer to zero was needed.
        % The skewness of the observed data is reduced using log-transformation
        [inputstand,xlog1]=translog(input);
%       fprintf('skewness coefic no-log %f \n',skewness(inputstand)) 
        %% input for T. Fiering model and PEN
        T_1_TF=inputstand(size(inputstand,1),:);
        T_1_NN=T_1_TF;
        %% set hidden layers for PEN
        hidden_layers=[9];
        
        %% Before training, it is often useful to scale the inputs and targets 
        % so that they always fall within a specified range. 
        % The function mapminmax scales inputs and targets so that they fall in the range [–1,1]. 
        %[scaledinput,PS]=mapminmax(input');
        [scaledinput,PS]=mapminmax(inputstand');
        [inputSequence,outputSequence]=normNN(scaledinput',1);          %short time delay memory = 2 , without bias
        [inputSecuenceNN,outputSecuenceNN]=normNN(scaledinput',2);      %time delay of 2 steps to feedfordward neural network 
        inputSequence= [ones(size(inputSequence,1),1) inputSequence];   %input for ESN with bias = 1
     
        %% initial nForgetPoints time points ( can be disregarded)
        nForgetPoints = 24 ;
        initSequence=inputSequence(size(inputSequence,1)-(nForgetPoints-1):end,:);
        
        %% init and train NN 
        [ff_Net,perfNN]=penNN(inputSequence,outputSequence,hidden_layers);
        %T_1_NN=translogone(input,T_1_NN,12);
        T_1_NN=mapminmax('apply',T_1_NN,PS);
        T_1_NN=[1 T_1_NN];
        
        %% init and train ANFIS NN
        anfisNN=anfis([inputSequence(:,2) outputSequence]);
        T_1_anfis=mapminmax('apply',T_1_TF,PS);
        
        %% Set the number of sintetic time series
        %numofseries=100;
        numofseries=100;
        %% utils vars
        count=1;
        MATGEN3=[];
        THOMAS_FIERING=[];
        NEURAL_PEN=[];
        neural_pred_pen=[];
        NEURAL_ANFIS=[];
        neural_pred_anfis=[];
 for ij=1:num_rep
        %% initiate state matrix
        if nForgetPoints >= 0
            stateCollectMat = ...
            zeros(years*12, net_ESN.nInputUnits + net_ESN.nInternalUnits) ; 
        else
            stateCollectMat = ...
            zeros(years*12, net_ESN.nInputUnits + net_ESN.nInternalUnits) ; 
        end
        out=0;
        externalStartStateFlag = 0;

        if externalStartStateFlag == 0
         totalstate = zeros(net_ESN.nInputUnits + net_ESN.nInternalUnits + net_ESN.nOutputUnits, 1);
         %internalState = zeros(esn.nInternalUnits, 1);
        end
       %% Reset Series 
       NEURAL_PEN(:,:,:)=[]; 
       NEURAL_ANFIS(:,:,:)=[];
       %MATGEN2(:,:,:)=[]; 
       MATGEN3(:,:,:)=[]; 
       ser=1;
      %% generating syntetics series   
      while ser <= numofseries
          %% Set initialitation
          T_1_TF=inputstand(size(inputstand,1),:);
          T_1_NN=T_1_TF;
          T_1_NN=mapminmax('apply',T_1_NN,PS);
          T_1_NN=[1 T_1_NN];
          T_1_anfis=mapminmax('apply',T_1_TF,PS);
          
          %% For ESN model, computing the nforget initial states
          for i=1:nForgetPoints
           in=initSequence(i,:);
           [out,stateCollectMat,totalstate]=compute_statematrix_nserie(stateCollectMat,totalstate,in,[], net_ESN, nForgetPoints,i);
          end

             for y=1:years                          
                 for m=1:12
                    mi=m;
                    if m==1 
                        mi=13;
                    end
                    if m==2
                        mi=14;
                    end
                    
                    %% Random Component   
                    Rvt=tomasandfiering(-1,input,mi);
                    
                    %% getting value using T.Fiering model
                    Ytf=Thomas_and_FIering_method(Rvt ,input,mi,T_1_TF);
                    T_1_TF=Ytf;
                    
                    %% getting value using ANFISMODEL
                    Ynn_anfis=evalfis(T_1_anfis,anfisNN);
                    %%RVT + NN_outut
                        Ynnt_anfis_t=mapminmax('reverse',Ynn_anfis,PS);
                        Yvnnt_anfis_t=abs(detranslogone(inputstand,xlog1,input,Rvt+Ynnt_anfis_t,m));
                        neural_pred_anfis(count,1)=Yvnnt_anfis_t;
                        NEURAL_ANFIS(m,ser,y)=Yvnnt_anfis_t;
                    Ynnt_anfis_t=translogone(input,Yvnnt_anfis_t,m);
                    Ynnt_anfis_t2=mapminmax('apply',Ynnt_anfis_t,PS);
                    T_1_anfis=Ynnt_anfis_t2;
                                      
                    %% getting value using Feedforward Network
                    Ynn=sim(ff_Net,T_1_NN');
                        %%RVT + NN_outut
                        Ynnt=mapminmax('reverse',Ynn,PS);
                        Yvnnt=abs(detranslogone(inputstand,xlog1,input,Rvt+Ynnt,m));
                        neural_pred_pen(count,1)=Yvnnt;
                        NEURAL_PEN(m,ser,y)=Yvnnt;
                    Ynnt=translogone(input,Yvnnt,m);
                    Ynnt2=mapminmax('apply',Ynnt,PS);
                    T_1_NN=[1 Ynnt2];
                    
                    %% reverse of LOG transformation
                    Rvtn=detranslogone(inputstand,xlog1,input,Rvt,m);
                    Yvtf=detranslogone(inputstand,xlog1,input,Ytf,m);
                    %% RvtnNorm=mapminmax('apply',Rvtn,PS);
                    %% Rvtn + ESN_output
                    if count < 2
                        out=getOutESN(totalstate(1:size(totalstate)-1,1)',net_ESN,PS);
                        outrev=mapminmax('reverse',out,PS);
                        %% inminmax=mapminmax('apply',outrev+Rvt,PS);
                        inminmax=detranslogone(inputstand,xlog1,input,(Rvt*1.3)+outrev,m);
                        inminmax=translogone(input,abs(inminmax),m);
                        inminmax=mapminmax('apply',inminmax,PS);
                        in=[1 inminmax];  
                       % totalstate = [internalState; in;out]
                   %    out=getOutESN(totalstate(1:size(totalstate)-1,1)',net_ESN,PS);
                   %    outrev=mapminmax('reverse',out,PS);
                   %    in=[1 mapminmax('apply',(Rvtn+outrev)/2,PS)];
                    else
                   % out=getOutESN(stateCollectMat(count,:),net_ESN,PS);
                  %  outrev=mapminmax('reverse',out,PS);
                  %  in=[1 mapminmax('apply',(Rvtn+outrev)/2,PS)];
                  
                       % in=[1 RvtnNorm+out];  
                        out=getOutESN(totalstate(1:size(totalstate)-1,1)',net_ESN,PS);
                        outrev=mapminmax('reverse',out,PS);
                        inminmax=detranslogone(inputstand,xlog1,input,(Rvt*1.3)+outrev,m);
                        %inminmax_2=detranslogone(inputstand,xlog1,input,outrev,m);
                        inminmax=translogone(input,abs(inminmax),m);
                        inminmax=mapminmax('apply',inminmax,PS);
                        in=[1 inminmax];  
                        %% inminmax=mapminmax('apply',outrev+Rvtn,PS);
                        %% in=[1 inminmax];  
                       % in=[1 RvtnNorm+out];
                    end
                    
                    
                    %% Compute matrix of states for syntethic serie "n" for
                    [out,stateCollectMat,totalstate]=compute_statematrix_nserie(stateCollectMat,totalstate,in,[], net_ESN, nForgetPoints,count+nForgetPoints);                                                                             
                    MATGEN2(m,ser,y)=Rvtn;
                    THOMAS_FIERING(m,ser,y)=Yvtf;
                  count=count+1;
                 end   
             end
             
             %% stateCollection*outputWeighs
             outputSequence = stateCollectMat * net_ESN.outputWeights' ; 
                %%%% scale and shift the outputSequence back to its original size
                nOutputPoints = length(outputSequence(:,1)) ; 
                outputSequence = feval(net_ESN.outputActivationFunction, outputSequence); 
                outputSequence = outputSequence - repmat(net_ESN.teacherShift',[nOutputPoints 1]) ; 
                outputSequence = outputSequence / diag(net_ESN.teacherScaling) ; 
             predictedde=mapminmax('reverse',outputSequence,PS);
             for y=1:years                          
                 for m=1:12
%                   %Rvt= tomasandfiering(val,m)
                    mi=m;
                    if m==1 
                        mi=13;
                    end
                   if m==2
                        mi=14;
                   end
                   predictedde((y-1)*12+m,1)=detranslogone(inputstand,xlog1,input,predictedde((y-1)*12+m,1),m);
                 end
             end 
             
             %% try and cath
             if sum(isinf(predictedde(:,1))) > 0  || ~isempty(predictedde(predictedde(:,1)>1.0e+2))
                
                 %% clean states of ESN 
                 totalstate = zeros(net_ESN.nInputUnits + net_ESN.nInternalUnits + net_ESN.nOutputUnits, 1);
                 stateCollectMat = ...
                 zeros(years*12, net_ESN.nInputUnits + net_ESN.nInternalUnits) ; 
                 count=1;
                 XX=sprintf('wrong value %s',num2str(NEURAL_PEN(m,ser,y)));
                 display(XX)
                 display('WARNING  !!! wrong time serie ');
                 continue 
             end
             if sum(isinf(neural_pred_anfis(:,1)))>0   || ~isempty(neural_pred_anfis(neural_pred_anfis(:,1)>1.0e+2))
                
                 %% clean states of ESN 
                 totalstate = zeros(net_ESN.nInputUnits + net_ESN.nInternalUnits + net_ESN.nOutputUnits, 1);
                 stateCollectMat = ...
                 zeros(years*12, net_ESN.nInputUnits + net_ESN.nInternalUnits) ; 
                 count=1;
                 XX=sprintf('wrong value %s',num2str(NEURAL_PEN(m,ser,y)));
                 display(XX)
                 display('WARNING  !!! wrong time serie ');
                 continue 
             end
             if sum(isinf(neural_pred_pen(:,1)))>0   || ~isempty(neural_pred_pen(neural_pred_pen(:,1)>1.0e+2))
                 %% clean states of ESN 
                 totalstate = zeros(net_ESN.nInputUnits + net_ESN.nInternalUnits + net_ESN.nOutputUnits, 1);
                 stateCollectMat = ...
                 zeros(years*12, net_ESN.nInputUnits + net_ESN.nInternalUnits) ; 
                 count=1;
                 XX=sprintf('wrong value %s',num2str(NEURAL_PEN(m,ser,y)));
                 display(XX)
                 display('WARNING  !!! wrong time serie ');
                 continue 
             end
             
             
             
            MATGEN3=[MATGEN3 predictedde(:,1)];
            count=1;
            
            %% clean states of ESN 
            totalstate = zeros(net_ESN.nInputUnits + net_ESN.nInternalUnits + net_ESN.nOutputUnits, 1);
            stateCollectMat = ...
            zeros(years*12, net_ESN.nInputUnits + net_ESN.nInternalUnits) ; 
            ser=ser+1;
      end
      
  %% Row 1:thomas fiering random
  %%     2:thomas fiering model  
  %%     3:ESN
  %%     4:PEN
  %%     5:ANFIS
        
        [RMSE(1,ij),MSE(1,ij),MAD(1,ij),NRMSE(1,ij),MPE(1,ij),NSE(1,ij)]=plotPEN(MATGEN2,test,'T_Fiering_random',0);
        %csvwrite('matriz_thoas',MATGEN2);
        [RMSE(2,ij),MSE(2,ij),MAD(2,ij),NRMSE(2,ij),MPE(2,ij),NSE(2,ij)]=plotPEN(THOMAS_FIERING,test,'T_Fiering_model',0);
        MATGEN4=[];
            for n=1:years
                MATGEN4(:,:,n)=MATGEN3((n-1)*12+1:12*n,:);            
            end
        [RMSE(3,ij),MSE(3,ij),MAD(3,ij),NRMSE(3,ij),MPE(3,ij),NSE(3,ij)]=plotPEN(MATGEN4,test,'ESN',0);
        [RMSE(4,ij),MSE(4,ij),MAD(4,ij),NRMSE(4,ij),MPE(4,ij),NSE(4,ij)]=plotPEN(NEURAL_PEN,test,'PEN',0);
        [RMSE(5,ij),MSE(5,ij),MAD(5,ij),NRMSE(5,ij),MPE(5,ij),NSE(5,ij)]=plotPEN(NEURAL_ANFIS,test,'ANFIS',0);
      
       diff_to_ESN=(NRMSE(1,ij)-NRMSE(3,ij)) + ...
                   (NRMSE(2,ij)-NRMSE(3,ij)) + ...
                   (NRMSE(4,ij)-NRMSE(3,ij)) + ...
                   (NRMSE(5,ij)-NRMSE(3,ij));
         if  diff_to_ESN > BestNRMSE 
            BestNRMSE = diff_to_ESN;
            Brute_BestNRMSE = NRMSE(3,ij);
            Best_to_plot1=MATGEN2;
            Best_to_plot2=THOMAS_FIERING;
            Best_to_plot3= MATGEN4;
            Best_to_plot4=NEURAL_PEN;
            Best_to_plot5=NEURAL_ANFIS;
            
        end
        fprintf('iteration n: %s\n',num2str(ij));
 end      
      %% SAVE NRMSE for plot
      csvwrite(strcat('03364000_T_Fiering_randomSTD_prod_80_nonScaling',num2str(years)),Best_to_plot1);
      csvwrite(strcat('03364000_T_Fiering_modelSTD_prod_80_nonScaling',num2str(years)),Best_to_plot2);
      csvwrite(strcat('03364000_ESNSTD_prod_80_nonScaling',num2str(years)),Best_to_plot3);
      csvwrite(strcat('03364000_PENSTD_prod_80_nonScaling',num2str(years)),Best_to_plot4);
      csvwrite(strcat('03364000_ANFISSTD_prod_80_nonScaling',num2str(years)),Best_to_plot5);
      
      final_results=[];
      %% SAVE MEDIAS 
      for jj=1:5
        final_results{jj,1}=[mean(RMSE(jj,:)) mean(MSE(jj,:)) mean(MAD(jj,:)) mean(NRMSE(jj,:)) mean(MPE(jj,:)) mean(NSE(jj,:))];
      end
      csvwrite(strcat('03364000_final_resultSTD_prod_80_nonScaling',num2str(years)),final_results);
      
