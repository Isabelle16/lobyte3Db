function [deposThick, flowThick] = depoStepGradient(flowThick, deposThick, nbrGrads, glob, y, x)
 
%% Deposit a defined amount of sediment

if glob.emt == 1
   deposPercent = glob.fracDepos./3;
elseif glob.emt == 2
   deposPercent = glob.fracDepos./2;
else
   deposPercent = glob.fracDepos;
end


deposVol = (flowThick(y,x)).*deposPercent; 
deposThick(y,x) = (deposThick(y,x))+deposVol;

% amount of sediment that keep flowing
flowThick(y,x) = flowThick(y,x)-deposVol;  

[flowThick] = subGradFlow(flowThick, nbrGrads, glob, y, x);

end


                        
                        
                        
                        
                        
                        
                        