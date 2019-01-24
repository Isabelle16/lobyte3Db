function plotRelationsP(glob,depos,minThickness)

pValueVector = reshape(glob.runsAnalysisPValueMap, [1,(glob.ySize * glob.xSize)]);
pValueVectorClean=removeValues(pValueVector,glob,depos);

completenessVector = reshape(depos.stratCompletenessContig, [1,(glob.ySize * glob.xSize)]);

R = reshape(glob.runsOrderMetric, [1,(glob.ySize * glob.xSize)]);

[~,maxContiguousThickness,meanContiguousThickness]=contiguous(depos,glob,minThickness);
maxCT = reshape(maxContiguousThickness, [1,(glob.ySize * glob.xSize)]);
meanCT = reshape(meanContiguousThickness, [1,(glob.ySize * glob.xSize)]);

figure

subplot(2,2,1)
scatter(completenessVector, pValueVectorClean, 'x');
xlabel('Stratigraphic completeness');
ylabel('Runs analysis P value');
title('Completeness')

subplot(2,2,2)
scatter(R, pValueVectorClean, 'x');
xlabel('Runs Order Metric');
ylabel('Runs analysis P value');
title('Runs Order Metric')

subplot(2,2,3)
scatter(maxCT, pValueVectorClean, 'x');
xlabel('Maximum contigous thicknesses');
ylabel('Runs analysis P value');
title('Max contiguous Stephan')

subplot(2,2,4)
scatter(meanCT, pValueVectorClean, 'x');
xlabel('Mean contigous thicknesses');
ylabel('Runs analysis P value');
title('Mean contiguous Stephan')


end



function dataSet=removeValues(dataSet,glob,depos)
%remove P values with too few units from the P-value map

% Line below has been replaced with
% Pmap(Pmap==1)=NaN; %P=1 where there is no thickness, remove those values

events=depos.transThickness>0; %3d matrix with value 1 wherever there's been deposition
includedEvents=sum(events,3); %map of number of events

eventTresholdP=max([4 glob.sedimentSupplyPeriod]); %At least 4 thicknesses should be included, and at least length of signal to be resolved in order to create stable P value (Burgess 2016 JSR, p156)

includedEvents(includedEvents<eventTresholdP)=0; %map for minimum number of events for P analysis

dataSet(includedEvents==0)=NaN; %exclude unstable points
dataSet(dataSet<0)=NaN;

end