function [ Y_n_1 ] = Thomas_and_Fiering_ASST( R_component ,input,mes,in )
%THOMAS_AND_FIERING_ASST Summary of this function goes here
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
    
%% reducir el coeficiente de asimetria log-transformada
    XLOG=sign(x).*log2((abs(x))+1);
    YLOG=sign(y).*log2((abs(y))+1);
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

