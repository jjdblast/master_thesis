function [ ] = setAnchors( handles, positions, list_of_distances, nSamples )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    % Empty and fill the list
    set(handles.list_of_anchors_pop, 'Value', 1);
    set(handles.list_of_anchors_pop, 'String', 'Select anchor');
    set(handles.list_of_anchors_pop, 'String', positions(:,1));
    set(handles.list_of_anchors_pop, 'Enable', 'on');
    % Remove those values with values with differe from the mean more
    % than 0.3m which is used for avoiding some errors
    hist_aux = str2double(list_of_distances(1:nSamples,3));
    hist_aux = hist_aux (abs(hist_aux-mean(hist_aux)) < 300);
    hold(handles.axes_pdf, 'on');
    hist(handles.axes_pdf, hist_aux);
    mean_aux = mean(hist_aux);
    variance = var (hist_aux);
    text = strcat('Mean: ', num2str(mean_aux), '. Variance: ', num2str(variance));
    set(handles.text_anchor_data, 'String', text);

end

