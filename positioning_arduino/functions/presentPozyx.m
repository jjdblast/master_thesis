function [ ] = presentPozyx( handles, tag )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% TAG
% One out of number_of_devices+1 rows of READ contains the tag positions x,y
% Plot the estimated position of the tag
axes(handles.axes_algo);
plot(handles.axes_algo, mean(tag(:,1)), mean(tag(:,2)),'x','Color',[0.098 0.4784 0.5176], 'MarkerFaceColor', [0.098 0.4784 0.5176], 'MarkerSize', 10, 'LineWidth', 3,'DisplayName','Pozyx');
% info = {'\leftarrow Pozyx'};
% info2 = strcat ('(', num2str(round(mean(tag(:,1)),0)), ',', num2str(round(mean(tag(:,2)),0)), ')');
% And label it
% text(mean(tag(:,1)), mean(tag(:,2)), info)
% text(mean(tag(:,1)), mean(tag(:,2))-175, info2)
legend(handles.axes_algo, '-DynamicLegend');

set(handles.list_of_algos_pop, 'Value', 1);
algos = get(handles.list_of_algos_pop, 'String');
set(handles.list_of_algos_pop, 'String', 'Pozyx');
set(handles.list_of_algos_pop, 'String', algos);

info = strcat ('Estimator: (', num2str(round(mean(tag(:,1)),0)), ',', num2str(round(mean(tag(:,2)),0)), ')');
set(handles.text_algo_estimator, 'String', info);


end

