Parameters for simulation:

NSAMPLES = 100;

SIGMA = 0.1;

ERROR_TYPE = 'Gaussian'; % 'Gaussian', 'Exponential', 'Uniform'

NUM_ITERATIONS = 4;

SAMPLE_TECHNIQUE = 'Mixture'; % 'Importance', 'Mixture', 'Gibbs'

K_MIXTURE_PARAMETER = 3;    %Max value is the number of devices + 1 is connected a device

RESAMPLE_OPTION = 0; % (Only in Importance)
% 0: Resampling after the multiplication of each message from the anchors 
% and from the devices.
% 1: Resampling only after the multiplication of each message from the
% devices (Only in Importance)

MULTIPLICATION_OPTION = 1;
% 0: Multiplicating 1 message times other message, and the result times the
% next one.
% 1: Multiplicating all messages together

BMS_OPTION = 0; %Bandwidth Matrix Selector
% 0: Silverman's rule of thumb
%%%%%%%%%%%%% 2D Estimators %%%%%%%%%%%%%
% 1: 2D Unbiased Cross-validation (UCV)
% 2: 2D Unbiased Cross-validation with Diagonal matrix (UCV + Diagonal)
% 3: 2D Biased Cross-validation 1 (BCV1)
% 4: 2D Biased Cross-validation 2 (BCV2)
% 5: 2D Biased Cross-validation 1 with Diagonal matrix (BCV1 + Diagonal)
% 6: 2D Biased Cross-validation 2 with Diagonal matrix (BCV2 + Diagonal)
%%%%%%%%%%%%% 1D Estimators %%%%%%%%%%%%%
% In 1D Each component is calculated separately
% 7: 1D Unbiased Cross-validation (UCV)
% 8: 1D Biased Cross-validation 1 (BCV1)
% 9: 1D Biased Cross-validation 2 (BCV2)
%%%%%%%%%%%%% 1D Estimators %%%%%%%%%%%%%
% 10: 1D Maximum likelihood Cross-validation (MLCV)
% 11: 1D Unbiased Cross-validation (UCV)
% 12: 1D Biased Cross-validation 1 (BCV1)
% 13: 1D Biased Cross-validation 2 (BCV2)
% 14: 1D Complete Cross-validation (CCV)
% 15: 1D Modifed Cross-validation (MCV)
% 16: 1D Trimmed Cross-validation (TCV)