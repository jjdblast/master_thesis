function [ H ] = bandwidthMatrixSelector(message, BMS_OPTION )
%BANDWIDTHMATRIXSELECTOR Summary of this function goes here
%   Detailed explanation goes here

% 0: Silverman's rule of thumb
% 1: 2D Unbiased Cross-validation (UCV)
% 2: 2D Unbiased Cross-validation with Diagonal matrix (UCV + Diagonal)
% 3: 2D Biased Cross-validation 1 (BCV1)
% 4: 2D Biased Cross-validation 2 (BCV2)
% 5: 2D Biased Cross-validation 1 with Diagonal matrix (BCV1 + Diagonal)
% 6: 2D Biased Cross-validation 2 with Diagonal matrix (BCV2 + Diagonal)
% In 1D Each component is calculated separately
% 7: 1D Unbiased Cross-validation (UCV)
% 8: 1D Biased Cross-validation 1 (BCV1)
% 9: 1D Biased Cross-validation 2 (BCV2)

% plot_BMS( message )
% pause

H_ini = BMS_silverman(message);

%H_ini = [0 0; 0 0];
t_bms1 = tic;
if BMS_OPTION == 0
    H = H_ini;
elseif BMS_OPTION == 1
    %[H, ~] = fmincon(@(H) BMS_ucv_normal(message,H), H_ini, [], [], [], [],[0,0;0,0],[]);
    H_ini = [diag(H_ini)' 0.2];
    [H_fix, ~] = fminsearch(@(H_fix) BMS_ucv_normal(message,H_fix), H_ini);
    H = [H_fix(1), H_fix(3); H_fix(3), H_fix(2)];
    %[H, ~] = fminunc(@(H) BMS_ucv_normal(message,H), H_ini);
elseif BMS_OPTION == 2
    Hdiag_ini=diag(H_ini)';
    [H_UCV_diag, ~] = fminsearch(@(diagH) BMS_ucv_normal_diag(message,diagH), Hdiag_ini);
    H = [H_UCV_diag(1), 0; 0, H_UCV_diag(2)];
elseif BMS_OPTION == 3
    [H, ~] = fminsearch(@(H) BMS_bcv_normalv2(message,H,1), H_ini);
elseif BMS_OPTION == 4
    [H, ~] = fminsearch(@(H) BMS_bcv_normalv2(message,H,2), H_ini);
elseif BMS_OPTION == 5
    Hdiag_ini=diag(H_ini)';
    [H_UCV_diag, ~] = fminsearch(@(diagH) BMS_bcv_normal_diagv2(message,diagH,1), Hdiag_ini);
    H = [H_UCV_diag(1), 0; 0, H_UCV_diag(2)];
elseif BMS_OPTION == 6
    Hdiag_ini=diag(H_ini)';
    [H_UCV_diag, ~] = fminsearch(@(diagH) BMS_bcv_normal_diagv2(message,diagH,2), Hdiag_ini);
    H = [H_UCV_diag(1), 0; 0, H_UCV_diag(2)];
elseif BMS_OPTION == 7
    message_x = message(:,1);
    message_y = message(:,2);
    [H11, ~] = fminsearch(@(h) BMS_1D_ucv_normal(message_x,h), H_ini(1,1));
    [H22, ~] = fminsearch(@(h) BMS_1D_ucv_normal(message_y,h), H_ini(2,2));
    H = [H11, 0; 0, H22];
elseif BMS_OPTION == 8
    message_x = message(:,1);
    message_y = message(:,2);
    [H11, ~] = fminsearch(@(h) BMS_1D_bcv_normalv2(message_x,h,1), H_ini(1,1));
    [H22, ~] = fminsearch(@(h) BMS_1D_bcv_normalv2(message_y,h,1), H_ini(2,2));
    H = [H11, 0; 0, H22];
elseif BMS_OPTION == 9
    message_x = message(:,1);
    message_y = message(:,2);
    [H11, ~] = fminsearch(@(h) BMS_1D_bcv_normalv2(message_x,h,2), H_ini(1,1));
    [H22, ~] = fminsearch(@(h) BMS_1D_bcv_normalv2(message_y,h,2), H_ini(2,2));
    H = [H11, 0; 0, H22];
elseif BMS_OPTION == 10
    message_x = message(:,1);
    message_y = message(:,2);
    [H11, ~] = fminbnd(@(h) BMS_1D_mlcv(message_x,h), 0, H_ini(1,1));
    [H22, ~] = fminbnd(@(h) -BMS_1D_mlcv(message_y,h), 0, H_ini(2,2));
    H = [H11, 0; 0, H22];
elseif BMS_OPTION == 11
    message_x = message(:,1);
    message_y = message(:,2);
    [H11, ~] = fminbnd(@(h) BMS_1D_ucv(message_x,h), 0, H_ini(1,1));
    [H22, ~] = fminbnd(@(h) BMS_1D_ucv(message_y,h), 0, H_ini(2,2));
    H = [H11, 0; 0, H22];
elseif BMS_OPTION == 12
    message_x = message(:,1);
    message_y = message(:,2);
    [H11, ~] = fminbnd(@(h) BMS_1D_bcv(message_x,h,1), 0, H_ini(1,1));
    [H22, ~] = fminbnd(@(h) BMS_1D_bcv(message_y,h,1), 0, H_ini(2,2));
    H = [H11, 0; 0, H22];
elseif BMS_OPTION == 13
    message_x = message(:,1);
    message_y = message(:,2);
    [H11, ~] = fminbnd(@(h) BMS_1D_bcv(message_x,h,2), 0, H_ini(1,1));
    [H22, ~] = fminbnd(@(h) BMS_1D_bcv(message_y,h,2), 0, H_ini(2,2));
    H = [H11, 0; 0, H22];
elseif BMS_OPTION == 14
    message_x = message(:,1);
    message_y = message(:,2);
    [H11, ~] = fminbnd(@(h) BMS_1D_ccv(message_x,h), 0, H_ini(1,1));
    [H22, ~] = fminbnd(@(h) BMS_1D_ccv(message_y,h), 0, H_ini(2,2));
    H = [H11, 0; 0, H22];
elseif BMS_OPTION == 15
    message_x = message(:,1);
    message_y = message(:,2);
    [H11, ~] = fminbnd(@(h) BMS_1D_mcv(message_x,h), 0, H_ini(1,1));
    [H22, ~] = fminbnd(@(h) BMS_1D_mcv(message_y,h), 0, H_ini(2,2));
    H = [H11, 0; 0, H22];
elseif BMS_OPTION == 16
    message_x = message(:,1);
    message_y = message(:,2);
    [H11, ~] = fminbnd(@(h) BMS_1D_tcv(message_x,h), 0, H_ini(1,1));
    [H22, ~] = fminbnd(@(h) BMS_1D_tcv(message_y,h), 0, H_ini(2,2));
    H = [H11, 0; 0, H22];
end

t_bms2 = toc(t_bms1);
%sprintf('Bandwidth matrix estimated in %f seconds', t_bms2) 

if (H(1,1) == 0)&&(H(1,2) == 0)&&(H(2,1) == 0)&&(H(2,2) == 0)
    disp('H = 0')
    message
end


if H(1,1) < 0
    H(1,1)
    H(1,1) = 0;
end
if H(1,2) < 0
    H(1,2)
    H(1,2) = 0;
end
if H(2,1) < 0
    H(2,1)
    H(2,1) = 0;
end
if H(2,2) < 0
    H(2,2)
    H(2,2) = 0;    
end


