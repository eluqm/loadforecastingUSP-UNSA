clear all;

%run in using parallel for nForget for RNN_echo state network
inputs=load('source/03054500TygartMonthly.dly.txt');
net_ESN=load_esn('ESN03054500TygartMonthD');
Result=[];
parfor npoint=1:50
[a,b,c]=final_test_parallel(inputs,net_ESN,3,2,50,npoint)
Result(npoint,:)=[a,b,c];
end