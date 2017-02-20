function [ vector ] = vech( matrix )
%VECH Vector half operator
%   Vech(H) is the lower triangular half of H strung out column-wise into a
%   vector

y = matrix';
vector = y(triu(true(size(y)),0));


end

