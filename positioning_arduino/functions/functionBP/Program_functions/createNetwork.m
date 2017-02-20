function [ Anchors, Devices, names, size_network ] = createNetwork( num_anchors,num_devices,reply )
%CREATENETWORK Summary of this function goes here
%   Detailed explanation goes here
Anchors = zeros(num_anchors,2);
Devices = zeros(num_devices,2);
%Size of the area: a x d in which the anchors can be
a = 0; b = 100;
c = 0; d = 100;
size_network = [0 120; 0 120];
%Size of the area: aa x dd in which the devices can be
%Must be smaller than the area before
aa = 20; bb = 80;
cc = 20; dd = 80;


if reply == 'Y'
    for i = 1:num_anchors
        Anchors(i,:) = [a + (b-a).*rand(1), c + (d-c).*rand(1)];
    end
    for i = 1:num_devices
        Devices(i,:) = [aa + (bb-aa).*rand(1), cc + (dd-cc).*rand(1)];
    end    
elseif reply == 'N'
    figure
    grid
    axis([a b c d])
    xlabel('Horizontal Distance (m)')
    ylabel('Vertical Distance (m)')
    title('Network Topology')
    disp('Select the anchors')
    Anchors = ginput(num_anchors)
    plot(Anchors(:,1), Anchors(:,2), 'o')
    grid
    axis([a b c d])
    disp('Select the devices')
    Devices = ginput(num_devices)
    close
else
    disp('Answer should be Y or N')
end

figure
% hold on
% plot(Anchors(:,1), Anchors(:,2), 'or')
% plot(Devices(:,1), Devices(:,2), 'ob', 'MarkerFaceColor', 'k', 'MarkerSize', 10)
% 
% legend('Anchors', 'Devices');
hold all
newleg = {};
for i = 1:num_anchors
    plot(Anchors(i,1), Anchors(i,2), 'o')
    newleg{length(newleg)+1} = sprintf('Anchor %d', i);
end
for i = 1:num_devices
    newleg{length(newleg)+1} = sprintf('Device %d', i);
    plot(Devices(i,1), Devices(i,2), 'o', 'MarkerFaceColor', 'k', 'MarkerSize', 10)
end
legend(newleg);

grid
axis([a b c d])
xlabel('Horizontal Distance (m)')
ylabel('Vertical Distance (m)')
title('Network Topology')


names = {};
for i = 1:num_anchors
    names{length(names)+1} = sprintf('Anchor %d', i);
end
for i = 1:num_devices
    names{length(names)+1} = sprintf('Device %d', i);
end

%
%newleg = {};
%for i = 1:num_anchors
%    plot(Anchors(i,1), Anchors(i,2), 'o')
%    newleg{length(newleg)+1} = sprintf('Anchor %d', i);
%end
%for i = 1:num_devices
%    newleg{length(newleg)+1} = sprintf('Device %d', i);
%    plot(Devices(i,1), Devices(i,2), 'o', 'MarkerFaceColor', 'k', 'MarkerSize', 10)
%end
%legend(newleg);

end

