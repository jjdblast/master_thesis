function [ UCV ] = BMS_scv_normal(X, H, G)
%BMS_UCV Bandwidth Matrix Selection using Smooth cross-validation
%   H = BMS_ucv(X, H)
%   G is the pilot bandwidth matrix

[n, d] = size(X);


% arg1
arg1 = 0;
for i = 1:n
    for ii=1:n
        if i~=ii
            arg1 = arg1 + phiX(X(i,:)-X(ii,:), 2*H + 2*G) ...
                - 2*phiX(X(i,:)-X(ii,:), H+2*G) ... 
                + phiX(X(i,:)-X(ii,:), 2*G);
        end
    end
end

UCV = n^-1*(n-1)^-1*arg1 + n^-1*(4*pi)^(-d/2)*det(H)^(-1/2);



%Local Functions:
    function a = phiX(x, matrix)
        a=det(matrix)^(-1/2)*kernel_gaus(matrix^(-1/2)*x');
    end

    function a = kernel_gaus(x)
        a = (2*pi)^(-2/2)*exp(-(x'*x)/2);
    end

end

