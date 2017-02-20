function [ Finished ] = checkIfFinished(isLimitedBySamples, nSamples, isLimitedByTime, nTime, isStopped, READ, times_vector)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% In principle, is not finished
Finished = 0;

% We stop measuring:
% - if is limited by samples and the nSamples is greater than the number of
% rows of READ
if (isLimitedBySamples && length(READ) >= nSamples)
    Finished = 1;
end

% - if is limited by time and the nTime is greater than the last time
if (isLimitedByTime && times_vector(end) >= nTime)
    Finished = 1;
end

% If finished, update the String of the button
if (Finished==1)
    READ
end

end

