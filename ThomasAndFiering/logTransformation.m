% the skennes of the observer data is  reduced using log-transformation 
% where :
%size of inputData has to be inputData(12*n,1)
function [logData]=logTransformation(inputData,inputHistorical)

count=1;
count2=1;
count3=1;
xi=0;
inputActualMonth=0;

for i=1:12
    for mes=i:12:size(inputHistorical,1)
    
        xi(count,1)=inputHistorical(mes,1);
        count=count+1;
    end
    for mes=i:12:size(inputData,1)
        inputActualMonth(count3,1)=inputData(mes,1);
        count3=count3+1;
    end
    
    g=skewness(xi);
    ximean=mean(xi);
    a=0.85;
    ct=a/(g^2);
    XLOG=log10(inputActualMonth+(ct*ximean));%normalizada
    
    for j=i:12:size(inputData,1)
      %  newdata(j,1)=Xstda(count2,1);
        logData(j,1)=XLOG(count2,1);
        count2=count2+1;
    end
    count2=1;
    count=1;
    count3=1;
    xi=[];
    inputActualMonth=[];
    
end
end