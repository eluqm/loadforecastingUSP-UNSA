function [MATGEN,input3,inputstand,inputlogg,perfNN,rmse,mse,test]= PEN2(years,serienum,inputm1,val,hidden)%linux val=4 = caudal windows= 3 
        %inputm1 => datos de los 2 meses anteriores [xn-2 xn-1] => [yn-1 yn]
        %inputs=xlsread('C:\Users\edson\Downloads\Datos_Pruebas.xls');
        if val==11 || val==12
            inputs=xlsread('E:\PEN\evaporacionpreaguada.xls');
            val=val-10;
        else
        inputs=xlsread('Datos_Pruebas.xls');
        end
        input=inputs(:,val);
        [input,test]=splitData(input,1);
        MATGEN=0;
        inputstand=0;
        inputm1(1,2)=translogone(input,inputm1(1,2),12);
        inputm1(1,1)=translogone(input,inputm1(1,1),11);
        %inputm1()
        %se standariza toda la data historica
        [inputstand,xlog1]=translog(input);
        %datos para la red
        inputlogg=xlog1;
        [yi,PS]=mapminmax(inputstand');
        datainputstart=mapminmax('apply',inputm1,PS);
        %normalizacion para la NN
        [i,t]=normNN(yi',2);%se divide la data para NN
       
        %se entrena la red con N capas
        [net,perfNN]=penNN(i,t,hidden);
        
        %generacion de datos estocasticos por mes 
       
       
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