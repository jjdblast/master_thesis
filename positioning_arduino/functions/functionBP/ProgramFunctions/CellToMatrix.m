function [ dataMatrix ] = CellToMatrix( dataCell )
%CELLTOMATRIX Function to transform the positions given in a cell to a
%matrix

dataMatrix = zeros(length(dataCell),2);

for i = 1:length(dataCell)
    dataMatrix(i,:) = dataCell{i}';
end
    

end

