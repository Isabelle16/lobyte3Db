function [glob] = readLobyteParameters(glob)

fileIn = fopen('LobyteInputFile');

glob.initialFlowType=fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn);

glob.gravity=fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);

%% Ambient fluid properties
glob.rhoAmbient=fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);

glob.gammaAmbient = glob.rhoAmbient * glob.gravity; % Specific weight of ambient fluid (water) in N/m3
  
%% Grain properties
glob.medianGrainDiameter=fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
glob.medianGrainDiameter = glob.medianGrainDiameter*10^-3;

glob.rhoSolid=fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);

glob.gammaSolid = glob.rhoSolid * glob.gravity; % specific weight of the grains in N/m3

%% Flow properties (flow volume concentration is the key distinguishing factor for the three flow types)
glob.flowVolumConcentration=fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);

glob.concentrationThreshold=fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);


glob.rhoFlow = glob.rhoSolid * glob.flowVolumConcentration + glob.rhoAmbient * (1-glob.flowVolumConcentration);  % flow mass density (kg/m^3) (specific mass)
glob.reducedGravity = glob.gravity.*(glob.rhoFlow./glob.rhoAmbient - 1); % gravity reduced by the buoyancy force when the flow is underwater 
if glob.reducedGravity > glob.gravity
    glob.reducedGravity = glob.gravity;
end
    
a = glob.gammaSolid .* glob.flowVolumConcentration;
b = glob.gammaAmbient .* (1 - glob.flowVolumConcentration);
glob.gammaFlow = a + b;    % specific weight of a mixture in N/m3

%% Velocity threshold
glob.deposVelocity=fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);

%% Parameters and thresholds controlling sediment deposition
glob.minFlowThick=fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
glob.minFlowThick = glob.minFlowThick * 10^-3;

glob.fracDepos=fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);

glob.depositSlopeFactor=fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);

glob.flowRadiationFactor=fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);

%% Pelagic sediment parameters
glob.hp = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn);

glob.hpThickPerTimestep=fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);

%% Sediment source/s params
glob.eventNum=fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);  

glob.y=fscanf(fileIn,'%f', glob.eventNum);
dummyLabel = fgetl(fileIn);  

glob.x=fscanf(fileIn,'%f', glob.eventNum);
dummyLabel = fgetl(fileIn);  

glob.dir = 3; % Average max dip of the topography (1 = E; 2 = SE; 3 = S and so on, clockwise)

end