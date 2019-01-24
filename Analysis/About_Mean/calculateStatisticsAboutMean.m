function [glob, depos] = calculateStatisticsAboutMean (glob, depos, xco, yco)
% Calculate stratigraphic completeness and proportion of total area covered stats for each time interval in the strata

    minimumThickness=0;
    disp('Minimum thickness threshold')
    disp(minimumThickness)

    fprintf('Calculating completeness and runs analysis p values...');
    
    glob.runsAnalysisPValueMap = zeros(glob.ySize, glob.xSize) - 1; % Set array to a dummy value to ID elements not assigned values
    glob.runsOrderMetric = zeros(glob.ySize, glob.xSize) - 1; % Set array to a dummy value to ID elements not assigned values
    pValuesList = zeros(1, glob.ySize * glob.xSize); % Vector to record all p values calculated, to calculate summary stats
    
    % Calculate stratigraphic completeness and the runs analysis P value for each point on the grid
    pValuesCount = 0;
    fprintf('X: ');
    for x = 1:glob.xSize
        fprintf('%3d', x);
        for y = 1:glob.ySize
            deposCountOnePoint = 0;
            deposCountContigOnePoint = 0;
  
            % Loop through time to calculate total and contiguous stratigraphic completeness
            for t = 2:glob.totalIterations 
               if depos.transThickness(y,x,t) > 0 % So thickness of deposited flows at x,y,t is > 0
                   deposCountOnePoint = deposCountOnePoint + 1; % So this is an iteration that records some deposition, so add to count for total strat completeness
               end
               
               if depos.transThickness(y,x,t) > 0 && depos.transThickness(y,x,t-1) > 0 % Count all >0 thickness units with a similar unit contiguous i.e. in contact below
                   deposCountContigOnePoint = deposCountContigOnePoint + 1;
               end
            end
            depos.stratCompleteness(y,x) = deposCountOnePoint / glob.totalIterations; % Divide deposition record count at x,y by total iterations to get completeness
            depos.stratCompletenessContig(y,x) = deposCountContigOnePoint / glob.totalIterations;
             
            % Loop through time again and calculate the maximum number of contiguous thickness units
            maxContigCountOnePoint = 0;
            for t = 2:glob.totalIterations 
                contigLoop = t;
                contigCount = 0;
                while contigLoop <= glob.totalIterations && depos.transThickness(y,x,contigLoop) > 0 && depos.transThickness(y,x,contigLoop-1) > 0 
                    contigCount = contigCount + 1;
                    contigLoop = contigLoop + 1;
                end
                
                if contigCount > maxContigCountOnePoint
                    maxContigCountOnePoint = contigCount;
                end
                t = contigLoop; % Could perhaps just use t in inner loop too instead of contigLoop?
            end
            depos.stratCompletenessContigMax(y,x) = maxContigCountOnePoint / glob.totalIterations;
            
            
            nEvents=numberEvents(depos.transThickness(y,x,:),minimumThickness);
            if nEvents >= 20 % && length(nonzeros(depos.transThickness(y,x,:))) > 10
                [glob.runsAnalysisPValueMap(y,x),glob.runsOrderMetric(y,x)] = oneSectionRunsAnalysisAboutMean(depos.transThickness(y,x,:),0,minimumThickness); % Zero is the flag value for no graphics plotting
                pValuesCount = pValuesCount + 1;
                pValuesList(pValuesCount) = glob.runsAnalysisPValueMap(y,x);
            end
        end
        fprintf('\b\b\b');
    end
    fprintf('Done\n');
    
    pValuesList(pValuesList==0) = []; % Remove zeroes from the pValues list
    
    if sum(depos.transThickness(50,100,:)) > 0.01
        [dummy,~] = oneSectionRunsAnalysisAboutMean(depos.transThickness(50,100,:),1,minimumThickness); % One is the flag value for graphics plotting
    end
    if sum(depos.transThickness(80,100,:)) > 0.01
        [dummy,~] = oneSectionRunsAnalysisAboutMean(depos.transThickness(65,100,:),1,minimumThickness);
    end
    if sum(depos.transThickness(79,94,:)) > 0.01
        [dummy,~] = oneSectionRunsAnalysisAboutMean(depos.transThickness(80,100,:),1,minimumThickness);
    end
    if sum(depos.transThickness(70,90,:)) > 0.01
        [dummy,~] = oneSectionRunsAnalysisAboutMean(depos.transThickness(60,90,:),1,minimumThickness);
    end% 
    
    % Calculate the maximum fan area, the total number of points on the x y grid that have recorded some deposition
    totalDeposArea = 0;
    for x = 2:glob.xSize-1
        for y = 1:glob.ySize-1
            totalThick = depos.elevation(y,x,glob.totalIterations) - depos.elevation(y,x,1);
            if totalThick > 0 
                totalDeposArea = totalDeposArea + 1;
            end
        end
    end
    
    
    % Calculate the centroid of transported sediment deposition at each time step
    % This should show the fan stacking through time, particlurly clustering to form lobes, and avulsions between lobes
    glob.centroidX = zeros(1, glob.totalIterations);
    glob.centroidY = zeros(1, glob.totalIterations);
    for t = 1:glob.totalIterations
        pointCount = 0;
        for x = 2:glob.xSize-1
            for y = 1:glob.ySize-1
                if depos.transThickness(y,x,t) > 0
                    glob.centroidX(t) = glob.centroidX(t) + x;
                    glob.centroidY(t) = glob.centroidY(t) + y;
                    pointCount = pointCount + 1;
                end
            end
        end
        glob.centroidX(t) = glob.centroidX(t) / pointCount;
        glob.centroidY(t) = glob.centroidY(t) / pointCount;
    end
    
    % Now calculate the seperation distance of the centroids, specifically centroid(t) from centroid(t-1)
    for t = 2:glob.totalIterations
        deltaX = glob.centroidX(t) - glob.centroidX(t-1);
        deltaY = glob.centroidY(t) - glob.centroidY(t-1);
        glob.centroidSeperation(t) = sqrt((deltaX * deltaX) + (deltaY * deltaY));
    end
   
    glob.meanThickness = zeros(1,glob.totalIterations);
    glob.deposArea = zeros(1,glob.totalIterations);
    glob.deposAreaProportion = zeros(1,glob.totalIterations);
    
    meanThicknessAll = mean(mean(mean(nonzeros(depos.transThickness(:,:,:)))));
    minThicknessAll = min(min(min(nonzeros(depos.transThickness(:,:,:)))));
    maxThicknessAll = max(max(max(nonzeros(depos.transThickness(:,:,:)))));
    
    % Calculate the proportion of areal coverage for each time step and the mean thickness of layer at each time t
    for t = 2:glob.totalIterations       
        glob.deposArea(t) = nnz(depos.transThickness(:,:,t)); % Counts non-zero elements, so number of points covered by thickness > 0 is depositional area
        glob.deposAreaProportion(t) = nnz(depos.transThickness(:,:,t)) / totalDeposArea; 
        glob.meanThickness(t) = mean(mean(nonzeros(depos.transThickness(:,:,t))));
    end
    
    % The ideal homogenous thickness is the flow volume at time t / maximum fan area. We can then calcuate through a vertical succession the proportional thickness of
    % each layer relative to that idea homogenous thickness
    allFanLayerThickness = zeros(1, glob.totalIterations);
    for t = 2:glob.totalIterations
        allFanLayerThickness(t) = glob.supplyHistory(t) / totalDeposArea;
        depos.proportionThickness(t) = (depos.elevation(yco,xco,t) - depos.elevation(yco,xco,t-1)) ./ allFanLayerThickness(t);
    end
    
    fprintf('Summary statistics, all fan\n');
    fprintf('Mean unit thickness %4.3f m Minimum %4.3f m Maximum %4.3f m\n', meanThicknessAll, minThicknessAll, maxThicknessAll);
    fprintf('Mean unit area %d Minimum %d Maximum %d\n', mean(glob.deposArea), min(glob.deposArea), max(glob.deposArea));
    fprintf('Runs analysis P values. Minimum: %5.4f Mean %5.4f Mode %5.4f Maximum %5.4f\n', min(pValuesList), mean(pValuesList), mode(pValuesList), max(pValuesList));

    fprintf('Done\n');
end