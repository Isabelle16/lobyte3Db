function plotCentroids(glob, depos)

    ffOne = figure;

    for t = 2:glob.totalIterations                      
         yco = [glob.centroidY(t)-0.5 glob.centroidY(t)-0.5 glob.centroidY(t)+0.5 glob.centroidY(t)+0.5];  % 4 vertices coordinates clockwise 
         xco = [glob.centroidX(t)-0.5 glob.centroidX(t)+0.5 glob.centroidX(t)+0.5 glob.centroidX(t)-0.5];
         zco = [t t t t];

         patch(xco,yco,zco,depos.faciesColour(t,:));
    end
     
    totalThick = zeros(glob.ySize, glob.xSize);
    totalThick(:,:) = depos.elevation(:,:,glob.totalIterations) - depos.elevation(:,:,1);
      
    maxTotalThick = max(max(totalThick));
        
    for x = 1:glob.xSize
         for y = 1:glob.ySize
            yco = [y-0.5 y-0.5 y+0.5 y+0.5];  % 4 vertices coordinates clockwise 
            xco = [x-0.5 x+0.5 x+0.5 x-0.5];
            zco = [0 0 0 0];
            patch(xco,yco,zco,[1 (totalThick(y,x) / maxTotalThick) 0], 'EdgeColor','none');
         end
    end

    %% General
    view([220 60]);
   
    ax = gca;
    xlabel('X Distance (km)');
    ylabel('Y Distance (km)');
    zlabel('Elapsed model time (it #)')
    
    ax.LineWidth = 0.5;
    ax.FontSize = 12;
    
    axis tight
    grid on

    % %% Set figure position and dimension
    % width = 125;     % Width in inches
    % height = 85;    % Height in inches
    % set(ffOne, 'Position', [0.5 0.5 width*17, height*9]); % <- Set size

    %% Save image using save_fig
    % set(ffOne,'Color','none'); % set transparent background
    % set(gca,'Color','none');
    % export_fig( sprintf('Orpheus3D %d',iteration),...
    %    '-png', '-transparent', '-m12', '-q101');


end