function nEvents=numberEvents(data,minimumThickness)
%number of events thicker than thickness threshold
%for a vector

events=(data>minimumThickness); %3d matrix with value 1 wherever there's been deposition
nEvents=sum(events); %map of number of events

end