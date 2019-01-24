function [glob, sedLost] = steepestDescentTransport(topog, glob, iteration) 
% Calculate sediment channel-type transport route from the point of 
% erosion using steepest gradient descent method.

% create a new extended topography (to deal with model boundaries). 
dummyTopog = zeros(glob.ySize+2, glob.xSize+2);
dummyTopog(2:glob.ySize+1,2:glob.xSize+1) = topog;
dummyTopog(2:glob.ySize+1,1) = topog(:,1);
dummyTopog(1,2:glob.xSize+1) = topog(1,:);
dummyTopog(2:glob.ySize+1,glob.xSize+2) = topog(:,glob.xSize);
dummyTopog(glob.ySize+2,2:glob.xSize+1) = topog(glob.ySize,:);
dummyTopog(1,1) = dummyTopog(1,2);
dummyTopog(1,end) = dummyTopog(2,end);
dummyTopog(end,end) = dummyTopog(end-1,end);
dummyTopog(end,1) = dummyTopog(end,2);

% set initial conditions      
runUpHeight = 0; % initial value of the run up eight when the flow velocity is equal to  0
flowDone = false;
sedLost = false;
sedTrap = false;
glob.fun = 'descent';

% keep coordinates constant in the extended topography (update coord in agreement with the new topography)
glob.yIn = glob.yIn+1;
glob.xIn = glob.xIn+1;
deepX = glob.xIn;
deepY = glob.yIn;
it = 1;

% initialize arrays
transRoute = zeros(glob.ySize+2, glob.xSize+2);
transLength = 1;
transRoute(glob.yIn, glob.xIn) = transLength;

while flowDone == false

    % update topography with the flow depth and the runup height
    dummyTopog(glob.yIn,glob.xIn) = dummyTopog(glob.yIn,glob.xIn) + glob.flowHead + runUpHeight;   

    % find deepest cell           
    [deepY, deepX, sedLost, sedTrap, cellIndex] = findDeepestCellNew(glob,dummyTopog,glob.yIn, glob.xIn);

    if sedLost == true

        sedLost = true;
        flowDone = true;

    elseif sedLost == false && sedTrap == true

        glob.yIn = deepY; 
        glob.xIn = deepX;
        flowDone = true;

    elseif sedLost == false && sedTrap == false

        % calculate slope-based velocity  
        [slope] = calculateSlope(glob, dummyTopog, glob.yIn, glob.xIn, deepY, deepX, cellIndex);
        [velocity, ~] = calculateVelocity(slope, dummyTopog, glob, deepY, deepX, iteration);
        % calculate velocity-dependent run up height
        [runUpHeight] = calculateRunUpHeight(dummyTopog, velocity, glob, deepY, deepX, iteration);


        if velocity > glob.deposVelocity

            flowDone = false;
            glob.yIn = deepY; 
            glob.xIn = deepX;  
            transLength = transLength+1;
            transRoute(glob.yIn, glob.xIn) = transLength;

        else
            flowDone = true;
            glob.lastRunUpHeight = runUpHeight;
        end

    end

    %     % dilute the flow when it is under sea level  
    %     glob.wateringFactor = 0.02;
    %     if topog(glob.y, glob.x) < glob.seaLevel(glob.event) && glob.flowConcentration > glob.concentrationThreshold;
    %         glob.concentration = glob.concentration - glob.wateringFactor;
    %         end

    it = it+1;
    clear velocity
    clear slope


end

% restore coordinates in agreement with original topog
glob.yIn = glob.yIn - 1;
glob.xIn = glob.xIn - 1;
end

