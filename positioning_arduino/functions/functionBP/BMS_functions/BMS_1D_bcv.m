function [ BCV ] = BMS_1D_bcv( X, h, type )
%BMS_1D_BCV Bandwidth Selection Biased cross-validation
%   H = BMS_1D_bcv(X, h, type)

% X is now a column vector
[n, d] = size(X);

if type == 1
    arg1 = 0;
    for i = 1:n
        for ii=1:n
            if i~=ii
                arg1 = arg1 + der2_phi_conv((X(ii)-X(i))/h);
            end
        end
    end

elseif type == 2
    arg1 = 0;
    for i = 1:n
        for ii=1:n
            if i~=ii
                arg1 = arg1 + der4_phi((X(ii)-X(i))/h);
            end
        end
    end
end

BCV = 1/2/sqrt(pi)/n/h + 1/(4*n*(n-1)*h)*arg1;

function a = der2_phi_conv(x)
    a=-1/2*sqrt(pi)*exp(-x^2/4)*(x^2+2) + ...
        sqrt(pi)*exp(-x^2/4) + ...
        1/16*sqrt(pi)*exp(-x^2/4)*(x^4-4*x^2+12);
end

function a = der2_phi(x)
    a=(x^2-1)*exp(-x^2/2)*1/sqrt(2*pi);
end

function a = der4_phi(x)
    a=(x^4-6*x^2+3)*exp(-x^2/2)*1/sqrt(2*pi);
end

end

