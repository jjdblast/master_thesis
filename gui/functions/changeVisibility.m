function [ ] = changeVisibility( handles, value )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% Set the Enable property to the buttons/boxes to value (on/off)
set(handles.list_of_ports, 'Enable', value);
set(handles.check_limit_samples, 'Enable', value);
set(handles.check_limit_time, 'Enable', value);
set(handles.text_nsamples, 'Enable', value);
set(handles.text_tsamples, 'Enable', value);
set(handles.text_actual_distance, 'Enable', value);
set(handles.calculate_button, 'Enable', value);

if(strcmp(value,'on'))
    set(handles.calculate_button, 'String', 'Range');
end

end

