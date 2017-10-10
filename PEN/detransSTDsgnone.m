function [ data ] = detransSTDsgnone(inputlog,num,mess)
%DETRANSSTDSGNONE Summary of this function goes here
%   Detailed explanation goes here

count=1;
logdata=0;

    for mes=mess:12:size(inputlog,1)
        logdata(count,1)=inputlog(mes,1);
        count=count+1;
    end
    
    xvt=(num*std(logdata))+mean(logdata);
    destdData1=((2.^(abs(xvt)))-1)/sign(xvt);
    
data=destdData1;

end

