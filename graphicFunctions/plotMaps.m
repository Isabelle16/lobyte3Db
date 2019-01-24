function plotMaps(glob, depos)

%% Draw maps showing stratigraphic completeness at each xy location, plus other properties

scrsz = get(0,'ScreenSize'); % screen dimensions vector
ffSix = figure('Visible','on','Position',[1, 0, scrsz(3)*0.5, scrsz(4)*0.95]);

% subplot(2,2,1);

% Stratigraphic completeness map
for x = 1:glob.xSize
     for y = 1:glob.ySize
        yco = [y-0.5 y-0.5 y+0.5 y+0.5];  % 4 vertices coordinates clockwise 
        xco = [x-0.5 x+0.5 x+0.5 x-0.5];
        if sum(depos.transThickness(y,x,:)) > 0.01
            colour = [1 depos.stratCompletenessContig(y,x) 0];
            patch(xco, yco, colour, 'EdgeColor','none');
        end
     end
end

ax = gca;
xlabel('Strike Distance (km)');
ylabel('Dip distance (km)');
ax.LineWidth = 0.5;
ax.FontSize = 12;
axis tight
grid on
title('Stratigraphic completeness (contiguous)');

% subplot(2,2,2);
% for x = 1:glob.xSize
%      for y = 1:glob.ySize
%         yco = [y-0.5 y-0.5 y+0.5 y+0.5];  % 4 vertices coordinates clockwise 
%         xco = [x-0.5 x+0.5 x+0.5 x-0.5];
%         if glob.runsAnalysisPValueMap(y,x) >= 0.0 && glob.runsAnalysisPValueMap(y,x) <= 1.0
%             colour = [1 glob.runsAnalysisPValueMap(y,x)*2 0]; % *2 because correct p value should range from 0 to 0.5, so *2 multiplication needed for range 0-1
%             patch(xco, yco, colour, 'EdgeColor','none');
%         end
%      end
% end
% 
% ax = gca;
% xlabel('Strike Distance (km)');
% ylabel('Dip distance (km)');
% ax.LineWidth = 0.5;
% ax.FontSize = 12;
% axis tight
% grid on
% title('Runs analysis P value');
% 
% subplot(2,2,3);
% for x = 1:glob.xSize
%      for y = 1:glob.ySize
%         yco = [y-0.5 y-0.5 y+0.5 y+0.5];  % 4 vertices coordinates clockwise 
%         xco = [x-0.5 x+0.5 x+0.5 x-0.5];
%         if depos.stratCompletenessContig(y,x) > 0 && glob.runsAnalysisPValueMap(y,x) >= 0.0
%             colour = [1 abs(depos.stratCompletenessContig(y,x) - glob.runsAnalysisPValueMap(y,x)) 0];
%             patch(xco, yco, colour, 'EdgeColor','none');
%         end
%      end
% end
% 
% ax = gca;
% xlabel('Strike Distance (km)');
% ylabel('Dip distance (km)');
% ax.LineWidth = 0.5;
% ax.FontSize = 12;
% axis tight
% grid on
% title('Correlation');
% 
% % dumpOut = fopen('correlTest.dat','w');
% % for x = 1:glob.xSize
% %      for y = 1:glob.ySize
% %          fprintf(dumpOut,'%f %f\n', depos.stratCompletenessContig(y,x), glob.runsAnalysisPValueMap(y,x));
% %      end
% % end
% % fclose(dumpOut);
% 
% 
% %% Save image using save_fig
% % set(ffOne,'Color','none'); % set transparent background
% % set(gca,'Color','none');
% 
% % export_fig( sprintf('OrpheusCrossSection %d',iteration),...
% %    '-png', '-transparent', '-m12', '-q101');
end



