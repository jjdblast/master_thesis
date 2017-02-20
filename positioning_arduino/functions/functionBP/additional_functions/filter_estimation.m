function [ value, points ] = filter_estimation( estimation, surface_matrix ,thres )
%FILTER_ESTIMATION Summary of this function goes here
%   Detailed explanation goes here

max_value = max(estimation);
min_value = min(estimation);
vector_value = [min_value max_value];
vector_perc = [0 100];
threshold = interp1(vector_perc, vector_value, thres);

ii=1;
for i = 1:length(surface_matrix)
    if estimation(i) >= threshold
        value(ii,:) = estimation(i);
        points(ii,:) = surface_matrix(i,:);
        ii = ii+1;
    end
end


end

