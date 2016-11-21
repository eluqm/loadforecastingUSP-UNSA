function[Yvt] = simESN(netESN,dataInput)% dataInput the input that represent [x-1 x-2]
nForgetPoints=0
disp('Generating data ............');
disp(dataInput)
Yvt=test_esn(dataInput,netESN, nForgetPoints)

end