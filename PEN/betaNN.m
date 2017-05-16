function net=betaNN(input,datainputstart)%se toman entradas del mes t del año v-1
[yi,PS]=mapminmax(input');
[i,t]=normNN(yi');
datainputstart=mapminmax('apply',datainputstart,PS);
[ii,test]=splitData(i,1);
[tt,test2]=splitData(t,1);
%net=penNN(ii,tt,[10]);
%
net = feedforwardnet(9);
net = train(net,ii',tt');
view(net);
y = net(ii');
perf = perform(net,y,tt')
for mes=1:12
    
    output(mes,1)=sim(net,ii(size(ii,1)-12+mes,1));
    %sim(net,)
    %datainputstart=output(mes,1);
end

plot(test);
hold all;
plot(output);
hleg1 = legend('real','prediccionxxxxxx');
xlabel('mes');
ylabel('caudal');


end