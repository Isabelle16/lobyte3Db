function plotVerticalSectionAndChronostratsPAPER(glob, depos, x, y)
% Draw a single vertical section at point x,y on the grid. Colour code
% units a random shade red-to-yellow and assign a random grainsize

scrsz = get(0,'ScreenSize'); % screen dimensions vector
ffFive = figure('Visible','on','Position',[1 1 (scrsz(3)*0.8) (scrsz(4)*0.95)]);

% chronoStartXco = max(depos.proportionThickness) + 50;
vertSectWidth = 40;
chronoStartXco = 50;
chronoWidth = 40;
sedSupplyStartXco = 100;

% Plot the  vertical section, chronostrat, and supply curve
for t = 2:glob.totalIterations 
%  
%       xco = [0 vertSectWidth vertSectWidth 0];
%       zco = [depos.elevation(y,x,t) depos.elevation(y,x,t), depos.elevation(y,x,t-1) depos.elevation(y,x,t-1)];
%       patch(xco, zco, depos.faciesColour(t,:), 'EdgeColor','none');
    % Calculate unit elevations
     baseOfUnit = depos.elevation(y,x,t-1); % top of the unit below
     topOfTransported = baseOfUnit + depos.transThickness(y,x,t);
     topOfUnit = depos.elevation(y,x,t);
    
      % Draw the transported fraction first 
      xco = [0 vertSectWidth vertSectWidth 0];  
      zco = [baseOfUnit baseOfUnit topOfTransported topOfTransported];
      patch(xco, zco, depos.faciesColour(t,:), 'EdgeColor','none');
      
      % Draw the hemipelagic fraction
      xco = [0 vertSectWidth*0.2 vertSectWidth*0.2 0];  
      zco = [topOfTransported topOfTransported topOfUnit topOfUnit];
      patch(xco, zco, [0.7 0.7 0.7], 'EdgeColor','none');

%       if (depos.elevation(y,x,t) - depos.elevation(y,x,t-1)) > 0.001
    if (depos.transThickness(y,x,t) - depos.transThickness(y,x,t-1)) > 0.001
          xco = [chronoStartXco chronoStartXco chronoStartXco+chronoWidth chronoStartXco+chronoWidth];
          zco = [t t+1 t+1 t];
          patch(xco, zco, depos.faciesColour(t,:), 'EdgeColor','none');
      end
      
%       if mod(t, 10) == 0 % Draw a marker line for every tenth iteration when t/10 has remainder 0
%           xco = [0 vertSectWidth chronoStartXco chronoStartXco+chronoWidth];
%           zco = [depos.elevation(y,x,t) depos.elevation(y,x,t) t t];
%           line(xco, zco, 'color', [0 0 0]);
%       end
%       
      xco = [sedSupplyStartXco sedSupplyStartXco + glob.supplyHistory(t-1) sedSupplyStartXco + glob.supplyHistory(t) sedSupplyStartXco];
      zco = [t-1 t-1 t t];
      patch(xco, zco, [0 0.8 0.4], 'EdgeColor','none');
end


ax = gca;
ylabel('Thickness (m)');
ax.LineWidth = 0.5;
ax.FontSize = 12;
axis tight
grid off

% export_fig( sprintf('OrpheusCrossSection %d',iteration),...
%    '-png', '-transparent', '-m12', '-q101');
end



