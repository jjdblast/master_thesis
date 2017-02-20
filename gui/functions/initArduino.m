function [ arduino ] = initArduino( port, handles )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
clear arduino;
pause(0.1);
updatePorts(handles);
pause(0.05);
arduino = serial(port,'BaudRate',115200);
fclose(arduino);
end

