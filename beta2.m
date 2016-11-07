

function[output]= beta2(x,t,hidden,s,real)
%west end girl
%net = newff([0 1;0 1],[4 1],{'logsig','logsig'})
%input=[1 1 0 0; 1 0 1 0]
%target = [0 1 1 0]
%net.trainParam.show=NaN;
%net = train(net,input,target);
%[x,t] = simplefit_dataset;
net = feedforwardnet(hidden);
net = train(net,x',t');
view(net);
y = net(x');
perf = perform(net,y,t')
output=sim(net,s');
plot(output');hold all;plot(real);hold off;figure(gcf);
hleg1 = legend('red neuronal','valor real');
%output= sim(net,input)
end
