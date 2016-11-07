function[input,output]= betainput2()

inputs=xlsread('C:\Users\edson\Downloads\Datos_pruebas.xls');
input=inputs(:,3);
%normalizando 
input=(2*(input-min(input)))/(max(input)-min(input))  -1 ;
colm2=input;
colm2(size(input,1)+1,1) = 0;
colm2(1,:)=[];
input(:,2)=colm2;


sim(:,1)=input(size(input,1)-11:size(input,1),1);
sim(:,2)=input(size(input,1)-11:size(input,1),2);

%input=input(size(input,1)-12,1);
input=input(1:size(input,1)-12,:);



%#################################################################
output = colm2;
output=(2*(output-min(output)))/(max(output)-min(output))  -1 ;
output(size(output,1)+1,1)=0;
output(1,:)=[];

real=output;

output=output(1:size(output,1)-12,1);
real=real(size(real,1)-11:size(real,1),1);

end
