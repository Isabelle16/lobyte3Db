function compareRuns(const,cycl)


%remove negative flag values
const(const<0)=NaN;
cycl(cycl<0)=NaN;

%create copies
constant=const;
cyclic=cycl;

%% Make a difference map

% %make all P values range from 0-0.5
% constant(constant>0.5)=1-constant(constant>0.5);
% cyclic(cyclic>0.5)=1-cyclic(cyclic>0.5);

differenceP=constant-cyclic; %difference in P value

C=load('polarityColour'); %colorbar

figure
h=imagesc(differenceP);
set(h,'AlphaData',~isnan(differenceP)) %no colour for NaNs
title('Difference in P value')
% colormap C
% colorbar

%% Percentage of points with order

threshold=0.1;

constant=const;
cyclic=cycl;

%total point with P value
constPointsTotal=sum(sum((constant>=0)));
cyclPointsTotal=sum(sum((cyclic>=0)));

%points with P value > Treshold
constPointsThresh=sum(sum((constant<=threshold)));
cyclPointsThresh=sum(sum((cyclic<=threshold)));

constPPerc=constPointsThresh/constPointsTotal;
cyclPPerc=cyclPointsThresh/cyclPointsTotal;

fprintf('Fraction below %fthreshold \n Constant run: %fconstPPerc \n Cyclic run: %fcyclPPerc \n',threshold,constPPerc,cyclPPerc')









end