function [velocity, flowType] = calculateVelocity(slope, topog, glob, deepY, deepX, iteration)
% calculate mean flow velocity
bedSlope = abs(slope);

if glob.flowVolumConcentration > glob.concentrationThreshold      
   %% Mean Flow Velocity Hyperconcentrations using Manning equation
   a = (glob.flowHead ./ glob.medianGrainDiameter)^(1/6);
   b = (glob.flowHead .* glob.gravity .* bedSlope).^0.5;
   velocity = 5 .* a .* b;
   flowType = 'hyperconcentrations';
end

if glob.flowVolumConcentration <= glob.concentrationThreshold && topog(deepY,deepX) < glob.SL(iteration)  
   %% Mean Flow Velocity Density Current 
   darcyFrictionFactor = 0.04;
   coeff = 0.5; %% empirical coefficient
   a = 8.*glob.reducedGravity.*glob.flowVolumConcentration;
   b = darcyFrictionFactor.*(1+coeff);
   c = glob.flowHead.* bedSlope;
   velocity = sqrt((a./b).*c); 
   flowType = 'density current';
end

if glob.flowVolumConcentration <= glob.concentrationThreshold && topog(deepY,deepX) >= glob.SL(iteration)  
   %% Calculate beload velocity and suspension velocity for streamflow   
   % steady uniform turbulent flow in a wide rectangular channel
   streamWidth = 52.0;
   streamDepth = 3.7;
   crossSectionArea = streamWidth.*streamDepth;
   wettedPerimeter = streamWidth + streamDepth.*2;
   hydraulicRadius = crossSectionArea ./ wettedPerimeter;
   shearVelocity = sqrt(glob.gravity .* streamDepth .* bedSlope);
   boundaryShearStress = glob.rhoFlow .* shearVelocity.^2;
   frictionSlope = boundaryShearStress ./ (hydraulicRadius .* glob.gammaFlow);
   n = 0.062 .* glob.medianGrainDiameter.^(1/6);
   
   thresholdDiameter = 0.5*10^(-3); % coarser sediments are bedload 
   
   if glob.medianGrainDiameter <= thresholdDiameter 
   % suspension load velocity using Manning equation
   suspensionVelocity = 1/n .* hydraulicRadius.^(2/3) .* frictionSlope.^0.5;  
   velocity = suspensionVelocity;
   else
   % bedload sediment velocity
   bedloadVelocity = 5.75.*shearVelocity; 
   velocity = bedloadVelocity;
   end
   flowType = 'streamflow';  
end
end






