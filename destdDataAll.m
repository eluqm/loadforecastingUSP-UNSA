function [destdinputall]= destdDataAll(stdinput,brutedata)


x=0;
count = 1;
for mes=1:12
    for i=mes:12:size(stdinput,1)
        x(count,1)=stdinput(i,1);   
        y(count,1)=brutedata(i,1);
        count=count+1;
    end
    %################################################################
    %###########Reducccion del coeficiente de asimetria ############
    %##################################################################
    %calculo del coeficiente de asimetria del mes x para todos los as
    g=skewness(y);
    %gy=skewness(y);
    %media del tcorrcoef
    ximean=mean(y);
    %yimean=mean(y);
    %constante 'a'
    a=0.85;
    ct=a/(g^2);
    %reducir el coeficiente de asimetria log-transformada
    
    xvt=(x*std(x) )+mean(x);
    destdData1=10.^(xvt)-(ct*ximean);
    
    count2=1;
   for sizex=mes:12:size(stdinput,1) 
        
            destdinputall(sizex,1)=destdData1(count2,1);
             count2=count2+1;
            
   end
   
   count2=1;
   count=1;
   destdData1=[];
   x=[];
end

       
    

end