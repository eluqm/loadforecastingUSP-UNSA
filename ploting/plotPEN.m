
%%        MATGEN : rows=12(month), colum=m-series, deep = years
%%        test : data actual

function  [RMSE,MSE]=plotPEN(MATGEN,test,name)

  warning('off');       
         
        % what is the maximun value of first year
        %  for mes=1:12      
        %    maxtotal=[]
        %        for year=1:size(MATGEN,3)
        %        maxmin(mes,1)=max(max(MATGEN(mes,:,year)),maxmin);%maximo valor por mes
        %        maxmin(mes,2)=maxmin(mes,2)+min(MATGEN(mes,:,year));%minimo valor por mes
        %        end
       %     
       %   end
          
          %% calculating mean of all syntetic series      
          for serie=1:size(MATGEN,2)
            for m=0:12*size(MATGEN,3)-1  
                fxi(m+1,1)=mean(MATGEN(mod(m,12)+1,:,ceil((m+1)/12))); 
            end
          end
         
           
          %% size of time series prediction 12*years
          x=[1:12*size(MATGEN,3)]; 
          
          %% for Data interpolation using pchip method
          xq1 = 1:.1:size(test,1);
          
          %% plotting all syntetics series
          
          plotData2=[];
          figure('Name',name);
          %plotting first serie in order to permit print syntetic series legend 
        %  for n=1:size(MATGEN,3)
         %   plotData2=[plotData2;MATGEN(:,1,n)];
         % end
         % inter=pchip(x,plotData2,xq1);
         % h1=plot(x,plotData2','.b',xq1,inter,':k');
          hold on;
          plotData2=[];
           for seri=1:size(MATGEN,2)   
              for n=1:size(MATGEN,3) 
                plotData2=[plotData2;MATGEN(:,seri,n)];
              end
                inter=pchip(x,plotData2,xq1);
                h1=plot(x,plotData2','.b',xq1,inter,':k');
                %h1(seri,1)=h_1;
                hold on;
                plotData2=[];
           end
         % hleg1=legend('syntetics series');
           
           %% adding
           if size(test,1)>0    
            %xq1 = 1:size(test,1);
            
            p = pchip(x,test,xq1);
           %% h2=plot(x,test,xq1,p,'-bd','LineWidth',1); %plotear 
            h2=plot(x,test,'db',xq1,p,'-b','LineWidth',1,'markers',5); 
            legend([h1;h2],'escenarios','real') 
            hold off;
            
            q1 = pchip(x,fxi,xq1);
            q2 = pchip(x,test,xq1);
            figure('Name',strcat(name,' respect medias'))
            %% q=pchip(x,fxi,xq1);
            plot(x,fxi,'or',xq1,q1,'-r');
            hold on;
            plot(x,test,'bd',xq1,q2,'-b');
            hleg2= legend('mean of syntetics series','actual serie');
            %strValues = strtrim(cellstr(num2str(fxi(:),'(%0.3f)')));
            %text(1:size(fxi),fxi(:),strValues,'VerticalAlignment','bottom');
            %plot(x,test,'o',xq1,p,'-');
         end
         %%%%compute NRMSE training error
        Error = compute_NRMSE(fxi, test); 
        disp(sprintf(' NRMSE = %s de %s', num2str(Error),name))
        %MPE error
        summ= 0 ;
        for i=1:size(fxi,1)
            summ= summ + abs(fxi(i,1)-test(i,1))/test(i,1); 
        end
        %summ = sum((fxi - test))/test;
        ErrorMPE = summ*(100/size(fxi,1));
        disp(sprintf(' MPE = %s de %s', num2str(ErrorMPE),name))
        
        %MAD error
        summ1= 0 ;
        for i=1:size(fxi,1)
            summ1= summ1 + abs(fxi(i,1)-test(i,1)); 
        end
        %summ = sum((fxi - test))/test;
        ErrorMAD = summ1*(1/size(fxi,1));
        disp(sprintf(' MAD = %s de %s', num2str(ErrorMAD),name))
        
        if size(test,1)>0        
                RMSE=sqrt(sum((fxi-test).^2)/size(fxi,1));
                MSE=sum((fxi-test).^2)/size(fxi,1);
        end 
        disp(sprintf(' RMSE = %s de %s', num2str(RMSE),name))
        disp(sprintf(' MSE = %s de %s', num2str(MSE),name))
end
