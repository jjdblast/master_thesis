function [ ] = changeVisibility( handles, value )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% Set the Enable property to the buttons/boxes to value (on/off)
set(handles.list_of_ports, 'Enable', value);
set(handles.update_button, 'Enable', value);
set(handles.samples_text, 'Enable', value);
set(handles.calibrate_button, 'Enable', value);
set(handles.start_button, 'Enable', value);
% set(handles.list_of_anchors_pop, 'Enable', value);
% set(handles.list_of_algos_pop, 'Enable', value);
% When something is done, re-write the buttons
if(strcmp(value,'on'))
    set(handles.calibrate_button, 'String', 'Calibrate');
    set(handles.start_button, 'String', 'Positioning');
end

end

