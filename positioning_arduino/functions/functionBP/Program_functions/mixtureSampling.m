function [ y ] = mixtureSampling( message1, message2, K_MIXTURE_PARAMETER, RESAMPLE_OPTION,BMS_OPTION )
%MIXTURESAMPLING Summary of this function goes here
%   Detailed explanation goes here

% NONPARAMETRIC BELIEF PROPAGATION FOR SELF-LOCALIZATION OF SENSOR NETWORKS
% Pag.5 Alg.2

if (RESAMPLE_OPTION == 0)
    [nsamples1, ~] = size(message1);
    [nsamples2, ~] = size(message2);
    nsamples = min(nsamples1, nsamples2);

    leng_message = (K_MIXTURE_PARAMETER*nsamples)/2;
    if leng_message > nsamples
        leng_message = nsamples;
    end
 
    % First we take K*N/2 of each message (in the case of 2 messages)
    new_message1 = message1(1:leng_message,:);
    new_message2 = message2(1:leng_message,:);
    
    %Sampling of message1 on the points of message2
    H = bandwidthMatrixSelector(message1,BMS_OPTION);
    result1 = multikde(new_message2,message1,H,'gaus');
    %result1 = normalizeWeights(result1);
    %figure, plot3(message2(:,1), message2(:,2), result1, '*'), grid
    
    %Sampling of message2 on the points of message1
    H = bandwidthMatrixSelector(message2,BMS_OPTION);
    result2 = multikde(new_message1,message2,H,'gaus');
    %result2 = normalizeWeights(result2);
    %figure, plot3(message1(:,1), message1(:,2), result2, '*'), grid
    
    %ESTO ESTA MAL: mixture_result = normalizeWeights([result1; result2]);
    r1 = normalizeWeights(result1)/2;
    r2 = normalizeWeights(result2)/2;
    mixture_result = [r1; r2];
    
    mixture_message = [[new_message2(:,1:2); new_message1(:,1:2)], mixture_result];
    %figure, plot3(mixture_message(:,1), mixture_message(:,2), mixture_message(:,3), '*'), grid
    %[nsamples, ~] = size(mixture_message);
    
    %y = sortrows(mixture_message, -3);   
    y = mixture_message(randperm(end),:);
    %y = resample(y, nsamples, 2);
    %figure, plot3(result3(:,1), result3(:,2), result3(:,3), '*'), grid
    y = resample(y, nsamples, 2);

elseif (RESAMPLE_OPTION == 1)
    [nsamples1, ~] = size(message1);
    [nsamples2, ~] = size(message2);
    nsamples = min(nsamples1, nsamples2);

    leng_message = (K_MIXTURE_PARAMETER*nsamples)/2;
 
    % First we take K*N/2 of each message (in the case of 2 messages)
    new_message1 = message1(1:leng_message,:);
    new_message2 = message2(1:leng_message,:);
    
    %Sampling of message1 on the points of message2
    %BUT BEFORE WE HAVE TO CHOOSE THE POINTS OF message2 in which we are
    %going to evaluate message1
    H = bandwidthMatrixSelector(message1,BMS_OPTION);
    points_message2 = resample(message2, nsamples, 2);
    result1 = multikde(points_message2,message1,H,'gaus');
    %result1 = normalizeWeights(result1);
    %figure, plot3(points_message2(:,1), points_message2(:,2), result1, '*'), grid
    
    %Sampling of message2 on the points of message1
    %BUT BEFORE WE HAVE TO CHOOSE THE POINTS OF message1 in which we are
    %going to evaluate message2
    H = bandwidthMatrixSelector(message2,BMS_OPTION);
    points_message1 = resample(message1, nsamples, 2);
    result2 = multikde(points_message1,message2,H,'gaus');
    %result2 = normalizeWeights(result2);
    %figure, plot3(message1(:,1), message1(:,2), result2, '*'), grid
    
    %mixture_result = normalizeWeights([result1; result2]);   
    r1 = normalizeWeights(result1)/2;
    r2 = normalizeWeights(result2)/2;
    mixture_result = [r1; r2];
    
    mixture_message = [[points_message2(:,1:2); points_message1(:,1:2)], mixture_result];
    %figure, plot3(mixture_message(:,1), mixture_message(:,2), mixture_message(:,3), '*'), grid
    %[nsamples, ~] = size(mixture_message);
    
    y = sortrows(mixture_message, -3);   
    %y = mixture_message(randperm(end),:);
    %y = resample(y, nsamples, 2);
    %figure, plot3(result3(:,1), result3(:,2), result3(:,3), '*'), grid
    y = y(1:nsamples,:);
end
end

