function [topog, depos] = runSubsidence (glob, topog, depos)

subsRate = 0.8; 
topog(glob.faultYCo:end,:) = topog(glob.faultYCo:end,:) - subsRate;

% update deposited layers with subsidence
depos.elevation(glob.faultYCo:end,:,:) = depos.elevation(glob.faultYCo:end,:,:)- subsRate;

end

