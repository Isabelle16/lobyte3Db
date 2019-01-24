function [contiguousThickness,maxContiguousThickness,meanContiguousThickness]=contiguous(depos,glob,minThickness)
%looks for how long deposition remains in one location before switching

contiguousThickness=NaN(glob.ySize,glob.xSize,glob.totalIterations); %preallocate memory

for x=1:glob.xSize
    for y=1:glob.ySize
        thicknessCount=0; %number of uninterupted depositions
        for t=2:glob.totalIterations
            if depos.transThickness(y,x,t)>minThickness %if there has been deposition
                thicknessCount=thicknessCount+1; %add to number of uninterupted depositions
            else
                contiguousThickness(y,x,t)=thicknessCount; %save the number of depositions
                thicknessCount=0; %and then reset the number to zero   
            end
        end
    end
end

maxContiguousThickness=max(contiguousThickness,[],3);
meanContiguousThickness=mean(contiguousThickness,3,'omitnan');

figure
subplot(1,2,1)
imagesc(maxContiguousThickness)
colorbar
title('Maximum contiguous deposition')
axis equal

subplot(1,2,2)
imagesc(meanContiguousThickness)
colorbar
title('Mean contiguous deposition')
axis equal


end %function