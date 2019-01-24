function [flowThick, deposThick] = fanLobeDeposition(glob, topog) 
    
    flowThick = zeros(glob.ySize+2,glob.xSize+2); % flowThick records the sediment thickness flow at every step 
    deposThick = zeros(glob.ySize+2,glob.xSize+2);  % depos is the matrix that records the sediment deposited at every step
    deposDone = false; % Set the end of flow flag so that the flow can start
    
    % update current cell coordinate acconding to the new, increased grid size
    glob.yDep = glob.yDep+1;
    glob.xDep = glob.xDep+1;
    
    % create a new topography (to deal with model boundaries). 
    dummyTopog = zeros(glob.ySize+2, glob.xSize+2);
    dummyTopog(2:glob.ySize+1,2:glob.xSize+1) = topog;
    dummyTopog(2:glob.ySize+1,1) = topog(:,1);
    dummyTopog(1,2:glob.xSize+1) = topog(1,:);
    dummyTopog(2:glob.ySize+1,glob.xSize+2) = topog(:,glob.xSize);
    dummyTopog(glob.ySize+2,2:glob.xSize+1) = topog(glob.ySize,:);
    dummyTopog(1,1) = dummyTopog(1,2);
    dummyTopog(1,end) = dummyTopog(2,end);
    dummyTopog(end,end) = dummyTopog(end-1,end);
    dummyTopog(end,1) = dummyTopog(end,2);
    
    
    flowThick(glob.yDep,glob.xDep) = glob.flowDepth; % the sediment has been transported in the cell from which start deposition

    glob.emt = 1;
   
    while deposDone == false 
       [newFlowThick, newDeposThick] = fanLobeDepositionStep(flowThick, deposThick, glob, dummyTopog);
       
       newSize = size(flowThick,1);
       if isempty(find(newFlowThick(2:newSize-1,2:newSize-1) > glob.minFlowThick, 1))
          deposDone = true;
       end
       
       flowThick = newFlowThick;
       deposThick = newDeposThick;
        
       % Increase the deposited fraction at each flow step       
       glob.fracDepos = glob.fracDepos + glob.depositSlopeFactor; 

       glob.emt = glob.emt + 1;
    end

    %Resize arrays according to the model size  
    
    flowThick(:,1) = [];
    flowThick(:,end) = [];
    flowThick(1,:) = [];
    flowThick(end,:) = [];
    
    deposThick(:,1) = [];
    deposThick(:,end) = [];
    deposThick(1,:) = [];
    deposThick(end,:) = []; 
    
end

function [flowThick, deposThick] = fanLobeDepositionStep (flowThick, deposThick, glob,  topog)
% When erosion and trasport occured and the gradient along the transport
% path drops below a defined threshold the function_fanLobeDeposition
% calculates, for every step, the thickness of sediment to be deposited and
% the amount of sediment that keep flowing (flow front) proportionally to
% the gradient.
%
% (in this header 'STEP' is intended as a certain iteration in the loop
% that deposit the sediments conversely, 'EVENT', embraces a complete 
% erosion/transport and deposition happening)
% Input/Output:   - flowThick: 2D matrix with the flow front thickness at the
%                              current step (input). The function calculates the next
%                              position of the flow front and its thickness.
%
%                 - deposThick: matrix recording the sediment thickness
%                               deposited ad every step.

[row,col] = find(flowThick > glob.minFlowThick); % [row,col] are two column vectors containing the 
                               % coordinates y and x, respectively, 
                               % of cells where sediment is flown. 
                               
flowThickCost = flowThick; % flowThickCost does not change in the following for loop
                           % (required by the memory effect).
flowThickCost = flowThickCost <= 0; % flowThickCost = 1  where the flow can go 
                                    % flowThickCost = 0  already occupied cells
flowThickCost(deposThick > 0) = 0;  % the flow cannot go back into previous occupied cells                                  
   %% Main function loop:
    % for every cell(y,x) in which sediment is flown (one cell at a time) the
    % for loop calculates the thickness of sediment to be deposited in the cell(y,x)
    % itself (and stores it in deposThick matrix), and moves the rest to the
    % neighbouring lower cells proportionally to the gradient.
    % Every cell is treated independently and the resulted partial-flow-front
    % is then stored in the flowThick array

    for k = 1:size(row,1) 
            y = row(k);
            x = col(k);
            
            glob.depStep = size(row,1);
            % Set boundary conditions %% SEDIMENT FLOWING OUTSIDE THE MODEL
            % BOUNDARIES IS LOST
            if y < size(flowThick,1) && y > 1  &&...   
               x < size(flowThick,2) && x > 1 % && flowThick(y,x) > glob.minFlowThick
                       
           %% Find the cells with lower elevation and exclude the ones yet occupied (Memory Effect)
            %  Memory Effect: the flow from the current cell(y,x) must not go in neighbouring
            %  cells already occupied.
                memory = flowThickCost(y-1:y+1, x-1:x+1); % memory is a sub-matrix 3x3 containing the current 
                                            % cell(y,x) flow thickness and its neighbours
            % build a row vector flowNbr containing the flow thickness of cell(y,x)
            % neighbours starting from E cell clockwise. Subsequently, flowNbr becames a
            % binary vector where 0 = cells where sediment is flown (sediment thick > 0)
            % and 1 = cells not already occupied where the flow can go:
                flowNbr = [memory(2,3) memory(3,3) memory(3,2)...
                memory(3,1) memory(2,1) memory(1,1) memory(1,2) memory(1,3)]';   
            % now find lower cells and exclude the ones yet occupied (memory effect).  
            % gradNbr is a vector containing the gradient between cell(y,x)
            % and its neighbours starting from E. 
            % binGradNbr is a binary vector where 0 = higher cells (positive grad)
            % 1 = lower cells (negative grad)
                 glob.fun = 'grad';
                [~, ~, nbrGrads] = neighbourMaxGrad(glob, topog, y, x);
                 binGradNbr = nbrGrads<0;             
            % now gradNbr become a vector containing just the lower cells
            % gradient turned to positive:
                nbrGrads = abs(nbrGrads.*binGradNbr); 
            % now set equal to zero the gradients of the cells already
            % occupied, in which the current flow can't go.
                nbrGrads = nbrGrads.*flowNbr;
                nbrGrads = round(nbrGrads,3);
                
                               
%%              % if all the nbr cells are higher than the current cell...
                if isempty(find(nbrGrads, 1)) % current cell belongs to a basin or flat topography
                                             
                    [deposThick, flowThick] = depoStepKinetics(flowThick, deposThick, flowNbr, glob, topog, y, x);

%%             % else...current cell has at least one lower nbr cell                

                elseif ~isempty(find(nbrGrads, 1)) 
              
                    [deposThick, flowThick] = depoStepGradient(flowThick, deposThick, nbrGrads, glob, y, x);

                end

            end 
     end

  end   


    




