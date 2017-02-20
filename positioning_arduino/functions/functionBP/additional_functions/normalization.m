function [ y ] = normalization( x )
%NORMALIZATION Normalization function
%   Given a vector, it calculates the normalization with respect to the max
%   normalization(X)
    
    y = x/max(x);

end

