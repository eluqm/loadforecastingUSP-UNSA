%% take care about negative and Constant values
%% the comment below was taken from : https://www.statalist.org/forums/forum/general-stata-discussion/general/625369-log-transformation-of-negative-values
%% 
%% Taking the log of a change doesn't usually make sense,
%% unless the circumstances are such that only positive changes can occur. 
%% What is the science that suggests a log annualized change vs log real value of survey mean model? 
%% Would it make sense to look at the logarithm of the ratio of current population living below poverty 
%% threshold to some baseline value? The ratios will always be positive numbers, 
%% and taking logarithms has the advantage of making a doubling and a halving metrically similar.
function [newdata,logdata]= transSTDsgn(input)
count=1;
count2=1;
xi=0;

for i=1:12
    for mes=i:12:size(input,1)
    
        xi(count,1)=input(mes,1);
        count=count+1;
    end
         
    %% Skewness was removed from the original records by the transformation given by
    %% Log transform to negative values, suggest was taken from : https://www.researchgate.net/post/How_can_I_log_transform_a_series_with_both_positive_and_negative_values2
    XLOG=sign(xi).*log2((abs(xi))+1);
    
    %Then the data were standardized on monthly basis through: 
    %Y_(v,t) = X_(v,t) − X2_t / S_t
    % where X2_t , S_t are sample mean and standard deviation of normalized inflows for month t, 
    % and Y_(v,t) is standardized value for month t and year v. 
    % Here, the standardized data Y_(v,t) are utilized for data generation by Thomas-Fiering model
    Xstda=(XLOG-mean(XLOG))/std(XLOG);
    
    for j=i:12:size(input,1)
        newdata(j,1)=Xstda(count2,1);
        logdata(j,1)=XLOG(count2,1);
        count2=count2+1;
    end
    count2=1;
    count=1;
    xi=[];
    
end

end

