function [ output ] = multiplicateMessages( message2, message1,SAMPLE_TECHNIQUE,K_MIXTURE_PARAMETER, anchors,RESAMPLE_OPTION,BMS_OPTION)
%MULTIPLICATEMESSAGES Summary of this function goes here
%   Detailed explanation goes here

%Gibbs parameter
k = 4; %Number of iterations of the Gibbs sampler

if strcmp(SAMPLE_TECHNIQUE, 'Importance')
    %Sampling of message1 on the points of message2
    if RESAMPLE_OPTION == 0
        H = bandwidthMatrixSelector(message1,BMS_OPTION);
        result1 = multikde(message2,message1,H,'gaus');
        result1 = normalizeWeights(result1);
        %figure, plot3(message2(:,1), message2(:,2), result1, '*'), grid
        %title('test')
        [nsamples, ~] = size(message1);
        result2 = resample([message2(:,1:2), result1], nsamples, 2);
        %figure, plot(result2(:,1), result2(:,2), 'o'), grid
        output = result2(:,:);
    elseif RESAMPLE_OPTION == 1
        H = bandwidthMatrixSelector(message1,BMS_OPTION);
        [nsamples, ~] = size(message2);
        new_message2 = resample(message2, nsamples, 2);
        result1 = multikde(new_message2,message1,H,'gaus');
        result1 = normalizeWeights(result1);
%         figure, plot3(new_message2(:,1), new_message2(:,2), result1, '*'), grid
%         title('test')
        %result2 = resample([new_message2(:,1:2), result1], nsamples, 2);
%         figure, plot3(result2(:,1), result2(:,2), result2(:,3),'*'), grid
%         title('test despues')
        output = [new_message2(:,1:2), result1];
        %output = result2(:,:);
    end

elseif strcmp(SAMPLE_TECHNIQUE, 'Mixture')
    %Multipliying device messages
    
%     %Before the mixture Samplng:
%     figure, subplot(2,1,1)
%     plot3(message1(:,1), message1(:,2),message1(:,3),'o'),grid
%     hold all
%     plot3(message2(:,1), message2(:,2),message2(:,3),'o')

    output = mixtureSampling(message1, message2, K_MIXTURE_PARAMETER, RESAMPLE_OPTION,BMS_OPTION); 
    
%     if RESAMPLE_OPTION == 0
%         [nsamples, ~] = size(message1);    
%         output = resample(output, nsamples, 2);
%         %After the mixture Sampling
%         subplot(2,1,2), plot3(output(:,1), output(:,2),output(:,3),'o'),grid
%     elseif RESAMPLE_OPTION == 1
%         output = sortrows(output, -3);   
%         [nsamples, ~] = size(message1);    
%         output = output(1:nsamples,:);
%         subplot(2,1,2), plot3(output(:,1), output(:,2),output(:,3),'o'),grid
%     end

%     subplot(2,1,2), plot3(output(:,1), output(:,2),output(:,3),'o'),grid
elseif strcmp(SAMPLE_TECHNIQUE, 'Gibbs')
    [NSAMPLES, ~] = size(message1);
    output = zeros(NSAMPLES,1);
    output(:,3) = 1/NSAMPLES;
    
    full_messages{1} = message1;
    full_messages_H_FIX{1} = bandwidthMatrixSelector(full_messages{1},BMS_OPTION); 
    full_messages{2} = message2;
    full_messages_H_FIX{2} = bandwidthMatrixSelector(full_messages{2},BMS_OPTION);
        
    for index_out = 1:NSAMPLES
        %Message1
        full_messages_H{1} = full_messages_H_FIX{1};
        y = resample(full_messages{1},1,2);
        Label{1} = y(1:2)';
        %Message2
        full_messages_H{2} = full_messages_H_FIX{2};
        y = resample(full_messages{2},1,2);
        Label{2} = y(1:2)';       
        for jjj = 1:k
            %For each message:
            for j = 1:length(full_messages)
                CovMatrix_calc0 = [];
                for jj = 1:length(full_messages)
                    if (j ~= jj)
                        if isempty(CovMatrix_calc0)
                            CovMatrix_calc0 = inv(full_messages_H{jj});
                            Cov_Mu_calc0 = inv(full_messages_H{jj}) * Label{jj};
                        else
                            CovMatrix_calc0 = CovMatrix_calc0 + inv(full_messages_H{jj});
                            Cov_Mu_calc0 = Cov_Mu_calc0 + inv(full_messages_H{jj}) * Label{jj};
                        end
                    end
                end
                % Variance and mean of *
                Cov_ast = inv(CovMatrix_calc0);
                Mu_ast = Cov_ast*Cov_Mu_calc0;
                % Calculation of Cov_ and Mu_
                Cov_ = [];
                Mu_ = [];
                for jj = 1:NSAMPLES
                    %Multiplication of each sample times *
                    Cov_{jj} = inv( inv(Cov_ast) + inv(full_messages_H{j}) );
                    Mu_{jj} = Cov_{jj} * (inv(Cov_ast)*Mu_ast + inv(full_messages_H{j})*full_messages{j}(jj,1:2)');
                    %Have to choose a 'good' x point to evaluate the function
                    x = Mu_{jj}';

                    N_i = multiGaussian(x, full_messages{j}(jj,1:2), full_messages_H{j});
                    N_ = multiGaussian(x, Mu_{jj}', Cov_{jj});
                    N_ast = multiGaussian(x, Mu_ast', Cov_ast);
    %                 Weight(jj) = log10(full_messages{j}(jj,3)) + log10(N_i) + log10(N_ast) - log10(N_);
                    Weight(jj) =  full_messages{j}(jj,3)*(N_i*N_ast)/N_;
                end
                %CAREFUL, Sometimes we can have -Inf value, if we try to
                %normalize a vector with -Inf values we will have a wrong
                %result.
                Weight2 = normalizeWeights(Weight');
                all_weights = [(1:NSAMPLES)' Weight2];
                %Have to choose another starting point for the message j
                y = resample(all_weights,1,1);
                pos = y(1,1);
                if pos == 0
                    j
                    jjj
                    %Weight'
                    %Weight2
                    y
                else
                    %Only update the label if there is not NaN problem (due
                    %to have performed too many iterations
                    Label{j} = Mu_{pos};
                    full_messages_H{j} = Cov_{pos};                   
                end
            end
        end
        %Now we have three points
        % Label{j} Mu_l{j}
        % full_messages_H{j} inv(BMS_silverman(full_messages{j}))
        Cov_calc = inv(full_messages_H{1});
        Mu_calc = Cov_calc*Label{1};
        for j = 2:length(full_messages)
            Cov_calc = Cov_calc + inv(full_messages_H{1});
            Mu_calc = Mu_calc + inv(full_messages_H{1})*Label{j};
        end
        Cov_prod = inv(Cov_calc);
        Mu_prod = Cov_prod*Mu_calc;
        %Draw a sample from the distribution N(x; Mu_prod, Cov_prod)
        output(index_out,1:2) = mvnrnd(Mu_prod,Cov_prod);
    end
            
end

end

