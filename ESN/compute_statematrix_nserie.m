function [netOut,stateCollection,totalstate] =compute_statematrix_nserie( stateCollection,totalstate,inputSequence,outSequence, esn, nForgetPoints,i) 


% compute_statematrix_nserie  runs the (input+Rtvn_noise) through the ESN and writes the
% obtained input+reservoir states into stateCollectMat.
% The first nForgetPoints will be deleted, as the first few states could be
% not reliable due to initial transients  
%
% inputs:
% inputSequence = input time series of size nTrainingPoints x nInputDimension
% outputSequence = output time series of size nTrainingPoints x nOutputDimension
% esn = an ESN structure, through which we run our input sequence
% nForgetPoints: an integer, may be negative, positive or zero.
%    If positive: the first nForgetPoints will be disregarded (washing out
%    initial reservoir transient)
%    If negative: the network will be initially driven from zero state with
%    the first input repeated |nForgetPoints| times; size(inputSequence,1)
%    many states will be sorted into state matrix
%    If zero: no washout accounted for, all states except the zero starting
%    state will be sorted into state matrix
% Rtvn_noise= Thomas and Fiering random component 
% 
% Note: one of inputSequence and outputSequence may be the empty list [],
% but not both. If the inputSequence is empty, we are dealing with a purely
% generative task; states are then computed by teacher-forcing
% outputSequence. If outputSequence is empty, we are using this function to
% test a trained ESN; network output is then computed from network dynamics
% via output weights. If both are non-empty, states are computed by
% teacher-forcing outputSequence.
%
% optional input argument:
% there may be one optional input, the starting vector by which the esn is
% started. The starting vector must be given as a column vector of
% dimension esn.nInternalUnits + esn.nInputUnits + esn.nOutputUnits   (that
% is, it is a total state, not an internal reservoir state). If this input
% is desired, call test_esn with fourth input 'startingState' and fifth
% input the starting vector.
%
% output:
% stateCollectMat = matrix of size (nTrainingPoints-nForgetPoints) x
% nInputUnits + nInternalUnits 
% stateCollectMat(i,j) = internal activation of unit j after the 
% (i + nForgetPoints)th training point has been presented to the network

%
% Version 1.0, April 30, 2006
% Copyright: Fraunhofer IAIS 2006 / Patents pending
% Revision 1, June 6, 2006, H. Jaeger
% Revision 2, June 23, 2007, H. Jaeger (added optional starting state
% input)
% Revision 3, July 1, 2007, H. Jaeger (added leaky1_esn update option)
% Revision 4, Apr 24, 2010, H. Jaeger: reworded header text to avoid an
%                        ambiguity




    teacherForcing = 0;
    %nDataPoints = length(inputSequence(:,1));




%% set 



%%%% if nForgetPoints is negative, ramp up ESN by feeding first input
%%%% |nForgetPoints| many times

internalState = zeros(esn.nInternalUnits, 1);

collectIndex = i-nForgetPoints-1;
%for i = 1:nDataPoints
    
    % scale and shift the value of the inputSequence
    if esn.nInputUnits > 0
        in = esn.inputScaling .* inputSequence' + esn.inputShift;  % in is column vector
    else in = [];
    end
    
    % write input into totalstate
    if esn.nInputUnits > 0
        totalstate(esn.nInternalUnits+1:esn.nInternalUnits + esn.nInputUnits) = in;
    end    
    
    % the internal state is computed based on the type of the network
    switch esn.type
        case 'plain_esn'
            typeSpecificArg = [];
        case 'leaky_esn'
            typeSpecificArg = [];
        case 'leaky1_esn'
            typeSpecificArg = [];
%         case 'twi_esn'
%             if  esn.nInputUnits == 0
%                 error('twi_esn cannot be used without input to ESN');
%             end
%             if i == 1
%                 typeSpecificArg = esn.avDist;
%             else
%                 typeSpecificArg = norm(inputSequence(i,:) - inputSequence(i-1,:));
%             end
    end
    internalState = feval(esn.type, totalstate, esn, typeSpecificArg) ; 
    
    if teacherForcing
        netOut = esn.teacherScaling .* outputSequence(i,:)' + esn.teacherShift;
    else        
        netOut = feval(esn.outputActivationFunction, esn.outputWeights * [internalState; in]);
    end
    
    
    totalstate = [internalState; in; netOut];
    
    %collect state
    if nForgetPoints >= 0 &&  i > nForgetPoints
        collectIndex = collectIndex + 1;
        stateCollection(collectIndex,:) = [internalState' in']; 
    elseif nForgetPoints < 0
        collectIndex = collectIndex + 1;
        stateCollection(collectIndex,:) = [internalState' in']; 
    end
    

