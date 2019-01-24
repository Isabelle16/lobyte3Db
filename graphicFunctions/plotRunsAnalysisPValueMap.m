function plotRunsAnalysisPValueMap(glob,depos)
%plots P values for thickness data without P=1 values

Pmap=removePValues(glob,depos);

figure
h1=imagesc(Pmap);
set(h1,'AlphaData',~isnan(Pmap)) %no colour for NaNs
title('P-value map for thickness')

%adjust colourbar to show red colour everywhere where P<=0.1
c=parula;
signifP=round(0.1*length(c));
reds=zeros(signifP,3);
reds(:,1)=1;
c(1:signifP,1:3)=reds;
    
figure
h2=imagesc(Pmap);
set(h2,'AlphaData',~isnan(Pmap)) %no colour for NaNs
title('P-value map for thickness where P<0.1')
colormap(c)


end