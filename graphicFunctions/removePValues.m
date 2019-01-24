function Pmap=removePValues(glob,depos)
%remove P values with too few units from the P-value map

Pmap=glob.runsAnalysisPValueMap;

% Line below has been replaced with
% Pmap(Pmap==1)=NaN; %P=1 where there is no thickness, remove those values

events=depos.transThickness>0; %3d matrix with value 1 wherever there's been deposition
includedEvents=sum(events,3); %map of number of events

eventTresholdP=glob.sedimentSupplyPeriod;
eventTresholdP=max([4 glob.sedimentSupplyPeriod]); %At least 4 thicknesses should be included, and at least length of signal to be resolved in order to create stable P value (Burgess 2016 JSR, p156)

includedEvents(includedEvents<eventTresholdP)=0; %map for minimum number of events for P analysis 

Pmap(includedEvents==0)=NaN; %exclude unstable points
Pmap(Pmap<0)=NaN;

end