function c=gridSemiCircle(glob,r,col,row)
%creates logical grid with value 1 for all values within radius r

[x,y]=meshgrid(1:glob.xSize,1:glob.ySize);
z=sqrt((x-col).^2+(y-row).^2); %radius from point (col,row)
c=(z<r); %only values within radius will get value 1
c(1:row-1,:)=0; %make it a semi-circle

end
