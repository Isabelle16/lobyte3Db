function plotVerticalSectionPAPER(glob, depos, x, y)
% Draw a single vertical section at point x,y on the grid. Colour code
% units a random shade red-to-yellow and assign a random grainsize

scrsz = get(0,'ScreenSize'); % screen dimensions vector
ffFour = figure('Visible','on','Position',[1 1 (scrsz(3)*0.15) (scrsz(4)*0.95)]);

for t = 2:glob.maxIt
    
     % Calculate unit elevations
     baseOfUnit = depos.elevation(y,x,t-1); % top of the unit below
     topOfTransported = baseOfUnit + depos.transThickness(y,x,t);
     topOfUnit = depos.elevation(y,x,t);
    
      % Draw the transported fraction first  
      xco = [0 1 1 0];  
      zco = [baseOfUnit baseOfUnit topOfTransported topOfTransported];
      patch(xco, zco, depos.faciesColour(t,:), 'EdgeColor','none');
      
      % Draw the hemipelagic fraction
      xco = [0 0.2 0.2 0];  
      zco = [topOfTransported topOfTransported topOfUnit topOfUnit];
      patch(xco, zco, [0.7 0.7 0.7], 'EdgeColor','none');
      
%       if mod(t, 10) == 0 % Draw a marker line for every tenth iteration when t/10 has remainder 0
%             line([0 1],[depos.elevation(y,x,t) depos.elevation(y,x,t)], 'color', [0 0 0]);
%       end
end

ax = gca;
ylabel('Thickness (m)');
ax.LineWidth = 0.5;
ax.FontSize = 12;
axis tight
% grid on

% export_fig( sprintf('OrpheusCrossSection %d',iteration),...
%    '-png', '-transparent', '-m12', '-q101');
end



