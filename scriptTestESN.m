clear all; 

inputs=load('source/11413000monthly.dly.txt');
%inputs=xlsread('source/Datos_Pruebas.xls');
input=inputs(:,1);
data=inputs(:,1); %historical data
years=2;
[inputstandstart,xlog1start]=translog(input);
[input,test]=splitData(input,years);
[less,teststandard]=splitData(inputstandstart,years);
MATGEN=0;
        
        % A transformation is required if a time series is not normally distributed
        % It aims to remove the seasonality from the mean and the variance,
        % if skewness coefficients are biased. Therefore, a transformation to reduce this skewness closer to zero was needed.
        % The skewness of the observed data is reduced using log-transformation
                
        %log-transformation and standarization of data 
        [inputstand,xlog1]=translog(input);
        %[teststand,test]=translog(test);
        % A step before training the neural networkk, 
        % it is often useful to scale the inputs and targets so that they always fall within a specified range. 
        % in this project, the data were scaled in the range of [-1, +1] using the equation:
       
        
        %neural network based architectures are prepared; 
        [scaledinput,PS]=mapminmax(input');
        [inputSequence,outputSequence]=normNN(scaledinput',1);%short time delay memory = 2 , without  bias
        inputSequence= [ones(size(inputSequence,1),1) inputSequence];
        %%%% generate an esn 
        nForgetPoints = 11 ;
        
        nInputUnits = 2; nInternalUnits = 30; nOutputUnits = 1; 
        %creating and training ESN
        [net,perfNN] = penESN(inputSequence,outputSequence,nInputUnits,nInternalUnits,nOutputUnits);
       % [newinputSequence,outputSequence]=normNN(input(size(input,1)-(12*years)+nForgetPoints),2);
       predictinputSequence=inputSequence(size(inputSequence,1)-(12*years)-(nForgetPoints-1):end,:);
       predicted=test_esn(predictinputSequence, net, nForgetPoints);
       initSequence=inputSequence(size(inputSequence,1)-(nForgetPoints-1):end,:)
     %   t_n=inputSequence(size(inputSequence,1)-nForgetPoints:end,:);
        %t_n=[1 3; 5 0.4];
      %  T=[];
      
      %  for n=1:12*years
     %       y_n=test_esn(t_n, net, nForgetPoints)
     %       t_nn(n,1)=y_n;
          %  t_n=[t_n ;1 y_n(size(y_n,1),:)];
     %     t_n(1,:)=[]
     %     t_n=[t_n;1 y_n]
           %t_n=[t_n(1,2) t_n(2,1);t_n(2,2) y_n]
     %       T(n,:)=y_n;
     %   end
      %  t_nn=t_n(nForgetPoints+2:end,2);
        
     %   plot(T)
        %[inputTestSequence,outputTestSequence]=normNN(test,2);
       % inputSequencetest=inputSequence(size(inputSequence,1)-59:size(inputSequence,1),:);
        %outputSequencePredicted=test_esn(inputSequencetest,net, nForgetPoints);
       %v!!!!!!! ojo !!! delay 2 ??? 
     %   for i=1:3
     %   outputSequencePredicted=[outputSequencePredicted(size(outputSequencePredicted,1),1);outputSequencePredicted]
    %    outputSequencePredicted(size(outputSequencePredicted,1),:)=[]
    %    end
     %%   testlog=logTransformation(test,input);
        % outputSequencePredicted=abs( outputSequencePredicted);
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
%testError = compute_NRMSE(outputSequencePredicted, test); 
%disp(sprintf('test NRMSE = %s', num2str(testError)))
%plot_sequence(test(nForgetPoints+1:end,:), outputSequencePredicted, nPlotPoints, ...
 %   'testing: teacher sequence (red) vs predicted sequence (blue)') ;
% testlog=inverseLogTransformation(testlog,input);
% outputSequencePredicted=inverseLogTransformation(outputSequencePredicted,input);
%figure(4) 
%predicted=mapminmax('reverse',predicted,PS);
%predicted=inverseLogTransformation(predicted,input);
%plot([1:12*years],predicted,'-ro',[1:12*years],test,'-bd')
%        hleg2= legend('predicted','actual');
%         predicted=test_esn(predictinputSequence, net, nForgetPoints);
%         predicted=  mapminmax('reverse',predicted',PS);
%         predicted=predicted';
 numofseries=100;
 count=1;
 MATGEN3=[];
% %t_nn=t_n
 for ser=1:numofseries
%    % predicted=[zeros(nForgetPoints,1);predicted];
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
                    Rvt=tomasandfiering2(-1,input,mi);%componente aleatorio 
%                   %Yvt=sim(net,i(size(i,1)-12+m,1));
%                 %  Yvt=test_esn(t_n, net, nForgetPoints);
%                   % Yvt=sim(net,datainputstart');%OJO .... !!!
%                    %de-scaled valor de la red
%                 %   Yvtn=mapminmax('reverse',Yvt,PS);
%                    
                    Rvtn=detranslogone(inputstand,xlog1,input,Rvt,m);
%                    
%                    predicted(m+12*(y-1),1)=predicted(m+12*(y-1),1);
%                   %  Rvtn=abs(Rvtn/2-predicted(mod(m,12*years+1)));
%               %    Rvtn1=abs(Yvtn+Rvt);
                 %   MATGEN(m,ser,y)=predicted(m+12*(y-1),1);
                    MATGEN2(m,ser,y)=abs(Rvtn);
%                %    t_n(1,:)=[];
                    inputNetworkESN(count,1)=abs(Rvtn);
%                %    y_n=mapminmax('apply',Yvtn,PS);
%                %    t_n=[t_n;1 y_n];
%                    %datainputstart=mapminmax('apply',Yvtn,PS);
%                    %Rvtn2=translogone(input,Rvtn,m);
%                    %Rvtn3=mapminmax('apply',Rvtn2,PS);
%                   % datainputstart=[datainputstart(1,2) Rvtn3];
                  count=count+1;
                end
           
             end
             inputNetworkESN1=mapminmax('apply',inputNetworkESN',PS);
             inputNoiseNetwork=[ones(size(inputNetworkESN1',1),1) inputNetworkESN1'];
          %   nforgetinput=[ones(nForgetPoints,1) zeros(nForgetPoints,1)];
             inputNoiseNetwork=[initSequence;inputNoiseNetwork];
                 
%                 predicted=  mapminmax('apply',predicted',PS);
%                 predicted=[zeros(nForgetPoints,1);predicted'];
                predicted= test_esn(inputNoiseNetwork, net, nForgetPoints);
                predictedde=mapminmax('reverse',predicted,PS);
                MATGEN3=[MATGEN3 predictedde(:,1)];
%                predicted
%            %    MATGEN(:,ser,y)=predicted(:,1);
%              %   predicted=[zeros(nForgetPoints,1);predicted];
%            % predicted=predicted(MATGEN2(:,ser,y));
%             
             count=1;
%          %  t_n=t_nn;
%            % datainputstart=mapminmax('apply',inputm1,PS);
 end
          [rmse,mse]=plotPEN(MATGEN2,test,'tomas and fiering');
          MATGEN4=[];
            for n=1:years
                MATGEN4(:,:,n)=MATGEN3((n-1)*12+1:12*n,:);
            end
            [rmse,mse]=plotPEN(MATGEN4,test,'ESN and aleatorio');
         % figure(10)      
        %    plot(MATGEN3)
        %    hleg2= legend('tomasfiering');
         
%   %      plot(MATGEN(:,:,1))
%         