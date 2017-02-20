function [  ] = displayAnchors( handles_axes, list_of_devices )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

number_of_devices = size(list_of_devices,1);

% Plot Coordinates (see list_of_devices structure for more info)
device_str = list_of_devices(:,2);
x_str_coords = list_of_devices(:,3);
x_coords = str2double(x_str_coords);
y_str_coords = list_of_devices(:,4);
y_coords = str2double(y_str_coords);
% z_str_coords = list_of_devices(:,5);
% z_coords = str2double(z_str_coords);

% In the map
axes(handles_axes);
hold(handles_axes, 'on');
grid(handles_axes, 'on');

p1= plot(handles_axes, x_coords,y_coords,'o','Color',[0.7529  0 0], 'MarkerFaceColor', [0.7529  0 0], 'MarkerSize', 10,'DisplayName','Anchors');   

for i = 1:number_of_devices
    
    %+- 500 mm of marging
    marging = 500;
    axis([min(x_coords)-marging max(x_coords)+marging min(y_coords)-marging max(y_coords)+marging]);
    % A fancy arrow
    info = strcat({'\leftarrow Anchor: '}, device_str{i});
    info2 = strcat ('(', x_str_coords{i}, ',', y_str_coords{i}, ')');
    text(x_coords(i), y_coords(i), info);
    text(x_coords(i), y_coords(i)-0.07*(max(y_coords)+marging), info2);    
end
legend(handles_axes,'-DynamicLegend');
end

