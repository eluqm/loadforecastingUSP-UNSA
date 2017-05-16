function [MATGEN,input3,inputstand,inputlogg,perfNN,rmse,mse,test]= PEN(years,serienum,inputm1,val,hidden)%linux val=4 = caudal windows= 3
        %inputs=xlsread('C:\Users\edson\Downloads\Datos_Pruebas.xls');
        inputs=xlsread('Datos_Pruebas.xls');
        input=inputs(:,val);
        [input,test]=splitData(input,1);
        MATGEN=0;
        inputstand=0;
        inputm1=translogone(input,inputm1,12);
        
        %se standariza toda la data historica
        [inputstand,xlog1]=translog(input);
        inputlogg=xlog1;
        %datos para la red
        [yi,PS]=mapminmax(inputstand');
        fprintf('data escalada');
        datainputstart=mapminmax('apply',inputm1,PS);
        %normalizacion para la NN
        [i,t]=normNN(yi',1);%se divide la data para NN
       
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
                   %fprintf('mes %d ',mi);
                   Rvt=tomasandfiering(val,input,mi);%componente aleatorio 
                  %Yvt=sim(net,i(size(i,1)-12+m,1));
                   Yvt=sim(net,datainputstart);
                   %de-scaled valor de la red
                   Yvtn=mapminmax('reverse',Yvt,PS);
                   
                   Rvtn=detranslogone(inputstand,xlog1,input,Rvt+Yvtn,m);
                   Rvtn=abs(Rvtn);
                   %Rvtn=detranslogone(inputstand,xlog1,input,Rvt+Yvtn,mi);
                   %fprintf('valor mes %d = %f',mi,Rvtn,Yvt);
                   MATGEN(m,ser,y)=Rvtn;
                   %MATGEN(m,ser,y)=Rvtn;
                   %transformar log
                   Rvtn2=translogone(input,Rvtn,m);
                   datainputstart=mapminmax('apply',Rvtn2,PS);
                   %datainputstart=Rvtn;
                end
            
            
            end
             datainputstart=mapminmax('apply',inputm1,PS);
        end
        %inputm1;
        input3=input;
        
       [rmse,mse]=plotPEN(MATGEN,test);

end
