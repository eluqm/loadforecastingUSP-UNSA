function denorX= denormNN(num,X)
%se va tener que modificar 
denorX = ((num+1)*(max(X)-min(X))/2)+ min(X);
end