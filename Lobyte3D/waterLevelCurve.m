function [glob] = waterLevelCurve (glob)
% Initialize water level curve
initialSL = 25.5; % in meters
SLAmp = 0; % Sea level oscillation amplitude in meters
SLPeriod = 0.002; % Sea level oscillation period in My 
glob.SL = zeros(1, glob.totalIterations);
t = 1:glob.totalIterations;
glob.SL(t) = initialSL + ((sin(pi*(((t.*glob.deltaT)/SLPeriod)*2)))*SLAmp); 
end