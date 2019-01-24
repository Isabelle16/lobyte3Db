function [deepY, deepX, sedLost, sedTrap, cellIndex] = findDeepestCellNew(glob,dummyTopog, y, x)

sedLost = false;
sedTrap = false;

%------
[maxGrad, cellIndex, nbrGrads] = neighbourMaxGrad(glob, dummyTopog, y, x);

N = [0 1;1 1;1 0;1 -1;0 -1;-1 -1;-1 0;-1 1]; % N contains the neighbours cell indices starting from E 

if size(cellIndex,1) == 1 && maxGrad <= 0   % the minimum is unique
    
       deepY = y + N(cellIndex,1);
       deepX = x + N(cellIndex,2); 
       glob.dir = cellIndex;
       
elseif size(cellIndex,1) > 1 && isempty(find(nbrGrads <= 0, 1))==false % the minimum is non-unique: shuffle coord and take a random cell between the lowest
    
    if isempty(find(cellIndex==glob.dir, 1))==false % keep the previous step direction
        cellIndex = glob.dir;
        deepY = y + N(cellIndex,1);
        deepX = x + N(cellIndex,2); 
        
    else % shuffle coord and take a random cell between the lowest
       aa = 1:length(cellIndex);
       aarand = aa(randperm(length(aa)));
       indx = aarand(1); 
       randCellInd = cellIndex(indx);
       
       deepY = y + N(randCellInd,1);
       deepX = x + N(randCellInd,2);

       cellIndex = randCellInd; 
       glob.dir = cellIndex; 
    end
    
else % none of the Nbr cell is lower, local basin
    sedTrap = true;
    deepY = y;
    deepX = x; 
end

if deepY==1 || deepY==size(dummyTopog,1) || deepX==1 || deepX==size(dummyTopog,2) % flow crosses model boundary and get lost
    sedLost = true;
end  




% if min(topogNbr) <= dummyTopog(y,x)   % at least one lower/equal cell exists 
% 
% [val, ~] = min(topogNbr);  % find the minimum and its index
% [row] = find(topogNbr == val); % find all the elements of dummyTopog that are equal to the mimum
% 
%     if size(row) == 1 % the minimum is unique
% 
%        deepY = y + N(row,1);
%        deepX = x + N(row,2);
% 
%        cellIndex = row;
% 
%     else % the minimum is non-unique, shuffle coord and take a random cell between the lowest
% 
%        aa = 1:length(row);
%        aarand = aa(randperm(length(aa)));
%        indx = aarand(1); 
%        randCellInd = row(indx);
%        
%        
% 
%        deepY = y + N(randCellInd,1);
%        deepX = x + N(randCellInd,2);
% 
%        cellIndex = randCellInd;   
% 
%     end
% 
% end

% if min(topogNbr) > dummyTopog(y,x) % none of the Nbr cell is lower
%     sedTrap = true;
%     deepY = y;
%     deepX = x; 
% end

% if deepY==1 || deepY==size(dummyTopog,1) || deepX==1 || deepX==size(dummyTopog,2) % flow crosses model boundary and get lost
%     sedLost = true;
% end   

    
end


    