function [ y ] = multikde2(c_x, c_y, x, H)
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

[nx, ny] = size(c_x);
ni = nx*ny;

%vx = [c_x, c_y];
w = x(:,3);
x = x(:,1:2);
[n, ~] = size(x);

for ii = 1:nx
    for iii = 1:ny
        vx(1,:) = [c_x(ii,iii), c_y(ii,iii)];
        suma = 0;
        for i=1:n
            suma = suma + w(i).*KH(vx(1,:)-x(i,:),H);
        end
        y(ii,iii) = suma;
    end
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

