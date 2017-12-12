function out=getOutESN2(stateCollectMat_row,esn,PS,Rvt,var_factor)
                outputSequence = stateCollectMat_row * esn.outputWeights' ; 
                %%%% scale and shift the outputSequence back to its original size
                nOutputPoints = length(outputSequence(:,1)) ; 
                outputSequence = feval(esn.outputActivationFunction, outputSequence); 
		%%Where Rvt is [-1,1] and seasonalized
		%%Rvt will be teachershift modify 
        outputSequence=mapminmax('reverse',outputSequence,PS);
        %% outputSequence=detranslogone(inputstand,xlog1,input,outputSequence,m)
        %Rvt=mapminmax('apply',Rvt,PS);
        %%outrev=mapminmax('reverse',,PS);
		%Rvt_shift = [(diag(esn.teacherScaling) * Rvt')' + ...
        %	repmat(esn.teacherShift',[nOutputPoints 1])];
		 %%sum Rvt + out
        Rvt_shift=Rvt;
        outputSequence=outputSequence+(Rvt_shift*var_factor);
        outputSequence=abs(outputSequence);
        outputSequence=mapminmax('apply',outputSequence,PS);
		outputSequence = outputSequence - repmat(esn.teacherShift',[nOutputPoints 1]) ; 
                out = outputSequence / diag(esn.teacherScaling) ; 
             %out=mapminmax('reverse',outputSequence,PS);
end
