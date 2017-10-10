
%THOMAS_AND_FIERING_METHODNOLOG Summary of this function goes here
%   Detailed explanation goes here


function [ Y_n_1] = Thomas_and_FIering_methodNOLOG( R_component ,input,mes,in)
%THOMAS_AND_FIERING_METHOD Summary of this function goes here
%   Detailed explanation goes here
count=1;
x=[];
y=[];

    for i=mes:12:size(input,1)
        x(count,1)=input(i,1);
        y(count,1)=input(i-1,1);
        count=count+1;
    end 
    
%% calculo del coeficiente de asimetria del mes x para todos los as
    g=skewness(x);
    gy=skewness(y);
%% media del tcorrcoef
    ximean=mean(x);
    yimean=mean(y);
%% constante 'a'
    a=0.85;
    ct=a/(g^2);
    cty=a/(gy*gy);
%% reducir el coeficiente de asimetria log-transformada
    XLOG=x+ct*ximean;%normalizada
    YLOG=y+cty*yimean;
%% Standardized data
       Xstda=(XLOG-mean(XLOG))/std(XLOG);
       Ystda=(YLOG-mean(YLOG))/std(YLOG);

%% desviacion standar en el mes t
        SvtX=std(Xstda);
        SvtY=std(Ystda);
%% coeficiente de correlacion entre el mes t y t-1
      
        rt12=corr(Xstda,Ystda);
B_n=rt12*(SvtX/SvtY);       
Y_n_1= mean(Xstda) + B_n*(in+mean(Ystda))+R_component;
end

