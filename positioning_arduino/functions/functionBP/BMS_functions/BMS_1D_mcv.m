function [ MCV ] = BMS_1D_mcv( X, h )
%BMS_1D_MCV Bandwidth Selection Modified cross-validation
%   H = BMS_1D_mcv(X, h)

% X is now a column vector
[n, d] = size(X);

arg1 = 0;
for i = 1:n
    for ii=1:n
        if i~=ii
%             arg1 = arg1 + phi((X(ii)-X(i))/(2*h)) - phi((X(ii)-X(i))/h) + ...
%                 -0.5*der2_phi((X(ii)-X(i))/h);  
            arg1 = arg1 + phi_conv((X(ii)-X(i))/h) - phi((X(ii)-X(i))/h) + ...
                -0.5*der2_phi((X(ii)-X(i))/h);              
        end
    end
end

MCV = 1/2/sqrt(pi)/n/h + 1/(n*(n-1)*h)*arg1;

function a = phi(x)
    a=1/sqrt(2*pi)*exp(-x^2/2);
end

function a = phi_conv(x)
    a=1/sqrt(4*pi)*exp(-x^2/4);
end

function a = der2_phi(x)
    a=(x^2-1)*exp(-x^2/2)*1/sqrt(2*pi);
end

end

