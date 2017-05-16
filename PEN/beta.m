function[input,output,sim,real]= beta()

inputs=xlsread('C:\Users\edson\Downloads\Datos_pruebas.xls');
input=inputs(:,3);
%normalizando 
input=(2*(input-min(input)))/(max(input)-min(input))  -1 ;

sim=input(size(input,1)-11:size(input,1),1);
input=input(1:size(input,1)-12,1);
output = inputs(:,3);
output=(2*(output-min(output)))/(max(output)-min(output))  -1 ;
output(size(output,1)+1,1)=0;
output(1,:)=[];

real=output;

output=output(1:size(output,1)-12,1);
real=real(size(real,1)-11:size(real,1),1);

%real=outputs(size(outputs,1)-12:size(outputs,1),1);

%NETff = newff(inputs,output,[3])
%NETff = init(NETff);
%NETff = train(NETff,inputs,output);

end
