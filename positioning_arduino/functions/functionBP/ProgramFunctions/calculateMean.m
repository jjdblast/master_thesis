function [ output ] = calculateMean( message )
%CALCULATEMEAN Summary of this function goes here
%   Detailed explanation goes here

% message:
% column1: x
% column2: y
% column3: weights

xy = message(:,1:2);
w = message(:,3);

[N, ~] = size(message);

suma = 0;
for i = 1:N
    suma = suma + w(i).*(xy(i,:));
end

output = suma;

end

