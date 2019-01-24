function analyseWindowP(gridPThicknessWindow)
%calculates mean P statistic over the grid for a thickness window


iterations=size(gridPThicknessWindow,3);

meanSlice=NaN(iterations,1);
stdSlice=NaN(iterations,1);

for i=1:iterations
    slice=gridPThicknessWindow(:,:,i); %
    sliceVector=reshape(slice,[],1);
    meanSlice(i)=mean(sliceVector,'omitnan');
%     stdSlice(i)=std(sliceVector,'omitnan');
end

figure
plot(meanSlice)
% errorbar(meanSlice,stdSlice)
xlabel('Number of combined thicknesses')
ylabel('Mean P over full grid')
title('Mean P statistic vs thickness windows')

end %function