function [ vector_out ] = normalizeWeights( vector_in )
%NORMALIZEWEIGHTS Summary of this function goes here
%   Detailed explanation goes here

vector_out = vector_in/sum(vector_in);

end

