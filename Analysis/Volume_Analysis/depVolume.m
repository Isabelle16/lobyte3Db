function [vTotal,vCircle,vPerc]=depVolume(glob,depos)
%calculates the volume included in a semi-circular area for each iteration
%only works well with 1 flow/iteration. Otherwise approximate with find function

dr=1; %step size for semicircular grid, real distance depends on dx and dy
maxCircles=glob.ySize/dr;

vTotal=NaN(glob.totalIterations,maxCircles);
vCircle=NaN(glob.totalIterations,maxCircles);
vPerc=NaN(glob.totalIterations,maxCircles);

for i=2:glob.totalIterations %starts at 2 because first iteration is NaN
    
%     [col,row]=find(depos.transThickness(:,:,i)',1,'first'); %find 1st grid with deposition
    centreOfCircle=depos.firstDeposition{i};
    row=centreOfCircle(2); %y coor
    col=centreOfCircle(1); %x coor

    rcircle=dr:dr:(glob.ySize-row);
    maxSteps=length(rcircle); %maximum number of radii considered
    
    for j=1:maxSteps
        
        r=rcircle(j); %radius circle
        c=gridSemiCircle(glob,r,col,row); %create a mask for everything outside of radius r
        vTotal(i,j)=sum(sum(depos.transThickness(:,:,i)))*glob.dx*glob.dy; %total volume (m*km*km=hm^3)
        thickness=depos.transThickness(:,:,i);
        thickness(c==0)=0;
        vCircle(i,j)=sum(sum(thickness,'omitnan'),'omitnan')*glob.dx*glob.dy; %volume within circle, #rows is iterations, #columns is radius steps
        vPerc(i,j)=vCircle(i,j)./vTotal(i,j); %percentage of iteration's total volume stored within this circle
    
    end
    
end

figure
plot((1:maxCircles)*dr*glob.dy,vPerc')
xlabel('Radius included area (km)')
ylabel('Fraction deposited')
title('Deposited fraction vs distance')


end %function depVolume


function c=gridSemiCircle(glob,r,col,row)
%creates logical grid with value 1 for all values within radius r

[x,y]=meshgrid(1:glob.xSize,1:glob.ySize);
z=sqrt((x-col).^2+(y-row).^2); %radius from point (col,row)
c=(z<r); %only values within radius will get value 1
% c(1:row-1,:)=0; %make it a semi-circle

end
