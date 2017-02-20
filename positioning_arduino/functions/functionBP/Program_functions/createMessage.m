function [ message ] = createMessage(message, anchor, nsamples)
%CREATEMESSAGE Summary of this function goes here
%   Message from node2 to node1

    
    %Creation of message
    r = message;
    ang = (rand(nsamples,1)*360);

    message(:,1) = repmat(anchor(1,1),nsamples,1) + r.*cosd(ang);
    message(:,2) = repmat(anchor(1,2),nsamples,1) + r.*sind(ang);
    message(:,3) = 1/nsamples;


end

