function [ TCV ] = BMS_1D_tcv( X, h )
%BMS_1D_TCV Bandwidth Selection Trimmed cross-validation
%   H = BMS_1D_tcv(X, h)

% X is now a column vector
[n, d] = size(X);

cn = 1/n;

arg1 = 0;
for i = 1:n
    for ii=1:n
        if i~=ii
            arg1 = arg1 + phi_conv((X(ii)-X(i))/h) + ...
                - 2*phi((X(ii)-X(i))/h) * ind((X(ii)-X(i))/h, cn, h);          
        end
    end
end

TCV = 1/2/sqrt(pi)/n/h + 1/(n*(n-1)*h)*arg1;

function a = phi(x)
    a=1/sqrt(2*pi)*exp(-x^2/2);
end

function a = phi_conv(x)
    a=1/sqrt(4*pi)*exp(-x^2/4);
end

function a = ind(x, cn, h)
    if abs(x)>cn/h
        a=1;
    else
        a=0;
    end
end



end

