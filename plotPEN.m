%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        MATGEN : rows=12(month), colum=m-series, deep = years
%        test : data actual
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [error,ms]=plotPEN(MATGEN,test,name)

          
          maxmin=0;
        % what is the maximun value of first year
        %  for mes=1:12      
        %    maxtotal=[]
        %        for year=1:size(MATGEN,3)
        %        maxmin(mes,1)=max(max(MATGEN(mes,:,year)),maxmin);%maximo valor por mes
        %        maxmin(mes,2)=maxmin(mes,2)+min(MATGEN(mes,:,year));%minimo valor por mes
        %        end
       %     
       %   end
          
                
          for serie=1:size(MATGEN,2)
            for m=0:12*size(MATGEN,3)-1  
                fxi(m+1,1)=mean(MATGEN(mod(m,12)+1,:,ceil((m+1)/12))); %la media por mes de todas las series generadas
            end
          end
            if size(test,1)>0        
          %RMSE (root-mean-squared-error) 
           error=sqrt(sum((fxi-test).^2)/12);
           ms=sum((fxi-test).^2)/12;
             end 
          %MSE (mean-squared-error) 
         %  ms=mse(fxi-test);              % = sum((fxi-test).^2)/12
           
          
           x=[1:12*size(MATGEN,3)]; 
           plotData=[];
           for n=1:size(MATGEN,3)
            plotData=[plotData;MATGEN(:,1,n)];
           end
           figure('Name',name);
           h1=plot(x,plotData,'-k');
           hold on;
          plotData2=[];
           for seri=2:size(MATGEN,2)   %plotear todas las series 
              for n=1:size(MATGEN,3) 
                plotData2=[plotData2;MATGEN(:,seri,n)];
              end
                plot(x,plotData2,':k');
                hleg1=legend('syntetics series');
                hold on;
                plotData2=[];
           end
         if size(test,1)>0     
            h2=plot(x,test,'-bd','LineWidth',2); %plotear 
            legend([h1 h2],{'escenarios','real'}) 
            
            figure('Name',strcat(name,' respect medias'))      
            plot(x,fxi,'-ro',x,test,'-bd')
            hleg2= legend('mean of syntetics series','actual serie');
        
         end
         %%%%compute NRMSE training error
        Error = compute_NRMSE(fxi, test); 
        disp(sprintf(' NRMSE = %s de %s', num2str(Error),name))

end
