function data=detransSTDone(inputstand,input,num,mess)
count=1;

xi=0;
yi=0;
logdata=0;
%for i=1:12
    for mes=mess:12:size(input,1)
        logdata(count,1)=input(mes,1);
        xi(count,1)=inputstand(mes,1);
        yi(count,1)=input(mes,1);
        count=count+1;
    end
    
    g=skewness(yi);
    ximean=mean(yi);
    a=0.85;
    ct=a/(g^2);
    data=(num*std(logdata))+mean(logdata);
    %destdData1=exp(xvt)-(ct*ximean);
    %destdData1=10.^(xvt)-(ct*ximean);
    %XLOG=log10(xi+(ct*ximean));%normalizada
    %Xstda=(XLOG-mean(XLOG))/std(XLOG)
    
    %for j=i:12:size(input,1)
    %    newdata(j,1)=destdData1(count2,1);
    %    count2=count2+1;
    %end
    %count2=1;
    %count=1;
    %xi=[];
    %yi=[];    
    
    
    
    %logdata=[];
    
%end
%data=destdData1;

end

