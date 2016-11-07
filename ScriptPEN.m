function ScriptPEN(penn,series,input,val,numnodos) %numnodos = [3 5 7 9]

mat=0;

%if penn==1
%    for i=1:size(numnodos,2)
%    [a,b,c,d,perf,mse]=PEN(1,series,input,val,numnodos(1,i));
%    mat(i,1)=perf;
%    mat(i,2)=mse;
%    end
%else
    for i=1:size(numnodos,2)
        if penn==1
            [a,b,c,d,perf,mse]=PEN(1,series,input,val,numnodos(1,i));
        else
            [a,b,c,d,perf,mse]=PEN2(1,series,input,val,numnodos(1,i));
        end
    
    mat(i,1)=perf;
    mat(i,2)=mse;
    end
   
%end

mat(:,1)
mat(:,2)

end