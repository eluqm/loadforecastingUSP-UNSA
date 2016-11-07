function[net,perf] = penNN(x,t,hidden)

net = feedforwardnet(hidden);
net = train(net,x',t');
%view(net);
y = net(x');
perf = perform(net,y,t');

end
