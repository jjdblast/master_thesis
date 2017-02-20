function [ d_hat ] = estimateDistance2Devices(node1, node2, SIGMA, ERROR_TYPE)
%CREATEMESSAGE Summary of this function goes here

%   Message from node2 to node1



if strcmp(ERROR_TYPE,'Gaussian')
    d_hat = norm(node1-node2) + randn()*SIGMA;
elseif strcmp(ERROR_TYPE,'Uniform')
    a=-SIGMA; b=SIGMA;
    message(:,1) = node2(:,1) + a + (b-a).*rand(nsamples,1) + distance.*cosd(ang);  
    message(:,2) = node2(:,2) + a + (b-a).*rand(nsamples,1) + distance.*sind(ang);        
    d_hat = 0;
elseif strcmp(ERROR_TYPE,'Exponential')
    d_hat = norm(node1-node2) - exprnd(1)*SIGMA;
end



end

