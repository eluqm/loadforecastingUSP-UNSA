%function that plot training performance of ESN with spectral from 0.1 to
%0.9 , configuration: represents the training data from runTest.m script 
% bias = 10 
function [tseries]=plotPerformance(configuration,spectral,reservoirSize,bias)

tseries=tscollection(10:80);
x=bias:reservoirSize;
y=0;
count=1
%temp2=struct([]);
temp2(1,1)=struct('index',1,'serie',timeseries(y,bias:reservoirSize,'name','oshekhe?'));
for m=0.1:0.1:spectral
    for n=bias:reservoirSize
        y(n-bias+1,1)=configuration(count).error;
        
        count=count+1;
        
    end
    %ts1=addts(ts1,timeseries(y',bias:reservoirSize),'name',m);
   % temp2=timeseries(y,bias:reservoirSize,'name',sprintf('%0.1f',m));
  %  temp2.Name=sprintf('%0.1f',m);
  %  temp2.Data;
  %  temp2.time
    temp2(count-1,1)=struct('index',count-1,'serie',timeseries(y,bias:reservoirSize,'name',sprintf('%0.f',m*10)));
  % m*10 , because name creates conflics with index in time serie
  % collection 'tseries'
  tseries=addts(tseries,timeseries(y,bias:reservoirSize,'name',sprintf('%0.f',m*10)));
        plot(x,y);
        hold on
        y=[];
  % colormap winter
end

hold off
legend('Profits','Expenses')

%temp=timeseries
tseries;

%max(temp.Data)
end