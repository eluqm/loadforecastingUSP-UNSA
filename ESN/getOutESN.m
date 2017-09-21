function out=getOutESN(stateCollectMat_row,esn,PS)
                outputSequence = stateCollectMat_row * esn.outputWeights' ; 
                %%%% scale and shift the outputSequence back to its original size
                nOutputPoints = length(outputSequence(:,1)) ; 
                outputSequence = feval(esn.outputActivationFunction, outputSequence); 
                outputSequence = outputSequence - repmat(esn.teacherShift',[nOutputPoints 1]) ; 
                out = outputSequence / diag(esn.teacherScaling) ; 
             %out=mapminmax('reverse',outputSequence,PS);
end
