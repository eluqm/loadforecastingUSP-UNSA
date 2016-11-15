function  [error,ms]=plotPEN2(MATGEN,test,test2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        MATGEN : matriz filas=12, columna=m-series
%        test : data real 
%        test2 : data PERBC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          
          maxmin=0;
        
          for mes=1:12           
            maxmin(mes,1)=max(MATGEN(mes,:,1));%maximo valor por mes
            maxmin(mes,2)=min(MATGEN(mes,:,1));%minimo valor por mes
          end
          
                    
          for serie=1:size(MATGEN,2)
            for m=1:12  
                fxi(m,1)=mean(MATGEN(m,:,1)); %la media por mes de todas las series generadas
            end
          end
           
          %RMSE (root-mean-squared-error) 
           error=sqrt(sum((fxi-test).^2)/12);
           
          %MSE (mean-squared-error) 
           %ms=mse(fxi-test);              % = sum((fxi-test).^2)/12
           ms = sum((fxi-test).^2)/12
          
           x=[1:12]; 
           
           figure(1);
           h1=plot(x,MATGEN(:,1,1),'-k');
           hold on;
          
           for seri=2:size(MATGEN,2)   %plotear todas las series 
                plot(x,MATGEN(:,seri,1),'-k');
                hleg1=legend('escenarios');
                hold on;
           end
          
          h2=plot(x,test,'-bd','LineWidth',2); %plotear 
          legend([h1 h2],{'escenarios','real'})
          
          
        figure(2)
        
        
        
        plot(x,fxi,'-ro',x,test,'-bd',x,test2,'-gd')
        hleg2= legend('PEN','REAL','PERBC');
        
        

end