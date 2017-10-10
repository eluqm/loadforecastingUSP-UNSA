function [ Rvt ] = tomasandfieringNOLOG( val,input,mes)
%TOMASANDFIERINGNOLOG Summary of this function goes here
%   Detailed explanation goes here
%normalizar m y m-1 
%problema para enero
count=1;

for i=mes:12:size(input,1)
    x(count,1)=input(i,1);
    y(count,1)=input(i-1,1);
    count=count+1;
end 
%################################################################
%###########3Reducccion del coeficiente de asimetria ############
%##################################################################
%calculo del coeficiente de asimetria del mes x para todos los as
    g=skewness(x);
    gy=skewness(y);
%media del tcorrcoef
    ximean=mean(x);
    yimean=mean(y);
%constante 'a'
    a=0.85;
    ct=a/(g^2);
    cty=a/(gy*gy);
%reducir el coeficiente de asimetria log-transformada
    %XLOG=x+ct*ximean;%normalizada
    %YLOG=y+cty*yimean;
    XLOG=x;
    YLOG=y;
%coefasi=skewness(XLOG);

%##########################################################
%####STANDARIZACION DE LOS DATOS###########################
%##########################################################
    
       Xstda=(XLOG-mean(XLOG))/std(XLOG);
       Ystda=(YLOG-mean(YLOG))/std(YLOG);
    
%##########################################################
%####componente aleatorio Rv,j media cero y varianza 1#####
%##########################################################

%% numero aleatorio de una distribucion normal
       evt=normrnd(0,1);
%% desviacion standar en el mes t
        Svt=std(Xstda);
%% coeficiente de correlacion entre el mes t y t-1
        rt12=corr(Xstda,Ystda);
        
             
Rvt=evt*Svt*sqrt(1-(rt12*rt12));

end

