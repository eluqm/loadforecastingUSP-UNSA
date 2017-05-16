function [X,T]= normNN(input,model)%escalando entre [-1 1]
if model==1
    X=input;
    T=input;
    T(size(T,1)+1,1)=0;
    T(1,:)=[];
else
    X(:,1)=input;
    Xn(:,1)=input;
    Xn(size(Xn,1)+1,1)=0;
    Xn(1,:)=[];
    X(:,2)=Xn;
    
    T=X(:,2);
    
    T(size(T,1)+1,1)=0;
    T(1,:)=[];
end

end
