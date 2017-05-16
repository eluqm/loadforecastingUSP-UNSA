function histPlot(input,mes)

count=1;
x=0;
for i=mes:12:size(input,1)
    x(count,1)=input(i,1);
    %y(count,1)=stdinput(i,1);
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
%reducir el coeficiente de asimetria log-transformada
    XLOG=log(x+ct*ximean);%normalizada
    %YLOG=log(y+ct*yimean);
subplot(2,2,1)
    hist(x');
subplot(2,2,2)
hist(XLOG');
end