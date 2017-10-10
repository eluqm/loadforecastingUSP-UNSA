
%% this function plot time series from plain files 
%% input = [row matrix], this is the time serie from historical record 
%% namefile = name of plain files provided by run_test_final script

function MATGEN4=plotFromFile(namefile,input)

%% load from file to matrix
basic_MATGEN=load(namefile);
siz=size(basic_MATGEN,2)

years=str2num(namefile(end:end));
sizeSeries=siz/years;

[input,test]=splitData(input,years);
MATGEN4=[];
for n=1:years
    MATGEN4(:,:,n)=basic_MATGEN(:,(n-1)*sizeSeries+1:sizeSeries*n);            
end
 
%% using plot PEN function
plotPEN(MATGEN4,test,'fromfile',1);

end
