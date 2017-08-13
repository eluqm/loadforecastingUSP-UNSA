
%%        MATGEN : rows=12(month), colum=m-series, deep = years
%%        test : data actual

function  [RMSE,MSE,ErrorMAD,ErrorNRMSE,ErrorMPE,NSE]=plotPEN(MATGEN,test,name,display_plots)

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
         
 if display_plots == 1
          %% size of time series prediction 12*years
          x=[1:12*size(MATGEN,3)]; 
          
          %% for Data interpolation using pchip method
          xq1 = 1:.1:size(test,1);
          
          %% plotting all syntetics series
          figure('Name',name,'Units', 'pixels', ...
                 'Position', [100 100 500 375]);
          hold on;
          h1=[];
          %plotting first serie in order to permit print syntetic series legend 
        %  for n=1:size(MATGEN,3)
         %   plotData2=[plotData2;MATGEN(:,1,n)];
         % end
         % inter=pchip(x,plotData2,xq1);
         % h1=plot(x,plotData2','.b',xq1,inter,':k');
          
          plotData2=[];
          i=0;
           for seri=1:size(MATGEN,2)   
              for n=1:size(MATGEN,3) 
                plotData2=[plotData2;MATGEN(:,seri,n)];
              end
                inter=pchip(x,plotData2,xq1);
                h1{i+1}=plot(x,plotData2','.',xq1,inter);
                set(h1{i+1}       , ...
                'Color'           , [0.5 0.5 0.5]     , ...        
                'LineWidth'       , 0.8);
                 plotData2=[];
                i=i+1;
           end
           %legendInfo{1}=['Escenarios']
         
           
           %% adding
           if size(test,1)>0   
            p = pchip(x,test,xq1);
            
            %% h2=plot(x,test,xq1,p,'-bd','LineWidth',1); %plotear 
            h1{i}=plot(x,test,'db',xq1,p,'-b','LineWidth',2,'markers',4); 
            
            %% set legend for sintetics and real time series
            h_cero(1)=  plot(0,0,'.-','visible','off','Color',[0.5 0.5 0.5],'LineWidth',1.2);
            h_cero(2) = plot(0,0,'-db','visible', 'off','LineWidth',2,'markers',4);
            hLegend =legend(h_cero,'Escenarios','Observación','Location','NorthEast');
            
            %% Customise plot labels, titles fonts, etc
            hTitle  = title ({'series temporales hidrólogicas'});
            hXLabel = xlabel('Meses'              );
            hYLabel = ylabel('Caudal'     );
            set( gca                       , ...
                 'FontName'   , 'Helvetica' );
            set([hTitle, hXLabel, hYLabel], ...
                 'FontName'   , 'Latin Modern Roman');
            set([hLegend, gca]             , ...
                 'FontSize'   , 8           );
            set([hXLabel, hYLabel]  , ...
                'FontSize'   , 10          , ...
                'FontWeight' , 'bold'      );
            set( hTitle                    , ...
                'FontSize'   , 12          , ...
                'FontWeight' , 'bold'      );
            set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'LineWidth'   , 1         );
            hold off;
            
            %% Plot sintetic mean vs  real time series
            q1 = pchip(x,fxi,xq1);
            q2 = pchip(x,test,xq1);
            figure('Name',strcat(name,'respect medias'));
            plot(x,fxi,'or',xq1,q1,'-r');
            hold on;
            plot(x,test,'bd',xq1,q2,'-b');
            hleg2= legend('mean of syntetics series','actual serie');
            %strValues = strtrim(cellstr(num2str(fxi(:),'(%0.3f)')));
            %text(1:size(fxi),fxi(:),strValues,'VerticalAlignment','bottom');
            %plot(x,test,'o',xq1,p,'-');
           end
end   
        %% compute NRMSE training error
        ErrorNRMSE = compute_NRMSE(fxi, test); 
        %disp(sprintf(' NRMSE = %s de %s', num2str(ErrorNRMSE),name))
        
        %% MPE error
        summ= 0 ;
        for i=1:size(fxi,1)
            summ= (abs(fxi(i,1)-test(i,1))/test(i,1)*100)+summ; 
        end
        %summ = sum((fxi - test))/test;
        ErrorMPE = summ/size(fxi,1);
        %disp(sprintf(' MPE = %s de %s', num2str(ErrorMPE),name))
        
        %% MAD error
        summ1= 0 ;
        for i=1:size(fxi,1)
            summ1= summ1 + abs(fxi(i,1)-test(i,1)); 
        end
        ErrorMAD = summ1*(1/size(fxi,1));
        %disp(sprintf(' MAD = %s de %s', num2str(ErrorMAD),name))
        
        %% RMSE and MSE error
        if size(test,1)>0        
                RMSE=sqrt(sum((fxi-test).^2)/size(fxi,1));
                MSE=sum((fxi-test).^2)/size(fxi,1);
                if MSE == Inf || MSE == -Inf
                    error('error.')
                end
        end 
        %disp(sprintf(' RMSE = %s de %s', num2str(RMSE),name))
        %disp(sprintf(' MSE = %s de %s', num2str(MSE),name))
        
        %% CE coef...
        
        NSE=compute_CE(fxi,test);
        %disp(sprintf(' NSE = %s de %s', num2str(NSE),name))
end
