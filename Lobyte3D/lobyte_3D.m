%% Lobyte3D
close all; 
clear all;
clc;

%% Initialize model variables and parameters
glob.maxIts = 1050; % max number of iterations
glob.totalIterations = 15; % total model iterations
glob.deltaT = 0.01; % timestep in My
glob.dy = 0.1; % grid cell size in km 
glob.dx = 0.1; % grid cell size in km
glob.ySize = 200; 
glob.xSize = 200;

%% Create a ramp type topography
[topog, glob] = createTopography(glob);

%% Initialize water level and sediment supply oscillation curves
[glob] = waterLevelCurve (glob); 
[glob] = initializeSedimentSupplyParams(glob);

%% Initialize Lobyte parameters and arrays
[glob] = readLobyteParameters(glob);
[depos, trans] = initializeLobyteArrays(glob, topog);

%% Main model loop
glob.it = 2;
glob.maxIt = glob.totalIterations;
iteration = 1;

while glob.it <= glob.maxIt

    fprintf('It#%d Event#',glob.it);   
    depos.elevation(:,:,glob.it) = depos.elevation(:,:,glob.it-1); % copy the previous layer into the current one
    glob.flowVolumes = zeros(1, glob.eventNum) + glob.supplyHistory(glob.it);  % m^3
    firstDepositionIteration=zeros(glob.eventNum,2); %record first point of deposition for each flow, x and y coordinate
    deposThickWhole = zeros(glob.ySize, glob.xSize, glob.eventNum); % matrix recording every deposition events
    % use random indices to avoid trend
    kk = 1:glob.eventNum;
    krand = kk(randperm(length(kk))); 

    for i = 1 : glob.eventNum

        fprintf('%d ',i);
        k = krand(i);
        glob.yIn = glob.y(k);
        glob.xIn = glob.x(k);   
        glob.flowDepth = glob.flowVolumes(k);  
        glob.flowHead = glob.flowDepth*0.006;% m  % define the flow head as a percentage of the total sediment volume
        deposThick = zeros(glob.ySize, glob.xSize); % array recording deposited volume
        flowThick = zeros(glob.ySize, glob.xSize); % array that record sediment that keep flowing

        %% Calculate sediment channel-type transport route from the point of erosion    
        [glob, sedLost] = steepestDescentTransport(topog, glob, iteration);

        if sedLost == false

            % Deposit transported sediment       
            glob.yDep = glob.yIn;
            glob.xDep = glob.xIn;
            firstDepositionIteration(i,1)=glob.xDep;
            firstDepositionIteration(i,2)=glob.yDep;

            % Calculate fan-lobe deposition           
            % Flow thick is the thickness of the flow, depos thick the thickness of the deposit from the flow
            [flowThick, deposThick] = fanLobeDeposition(glob, topog); 
        end

        deposThick = deposThick + flowThick; % record the final flow thickness, all sediments deposited
        deposThickWhole(:,:,k) = deposThick; % Record flow in updated matrices that records all flows per time step
        topog = topog + deposThick; % Update topography so that the next flow will interact with the current deposition

        fprintf('vol %2.1f (%2.1f) ', sum(sum(deposThick)), sum(sum(sum(deposThickWhole(:,:,:)))));
    end

    depos.firstDeposition{glob.it}= firstDepositionIteration(i,:);

    % Update variables and matrices with the results from this iteration
    depos.transThickness(:,:,glob.it) = sum(deposThickWhole,3); % total transported sediment thickness for this time step, adds each flow at each xy coord
    
    checkProcess=strcmp(glob.hp,'yes');
    if checkProcess==1
        depos.hpThickness(:,:,glob.it) = depos.hpThickness(:,:,glob.it) + glob.hpThickPerTimestep; % total hemipelagic sediment thickness for this time step,
        depos.elevation(:,:,glob.it) = depos.elevation(:,:,glob.it) +  depos.transThickness(:,:,glob.it) + depos.hpThickness(:,:,glob.it);
    else
        depos.elevation(:,:,glob.it) = depos.elevation(:,:,glob.it) +  depos.transThickness(:,:,glob.it);
    end
    
    depos.faciesColour(glob.it,1:3) = [1.0 rand 0.0];
    topog = depos.elevation(:,:,glob.it);
    
    glob.it = glob.it + 1; 
    fprintf('\n');
end
    
%% Calculate results from the model runs
xCross = 100; % Position of the dip-oriented section on the x-axis
yCross = 50;  % Position of the strike-oriented section on the y-axis
[glob, depos] = calculateStatistics(glob, depos, xCross, yCross);

%% Plot results
plot_3DView(depos, trans, glob, topog);
% plot_3DViewHp(depos, trans, glob, topog);
plot_crossSection(glob, depos, xCross, yCross);
plotVerticalSection(glob, depos, xCross, yCross);
plotVerticalSectionAndChronostrats(glob, depos, xCross, yCross);
plotCentroids(glob, depos);
plotMaps(glob, depos);
plotPvsCompleteness(glob, depos);
plotRunsAnalysisPValueMap(glob,depos);
plotRelationsP(glob,depos,0);

%     outputFileRecord(xCross, yCross, glob.it-1, glob, depos);



