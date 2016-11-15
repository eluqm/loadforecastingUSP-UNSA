function [MATGEN,input3,inputstand,inputlogg,perfNN,rmse,mse,test]= PEN2(years,serienum,inputm1,val,hidden)%linux val=4 = caudal windows= 3 
        %inputm1 => the model ANN2 generates the inflow ( or evap , prec)
        %of the present month utilizing inflows of two previous months, in
        %this case for example to 1 year of prediction the model input are [(X-2)nov,(X-1)dic]=> [Yene] 
        %values
        % 
        %inputs=xlsread('C:\Users\edson\Downloads\Datos_Pruebas.xls');
        if val==11 || val==12
            inputs=xlsread('E:\PEN\evaporacionpreaguada.xls');
            val=val-10;
        else
        %inputs=xlsread('Datos_Pruebas.xls');
        inputs=load('07378500monthly.dly.txt')
        end
        input=inputs(:,val);
        [input,test]=splitData(input,1);
        MATGEN=0;
        inputstand=0;
        
        % A transformation is required if a time series is not normally distributed
        % It aims to remove the seasonality from the mean and the variance,
        % if skewness coefficients are biased. Therefore, a transformation to reduce this skewness closer to zero was needed.
        % The skewness of the observed data is reduced using log-transformation
        inputm1(1,2)=translogone(input,inputm1(1,2),12);
        inputm1(1,1)=translogone(input,inputm1(1,1),11);
        %inputm1()
        
        %log-transformation and standarization of data 
        [inputstand,xlog1]=translog(input);
        
        % A step before training the neural networkk, 
        % it is often useful to scale the inputs and targets so that they always fall within a specified range. 
        % in this project, the data were scaled in the range of [-1, +1] using the equation:
        inputlogg=xlog1;
        [yi,PS]=mapminmax(inputstand');
        datainputstart=mapminmax('apply',inputm1,PS);
       
        %neural network based architectures are prepared; 
        % the model (ANN2) generates the inflow of the present month utilizing inflows of two previous months.
        [i,t]=normNN(yi',2);
       
        %train neural network
        [net,perfNN]=penNN(i,t,hidden);
        
        %generacion de datos estocasticos por mes 
       % synthetic values produced by the model based on serienum
       
        for ser=1:serienum
            for y=1:years                          
                for m=1:12
                   %Rvt= tomasandfiering(val,m)
                   mi=m;
                   if m==1 
                        mi=13;
                   end
                   if m==2
                       mi=14;
                   end
                   Rvt=tomasandfiering2(val,input,mi);%componente aleatorio 
                  %Yvt=sim(net,i(size(i,1)-12+m,1));
                   Yvt=sim(net,datainputstart');%OJO .... !!!
                   %de-scaled valor de la red
                   Yvtn=mapminmax('reverse',Yvt,PS);
                   
                   Rvtn=detranslogone(inputstand,xlog1,input,Rvt+Yvtn,m);
                    Rvtn=abs(Rvtn);
                   MATGEN(m,ser,y)=Rvtn;
                   %datainputstart=mapminmax('apply',Yvtn,PS);
                   Rvtn2=translogone(input,Rvtn,m);
                   Rvtn3=mapminmax('apply',Rvtn2,PS);
                   datainputstart=[datainputstart(1,2) Rvtn3];
                end
            
            
            end
            datainputstart=mapminmax('apply',inputm1,PS);
        end
        input3=input;
       [rmse,mse]=plotPEN(MATGEN,test);
        
end