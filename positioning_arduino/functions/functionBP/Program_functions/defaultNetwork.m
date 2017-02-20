function [  ] = defaultNetwork( Anchors, Devices )
%DEFAULTNETWORK Summary of this function goes here
%   Detailed explanation goes here

figure
hold on
plot(Devices(1,1), Devices(1,2) ,'ob', 'MarkerFaceColor', 'k', 'MarkerSize', 10)
plot(Devices(2,1), Devices(2,2) ,'ob', 'MarkerFaceColor', 'k', 'MarkerSize', 10)
plot(Anchors(1,1), Anchors(1,2) ,'or')
plot(Anchors(2,1), Anchors(2,2) ,'og')
plot(Anchors(3,1), Anchors(3,2) ,'oy')
plot([Devices(1,1) Devices(2,1)],[Devices(1,2) Devices(2,2)])
plot([Devices(1,1) Anchors(1,1)],[Devices(1,2) Anchors(1,2)])
plot([Devices(1,1) Anchors(2,1)],[Devices(1,2) Anchors(2,2)])
plot([Anchors(2,1) Devices(2,1)],[Anchors(2,2) Devices(2,2)])
plot([Anchors(3,1) Devices(2,1)],[Anchors(3,2) Devices(2,2)])

grid
axis([0 60 0 70])
xlabel('Horizontal Distance (m)')
ylabel('Vertical Distance (m)')
title('Network Topology')
legend('Device 1' ,'Device 2' ,'Anchor 1' ,'Anchor 2', 'Anchor 3')
end

