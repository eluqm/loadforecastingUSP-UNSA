function internalWeights = generate_internal_weights_orth(nInternalUnits, ...
                                                  connectivity)
                                              
success = 0 ;                                               
while success == 0
    % following block might fail, thus we repeat until we obtain a valid
    % internalWeights matrix
    try,
        internalWeights = sprand(nInternalUnits, nInternalUnits, connectivity);
        internalWeights = full(internalWeights);
        if rank(internalWeights) >= size(internalWeights,1)
        internalWeights = orth(internalWeights);
        success=1;
        else
            success=0;
        end
        %internalWeights = double(rand(nInternalUnits, nInternalUnits) < connectivity);
       % internalWeights(internalWeights ~= 0) = ...
       %     internalWeights(internalWeights ~= 0)  - 0.5;
        opts.disp = 0;
        %maxVal = max(abs(eigs(internalWeights,1, 'lm', opts)));
        
        
        %success = 1 ;
    catch,
        success = 0 ; 
    end
end
end