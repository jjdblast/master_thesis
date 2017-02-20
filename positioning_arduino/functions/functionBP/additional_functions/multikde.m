function [ y ] = multikde(vx, x, H, mode)
%KDE3D Multivariate Kernel Density Estimation
%    Non-parametric way to estimate the probability density function of a
%    random variable
%
%    multikde(vx, x, H)
%    Inputs:
%    vx: points where we want to estimate that density (only the first two
%    rows)
%    x: distribution with the unknown density f that we want to estimate
%    (only the first two rows)
%    H: matrix bandwidth of the kernel

vx = vx(:,1:2);
w = x(:,3);
x = x(:,1:2);
[n, ~] = size(x);
y = zeros(length(vx),1);

for ii = 1:length(vx)
    suma = 0;
    for i=1:n
        suma = suma + w(i).*KH(vx(ii,:)-x(i,:),H);
    end
    y(ii) = suma;
end
    


%Local Functions:
    function a = KH(x, H)
        a=det(H)^(-1/2)*kernel_gaus(H^(-1/2)*x');
        %a=det(H)^(-1/2)*kernel_gaus((pinv(H)^-2)*x');
    end

    function a = kernel_gaus(x)
        a = (2*pi)^(-2/2)*exp(-(x'*x)/2);
    end


end

