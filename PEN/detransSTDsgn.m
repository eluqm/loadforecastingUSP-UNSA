function newdata = detransSTDsgn( inputstand,inputlog)
%DETRANSSTDSGN Summary of this function goes here
%   Detailed explanation goes here
count=1;
count2=1;
xi=0;
logdata=0;
for i=1:12
    for mes=i:12:size(inputlog,1)
        logdata(count,1)=inputlog(mes,1);
        xi(count,1)=inputstand(mes,1);
        %yi(count,1)=input(mes,1);
        count=count+1;
    end
    %XLOG=sign(xi).*log2((abs(xi))+1);
    %g=skewness(yi);
    %ximean=mean(yi);
    a=0.85;
    %ct=a/(g^2);
    xvt=(xi*std(logdata))+mean(logdata);
    destdData1=((2.^(abs(xvt)))-1)/sign(xvt);
    %XLOG=log10(xi+(ct*ximean));%normalizada
    %Xstda=(XLOG-mean(XLOG))/std(XLOG)
    
    for j=i:12:size(inputlog,1)
        newdata(j,1)=destdData1(count2,1);
        count2=count2+1;
    end
    count2=1;
    count=1;
    xi=[];
    yi=[];    
    
    
    
    logdata=[];
    
end



end

