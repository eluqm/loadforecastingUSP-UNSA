function destdData= destdData(inputbrute,stdinput,num,mes)


count=1;
x=0;
for i=mes:12:size(inputbrute,1)
    x(count,1)=inputbrute(i,1);
    y(count,1)=stdinput(i,1);
    %y(count,1)=input(i-1,1);
    count=count+1;
end 
%################################################################
%###########3Reducccion del coeficiente de asimetria ############
%##################################################################
%calculo del coeficiente de asimetria del mes x para todos los as
    g=skewness(x);
    %gy=skewness(y);
%media del tcorrcoef
    ximean=mean(x);
    %yimean=mean(y);
%constante 'a'
    a=0.85;
    ct=a/(g^2);
    
    xvt=(num*std(y) )+mean(y);
    destdData=10^(xvt)-(ct*ximean);


end