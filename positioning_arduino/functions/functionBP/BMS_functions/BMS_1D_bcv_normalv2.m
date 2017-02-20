function [ BCV ] = BMS_1D_bcv_normalv2(X, H, version)
%BMS_UCV Bandwidth Matrix Selection using Biased cross-validation
%   H = BMS_ucv(X, H)
%   version is the version of the BCV used, which depends on the manner in
%   which phi4 is estimated

% X is now a column vector
[n, d] = size(X);

x=[];

if version == 1
% To avoid erros:
syms x
    % For the univariate case we have to calculate phi1
    symb_kernel_gaus(x) = (2*pi)^(-2/2)*exp(-(x^2)/2);
    symb_arg1 = (2*H)^(-1/2)*x;
    symb_phi2H(x) = (2*H)^(-1/2)*symb_kernel_gaus(symb_arg1);
    phi1_symb_phi2H(x) = diff(symb_phi2H, x, 1);
%
    arg1 = 0;
    for i = 1:n
        for ii=1:n
            if i~=ii
                %0.00003 seconds per operation
                arg1 = arg1 + n^(-2)*der_phi(X(i,:)-X(ii,:));
            end
        end
    end
BCV = 1/4*vech(H)'*arg1*vech(H) + n^-1*(4*pi)^(-d/2)*det(H)^(-1/2);
end

if version == 2
% To avoid erros:
syms x
    % For the univariate case we have to calculate phi1
    symb_kernel_gaus(x) = (2*pi)^(-2/2)*exp(-(x^2)/2);
    symb_arg1 = (H)^(-1/2)*x;
    symb_phi2H(x) = (H)^(-1/2)*symb_kernel_gaus(symb_arg1);
    phi1_symb_phi2H(x) = diff(symb_phi2H, x, 1);   
%    
    arg1 = 0;
    for i = 1:n
        for ii=1:n
            if i~=ii
                arg1 = arg1 + n^(-1)*(n-1)^(-1)*der_phi(X(i,:)-X(ii,:));
            end
        end
    end

BCV = 1/4*vech(H)'*arg1*vech(H) + n^-1*(4*pi)^(-d/2)*H^(-1/2);
end

%Local Functions:
    function a = der_phi(x)
        % Eval
        %a = eval(phi1_symb_phi2H(x));
        a = -(5734161139222659*x*exp(-x^2/(4*H)))/(72057594037927936*H*(2*H)^(1/2));
    end

end

