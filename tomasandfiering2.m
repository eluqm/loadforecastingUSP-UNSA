function Rvt=tomasandfiering2(val,input,mes)

count=1;

for i=mes:12:size(input,1)
    x(count,1)=input(i,1);
    y(count,1)=input(i-1,1);
    z(count,1)=input(i-2,1);
    count=count+1;
end 
%################################################################
%###########3Reducccion del coeficiente de asimetria ############
%##################################################################
%calculo del coeficiente de asimetria del mes x para todos los as
    g=skewness(x);
    gy=skewness(y);
    gz=skewness(z);
%media del tcorrcoef
    ximean=mean(x);
    yimean=mean(y);
    zimean=mean(z);
%constante 'a'
    a=0.85;
    ct=a/(g^2);
    cty=a/(gy*gy);
    ctz=a/(gz^2);
%reducir el coeficiente de asimetria log-transformada
    XLOG=log10(x+ct*ximean);%normalizada
    YLOG=log10(y+cty*yimean);
    ZLOG=log10(z+ctz*zimean);
%coefasi=skewness(XLOG);

%##########################################################
%####STANDARIZACION DE LOS DATOS###########################
%##########################################################
    
       Xstda=(XLOG-mean(XLOG))/std(XLOG);
       Ystda=(YLOG-mean(YLOG))/std(YLOG);
       Zstda=(ZLOG-mean(ZLOG))/std(ZLOG);
%##########################################################
%####componente aleatorio Rv,j media cero y varianza 1#####
%##########################################################

%numero aleatorio de una distribucion normal
       evt=normrnd(0,1);
%desviacion standar en el mes t
        Svt=std(Xstda);
%coeficiente de correlacion entre el mes t y t-1
        %rt1=corr(x,y);
        %fprintf('coe1 %f\n ',rt1);
        rt12=getMultiCorr([Xstda Zstda],Ystda);
        %fprintf('coe1 %f\n ',rt12);   
             
Rvt=evt*Svt*sqrt(1-(rt12*rt12));

end