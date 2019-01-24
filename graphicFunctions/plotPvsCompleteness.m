function plotPvsCompleteness(glob, depos)
%plots completeness on x axis, P value on y axis. 

%     completenessVector = reshape(depos.stratCompletenessContigMax, [1,(glob.ySize * glob.xSize)]);
    completenessVector = reshape(depos.stratCompletenessContig, [1,(glob.ySize * glob.xSize)]);
    pValueVector = reshape(glob.runsAnalysisPValueMap, [1,(glob.ySize * glob.xSize)]);
    pValueVector(pValueVector<0)=NaN;
    
    figure
    scatter(completenessVector, pValueVector, 'x');

    xlabel('Stratigraphic completeness');
    ylabel('Runs analysis P value');
end