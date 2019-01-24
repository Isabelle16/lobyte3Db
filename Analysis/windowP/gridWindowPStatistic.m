function gridPThicknessWindow=gridWindowPStatistic(datacube,glob,minimumThickness)
%for a grid of x by y by numberIterations
%combines thicknesses and treats them like one thickness to calculate the P
%statistic. Ever slice is a Pvalue map for a different window of combined
%thicknesses.


gridPThicknessWindow=NaN(glob.ySize, glob.xSize, uint16(glob.totalIterations/4)); %x and y size grid, 3rd dimension is number of thicknesses combined
gridPThicknessWindow(:,:,1)=glob.runsAnalysisPValueMap; % P value map for individual thickness has already been calculated


for x = 1:glob.xSize
    x
    for y = 1:glob.ySize
        
        onlyThickness=datacube(y,x,:); %copy thickness data
        onlyThickness(onlyThickness<=minimumThickness)=[]; %remove too thin layers (minimum should be same as in calculateStatistics)
        
        %start calculating how long windowPStatistic result vector will be to fit it into grid.
        %This could be less than totalIterations/4 because values are removed.
        nThick=length(onlyThickness); %number of thickness measurements
        maxTimeWindow=uint16(nThick/4); %need at least 4 thicknesses to calculate a good r metric, so split dataset into 4
        
        if length(onlyThickness)>=8 %need at least 4 thickness to shift windows, but they will be combined so at least 8 for first combination
            gridPThicknessWindow(y,x,2:maxTimeWindow+1)=windowPStatistic(onlyThickness,minimumThickness); %calculate P when combining thickness and save it
        end
        
    end
    
end

end

function meanPThicknessWindow=windowPStatistic(data,minimumThickness)
% for 1D vector thickness dataset.
%combines multiple thicknesses to 1 layer, then calculates P statistic.
%Starts with combining 2 thicknesses: thickness 1 and 2, 3 and 4 etc. Treat the sum of 2 thicknesses as
%one layer, calculate P statistic. Then repeat for thickness 2 and 3, 4 and
%5 etc. Save the average P value. Then go to next window (3 thicknesses
%combined) etc up to 1/4 of total thicknesses are combined as one layer.

data(data<=minimumThickness)=[]; %make sure there's only significant thicknesses in dataset

nThick=length(data); %number of thickness measurements
maxThicknessWindow=uint16(nThick/4); %need at least 4 thicknesses to calculate a good r metric, so this is the maximum window considered

meanPThicknessWindow=NaN(maxThicknessWindow,1);

stopWindowShift=0; %this will be 1 when there's not sufficient thicknesses to continue increasing the window
i=1; %while loop is for the step number of thicknesses that will be combined to a single layer: i+1 thicknesses=1 layer
while i<=maxThicknessWindow && stopWindowShift==0
    
    windowRunsPValueSum=NaN(i+1,1); %allocate memory for P value, for all combinations of i+1 thicknesses
    for k=1:i+1 %to average: when combining 3 thicknesses to 1 layer, you can start at thickness 1, 2, or 3 of dataset. Take the average P value of these.
        
        multiLayerThickness=zeros(nThick,1)-999; %allocate memory, -999 should be replaced with thickness value
        j=k; %first thickness of dataset (see k for-loop for explanation)
        while j+i<=nThick %while loop actually combines thicknesses to 1 layer
            multiLayerThickness(j)=sum(data(j:j+i)); %sum i+1 thicknesses to 1 layer
            j=j+i+1; %jump to next thickness layer that needs to be combined
        end
        
        multiLayerThickness(multiLayerThickness<=minimumThickness)=[]; %remove unwanted values (all -999 flag values)
        
        if length(multiLayerThickness) >= 4 %minimum to do shuffeling
            [windowRunsPValueSum(k),~] = oneSectionRunsAnalysis(multiLayerThickness, 0, minimumThickness); %calculate P value
        end
        
    end
    
    meanPThicknessWindow(i)=mean(windowRunsPValueSum,'omitnan'); %average P value for different starting positions. This will be the output of the function, starting at 2 combined thicknesses at index i=1
    
    stopWindowShift=isnan(meanPThicknessWindow(i)); %when there's no 4 combined thickness left, no NaN will be replaced by a P value and while loop can be stopped
    
    i=i+1; %next window of thicknesses
    
end

end %function



