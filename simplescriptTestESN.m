clear all; 

inputs=load('source/03054500monthly.dly.txt');
%inputs=xlsread('source/Datos_Pruebas.xls');
input=inputs(:,1);
data=inputs(:,1);
%splitData(input,year_prediction)
%reservoirSIZE
ressize=21;
years=2;
numofseries=100;
%startinput is a initial data to run generative esn neural network

[input,test]=splitData(input,years);
startinput=input(size(input,1)-1);
%Matrix with all sintetic time series MATGEN(months,numseries,years)
MATGEN=0;

        % A transformation is required if a time series is not normally distributed
        % It aims to remove the seasonality from the mean and the variance,
        % if skewness coefficients are biased. Therefore, a transformation to reduce this skewness closer to zero was needed.
        % The skewness of the observed data is reduced using log-transformation
        % log-transformation and standarization of data training
        [inputstandar,inputlog]=translog(input);
        
        % A step before training the neural networkk, 
        % it is often useful to scale the inputs and targets so that they always fall within a specified range. 
        % in this project, the data were scaled in the range of [-1, +1] 
        [Xin,PS]=mapminmax(inputlog');
        
        
        %neural network based architectures are prepared;
        %%%% generate an esn
        [outputSequencePredicted, a, b, x, Win, Wout, W, aa, outSize]=ESN(ressize,years,Xin');
  
     
       
        
        
        

%%%%compute NRMSE training error
%trainError = compute_NRMSE(predictedTrainOutput, trainOutputSequence); 
%disp(sprintf('train NRMSE = %s', num2str(trainError)))

%%%%compute NRMSE testing error
%%testError = compute_NRMSE(outputSequencePredicted', test); 
%%disp(fprintf('test NRMSE = %s', num2str(testError)))
%plot_sequence(test(nForgetPoints+1:end,:), outputSequencePredicted, nPlotPoints, ...
 %   'testing: teacher sequence (red) vs predicted sequence (blue)') ;
% testlog=inverseLogTransformation(testlog,input);
% outputSequencePredicted=inverseLogTransformation(outputSequencePredicted,input);
%%figure(4) 
%%plot([1:12*years],outputSequencePredicted','-ro',[1:12*years],test,'-bd')
%%hleg2= legend('predicted by ESN','real');
        



%%for ser=1:numofseries
        %%    for y=1:years                          
        %%        for m=1:12
                   %Rvt= tomasandfiering(val,m)
        %%           mi=m;
       %%            if m==1 
       %%                 mi=13;
        %%           end
        %%           if m==2
        %%               mi=14;
        %%           end
        %%           Rvt=tomasandfiering2(-1,input,mi);%ramdom component 
                  %Y=sim(net,i(size(i,1)-12+m,1));
                  % Yvt=sim(net,datainputstart');%OJO .... !!!
                   %de-scaled valor de la red
                   %Yvtn=mapminmax('reverse',Yvt,PS);
        %%           [Y]=simBasicESN(startinput,x,Win,Wout,W,aa,outSize,years);
       %%            Rvtn=detranslogone(inputstand,xlog1,input,Rvt,m);
                    %Rvtn=Rvtn+outputSequencePredicted(mod(m,12*years+1));
       %%             Rvtn=abs(Rvtn+Y);
       %%            MATGEN(m,ser,y)=Rvtn;
                 %  MATGEN2(m,ser,y)=Rvt;
                   %datainputstart=mapminmax('apply',Yvtn,PS);
                   %Rvtn2=translogone(input,Rvtn,m);
                   %Rvtn3=mapminmax('apply',Rvtn2,PS);
                  % datainputstart=[datainputstart(1,2) Rvtn3];
        %%          startinput=Rvtn;
                 
         %%       end
            
            
      %%      end
           % datainputstart=mapminmax('apply',inputm1,PS);
%%end
      %%   [rmse,mse]=plotPEN(MATGEN,test);

  %  plot(MATGEN2(:,:,1))    