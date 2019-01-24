function [slope] = calculateSlope(glob, topog, y1, x1, y2, x2, cellIndex)

% Calculate slope and azimuth
dy = glob.dy.*10^3;
dx = glob.dx.*10^3;
dz = topog(y2,x2) - topog(y1,x1); % the slope is negative for outflow

if mod(cellIndex,2) == 0
    slope = dz/(sqrt(dy^2+dx^2));    
else
    slope = dz/dx; 
end  


end