function [glob] = initializeSedimentSupplyParams(glob)

glob.sedimentSupplyMax = 35.0;
glob.sedimentSupplyMin = 5.0;
glob.sedimentSupplyStart = glob.sedimentSupplyMin + ((glob.sedimentSupplyMax - glob.sedimentSupplyMin) / 2.0);
glob.sedimentSupplyPeriod = 200; % supply oscillation period in number of model iterations
glob.supplyOscillationAmplitude = (glob.sedimentSupplyMax - glob.sedimentSupplyMin) / 2.0;
% Initialize sediment supply sinusoid
% General equation: y = A sin(Bx + C) + D
% A = amplitude; 2pi/B = period; C = phase shift; D vertical shift or min supply

t = 1 : glob.maxIts;
sinLongerPeriod(t) = (glob.supplyOscillationAmplitude * sin((t / glob.sedimentSupplyPeriod).*2.*pi));
%     sinShorterPeriod(t) = (glob.supplyOscillationAmplitude * 0.5 * sin((t / (glob.sedimentSupplyPeriod/0.65)).*2.*pi));
glob.supplyHistory(t) =  glob.sedimentSupplyStart + sinLongerPeriod(t);% + sinShorterPeriod(t);
%     glob.supplyHistory(t) = 20.0; % Constant supply obviously, but sum 6000 over 300 iterations, so same as 5-35 range 20 it period sinusoid

%     glob.supplyHistory(200) = 1000;

% %on/off supply
% for i=11:20:glob.maxIts
%     if i+11<=glob.maxIts
%     glob.supplyHistory(i:i+9)=0;
%     end
% end
 glob.supplyHistory(:)=20; % constant supply
    
end
