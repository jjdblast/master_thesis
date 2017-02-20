function [ y ] = kh_test( c_x, c_y, H )
%KH_TEST Summary of this function goes here
%   Detailed explanation goes here

[nx, ny] = size(c_x);


for ii = 1:nx
    for iii = 1:ny
        x = [c_x(ii,iii), c_y(ii,iii)];
        y(ii,iii) = det(H)^(-1/2)*kernel_gaus(H^(-1/2)*x');
    end
end
 
 
 
 
    function a = kernel_gaus(x)
        a = (2*pi)^(-2/2)*exp(-(x'*x)/2);
    end


end

