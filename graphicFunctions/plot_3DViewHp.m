function plot_3DViewHp(glob, depos, xPosition, yPosition, iteration)

%% Plot lobyte 3D view

ffOne = figure(1);
view([-142 50]); 


totalFlowSedThick = sum(depos.transThickness,3); % total flow thickness
totalHpSedThick = sum(depos.hpThickness,3); % total hemipelagic thickness

totalDepos = totalFlowSedThick; % + totalHpSedThick; 
initialElevation = depos.elevation(:,:,1);
finalElevation = depos.elevation(:,:,glob.maxIt);



%% Plot the model final topography
pp = surf(1:glob.ySize, 1:glob.xSize, finalElevation);
pp.CData=totalDepos;
pp.EdgeColor = 'none';
%% Plot the lateral view 

% Plot the Hemipelagic sediment thickness
top = finalElevation;
bottom = initialElevation;

for x = glob.xSize
    for y = 1:glob.ySize-1
        xc = [x x x x];
        yc = [y y y+1 y+1];
        zc = [top(y,x) bottom(y+1,x) bottom(y+1,x) top(y+1,x)];
        patch(xc, yc, zc,[177  179  179]./255,'EdgeColor','none');

    end
end

for x = 1:glob.xSize-1
    for y = glob.ySize
        xc = [x x x+1 x+1];
        yc = [y y y y];
        zc = [top(y,x) bottom(y,x) bottom(y,x+1) top(y,x+1)];
        patch(xc,yc,zc,[177  179  179]./255,'EdgeColor','none');

    end
end

for x = 1
    for y = 1:glob.ySize-1
        xc = [x x x x];
        yc = [y y y+1 y+1];
        zc = [top(y,x) bottom(y,x) bottom(y+1,x) top(y+1,x)];
        patch(xc,yc,zc,[177  179  179]./255,'EdgeColor','none');

    end
end

for x = 1:glob.xSize-1
    for y = 1
        xc = [x x x+1 x+1];
        yc = [y y y y];
        zc = [top(y,x) bottom(y,x) bottom(y,x+1) top(y,x+1)];
        patch(xc,yc,zc,[177  179  179]./255,'EdgeColor','none');

    end
end


% Plot the basement

top = initialElevation;
bottom = min(min(initialElevation)) - 10;

for x = glob.xSize
    for y = 1:glob.ySize-1
        xc = [x x x x];
        yc = [y y y+1 y+1];
        zc = [top(y,x) bottom bottom top(y+1,x)];
        patch(xc, yc, zc,[72 72 72]./255,'EdgeColor','none');

    end
end

for x = 1:glob.xSize-1
    for y = glob.ySize
        xc = [x x x+1 x+1];
        yc = [y y y y];
        zc = [top(y,x) bottom bottom top(y,x+1)];
        patch(xc,yc,zc,[72 72 72]./255,'EdgeColor','none');

    end
end

for x = 1
    for y = 1:glob.ySize-1
        xc = [x x x x];
        yc = [y y y+1 y+1];
        zc = [top(y,x) bottom bottom top(y+1,x)];
        patch(xc,yc,zc,[72 72 72]./255,'EdgeColor','none');

    end
end

for x = 1:glob.xSize-1
    for y = 1
        xc = [x x x+1 x+1];
        yc = [y y y y];
        zc = [top(y,x) bottom bottom top(y,x+1)];
        patch(xc,yc,zc,[72 72 72]./255,'EdgeColor','none');

    end
end

%% Plot cross section position using patch
top = max(max(finalElevation)) - 25;
bottom = min(min(initialElevation)) - 10;

% y Cross section
zco = [top bottom bottom top];
yco = [yPosition yPosition yPosition yPosition]; 
xco = [0 0 glob.xSize+1 glob.xSize+1];
faciesCol = [1 0.921 0.843];
patch(xco, yco, zco, faciesCol,'FaceAlpha',0.35,'LineWidth',1 ); 

%x cross section
zco = [top bottom bottom top];
xco = [xPosition xPosition xPosition xPosition]; 
yco = [0 0 glob.ySize+1 glob.ySize+1];
faciesCol = [1 0.921 0.843];
patch(xco, yco, zco, faciesCol,'FaceAlpha',0.35,'LineWidth',1 ); 


%% General-----------------------------------------------------------
% set figure position and dimension
width = 125;     % Width in inches
height = 85;    % Height in inches
set(ffOne, 'Position', [0.5 0.5 width*15, height*10]); %<- Set size
% ax properties
ax = gca;
ax.LineWidth = 0.6;
ax.FontSize = 21;
% ax.FontWeight = 'bold';

xlabel('x(km)','FontSize',21)
ylabel('y(km)','FontSize',21)
zlabel('z(m)','FontSize',21)


axis tight
% daspect([1.25 1.25 1.0000]);
% pbaspect([3.2 3 1]);

% %  Axis off option
% axis off 


grid off

% shading flat
lightangle(250,30)
pp.FaceLighting = 'gouraud'; % 'flat';
pp.AmbientStrength = 0.9;
pp.DiffuseStrength = 0.8;
pp.SpecularStrength = 0.9;
pp.SpecularExponent = 25;
% pp.BackFaceLighting = 'unlit';
% material metal

view([-142 50]); 
%% Save image using save_fig

set(ffOne,'Color','none'); % set transparent background
set(gca,'Color','none');

% export_fig(sprintf('view3DCrossSec %d',iteration),...
%    '-png', '-transparent', '-m12', '-q101');




  






  