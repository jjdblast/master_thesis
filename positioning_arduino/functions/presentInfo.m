function [ tag, positions, list_of_distances ] = presentInfo( list_of_devices, READ, handles )
%UNTITLED2 Summary of this function goes here
% Split the READ data and present the info into three matrixes
% tag: nSamples rows with x and y of the tag measured during nSamples
% positions: number_of_devices rows x 3 columns (id, x, y)
% list_of_distances: number_of_devices*nSamples rows x 3 columns (id, time, distance)

number_of_devices = size(list_of_devices,1);


% TAG
% One out of number_of_devices+1 rows of READ contains the tag positions x,y
tag = str2double(READ(1:number_of_devices+1:end,1:2));
% Plot the estimated position of the tag
axes(handles.map);
plot(handles.map, mean(tag(:,1)), mean(tag(:,2)),'x','Color',[0.098 0.4784 0.5176], 'MarkerFaceColor', [0.098 0.4784 0.5176], 'MarkerSize', 10, 'LineWidth', 3,'DisplayName','Agent');

% And label it
info = strcat ('Pozyx Estimator: (', num2str(round(mean(tag(:,1)),0)), ',', num2str(round(mean(tag(:,2)),0)), ')');
set(handles.text_pozyx_estimator, 'String', info);
% text(mean(tag(:,1)), mean(tag(:,2))-175, info2)
legend(handles.map, '-DynamicLegend');


% POSITIONS
positions = list_of_devices(:,2:4);
% Split info, only second, third and fourth column contains the wanted data
% device_str = list_of_devices(:,2);
% x_str_coords = list_of_devices(:,3);
% x_coords = str2double(x_str_coords);
% y_str_coords = list_of_devices(:,4);
% y_coords = str2double(y_str_coords);
% z_str_coords = list_of_devices(:,5);
% z_coords = str2double(z_str_coords);
% 
% position = cell(number_of_devices,3);
% row = 1;
% for row = 1:number_of_devices
%     position(row,1)=
%     %+- 500 mm of marging
%     marging = 500;
%     axis([min(x_coords)-marging max(x_coords)+marging min(y_coords)-marging max(y_coords)+marging])
%     % A fancy arrow
%     info = strcat({'\leftarrow Anchor: '}, device_str{i});
%     info2 = strcat ('(', x_str_coords{i}, ' , ', y_str_coords{i}, ')');
%     text(x_coords(i), y_coords(i), info)
%     text(x_coords(i)+400, y_coords(i)-300, info2)
% end
% 


% LIST OF DISTANCES
% We eliminate one out of number_of_devices+1 rows from READ
% Outpit matrix, fill the first device measurements (second row until end)
list_of_distances = READ(2:number_of_devices+1:end,:);

% Now for each device (starting from third row)
for index_split = 3:number_of_devices+1
    % Define list_of_devices_aux matrix, reading from index_split one out
    % of number_of_devices+1 rows
    list_of_distances_aux = READ(index_split:number_of_devices+1:end,:);
    % Vertical concatenation with the previous one
    list_of_distances = vertcat(list_of_distances, list_of_distances_aux);
end

% There are algorithms to be presented now
set(handles.list_of_algos_pop, 'Enable','on');
end

