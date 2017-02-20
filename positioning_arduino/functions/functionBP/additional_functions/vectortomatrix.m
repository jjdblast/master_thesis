function [ matrix ] = vectortomatrix(length_x, length_y, vector )
%VECTORTOMATRIX Function that converts a vector into a matrix
%   matrix = vectortomatrix(length_x, length_y, vector)

for i=1:length_x
    matrix(:,i) = vector(1+length_x*(i-1): length_x*(i-1)+length_y);
    %es=[estimation(1:21), estimation(22:42), ]
end

end

