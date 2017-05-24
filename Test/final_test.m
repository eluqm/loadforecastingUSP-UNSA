clear all;
inputs=xlsread('source/Datos_Pruebas.xls');
%inputs=load('source/03054500TygartMonthly.dly.txt');
%inputs=load('source/03364000EastForkWhiteMonth.dly.txt');
%inputs=load('source/03179000bluestoneM.dly.txt');
input=inputs(:,4);
fprintf('skewness coefic no-log %f \n',skewness(input))
MATGEN3=[];
%figure
%histogram(input)
%hold on
%historical data 1 =, 2= , 3=
data=inputs(:,3); 
years=1;
[input,test]=splitData(input,years);

        %% A transformation is required if a time series is not normally distributed
        % It aims to remove the seasonality from the mean and the variance,
        % if skewness coefficients are biased. Therefore, a transformation to reduce this skewness closer to zero was needed.
        % The skewness of the observed data is reduced using log-transformation
        [inputstand,xlog1]=translog(input);
        
        
        %% Before training, it is often useful to scale the inputs and targets 
        % so that they always fall within a specified range. 
        % The function mapminmax scales inputs and targets so that they fall in the range [–1,1]. 
            %% [scaledinput,PS]=mapminmax(input');
        [scaledinput,PS]=mapminmax(inputstand');
        [inputSequence,outputSequence]=normNN(scaledinput',1);%short time delay memory = 2 , without  bias
        inputSequence= [ones(size(inputSequence,1),1) inputSequence];
     
        %% initial nForgetPoints time points ( can be disregarded)
        nForgetPoints = 12 ;
        initSequence=inputSequence(size(inputSequence,1)-(nForgetPoints-1):end,:);
       
        numofseries=20;
        count=1;
        MATGEN3=[];
        %ESN03054500TygartMonthD_leaky_ramdom_ridge
        %net_ESN=load_esn('ESN03054500TygartMonthD_leaky_ramdom_ridge');
        %net_ESN=load_esn('ESN03054500TygartMonthD');
        %net_ESN=load_esn('ESN03054500Tygart_leaky_ridge_standard');
        net_ESN=load_esn('ESNPanie_leaky_ridge_standard');
        %net_ESN=load_esn('ESN03364000EastForkWhiteMonthD');
        %net_ESN=load_esn('ESN03364000EasstD_leaky_ramdom_ridge');
        %net_ESN=load_esn('ESN03179000bluestone_leaky_ridge_standard');
        %net_ESN=load_esn('ESN03179000bluestoneD_leaky_ramdom_ridge');
        %% initiate state  matrix
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
       
        
        
      %% generating 'numofserise'syntetics series   
      for ser=1:numofseries
          for i=1:nForgetPoints
           in=initSequence(i,:);
           [out,stateCollectMat,totalstate]=compute_statematrix_nserie(stateCollectMat,totalstate,in,[], net_ESN, nForgetPoints,i);
          end
% % predicted=[zeros(nForgetPoints,1);predicted];
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
                    
                    %Random Component   
                    Rvt=tomasandfiering(-1,input,mi);                
                    Rvtn=detranslogone(inputstand,xlog1,input,Rvt,m);
                    %% RvtnNorm=mapminmax('apply',Rvtn,PS);
                    %% Rvtn + ESN_output
                    if count < 2
                        out=getOutESN(totalstate(1:size(totalstate)-1,1)',net_ESN,PS);
                        outrev=mapminmax('reverse',out,PS);
                        %% inminmax=mapminmax('apply',outrev+Rvt,PS);
                        inminmax=detranslogone(inputstand,xlog1,input,Rvt+outrev,m);
                        inminmax=translogone(input,inminmax,m);
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
                        inminmax=detranslogone(inputstand,xlog1,input,Rvt+outrev,m);
                        inminmax=translogone(input,inminmax,m);
                        inminmax=mapminmax('apply',inminmax,PS);
                        in=[1 inminmax];  
                        %% inminmax=mapminmax('apply',outrev+Rvtn,PS);
                        %% in=[1 inminmax];  
                       % in=[1 RvtnNorm+out];
                    end
                    
                    
                    %% Compute matrix of states for syntethic serie "n" for
                    [out,stateCollectMat,totalstate]=compute_statematrix_nserie(stateCollectMat,totalstate,in,[], net_ESN, nForgetPoints,count+nForgetPoints);                                                                             
                    MATGEN2(m,ser,y)=Rvtn;
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
             
            % inputNetworkESN1=mapminmax('apply',inputNetworkESN',PS);
            % inputNoiseNetwork=[ones(size(inputNetworkESN1',1),1) inputNetworkESN1']; 
            MATGEN3=[MATGEN3 abs(predictedde(:,1))];
            count=1;
            totalstate = zeros(net_ESN.nInputUnits + net_ESN.nInternalUnits + net_ESN.nOutputUnits, 1);
            stateCollectMat = ...
            zeros(years*12, net_ESN.nInputUnits + net_ESN.nInternalUnits) ; 
       end
 [rmse,mse]=plotPEN(MATGEN2,test,'Tomas and Fiering');
 MATGEN4=[];
            for n=1:years
                MATGEN4(:,:,n)=MATGEN3((n-1)*12+1:12*n,:);
                %MATGEN5=[MATGEN5 ; MATGEN2(:,:,n)];
            end
            [rmse,mse]=plotPEN(MATGEN4,test,'ESN');
            
         %  parfor o=1:10
         %      y(o)=rand()
         %       disp(sprintf(' %d work', y(o)))
         %  end