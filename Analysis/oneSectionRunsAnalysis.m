function [runsPValueSum,runsOrderMetric] = oneSectionRunsAnalysis(thicknesses, plotGraphicsFlag, minimumThickness)

    thicknesses(thicknesses<=minimumThickness)=[]; %pretend like there's no zero thicknesses or hemipelagic
    
    
    
    TRUE = uint8(1);
    FALSE = uint8(0);
    maxIterations = 500;
    numberOfSwaps = length(thicknesses);
    maxRun = 3;
    minRun = 0;
    runBinIncrement = 0.01;
    runRange = maxRun - minRun;

    % Calculate and output the order metric for the entire data succession
    runsOrderMetric = calculateRunsOrderMetric(thicknesses);
  
    % Now calculate the metrics for many iterations of a random model
    
    for j = 1:maxIterations
        % Shuffle the observed section and calculate the order metric and DW stat each time
        shuffledThick = shuffleSection(thicknesses, numberOfSwaps);
        multiRunsOrderMetricDataShuffled(j) = calculateRunsOrderMetric(shuffledThick); 
    end

    % Stats on the shuffled section random model
    meanMultiRunsDataShuffled = mean(multiRunsOrderMetricDataShuffled);
    stdDevMultiRunsDataShuffled = std(multiRunsOrderMetricDataShuffled);
    bins = 0:runBinIncrement:runRange; % 0 is the minimum run metric, 3 a generally maximum value (this is what runRange should be set to)
    multiRunsOrderMetricDataShuffledHistData = histc(multiRunsOrderMetricDataShuffled, bins)/maxIterations; % Calculate frequency bins with histc but / by iterations to give relative freq
    runBinIndex = 1 + int16(((runsOrderMetric-minRun)/runRange)*(runRange/runBinIncrement)); % Position of runs stat in the histogram
    runsPValueSum = sum(multiRunsOrderMetricDataShuffledHistData(runBinIndex:length(multiRunsOrderMetricDataShuffledHistData))); % area under curve from r to max run value
    
%     if runsPValueSum > 0.5
%         runsPValueSum = 1.0 - runsPValueSum;
%     end
    
    if plotGraphicsFlag 
        plotMCRunsHistogram(minRun, runBinIncrement, maxRun, multiRunsOrderMetricDataShuffledHistData, runsOrderMetric);
    end
end

function runsOrderMetric = calculateRunsOrderMetric(thicknesses)
% find the number of units in the succession and declare arrays accordingly
    nz = max(size(thicknesses));
    deltaThick = zeros(1,nz);
    runsUp = zeros(1,nz);
    runsDown = zeros(1,nz);

    % Calculate the change in thickness between successive units
    i = 1:nz-1;
    j =2:nz; % so j = i + 1 therefore thickness change is thickness(j) - thickness(i)
    deltaThick(i) = thicknesses(j) - thicknesses(i);

    if deltaThick(1) >0 runsUp(1) = 1; end
    if deltaThick(1) < 0 runsDown(1) = 1; end

    for i=2:nz
        if deltaThick(i) > 0 runsUp(i) = runsUp(i-1)+1; end
        if deltaThick(i) < 0 runsDown(i) = runsDown(i-1)+1; end
    end

    deltaThickData=deltaThick~=0; %1 when there is a value for deltaThickness
    numberOfThicknesses=sum(deltaThickData);
    
    
    runsUpNormSum = (sum(runsUp)/numberOfThicknesses);
    runsDownNormSum = (sum(runsDown)/numberOfThicknesses);
    runsOrderMetric = (runsUpNormSum + runsDownNormSum);
end

function shuffledThick = shuffleSection(sectThick, totalSwaps)
% function to shuffle the facies succession to ensure a random configuration

    % Make copies of the original data in new arrays that will be used to store the shuffled sections
    shuffledThick = sectThick;
    
    n = uint16(max(size(shuffledThick)));
    j = 0;
    while j < totalSwaps
        
        % Select two unit numbers randomly to be swapped
        unit1 = uint16((rand * (n-1)) + 1);
        unit2 = uint16((rand * (n-1)) + 1);
        
        %Swap the thicknesses
        temp = shuffledThick(unit1);
        shuffledThick(unit1) = shuffledThick(unit2);
        shuffledThick(unit2) = temp;

        j = j + 1;
    end
end

function plotMCRunsHistogram(minRun, runBinIncrement, maxRun, multiRunsOrderMetricDataShuffledHistData, runsOrderMetric)
    % Subplot for the runs analysis histogram    
    figure
%     subplot('Position',[0.25 0.1 0.65 0.38]);
    hold on
    bins = minRun:runBinIncrement:maxRun; % Make sure that bins is set correctly for Runs analysis plots
    bar(bins, multiRunsOrderMetricDataShuffledHistData, 'EdgeColor','none', 'BarWidth', 1, 'FaceColor',[0.2 0.4 0.7]);
    maxFreq = max(multiRunsOrderMetricDataShuffledHistData) * 1.1; % This is needed to scale the plot

    lineColor = [0.80 0.00 0.00];
    x = [runsOrderMetric runsOrderMetric];
    y = [0 maxFreq]; % Draw the data line from y=0 to y=max frequency of the three histograms
    line(x,y, 'color', lineColor, 'linewidth', 3.0);

    grid on;
    axis([0 Inf 0 Inf]);
    set(gca,'Layer','top');
    xlabel('Runs Analysis Order Metric for Thickness ');
    ylabel('Relative Frequency');
end
