function plot_crossSectionPAPER(glob, depos, xCross, yCross)

%% Draw a strike-oriented cross section of the deposit at y = xCross

% scrsz = get(0,'ScreenSize'); % screen dimensions vector
% ffTwo = figure('Visible','on','Position',[1 1 (scrsz(3)*0.8) (scrsz(4)*0.8)]);
% 
% y = yCross; % y coord of the cell from which start deposition
% subplot(2,1,1);
% 
% % Find limits of deposition of transported sediment
%     leftStart = glob.ySize-1;
%     rightEnd = 0;
%     for x = 1:glob.ySize-1
%         for t = 2:glob.maxIt-1 
%             if depos.transThickness(y, x, t) > 0.001 && x < leftStart
%                 leftStart = x;
%             end
%             if depos.transThickness(y, x, t) > 0.001 && x > rightEnd
%                 rightEnd = x;
%             end
%         end
%     end
% 
% % Draw the strike-oriented cross-section diagram
% for t = 2:glob.maxIt-1 
%     
%     flowColour(t, 1:3) = [1 rand 0]; % Create and record a random colour for the flows in this time layer
%     
%     for x = leftStart:rightEnd   
%           unitBaseLeft = depos.elevation(y, x-1, t-1);
%           unitBaseMid = depos.elevation(y, x,t-1);
%           unitBaseRight = depos.elevation(y, x+1, t-1);
%           transUnitTopLeft = depos.elevation(y,x-1, t-1) + depos.transThickness(y, x-1, t);
%           transUnitTopMid = depos.elevation(y, x, t-1) + depos.transThickness(y, x, t);
%           transUnitTopRight = depos.elevation(y,x+1, t-1) + depos.transThickness(y, x+1, t);
% 
%           if depos.transThickness(y,x,t) > 0.001 % so thickness threshold to plot depos is 1mm  
%               % So a pinchout to below threshold thickness in point to the left
%               if x > 1 && depos.transThickness(y,x-1,t) < 0.001 
%                     xco = [x-1 x x];
%                     zco = [unitBaseLeft transUnitTopMid, unitBaseMid];
%                     patch(xco, zco, depos.faciesColour(t,:), 'EdgeColor','none');   
%               end
%               xco = [x x+1 x+1 x];  % 4 vertices coordinates clockwise 
%               zco = [transUnitTopMid transUnitTopRight, unitBaseRight unitBaseMid];
%               patch(xco, zco, depos.faciesColour(t,:), 'EdgeColor','none');
% 
%             end
%           
%             % Finally in the loop, draw the hemipelagic strata
%             xco = [x x+1 x+1 x];
%             zco = [transUnitTopMid transUnitTopRight depos.elevation(y,x+1,t) depos.elevation(y,x,t)];
%             patch(xco, zco, [0.7 0.7 0.7], 'EdgeColor','none');
%      end
% end
% 
% ax = gca;
% xlabel('Strike Distance (km)');
% ylabel('Elevation (m)');
% 
% ax.LineWidth = 0.5;
% ax.FontSize = 12;
% axis tight
% grid off
% 
% subplot(2,1,2);

% % Draw the strike-oriented chronostrat diagram
% for t = 2:glob.maxIt-1
%     
%      % Draw the flow centroid time series first so this is in the plot background
%      line([leftStart + glob.centroidSeperation(t-1) leftStart + glob.centroidSeperation(t)], [t-1 t], 'color',[0 0.2 1.0], 'LineWidth',0.5);
%     
%      zco = [t t t-1 t-1];
%      for x = 1:glob.xSize-1
%           if depos.transThickness(y,x,t) > 0.001 % so thickness threshold to plot depos on chronostrat is 1mm
%                 xco = [x x+1 x+1 x];  % 4 vertices coordinates clockwise       
%                 patch(xco, zco, depos.faciesColour(t,:), 'EdgeColor','none');
%           end
%      end
% end
% 
% ax = gca;
% xlabel('X Distance (km)');
% ylabel('Geological time (it #)');
% 
% ax.LineWidth = 0.5;
% ax.FontSize = 12;
% axis tight
% grid on


%% Draw a dip-oriented cross section of the deposit

scrsz = get(0,'ScreenSize'); % screen dimensions vector
ffThree = figure('Visible','on','Position',[10 10 (scrsz(3)*0.8) (scrsz(4)*0.8)]);

x = xCross; % y coord of the cell from which start deposition
subplot(2,1,1);

% Find limits of deposition of transported sediment
    leftStart = glob.ySize-1;
    rightEnd = 0;
    for y = 1:glob.ySize-1
        for t = 2:glob.maxIt-1 
            if depos.transThickness(y, x, t) > 0.001 && y < leftStart
                leftStart = y;
            end
            if depos.transThickness(y, x, t) > 0.001 && y > rightEnd
                rightEnd = y;
            end
        end
    end

for t = 2:glob.maxIt-1 
    
    flowColour(t, 1:3) = [1 rand 0]; % Create and record a random colour for the flows in this time layer
    
    for y = leftStart: rightEnd

          unitBaseLeft = depos.elevation(y-1, x, t-1);
          unitBaseMid = depos.elevation(y, x,t-1);
          unitBaseRight = depos.elevation(y+1, x, t-1);
          transUnitTopLeft = depos.elevation(y-1,x, t-1) + depos.transThickness(y-1, x, t);
          transUnitTopMid = depos.elevation(y, x, t-1) + depos.transThickness(y, x, t);
          transUnitTopRight = depos.elevation(y+1,x, t-1) + depos.transThickness(y+1, x, t);
         
          if depos.transThickness(y,x,t)  > 0.001 % so thickness threshold to plot depos is 1mm

              % So a pinchout to below threshold thickness in point to the left
              if y > 1 && depos.transThickness(y-1,x,t) < 0.001 
                    yco = [y-1 y y];
                    zco = [transUnitTopLeft transUnitTopMid, unitBaseMid];
                    patch(yco, zco, depos.faciesColour(t,:), 'EdgeColor','none');
              end
              
              yco = [y y+1 y+1 y];  % 4 vertices coordinates clockwise 
              zco = [transUnitTopMid transUnitTopRight, unitBaseRight unitBaseMid];
              patch(yco, zco, depos.faciesColour(t,:), 'EdgeColor','none');
        end
          
        % Finally in the loop, draw the hemipelagic strata
        yco = [y y+1 y+1 y];
        zco = [transUnitTopMid transUnitTopRight depos.elevation(y+1,x,t) depos.elevation(y,x,t)];
        patch(yco, zco, [0.7 0.7 0.7], 'EdgeColor','none');
     end
end

ax = gca;
xlabel('Dip Distance (km)');
ylabel('Elevation (m)');

ax.LineWidth = 0.5;
ax.FontSize = 12;
axis tight
grid off

subplot(2,1,2);

% % Draw the dip-oriented chronostratigraphic diagram
% for t = 2:glob.maxIt-1
%     
%     % Draw the flow centroid time series first so this is in the plot background
%     line([leftStart + glob.centroidSeperation(t-1), leftStart + glob.centroidSeperation(t)], [t-1 t], 'color',[0 0.2 1.0], 'LineWidth',0.5);
%     
%     zco = [t t t-1 t-1];
%     for y = 1:glob.ySize-1
%           if depos.transThickness(y,x,t) > 0.001 % so thickness threshold to plot depos on chronostrat is 1mm
%                 yco = [y y+1 y+1 y];  % 4 vertices coordinates clockwise 
%                 patch(yco, zco, depos.faciesColour(t,:), 'EdgeColor','none');
%           end
%     end
% end
% 
% ax = gca;
% xlabel('Y Distance (km)');
% ylabel('Geological time (it #)');
% 
% ax.LineWidth = 0.5;
% ax.FontSize = 12;
% axis tight
% grid on

%% Save image using save_fig
% set(ffOne,'Color','none'); % set transparent background
% set(gca,'Color','none');

% export_fig( sprintf('OrpheusCrossSection %d',iteration),...
%    '-png', '-transparent', '-m12', '-q101');
end



