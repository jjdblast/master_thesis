function [ y ] = kde(vx, x, h, mode)
%KDE Kernel Density Estimation
%    Non-parametric way to estimate the probability density function of a
%    random variable
%
%    kde(X, H)
%    Inputs:
%    X: distribution with the unknown density f that we want to estimate
%    H: bandwidth of the kernel


n = length(x);
w = x(:,2);
x = x(:,1);


%Kernel Functions:
%Uniform:
if strcmp(mode, 'uni') == 1
    for ii = 1:length(vx)
    suma = 0;
        for i = 1:n
            arg = (vx(ii)-x(i))/h;
            suma = suma + w(i).*kernel_uni(arg);
        end
    y(ii) = 1/n/h*suma;
    end
end

%Gaussian
if strcmp(mode, 'gaus') == 1
    for ii = 1:length(vx)
    suma = 0;
        for i = 1:n
            arg = (vx(ii)-x(i))/h;
            suma = suma + w(i).*kernel_gaus(arg);
        end
    y(ii) = 1/n/h*suma;
    end
end



%Local Functions:
    function a = kernel_uni(x)
        if abs(x) <= 1
            a = 1/2;
        else
            a = 0;
        end
    end

    function a = kernel_gaus(x)
        a = 1/sqrt(2*pi)*exp(-x^2/2);
    end

end

