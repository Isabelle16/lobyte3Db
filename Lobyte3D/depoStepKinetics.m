function [deposThick, flowThick] = depoStepKinetics(flowThick, deposThick, flowNbr, glob, topog, y, x)
% y, x  = coordinates of the current cell
if glob.emt == 1
   deposPercent = glob.fracDepos/3;
elseif glob.emt == 2
   deposPercent = glob.fracDepos/2;
else
   deposPercent = glob.fracDepos;
end

glob.fun = 'kinetic';

% add flow thickness in the current cell topography
kTopog= topog(y,x); % current cell topg before flow
glob.flowHead = flowThick(y,x)*0.006; % m  % define the flow head as a percentage of the total sediment volume
topog(y,x) = topog(y,x) + glob.flowHead + glob.lastRunUpHeight; % flowThick(y,x); 

topogNbr = [topog(y,x+1); topog(y+1,x+1); topog(y+1,x); topog(y+1,x-1);...
            topog(y,x-1); topog(y-1,x-1); topog(y-1,x); topog(y-1,x+1)]; 
            
[maxGrad, cellIndex, nbrGrads] = neighbourMaxGrad(glob, topog, y, x);
nbrGrads = nbrGrads.*flowNbr;

if isempty(find(nbrGrads > 0.00, 1))==false && isempty(find(nbrGrads < 0.00, 1))==true  %% at least one neighboring cell is higher or equal than the current = local basin, fill the basin accordingly to the highest cell and redistribute the rest

    
    deposVol = max(topogNbr) - kTopog;
    
    if deposVol >= flowThick(y,x) %% fill the local basin
        
        deposThick(y,x) = deposThick(y,x)+flowThick(y,x);
        flowThick(y,x) = 0; % Update flowThick

    else % fill the local basin and redistribute sediment excess
        deposThick(y,x) = deposThick(y,x) + deposVol;
        flowThick(y,x) = flowThick(y,x) - deposVol; % Update flowThick
        
        topog(y,x) = kTopog + flowThick(y,x); 
        
        [maxGrad, cellIndex, nbrGrads] = neighbourMaxGrad(glob, topog, y, x);
        binGradNbr = nbrGrads<0;             
        nbrGrads = abs(nbrGrads.*binGradNbr); 
        nbrGrads = nbrGrads.*flowNbr;
        
       if isempty(find(nbrGrads ~= 0, 1))==true % flat

          deposThick(y,x) = deposThick(y,x)+flowThick(y,x);
          flowThick(y,x) = 0; % Update flowThick
       else

        [flowThick] = subKinFlow(flowThick,  nbrGrads, glob, y, x);
       end
       
        
    end
        

elseif isempty(find(nbrGrads < 0.00, 1))==false % at least one cell is lower: deposit % in the current cell and redistribute the rest accordingly to grad depos function
    
    deposVol = deposPercent*flowThick(y,x);
    deposThick(y,x) = deposThick(y,x) + deposVol;
    flowThick(y,x) = flowThick(y,x) - deposVol; % amount of sediment that keep flowing
    
    binGradNbr = nbrGrads<0;             
    nbrGrads = abs(nbrGrads.*binGradNbr); 
%     nbrGrads = nbrGrads.*flowNbr;
    
    [flowThick] = subKinFlow(flowThick,  nbrGrads, glob, y, x);
    
elseif isempty(find(nbrGrads ~= 0.00, 1))==true % flat

      deposThick(y,x) = deposThick(y,x)+flowThick(y,x);
      flowThick(y,x) = 0; % Update flowThick
    
end



end


