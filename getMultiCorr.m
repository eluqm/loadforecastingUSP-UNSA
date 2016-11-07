function multicorr = getMultiCorr(X,Y)
    X=[ones(size(X,1),1) X];
    b=inv(X'*X)*X'*Y;
    Ss=(b'*X'*Y)-((ones(size(Y))'*Y).^2)/size(X,1);
    Sstotal=(Y'*Y)-((ones(size(Y))'*Y)^2/size(X,1));
    
    Sserror=(Y'*Y)-b'*X'*Y;
    
    multicorr=Ss/Sstotal;

end