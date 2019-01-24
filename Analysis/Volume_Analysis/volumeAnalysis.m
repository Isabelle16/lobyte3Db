function volumePValueSum=volumeAnalysis(glob,depos)
% Run Burgess(2016) analysis for increasing volume dataset

[~,vCircle,vPerc]=depVolume(glob,depos);

[~,col]=find(vPerc<1,1,'last'); %Don't have to analyse all semi-circles as fan won't be that big
maxR=col+1; %max radius considered is the largest needed to include all sediment

volumePValueSum=NaN(maxR,1);

for i=1:maxR
    
    volumePValueSum(i) = oneSectionRunsAnalysis(vCircle(2:end,i),0,0); %calculate P values for volumes. 1st run is always NaN's
    
end

figure
plot((1:maxR)*1*glob.dy,volumePValueSum)
xlabel('Radius included area (km)')
ylabel('P value')
title('P value with increasing amount of volumetric data')

end %function

