%   In case the skewness coefficients are biased, 
%   a transformation to reduce the skewness to zero are needed (Salas et al., 1980). 
%   The skewness of the observed data is reduced using log-transformation which can be written as:
%      
%       X_(v,t) = log (Q_(v,t) + c_t.Q2_t)
%       c_t = a /(g^2)_t
%
%    where Q_(v,t) is monthly observed inflow (MCM/month) for month t (t = 1, ..., 12) and year v (v = 1, ..., N);
%    N is number of years of record of the series; 
%    Q2_t is monthly average inflow for month t, 
%    a is a constant; 
%    g_t is the skewness coefficient for the set Q_(1,t), Q_(2,t),..., Q_(N,T); 
%    and X_(v,t) are the normalized inflows, for year v and month t.   

function logdata= translogone(input,num,mess)
count=1;

xi=0;


    for mes=mess:12:size(input,1)
    
        xi(count,1)=input(mes,1);
        count=count+1;
    end
    
    g=skewness(xi);
    ximean=mean(xi);
    a=0.85;
    ct=a/(g^2);
    XLOG=log10(xi+(ct*ximean));%normalizada
    logdata=log10(num+(ct*ximean));
    logdata=(logdata-mean(XLOG))/std(XLOG);
    
    %for j=i:12:size(input,1)
    %    newdata(j,1)=Xstda(count2,1);
    %    logdata(j,1)=XLOG(count2,1);
    %    count2=count2+1;
    %end
    %count2=1;
    %count=1;
    %xi=[];
    


end