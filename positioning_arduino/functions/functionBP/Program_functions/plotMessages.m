function [  ] = plotMessages( Anchors, Devices, messages, size_network )
%PLOTMESSAGES Summary of this function goes here
%   Detailed explanation goes here

num_anchors = length(Anchors);
num_devices = length(Devices);

figure
hold all
newleg = {};

for i = 1:num_devices
    for j = 1:length(messages)
        if messages{i,j} ~= 1
            %pause
            plot(messages{i,j}(:,1), messages{i,j}(:,2), '*');
            if j <= num_anchors
                newleg{length(newleg)+1} = sprintf('From Anchor %d to Device %d', j,i);
            else
                newleg{length(newleg)+1} = sprintf('From Device %d to Device %d', j-num_anchors,i);
            end
        end
    end
end

for i = 1:num_anchors
    plot(Anchors(i,1), Anchors(i,2), 'o')
    newleg{length(newleg)+1} = sprintf('Anchor %d', i);
end
for i = 1:num_devices
    newleg{length(newleg)+1} = sprintf('Device %d', i);
    plot(Devices(i,1), Devices(i,2), 'o', 'MarkerFaceColor', 'k', 'MarkerSize', 10)
end
legend(newleg);
%axis([size_network(1,1) size_network(1,2) size_network(2,1) size_network(2,2)])


end

