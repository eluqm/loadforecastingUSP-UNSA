function logdata= translogone(input,num,mess)
count=1;

xi=0;


    for mes=mess:12:size(input,1)
    
        xi(count,1)=input(mes,1);
        count=count+1;
    end
    
    g=skewness(xi);
    ximean=mean(xi);
    a=0.85;
    ct=a/(g^2);
    XLOG=log10(xi+(ct*ximean));%normalizada
    logdata=log10(num+(ct*ximean));
    logdata=(logdata-mean(XLOG))/std(XLOG);
    
    %for j=i:12:size(input,1)
    %    newdata(j,1)=Xstda(count2,1);
    %    logdata(j,1)=XLOG(count2,1);
    %    count2=count2+1;
    %end
    %count2=1;
    %count=1;
    %xi=[];
    


end