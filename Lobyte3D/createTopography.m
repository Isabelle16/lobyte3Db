function [topog, glob] = createTopography(glob)


%% Initialize topography: ramp type  

topog = zeros (glob.ySize, glob.xSize);
maxElev = 100; % m
topog(1,:) = maxElev; % initial elevation value  
elevDecayRate = maxElev * 0.02; 
i=2;
while topog(i-1,1) > 0                         
    topog(i,:) = topog(i-1,:) - elevDecayRate;
    i = i + 1;
end

for j =i:glob.ySize                         
    %     topog(i,:) = topog(i-1,:).*0.999; %.*elevDecayRate; 
    topog(j,:) = topog(j-1,:); 
end    
noise = rand(glob.ySize,glob.xSize).*0.0006;
topog = topog + noise;

glob.dir = 3; % Average max dip of the topography (1 = E; 2 = SE; 3 = S(y+) and so on, clockwise)

% %% Initialize topography: normal fault type (unit: m)
% 
% glob.faultYCo = 45; 
% 
% for i = 2:glob.faultYCo                         
%  topog(i,:) = topog(i-1,:) - 1.5; %.*elevDecayRate;   
% end   
% for i =glob.faultYCo:glob.ySize                         
%  topog(i,:) = topog(i-1,:) - 0.01; %.*elevDecayRate;   
% end    
% noise = rand(glob.ySize, glob.xSize).*0.00005;
% topog = topog + noise;
% 
% faultInitialThrow = 10; 
% 
% for i = glob.faultYCo:glob.ySize 
%  topog(i,:) = topog(i,:) - faultInitialThrow;  
% end



end 


