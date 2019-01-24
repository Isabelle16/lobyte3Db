function plot_3DView(depos,trans, glob, topog, iteration)

ffOne = figure(1);

%% Draw the top basement using surface (plot initial topography)
% mymapcoast;  
plotLastSurface = depos.elevation(:,:,1);
pp=surface(plotLastSurface);  
shading('flat'); 
set(pp,'LineStyle','none');

% %set(pp,'FaceAlpha',0.5);
% set(pp,'specularexponent',100.,'specularstrength',0.0); 
% set(pp,'diffusestrength',[0.9],'Ambientstrength',0.3); 
% colormap(cc);
% %put light and shading 
% camlight(18,5); 
% colormap(cc); 
% set(gcf,'PaperUnits','centimeters'); 
% set(gcf,'PaperPosition',[0. 0. 9. 9.]);

%% Draw basement
l = min(min(plotLastSurface)) - 20;
for x = glob.xSize
    for y = 1:glob.ySize-1
        xc = [x x x x];
        yc = [y y+1 y+1 y];
        zc = [l l plotLastSurface(y,x) plotLastSurface(y,x)];
        patch(xc,yc,zc,[177  179  179]./255,'EdgeColor','none');

    end
end

for x = 1:glob.xSize-1
    for y = glob.ySize
        xc = [x x+1 x+1 x];
        yc = [y y y y];
        zc = [l l plotLastSurface(y,x) plotLastSurface(y,x)];
        patch(xc,yc,zc,[177  179  179]./255,'EdgeColor','none');

    end
end

for x = 1
    for y =1:glob.ySize-1
        xc = [x x x x];
        yc = [y y+1 y+1 y];
        zc = [l l plotLastSurface(y,x) plotLastSurface(y,x)];
        patch(xc,yc,zc,[177  179  179]./255,'EdgeColor','none');

    end
end

for x = 1:glob.xSize-1
    for y = 1
        xc = [x x+1 x+1 x];
        yc = [y y y y];
        zc = [l l plotLastSurface(y,x) plotLastSurface(y,x)];
        patch(xc,yc,zc,[177  179  179]./255,'EdgeColor','none');

    end
end


% %% Draw Sea Level
% SL = 70; %% not in agreement with the real topography
% z = SL;
% x = 1:glob.xSize;
% y = 1:glob.ySize;
% zco = [z z z z];
% xco = [x(1) x(end) x(end) x(1)];
% yco = [y(1) y(1) y(end) y(end)];
% patch(xco,yco,zco,[0  1  1],'FaceAlpha',0.15,'EdgeColor','none');


%% Draw the sediment deposit using patch 
fr = 1;

 for t = 2:glob.maxIt %: maxEvent; %for the first deposit event 
   for y = 1:glob.ySize-1
      for x = 1:glob.xSize-1                 
        if depos.elevation(y,x,t) > depos.elevation(y,x,t-1)
             yco = [y y y+1 y+1];  % 4 vertices coordinates clockwise 
             xco = [x x+1 x+1 x];
             zco = [depos.elevation(y,x,t), depos.elevation(y,x,t), depos.elevation(y,x,t), depos.elevation(y,x,t)];
             %patch(xco,yco,zco,[1-(t/glob.maxIt) t/glob.maxIt 0]); 
             patch(xco,yco,zco,[1-(t/glob.maxIt) t/glob.maxIt 0]); 
        end     
        

      end 
   end
   
%         myMovie(fr) = getframe;
%        fr = fr + 1; 

 end




%% General
view([220 60]);
set(pp,'LineStyle','none');

ax = gca;
xlabel('X Distance (km)');
ylabel('Y Distance (km)');
zlabel('Z (m)')
% ax.XTick = [1 633.8 1267.6 1901.4 2535.2 3169];
% ax.XTickLabel = [0 20 40 60 80 100];
% ax.YTick = [1 633.8 1267.6 1901.4 2535.2 3169];
% ax.YTickLabel = [0 20 40 60 80 100];


ax.LineWidth = 0.5;
ax.FontSize = 21;
% ax.FontWeight = 'bold';
axis tight
grid off

% % shading flat
% lightangle(250,30)
% pp.FaceLighting = 'gouraud'; % 'flat';
% pp.AmbientStrength = 0.9;
% pp.DiffuseStrength = 0.8;
% pp.SpecularStrength = 0.9;
% pp.SpecularExponent = 25;
% % pp.BackFaceLighting = 'unlit';
% % material metal

ZLimits = [min(min(plotLastSurface)) max(max(plotLastSurface))];
demcmap(ZLimits)

% c = colorbar;
% c.Label.String ='Z (m)';
% c.FontSize = 18;
% % hold on
% % contour3(plotLastSurface)

% %% Set figure position and dimension
% width = 125;     % Width in inches
% height = 85;    % Height in inches
% set(ffOne, 'Position', [0.5 0.5 width*17, height*9]); % <- Set size

%% Save image using save_fig
set(ffOne,'Color','none'); % set transparent background
set(gca,'Color','none');

% export_fig( sprintf('Lobyte3D %d',iteration),...
%    '-png', '-transparent', '-m12', '-q101');



end