function [ BCV ] = BMS_bcv_normalv2(X, H, version)
%BMS_UCV Bandwidth Matrix Selection using Biased cross-validation
%   H = BMS_ucv(X, H)
%   version is the version of the BCV used, which depends on the manner in
%   which phi4 is estimated

[n, d] = size(X);

if version == 1
% To avoid erros:
x1=[];x2=[];
syms x1 x2
    x = [x1 x2];
    matrix = H;
    % For the bivariate case we have to calculate phi40, phi31, phi22, phi13
    % and phi04
    symb_kernel_gaus(x) = (2*pi)^(-2/2)*exp(-(x*x')/2);
    symb_arg1 = (2*matrix)^(-1/2)*x';
    symb_arg11(x) = symb_arg1(1);
    symb_arg12(x) = symb_arg1(2);
    symb_phi2H(x) = det(2*matrix)^(-1/2)*symb_kernel_gaus(symb_arg11, symb_arg12);
    phi40_symb_phi2H(x) = diff(symb_phi2H, x1, 4);
    phi04_symb_phi2H(x) = diff(symb_phi2H, x2, 4);
    phi22_symb_phi2H(x) = diff(diff(symb_phi2H, x1, 2), x2, 2);
    phi13_symb_phi2H(x) = diff(diff(symb_phi2H, x1, 1), x2, 3);
    phi31_symb_phi2H(x) = diff(diff(symb_phi2H, x1, 3), x2, 1);
%
    arg1 = 0;
    for i = 1:n
        for ii=1:n
            if i~=ii
                %0.05 seconds per operation
                arg1 = arg1 + n^(-2)*der_phi(X(i,:)-X(ii,:));
            end
        end
    end
BCV = 1/4*vech(H)'*arg1*vech(H) + n^-1*(4*pi)^(-d/2)*det(H)^(-1/2);
end

if version == 2
% To avoid erros:
x1=[];x2=[];
syms x1 x2
    x = [x1 x2];
    matrix = H;
    % For the bivariate case we have to calculate phi40, phi31, phi22, phi13
    % and phi04
    symb_kernel_gaus(x) = (2*pi)^(-2/2)*exp(-(x*x')/2);
    symb_arg1 = (matrix)^(-1/2)*x';
    symb_arg11(x) = symb_arg1(1);
    symb_arg12(x) = symb_arg1(2);
    symb_phi2H(x) = det(matrix)^(-1/2)*symb_kernel_gaus(symb_arg11, symb_arg12);
    phi40_symb_phi2H(x) = diff(symb_phi2H, x1, 4);
    phi04_symb_phi2H(x) = diff(symb_phi2H, x2, 4);
    phi22_symb_phi2H(x) = diff(diff(symb_phi2H, x1, 2), x2, 2);
    phi13_symb_phi2H(x) = diff(diff(symb_phi2H, x1, 1), x2, 3);
    phi31_symb_phi2H(x) = diff(diff(symb_phi2H, x1, 3), x2, 1);
    
%    
    arg1 = 0;
    for i = 1:n
        for ii=1:n
            if i~=ii
                arg1 = arg1 + n^(-1)*(n-1)^(-1)*der_phi(X(i,:)-X(ii,:));
            end
        end
    end

BCV = 1/4*vech(H)'*arg1*vech(H) + n^-1*(4*pi)^(-d/2)*det(H)^(-1/2);
end

%Local Functions:
    function a = der_phi(x)
    % Eval
    phi40 = eval(phi40_symb_phi2H(x(1), x(2)));
    phi04 = eval(phi04_symb_phi2H(x(1), x(2)));
    phi22 = eval(phi22_symb_phi2H(x(1), x(2)));
    phi13 = eval(phi13_symb_phi2H(x(1), x(2)));
    phi31 = eval(phi31_symb_phi2H(x(1), x(2)));
    a = [phi40 2*phi31 phi22; ...
        2*phi31 4*phi22 2*phi13; ...
        phi22 2*phi13 phi04];
    end

end

