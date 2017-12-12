function [rawData]=inverseLogTransformation(inputLogData,inputHistorical)

count=1;
count2=1;
count3=1;
xi=0;
yi=0;
%logdata=0;
for i=1:12
    for mes=i:12:size(inputHistorical,1)
       % logdata(count,1)=inputlog(mes,1);
        
        yi(count,1)=inputHistorical(mes,1);
        count=count+1;
    end
    for mes=i:12:size(inputLogData,1)
        xi(count3,1)=inputLogData(mes,1);
        count3=count3+1;
    end
    
    g=skewness(yi);
    ximean=mean(yi);
    a=0.85;
    ct=a/(g^2);
    %xvt=(xi*std(logdata))+mean(logdata);
    destdData1=10.^(xi)-(ct*ximean);
    %XLOG=log10(xi+(ct*ximean));%normalizada
    %Xstda=(XLOG-mean(XLOG))/std(XLOG)
    
    for j=i:12:size(inputLogData,1)
        rawData(j,1)=abs(destdData1(count2,1));
        count2=count2+1;
    end
    count2=1;
    count=1;
    count3=1;
    xi=[];
    yi=[];    
    
    
    
    %logdata=[];
    
end
end