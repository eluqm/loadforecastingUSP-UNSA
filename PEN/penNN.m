function[net,perf] = penNN(x,t,hidden)

net = feedforwardnet(hidden);
net.trainParam.showWindow = false;
net = train(net,x',t');
%view(net);

y = net(x');
perf = perform(net,y,t');

end
