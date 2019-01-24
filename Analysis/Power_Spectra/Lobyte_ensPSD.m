%calculates fft for all grid points, some effort to combine them

originalData=depos.transThickness;

s=size(originalData);

f=NaN(s(1),s(2),s(3));
s2=NaN(s(1),s(2),s(3));
cl95=NaN(s(1),s(2));

for r=1:s(1)
    for c=1:s(2)
        data=reshape(originalData(r,c,:),[],1); %select column of thickness data
        data(data<=0)=[]; %remove zero thickness
                
        nThicknesses=sum(data>0); %number of datapoints in series
        if nThicknesses>20 %exclude very short thickness successsions
%             [s2temp,f]=periodogram(data);
            [ftemp,s2temp,cl95(r,c)]=PSDeda(data,1,0.95); %calculate PSD
            s2temp=s2temp./mean(s2temp); %normalise power spectrum
            Lf=length(ftemp); %fit results into 3d matrix
            Ls2=length(s2temp);
            f(r,c,1:Ls2)=ftemp(1:Ls2);
            s2(r,c,1:Ls2)=s2temp;
        end
    end
end
%%
fReshape=reshape(f,[],1); %make 1 vector with all PSDs
s2Reshape=reshape(s2,[],1); %make the frequency vector


figure
hold on

plot(fReshape,s2Reshape,'b.','MarkerSize',1) %plot all combinations of freq and power

[ux,~,idx] = unique(fReshape); %find unique frequency values
ymean = accumarray(idx,s2Reshape,[],@mean); % Calculates mean for each unique frequency

plot(ux,ymean,'r','LineWidth',2) %


lineSupply=1/20; %period of supply curve. 1/P for frequency

maxYWindow=max(s2Reshape)*1.2;
minYWindow=min(s2Reshape(2:end))*1.2;
plot([lineSupply lineSupply],[minYWindow maxYWindow],'k')


title('Power spectrum of thickness')
xlabel('Frequency (1/layers)')
ylabel('Normalised power')
% set(gca, 'YScale', 'log')

hold off

%% Plot some examples

y=[50 80 50]; %y coordinates
x=[100 90 120]; %matcing x coordinates

figure
hold on


for i=1:length(y)
    xExample=reshape(f(y(i),x(i),:),[],1);
    yExample=reshape(s2(y(i),x(i),:),[],1);
    plot(xExample(1:length(yExample)),yExample);
end

plot([1/20 1/20],[0 0.002])
title('Example single location PSD')
xlabel('Frequency (1/layers)')
ylabel('Power')
% set(gca, 'YScale', 'log')

hold off

