function [runUpHeight] = calculateRunUpHeight(topog, velocity, glob, deepY, deepX, iteration)

% Note: when flow is underwater the REDUCED GRAVITY must be used g' = g.*(rhoCurrent./rhoAmbient - 1)
% g' is the reduced gravity by the buoyancy force

if topog(deepY, deepX) < glob.SL(iteration) 
   gravity = glob.reducedGravity;
else
   gravity = glob.gravity;
end

runUpHeight = 0.5.*(velocity.^2./gravity);

end
