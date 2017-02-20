function [ H ] = BMS_silverman(X)
%BMS_SILVERMAN Bandwidth Matrix Selection using Silverman's rule of thumb
%   H = BMS_silverman(X)
%   X must be a vector:
%   [x1]
%   [x2]
%   [x3]
%   ...
%   [xn]
%   And each component xi must be another vector: [xi1 xi2 .. xid]
%   IMPORTANT: NOW IT IS ONLY IMPLEMENTED FOR d=2

[n, d] = size(X);
d=2;

sigma_x = std(X(:,1));
sigma_y = std(X(:,2));

Hx = (  4/(d+2))^(1/(d+4))*n^(-1/(d+4))*sigma_x;
Hy = (4/(d+2))^(1/(d+4))*n^(-1/(d+4))*sigma_y;
H = [Hx^2, 0; 0, Hy^2];


end

