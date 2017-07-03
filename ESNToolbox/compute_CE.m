function [NSE]=compute_CE(estimatedOutput, correctOutput)
%% The Nash–Sutcliffe performance measure (Nash and Sutcliffe, 1970),
%% called, hereafter, the Nash–Sutcliffe efficiency (NSE), is computed as
%% follows:
sum=0;
sum2=0;
mean_obs=mean(correctOutput);
for i=1:size(estimatedOutput,1) 
    sum=sum+(correctOutput(i,1)-estimatedOutput(i,1)).^2;
    sum2=sum2+(correctOutput(i,1)-mean_obs).^2;
end

NSE=1-(sum/sum2);

end