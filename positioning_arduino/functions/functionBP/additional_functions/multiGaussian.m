function [ y ] = multiGaussian(vx, x, H)
%KDE3D Multivariate Kernel Density Estimation
%    Non-parametric way to estimate the probability density function of a
%    random variable without the weight
%
%    multikde(vx, x, H)
%    Inputs:
%    vx: points where we want to estimate that density (only the first two
%    rows)
%    x: distribution with the unknown density f that we want to estimate
%    (only the first two rows)
%    H: matrix bandwidth of the kernel

vx = vx(:,1:2);
x = x(:,1:2);

[size_y, ~] = size(vx);

y = zeros(size_y,1);

for ii = 1:size_y
    y(ii) = KH(vx(ii,:)-x,H);
end
 



%Local Functions:
    function a = KH(x, H)
        a=det(H)^(-1/2)*kernel_gaus(H^(-1/2)*x');
    end

    function a = kernel_gaus(x)
        a = (2*pi)^(-2/2)*exp(-(x'*x)/2);
    end


end

