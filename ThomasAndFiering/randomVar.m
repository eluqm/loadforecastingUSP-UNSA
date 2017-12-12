function [ Rvt ] = randomVar(input,mes )
%RANDOMVAR Summary of this function goes here
%   Detailed explanation goes here
%
%normalizar m y m-1 
%problema para enero
count=1;
for i=mes:12:size(input,1)
    x(count,1)=input(i,1);
    y(count,1)=input(i-1,1);
    count=count+1;
end 
%################################################################
%% Reducccion del coeficiente de asimetria 
%##################################################################
%% Reducir el coeficiente de asimetria log-transformada
    
    XLOG=sign(x).*log2((abs(x))+1);
    YLOG=sign(y).*log2((abs(y))+1);

%##########################################################
%% STANDARIZACION DE LOS DATOS
%##########################################################
    
    Xstda=(XLOG-mean(XLOG))/std(XLOG);
    Ystda=(YLOG-mean(YLOG))/std(YLOG);
    
%##########################################################
%% Random component Rvt,j media cero y varianza 1
%##########################################################

%% numero aleatorio de una distribucion normal
       evt=normrnd(0,1);
%% desviacion standar en el mes t
       Svt=std(Xstda);
%% coeficiente de correlacion entre el mes t y t-1
       rt12=corr(Xstda,Ystda);
        
             
Rvt=evt*Svt*sqrt(1-(rt12*rt12));

end

