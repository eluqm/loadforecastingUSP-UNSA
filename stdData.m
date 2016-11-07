function[stdinput,xlog1]= stdData(input)
x=0;
count = 1;
for mes=1:12
    for i=mes:12:size(input,1)
        x(count,1)=input(i,1);    
        count=count+1;
    end
    %################################################################
    %###########Reducccion del coeficiente de asimetria ############
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
    XLOG=log10(x+(ct*ximean));%normalizada
    %xlog=XLOG;
    
%##########################################################
%####STANDARIZACION DE LOS DATOS###########################
%##########################################################
    
    Xstda=(XLOG-mean(XLOG))/std(XLOG);
    meanxstda=mean(Xstda);
    stdxstda=std(Xstda);
     count2=1;
   for sizex=mes:12:size(input,1) 
   
           stdinput(sizex,1)=Xstda(count2,1);
           xlog1(sizex,1)=XLOG(count2,1);
           count2=count2+1;
            
   end
   count2=1;
   count=1;
   Xstda=[];
  
    x=[];
end

       
end
