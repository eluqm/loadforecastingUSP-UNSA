function [y] = simBasicESN(startinput,x_collectmatrix,Win,Wout,W,leaky_rate,outSize,years)
x=x_collectmatrix;
a=leaky_rate;
u=startinput;
testLen=12*years;
%Y = zeros(outSize,testLen);
%u = data(trainLen+1);
%Warning!!!
for t = 1:testLen 
	x = (1-a)*x + a*tanh( Win*[1;u] + W*x );
	y = Wout*[1;u;x];
	%Y(:,t) = y;
	% generative mode:
	u = y;
	% this would be a predictive mode:
	%u = data(trainLen+t+1);
end
end