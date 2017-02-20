function [ CCV ] = BMS_1D_ccv( X, h )
%BMS_1D_CCV Bandwidth Selection Complete cross-validation
%   H = BMS_1D_ccv(X, h)

% X is now a column vector
[n, d] = size(X);

arg1 = 0;
arg2 = 0;
arg3 = 0;
arg4 = 0;

delta = 3;

for i = 1:n
    for ii=1:n
        if i~=ii
            arg1 = arg1 + phi_conv((X(ii)-X(i))/(h));
            arg2 = arg2 + phi((X(ii)-X(i))/(h));
            arg3 = arg3 + der2_phi((X(ii)-X(i))/(h));
            arg4 = arg4 + der4_phi((X(ii)-X(i))/(h));            
        end
    end
end

CCV = 1/2/sqrt(pi)/n/h + 1/(n*(n-1)*h)*arg1 - 1/(n*(n-1)*h)*arg2 + ...
    - 0.5*h^2/(n*(n-1)*h^3)*arg3 + ... 
    1/24*(6-delta)*h^4/(n*(n-1)*h^5)*arg4;

function a = phi(x)
    a=1/sqrt(2*pi)*exp(-x^2/2);
end

function a = phi_conv(x)
    a=1/sqrt(4*pi)*exp(-x^2/4);
end

function a = der2_phi(x)
    a=(x^2-1)*exp(-x^2/2)*1/sqrt(2*pi);
end

function a = der4_phi(x)
    a=(x^4-6*x^2+3)*exp(-x^2/2)*1/sqrt(2*pi);
end

end

 