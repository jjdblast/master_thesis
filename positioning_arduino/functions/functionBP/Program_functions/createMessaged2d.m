function [ message ] = createMessaged2d(d_hat, node1, node2, belief1, belief2, nsamples, SIGMA, ERROR_TYPE)
%CREATEMESSAGE Summary of this function goes here

%   Message from node2 to node1



if strcmp(ERROR_TYPE,'Gaussian')
    %d_hat = norm(node1-node2) + randn()*SIGMA;
    ang = (rand(nsamples,1)*360);
    message(:,1) = belief2(:,1) + (d_hat + randn(nsamples,1)*SIGMA).*cosd(ang);  
    message(:,2) = belief2(:,2) + (d_hat + randn(nsamples,1)*SIGMA).*sind(ang);  
elseif strcmp(ERROR_TYPE,'Uniform')
    a=-SIGMA; b=SIGMA;
    message(:,1) = node2(:,1) + a + (b-a).*rand(nsamples,1) + distance.*cosd(ang);  
    message(:,2) = node2(:,2) + a + (b-a).*rand(nsamples,1) + distance.*sind(ang);        
elseif strcmp(ERROR_TYPE,'Exponential')
    %d_hat = norm(node1-node2) - exprnd(1)*SIGMA;
    ang = (rand(nsamples,1)*360);
    message(:,1) = belief2(:,1) + (d_hat + exprnd(1,[nsamples, 1])*SIGMA).*cosd(ang);  
    message(:,2) = belief2(:,2) + (d_hat + exprnd(1,[nsamples, 1])*SIGMA).*sind(ang);  
end

message(:,3) = belief2(:,3);


end

