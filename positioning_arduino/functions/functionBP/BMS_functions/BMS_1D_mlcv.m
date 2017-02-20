function [ MLCV ] = BMS_1D_mlcv( X, h )
%BMS_1D_MLCV Bandwidth Selection Maximum likelihood cross-validation
%   H = BMS_1D_mlcv(X, h)

% X is now a column vector
[n, d] = size(X);

arg2 = 0;
for i = 1:n
    arg1 = 0;
    for ii=1:n
        if i~=ii
            arg1 = arg1 + phi((X(ii)-X(i))/h);
        end
    end
    arg2 = arg2 + log10(arg1);
end

MLCV = n^-1*arg2-log10((n-1)*h);
MLCV = MLCV*(-1);

function a = phi(x)
    a=1/sqrt(2*pi)*exp(-x^2/2);
end

end

