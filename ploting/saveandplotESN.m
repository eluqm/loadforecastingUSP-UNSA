tseries=plotPerformance(configuration,0.9,80,10);
tsnames=gettimeseriesnames(tseries);
count=1;
index=[];
name='ESN03054500TygartMonthD';
for n=0.1:0.1:0.9
   [val,ind] =min(tseries.(tsnames(count)).Data);
   
plot(tseries.(tsnames(count)),':','LineWidth' , 0.2)
hold on
index(count,:)=[val,ind];
count=count+1;
end
[value,i]=min(index(:,1));

%tseries.(tsnames(i)).Time(index(i,2))
min_event=tsdata.event('peak',tseries.(tsnames(i)).Time(index(i,2)));
tseries.(tsnames(i)) = addevent(tseries.(tsnames(i)),min_event);
hold on
plot(tseries.(tsnames(i)),'.-b','LineWidth' , 1);
%grid on
% for legends are considered that tscollection put by default x as sufix name of
% time serie
for m=1:size(tsnames,2) 
   %if m ~=i 
       tsnames(1,m)=regexprep(tsnames(1,m),'x','0.');
  % end
end
legend(tsnames,sprintf('%0.1f',i/10))
%v=get(legend,'title')
%set(v,'string','Spectral radius')
title(' Spectral radius')
xlabel('Reservoir Size')
ylabel('RMSE')
%ls=get(legend,'String')
%lgd=legend(tsnames);
%lgd.String(i)={sprintf('%0.1f',0.6)}
%legend(i)
hold off

for  ii=1:spectral_radious*10
    ind(ii,1)=bestFinal(ii).error;
end
[val,in]=min(ind);

save_esn(bestFinal(in).networkESN,name)

