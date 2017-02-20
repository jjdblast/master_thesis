function [ arduino ] = initArduino( port )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
clear arduino;
arduino = serial(port,'BaudRate',115200);
fclose(arduino);
end

