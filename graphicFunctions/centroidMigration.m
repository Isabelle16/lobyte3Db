function [tx,ty,ts]=centroidMigration(glob)

%created by Stephan
%calculates migration of centroid in x-direction, y-direction and true
%direction, all vs time window

ni=length(glob.centroidX); %number of iterations
T=1:ni-1; %total number of time steps

tx=NaN(ni-1,ni-1); %movement centroid in x direction vs time window
ty=NaN(ni-1,ni-1); %movement centroid in y direction vs time window
ts=NaN(ni-1,ni-1); %seperation centroid vs time window

for t=1:ni-1 %time step
    for i=1:ni-t %number of times centroid migration can be calculated with time step t
        tx(i,t)=glob.centroidX(i+t)-glob.centroidX(i);
        ty(i,t)=glob.centroidY(i+t)-glob.centroidY(i);
        ts(i,t)=glob.centroidSeperation(i+t)-glob.centroidSeperation(i);
    end
end

meantx=mean(abs(tx),'omitnan');
meanty=mean(abs(ty),'omitnan');
meants=mean(abs(ts),'omitnan');

%Plot results

figure

hold all
plot(T,meantx);
plot(T,meanty);
plot(T,meants);

xlabel('Time step')
ylabel('Mean centroid migration')
legend('Centroid migration x-direction','Centroid migration y-direction','Centroid migration')

end