function addLineTS( ts_real,ts_sintec,gdc)
%ADDLINETS Summary of this function goes here
%   Detailed explanation goes here
   [diff_array,n]=max(abs(ts_real-ts_sintec));
    %for n=1:size(ts_real)
        line([n n],[ts_real(n) ts_sintec(n)],gdc,'Color','r','LineStyle','--');
    %end

end

