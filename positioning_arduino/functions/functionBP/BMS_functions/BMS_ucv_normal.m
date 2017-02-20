function [ UCV ] = BMS_ucv_normal(X, H_fix)
%BMS_UCV Bandwidth Matrix Selection using Unbiased cross-validation
%   H = BMS_ucv(X, H)

%Take only the first two rows, not the weight
X = X(:,1:2);
[n, d] = size(X);

H = [H_fix(1) H_fix(3); H_fix(3) H_fix(2)];
if H_fix(3) < sqrt(H_fix(1)*H_fix(2))
    %Problema, determinante negativo
    H_fix(3) = min([H_fix(1), H_fix(2)])/10; 
end


% arg1
arg1 = 0;
for i = 1:n
    for ii=1:n
        if i~=ii
            %0.000193 seconds per operation
            arg1 = arg1 + phi2H(X(i,:)-X(ii,:), H) - 2*phiH(X(i,:)-X(ii,:), H);
        end
    end
end

UCV = n^-1*(n-1)^-1*arg1 + n^-1*(4*pi)^(-d/2)*det(H)^(-1/2);



%Local Functions:
    function a = phiH(x, H)
        %a=det(H)^(-1/2)*kernel_gaus(H^(-1/2)*x');
        a=det(H)^(-1/2)*kernel_gaus((pinv(2*H)^-2)*x');
    end

    function a = phi2H(x, H)
        %a=det(2*H)^(-1/2)*kernel_gaus((2*H)^(-1/2)*x');
        a=det(2*H)^(-1/2)*kernel_gaus((pinv(2*H)^-2)*x');
    end

    function a = kernel_gaus(x)
        a = (2*pi)^(-2/2)*exp(-(x'*x)/2);
    end

end
