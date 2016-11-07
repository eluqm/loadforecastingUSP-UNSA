function Netff(input,output,hidden,func)

%hidden [2 3]
%func funcion de activacion
weights=0;
hidden(1,size(hidden,2)+1)=size(output,2);
sum=size(input,2);
total=0;
for w=1:size(hidden,2)
    total=total + sum*hidden(1,w);
    sum=hidden(1,w);
end

weights = rand(1,total);
hidden(:,size(hidden,2))=[];
y={};


for in=1:size(input,1)
    y{1}=input(in,:);
    
    
    %size(y,2)
    fprintf('entradaasd tamanio');
    %size(y(1,:))
    weigthsval=0;
    for layer=1:size(hidden,2)%por cada capa
        
        for neuron=1:hidden(1,layer)
            suma=0;
            %size(y(layer),2)
            for iy=1:size(y(layer),2)% y para cada neurona 
                         suma=suma+weights(1,(neuron-1)*size(y,2)+iy+weigthsval)*y{layer}(1,iy);
            end
            y{layer+1}(1,neuron)=suma;
            
        end
        %size(y(layer),2)
        
        %hidden(1,layer)
        weigthsval=weigthsval+size(y(layer),2)*hidden(1,layer);
        
    end
    %y=zeros(1,1);
    %fprintf(1,'sal... ');
    
end

y{3}

%for in=1:size(input,1)
 %   for
        
  %  end
%end
y
end
