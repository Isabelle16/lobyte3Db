function [depos, trans] = initializeLobyteArrays(glob, topog)

    % Sediment transport recording array
    trans.xCoord  = cell(1, glob.totalIterations);
    trans.yCoord  = cell(1, glob.totalIterations);
    trans.topog  = cell(1, glob.totalIterations);
    trans.velocity  = cell(1, glob.totalIterations);
    trans.runUpHeight  = cell(1, glob.totalIterations);
    trans.seaLevel  = cell(1, glob.totalIterations);
    trans.maxStep  = cell(1, glob.totalIterations);

    % Sediment deposition recording array
    depos.elevation = zeros(glob.ySize,glob.xSize,glob.totalIterations); % elevation for the strata layers
    depos.elevation(:,:,1) = topog;    % set base elevation in strata equal to initial topog elevation

    depos.transThickness =  zeros(glob.ySize,glob.xSize,glob.totalIterations); % thickness of transported material for each strata layer
    depos.transFaciesColour = zeros(glob.totalIterations, 3);
    depos.hpThickness = zeros(glob.ySize,glob.xSize,glob.totalIterations); % thickness of hemipelagic material for each strata layer
    
    depos.firstDeposition=cell(glob.totalIterations,1); %Record point of first deposition for volume analysis
    
    
end
