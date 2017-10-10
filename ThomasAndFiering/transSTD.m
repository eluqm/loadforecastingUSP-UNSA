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
function [newdata]= transSTD(input)
count=1;
count2=1;
xi=0;

for i=1:12
    for mes=i:12:size(input,1)
    
        xi(count,1)=input(mes,1);
        count=count+1;
    end
    
    g=skewness(xi);
    ximean=mean(xi);
    
    % a is a dimensionless parameter resulting from a refression analysis
    % between gt and ct
    a=5.85;
    ct=a/(g^2);
    
    %Skewness was removed from the original records by the transformation given by
    %XLOG=log(xi+(ct*ximean));
    XLOG=xi;
    %Then the data were standardized on monthly basis through: 
    %Y_(v,t) = X_(v,t) − X2_t / S_t
    % where X2_t , S_t are sample mean and standard deviation of normalized inflows for month t, 
    % and Y_(v,t) is standardized value for month t and year v. 
    % Here, the standardized data Y_(v,t) are utilized for data generation by Thomas-Fiering model
    Xstda=(XLOG-mean(XLOG))/std(XLOG);
    
    for j=i:12:size(input,1)
        newdata(j,1)=Xstda(count2,1);
        %logdata(j,1)=XLOG(count2,1);
        count2=count2+1;
    end
    count2=1;
    count=1;
    xi=[];
    
end

end

