function [ port ] = updatePorts( handles )
%UNTITLED Summary of this function goes here
% Update the available list_of_ports
clear serialInfo;
serialInfo = instrhwinfo('serial');

% If it is empty, disable calculate function
if (isempty(serialInfo.AvailableSerialPorts))
    set(handles.list_of_ports, 'String', 'No ports');
    port = '0';
    delete(instrfind('Type', 'serial')); 
    delete(instrfind({'Port'},{port}));
    changeVisibility(handles, 'off');
    set(handles.list_of_ports, 'Enable', 'on');
    set(handles.update_button, 'Enable', 'on');
    
% If not, fill the list with the available ports and set, clear it and
% initialize and arduino with it
else
    set(handles.list_of_ports, 'String', serialInfo.AvailableSerialPorts);
    clear port;
    contents = cellstr(get(handles.list_of_ports,'String'));
    port = contents{get(handles.list_of_ports,'Value')};

    % Visible list
    changeVisibility(handles, 'on');
    % delete previous ports
    delete(instrfind('Type', 'serial'));   
    delete(instrfind({'Port'},{port}));
end
end

