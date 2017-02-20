function [  ] = plot_BMS( message )
%PLOT_BMS Plot of the different Bandwidth selectors
%   plot_BMS( message )
%   message is 2-column matrix

BMS_silverman(message)

h=0:0.2:40;

message_x = message(:,1);
message_y = message(:,2);
    
for i = 1:length(h)
    sol_mlcv(i) = BMS_1D_mlcv(message_x,h(i));
    sol_ucv(i) = BMS_1D_ucv(message_x,h(i));
    sol_bcv1(i) = BMS_1D_bcv(message_x,h(i),1);
    sol_bcv2(i) = BMS_1D_bcv(message_x,h(i),2);
    sol_ccv(i) = BMS_1D_ccv(message_x,h(i));
    sol_mcv(i) = BMS_1D_mcv(message_x,h(i));
    sol_tcv(i) = BMS_1D_tcv(message_x,h(i));
end
figure, plot(h, sol_mlcv,'*-'),grid, title('MLCV')
figure, plot(h, sol_ucv,'*-'),grid, title('UCV')
figure, plot(h, sol_bcv1,'*-'),grid, title('BCV1')
figure, plot(h, sol_bcv2,'*-'),grid, title('BCV2')
figure, plot(h, sol_ccv,'*-'),grid, title('CCV')
figure, plot(h, sol_mcv,'*-'),grid, title('MCV')
figure, plot(h, sol_tcv,'*-'),grid, title('TCV')

H_ini(1,1) = 0;
%[H11, ~] = fminsearch(@(h) BMS_1D_mlcv(message_x,h), H_ini(1,1))
%[H11, ~] = fminsearch(@(h) BMS_1D_ucv(message_x,h), H_ini(1,1))
%[H11, ~] = fminsearch(@(h) BMS_1D_bcv(message_x,h,1), H_ini(1,1))
%[H11, ~] = fminsearch(@(h) BMS_1D_bcv(message_x,h,2), H_ini(1,1))
%[H11, ~] = fminsearch(@(h) BMS_1D_ccv(message_x,h), H_ini(1,1))
%[H11, ~] = fminsearch(@(h) BMS_1D_mcv(message_x,h), H_ini(1,1))
%[H11, ~] = fminsearch(@(h) BMS_1D_tcv(message_x,h), H_ini(1,1))

[H11_MLCV, ~] = fminbnd(@(h) BMS_1D_mlcv(message_x,h), 0, 20)
[H11_UCV, ~] = fminbnd(@(h) BMS_1D_ucv(message_x,h), 0, 20)
[H11_BCV1, ~] = fminbnd(@(h) BMS_1D_bcv(message_x,h,1), 0, 20)
[H11_BCV2, ~] = fminbnd(@(h) BMS_1D_bcv(message_x,h,2), 0, 20)
[H11_CCV, ~] = fminbnd(@(h) BMS_1D_ccv(message_x,h), 0, 20)
[H11_MCV, ~] = fminbnd(@(h) BMS_1D_mcv(message_x,h), 0, 20)
[H11_TCV, ~] = fminbnd(@(h) BMS_1D_tcv(message_x,h), 0, 20)


% for i = 1:length(h)
%     sol_mlcv(i) = -BMS_1D_mlcv(message_y,h(i));
%     sol_ucv(i) = BMS_1D_ucv(message_y,h(i));
%     sol_bcv1(i) = BMS_1D_bcv(message_y,h(i),1);
%     sol_bcv2(i) = BMS_1D_bcv(message_y,h(i),2);
%     sol_ccv(i) = BMS_1D_ccv(message_y,h(i));
%     sol_mcv(i) = BMS_1D_mcv(message_y,h(i));
%     sol_tcv(i) = BMS_1D_tcv(message_y,h(i));
% end
% figure, plot(h, sol_mlcv,'*-'),grid, title('MLCV')
% figure, plot(h, sol_ucv,'*-'),grid, title('UCV')
% figure, plot(h, sol_bcv1,'*-'),grid, title('BCV1')
% figure, plot(h, sol_bcv2,'*-'),grid, title('BCV2')
% figure, plot(h, sol_ccv,'*-'),grid, title('CLCV')
% figure, plot(h, sol_mcv,'*-'),grid, title('MCV')
% figure, plot(h, sol_tcv,'*-'),grid, title('TCV')

end

