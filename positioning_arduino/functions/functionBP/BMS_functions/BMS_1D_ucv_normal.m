function [ UCV ] = BMS_1D_ucv_normal(X, h)
%BMS_UCV Bandwidth Matrix Selection using Unbiased cross-validation
%   H = BMS_ucv(X, H)

% X is now a column vector
[n, d] = size(X);

% arg1
arg1 = 0;
for i = 1:n
    for ii=1:n
        if i~=ii
            %0.000193 seconds per operation
            arg1 = arg1 + phi2H(X(i,:)-X(ii,:), h) - 2*phiH(X(i,:)-X(ii,:), h);
        end
    end
end

UCV = n^-1*(n-1)^-1*arg1 + n^-1*(4*pi)^(-d/2)*det(h)^(-1/2);



%Local Functions:
    function a = phiH(x, H)
        a=det(H)^(-1/2)*kernel_gaus(H^(-1/2)*x');
    end

    function a = phi2H(x, H)
        a=det(2*H)^(-1/2)*kernel_gaus((2*H)^(-1/2)*x');
    end

    function a = kernel_gaus(x)
        a = (2*pi)^(-2/2)*exp(-(x'*x)/2);
    end

end

