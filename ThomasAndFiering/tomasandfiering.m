function [Rvt]= tomasandfiering(val,input,mes)%para enero se xonsidera mes = 13 no se tiene el primer mes 
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
    XLOG=log(x+ct*ximean);%normalizada
    YLOG=log(y+cty*yimean);
%coefasi=skewness(XLOG);

%##########################################################
%####STANDARIZACION DE LOS DATOS###########################
%##########################################################
    
       Xstda=(XLOG-mean(XLOG))/std(XLOG);
       Ystda=(YLOG-mean(YLOG))/std(YLOG);
    
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
        rt12=corr(Xstda,Ystda);
        %fprintf('coe1 %f\n ',rt12);   
             
Rvt=evt*Svt*sqrt(1-(rt12*rt12));
x;
y;

%#########################################################
%############RED NEURONAL DE DATOS SE NECESITA EL DATOS###
%##############DEL MES PASADO ############################
%#########################################################

%fprintf('componente aleatorio =%f\n',Rvt);





%calculo de parametros de regresion lineal

p=polyfit(x,y,1);
r2=corrcoef(x,y);
pendiente=p(1);
coefreg=r2(2,1);
%inter=p(2);%intercepto

%idc=polyval(p,x);
%plot(x,y,'*',x,idc);


end
