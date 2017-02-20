function [ output ] = multiplicateAllMessages(messages, message,connections, i,num_devices, num_anchors, NSAMPLES, SAMPLE_TECHNIQUE,K_MIXTURE_PARAMETER,anchors,RESAMPLE_OPTION,BMS_OPTION)
%MULTIPLICATEALLMESSAGES Summary of this function goes here
%   Detailed explanation goes here

%Gibbs parameter
k = 5; %Number of iterations of the Gibbs sampler

index = 1;
for j = 1:(num_anchors)
    if connections(i,j) == 1
        full_messages{index} = messages{i,j};
    index = index + 1;
    end
end

if length(full_messages) == 1
    output = full_messages{1};
    return
end

if strcmp(SAMPLE_TECHNIQUE, 'Importance')&&(anchors==1)
    index = 1;
    for j = 1:(num_anchors)
        if connections(i,j) == 1
            full_messages{index} = messages{i,j};
            index = index + 1;
        end
    end
    leng_message = NSAMPLES;
    if leng_message > NSAMPLES
        leng_message = NSAMPLES;
    end
    for j = 1:length(full_messages)
        new_messages{j} = full_messages{j}(1:leng_message,:);
    end
    
    if RESAMPLE_OPTION == 0

 
        for ii = 2:length(new_messages)
            H{ii} = bandwidthMatrixSelector(full_messages{ii},BMS_OPTION);
        end
        output_result = [];
        output_points = [];
        
        for ii = 1
            index_1 = 1;
            for iii = 1:length(new_messages)
                if (ii ~= iii)
                    result1{index_1} = multikde(new_messages{ii},full_messages{iii},H{iii},'gaus');
                    % figure, plot3(new_messages{ii}(:,1),new_messages{ii}(:,2),result1{index_1},'o')
                    index_1 = index_1 + 1;
                end                
            end
            % We have to multiply all the results1
            for iii = 1:(index_1-1)
                if (iii == 1)
                    result2 = result1{1};
                else
                    result2 = result2.*result1{iii};
                end
            end
            % figure, plot3(new_messages{ii}(:,1),new_messages{ii}(:,2),result2,'o')
            %Finally we have all the kde multiplications in result2, we
            %just adjust the weights
            result3 = normalizeWeights(result2);
            output_result = [output_result; result3];
            output_points = [output_points; new_messages{ii}];
            % figure, plot3(output_points(:,1),output_points(:,2),output_result,'o')
        end
        
        output = [output_points(:,1:2) output_result];
        output = resample([output(:,1:2), output(:,3)], NSAMPLES, 2);
        % figure, plot3(output(:,1),output(:,2),output,'o')
        % figure, plot(output(:,1),output(:,2),'o')
        
    elseif RESAMPLE_OPTION == 1
        
        for ii = 2:length(new_messages)
            H{ii} = bandwidthMatrixSelector(full_messages{ii},BMS_OPTION);
        end
        output_result = [];
        output_points = [];
        
        for ii = 1
        %The difference is that now we are not going to evaluate in all
        %samples of new_messages{ii}, but just in the ones which have an
        %important value.
        [nsamples, ~] = size(new_messages{ii});
        new_messages_r{ii} = resample(new_messages{ii}, nsamples, 2);
        
            index_1 = 1;
            for iii = 1:length(new_messages)
                if (ii ~= iii)
                    result1{index_1} = multikde(new_messages_r{ii},full_messages{iii},H{iii},'gaus');
                    % figure, plot3(new_messages{ii}(:,1),new_messages{ii}(:,2),result1{index_1},'o')
                    index_1 = index_1 + 1;
                end                
            end        
            % We have to multiply all the results1
            for iii = 1:(index_1-1)
                if (iii == 1)
                    result2 = result1{1};
                else
                    result2 = result2.*result1{iii};
                end
            end        
            %Finally we have all the kde multiplications in result2, we
            %just adjust the weights
            result3 = normalizeWeights(result2);
            output_result = [output_result; result3];
            output_points = [output_points; new_messages_r{ii}];            
        end
        
        output = [output_points(:,1:2) output_result];

    end
                
elseif strcmp(SAMPLE_TECHNIQUE, 'Importance')&&(anchors==0)
    index = 1;
    for j = (1+num_anchors):(num_anchors+num_devices)
        if connections(i,j) == 1
            full_messages{index} = messages{i,j};
            index = index + 1;
        end
    end
    leng_message = NSAMPLES;
    if leng_message > NSAMPLES
        leng_message = NSAMPLES;
    end
    for j = 1:length(full_messages)
        new_messages{j} = full_messages{j}(1:leng_message,:);
    end
    new_messages{length(new_messages)+1} = message(1:leng_message,:);
    full_messages{length(full_messages)+1} = message(:,:);
    
	if RESAMPLE_OPTION == 0

        for ii = 2:length(new_messages)
            H{ii} = bandwidthMatrixSelector(full_messages{ii},BMS_OPTION);
        end
        output_result = [];
        output_points = [];
        for ii = 1
            index_1 = 1;
            for iii = 1:length(new_messages)
                if (ii ~= iii)
                    result1{index_1} = multikde(new_messages{ii},full_messages{iii},H{iii},'gaus');
                    % figure, plot3(new_messages{ii}(:,1),new_messages{ii}(:,2),result1{index_1},'o')
                    index_1 = index_1 + 1;
                end                
            end
            % We have to multiply all the results1
            for iii = 1:(index_1-1)
                if (iii == 1)
                    result2 = result1{1};
                else
                    result2 = result2.*result1{iii};
                end
            end
            % figure, plot3(new_messages{ii}(:,1),new_messages{ii}(:,2),result2,'o')
            %Finally we have all the kde multiplications in result2, we
            %just adjust the weights
            result3 = normalizeWeights(result2);
            output_result = [output_result; result3];
            output_points = [output_points; new_messages{ii}];
            % figure, plot3(output_points(:,1),output_points(:,2),output_result,'o')
        end
        
        output = [output_points(:,1:2) output_result];
        output = resample([output(:,1:2), output(:,3)], NSAMPLES, 2);
        % figure, plot3(output(:,1),output(:,2),output,'o')
        % figure, plot(output(:,1),output(:,2),'o')
  
	elseif RESAMPLE_OPTION == 1
        
        for ii = 2:length(new_messages)
            H{ii} = bandwidthMatrixSelector(full_messages{ii},BMS_OPTION);
        end
        output_result = [];
        output_points = [];
        
        for ii = 1
        %The difference is that now we are not going to evaluate in all
        %samples of new_messages{ii}, but just in the ones which have an
        %important value.
        [nsamples, ~] = size(new_messages{ii});
        new_messages_r{ii} = resample(new_messages{ii}, nsamples, 2);
        
            index_1 = 1;
            for iii = 1:length(new_messages)
                if (ii ~= iii)
                    result1{index_1} = multikde(new_messages_r{ii},full_messages{iii},H{iii},'gaus');
                    % figure, plot3(new_messages{ii}(:,1),new_messages{ii}(:,2),result1{index_1},'o')
                    index_1 = index_1 + 1;
                end                
            end        
            % We have to multiply all the results1
            for iii = 1:(index_1-1)
                if (iii == 1)
                    result2 = result1{1};
                else
                    result2 = result2.*result1{iii};
                end
            end        
            %Finally we have all the kde multiplications in result2, we
            %just adjust the weights
            result3 = normalizeWeights(result2);
            output_result = [output_result; result3];
            output_points = [output_points; new_messages_r{ii}];            
        end
        
        output = [output_points(:,1:2) output_result];
        
    end



elseif strcmp(SAMPLE_TECHNIQUE, 'Mixture')&&(anchors==1)
    index = 1;
    for j = 1:(num_anchors)
        if connections(i,j) == 1
            full_messages{index} = messages{i,j};
            index = index + 1;
        end
    end
    leng_message = (K_MIXTURE_PARAMETER*NSAMPLES)/length(full_messages);
    if leng_message > NSAMPLES
        leng_message = NSAMPLES;
    end
    for j = 1:length(full_messages)
        new_messages{j} = full_messages{j}(1:leng_message,:);
    end
    if (RESAMPLE_OPTION == 0)
        for ii = 1:length(new_messages)
            H{ii} = bandwidthMatrixSelector(full_messages{ii},BMS_OPTION);
        end
        output_result = [];
        output_points = [];
        for ii = 1:length(new_messages)
            index_1 = 1;
            for iii = 1:length(new_messages)
                if (ii ~= iii)
                    result1{index_1} = multikde(new_messages{ii},full_messages{iii},H{iii},'gaus');
                    % figure, plot3(new_messages{ii}(:,1),new_messages{ii}(:,2),result1{index_1},'o')
                    index_1 = index_1 + 1;
                end                
            end
            % We have to multiply all the results1
            for iii = 1:(index_1-1)
                if (iii == 1)
                    result2 = result1{1};
                else
                    result2 = result2.*result1{iii};
                end
            end
            % figure, plot3(new_messages{ii}(:,1),new_messages{ii}(:,2),result2,'o')
            %Finally we have all the kde multiplications in result2, we
            %just adjust the weights
            result3 = normalizeWeights(result2)/(length(full_messages));
            output_result = [output_result; result3];
            output_points = [output_points; new_messages{ii}];
            % figure, plot3(output_points(:,1),output_points(:,2),output_result,'o')
        end
        
        output = [output_points(:,1:2) output_result];
        output = resample([output(:,1:2), output(:,3)], NSAMPLES, 2);
        % figure, plot3(output(:,1),output(:,2),output,'o')
        % figure, plot(output(:,1),output(:,2),'o')

        
        
%         % Multipliying anchors messages
%         output_points = [];
%         output_result = [];
%         for ii = 1:length(new_messages)
%             other_messages{ii} = [];
%             %For each message, we create the list of points with the other
%             %messages
%             for iii = 1:length(new_messages)
%                 if (ii ~= iii)
%                     other_messages{ii} = [other_messages{ii}; new_messages{iii}];
%                 end
%             end
%             %Then, we evaluate this message in the points of the other messages
%             H = bandwidthMatrixSelector(full_messages{ii},BMS_OPTION);
%             result1{ii} = multikde(other_messages{ii},full_messages{ii},H,'gaus');
%             output_points = [output_points; other_messages{ii}(:,1:2)];
%             output_result = [output_result; result1{ii}];
%         end
%         output_result = normalizeWeights(output_result);
%         output = [output_points output_result];
%         output = resample([output(:,1:2), output(:,3)], NSAMPLES, 2);
%         
%         %figure, plot3(output(:,1), output(:,2),output(:,3),'o'),grid
    elseif (RESAMPLE_OPTION == 1)
        % Multipliying anchors messages
        output_points = [];
        output_result = [];
        for ii = 1:length(new_messages)
            other_messages{ii} = [];
            %For each message, we create the list of points with the other
            %messages
            for iii = 1:length(new_messages)
                if (ii ~= iii)
                    other_messages{ii} = [other_messages{ii}; new_messages{iii}];
                end
            end
            %Then, we evaluate this message in the points of the other messages
            %BUT BEFORE WE HAVE TO CHOOSE THE POINTS OF other_messages in which we are
            %going to evaluate new_messages
            H = bandwidthMatrixSelector(full_messages{ii},BMS_OPTION);
            other_messages_resampled{ii} = resample(other_messages{ii}, NSAMPLES, 2);
            result1{ii} = multikde(other_messages_resampled{ii},full_messages{ii},H,'gaus');
            output_points = [output_points; other_messages_resampled{ii}(:,1:2)];
            output_result = [output_result; result1{ii}];
        end
        output_result = normalizeWeights(output_result);
        output = [output_points output_result];
        output = sortrows(output, -3);   
        output = output(1:NSAMPLES,:);
        %figure, plot3(output(:,1), output(:,2),output(:,3),'o'),grid
    end
    
elseif strcmp(SAMPLE_TECHNIQUE, 'Mixture')&&(anchors==0)
    index = 1;
    for j = (1+num_anchors):(num_anchors+num_devices)
        if connections(i,j) == 1
            full_messages{index} = messages{i,j};
            index = index + 1;
        end
    end
    leng_message = (K_MIXTURE_PARAMETER*NSAMPLES)/(length(full_messages)+1);
    if leng_message > NSAMPLES
        leng_message = NSAMPLES;
    end
    for j = 1:length(full_messages)
        new_messages{j} = full_messages{j}(1:leng_message,:);
    end
    new_messages{length(new_messages)+1} = message(1:leng_message,:);
    full_messages{length(full_messages)+1} = message(:,:);
    if (RESAMPLE_OPTION == 0)
        for ii = 1:length(new_messages)
            H{ii} = bandwidthMatrixSelector(full_messages{ii},BMS_OPTION);
        end
        output_result = [];
        output_points = [];
        for ii = 1:length(new_messages)
            index_1 = 1;
            for iii = 1:length(new_messages)
                if (ii ~= iii)
                    result1{index_1} = multikde(new_messages{ii},full_messages{iii},H{iii},'gaus');
                    % figure, plot3(new_messages{ii}(:,1),new_messages{ii}(:,2),result1{index_1},'o')
                    index_1 = index_1 + 1;
                end                
            end
            % We have to multiply all the results1
            for iii = 1:(index_1-1)
                if (iii == 1)
                    result2 = result1{1};
                else
                    result2 = result2.*result1{iii};
                end
            end
            % figure, plot3(new_messages{ii}(:,1),new_messages{ii}(:,2),result2,'o')
            %Finally we have all the kde multiplications in result2, we
            %just adjust the weights
            result3 = normalizeWeights(result2)/(length(full_messages));
            output_result = [output_result; result3];
            output_points = [output_points; new_messages{ii}];
            % figure, plot3(output_points(:,1),output_points(:,2),output_result,'o')
        end
        
        output = [output_points(:,1:2) output_result];
        output = resample([output(:,1:2), output(:,3)], NSAMPLES, 2);
        % figure, plot3(output(:,1),output(:,2),output,'o')
        % figure, plot(output(:,1),output(:,2),'o')        
        
        
        
        
        
        
        
        
        
        
        
        
%         % Multipliying anchors messages
%         output_points = [];
%         output_result = [];
%         for ii = 1:length(new_messages)
%             other_messages{ii} = [];
%             %For each message, we create the list of points with the other
%             %messages
%             for iii = 1:length(new_messages)
%                 if (ii ~= iii)
%                     other_messages{ii} = [other_messages{ii}; new_messages{iii}];
%                 end
%             end
%             %Then, we evaluate this message in the points of the other messages
%             H = bandwidthMatrixSelector(full_messages{ii},BMS_OPTION);
%             result1{ii} = multikde(other_messages{ii},full_messages{ii},H,'gaus');
%             output_points = [output_points; other_messages{ii}(:,1:2)];
%             output_result = [output_result; result1{ii}];
%         end
%         output_result = normalizeWeights(output_result);
%         output = [output_points output_result];
%         output = resample([output(:,1:2), output(:,3)], NSAMPLES, 2);
%         %figure, plot3(output(:,1), output(:,2),output(:,3),'o'),grid
    elseif (RESAMPLE_OPTION == 1)
        % Multipliying anchors messages
        output_points = [];
        output_result = [];
        for ii = 1:length(new_messages)
            other_messages{ii} = [];
            %For each message, we create the list of points with the other
            %messages
            for iii = 1:length(new_messages)
                if (ii ~= iii)
                    other_messages{ii} = [other_messages{ii}; new_messages{iii}];
                end
            end
            %Then, we evaluate this message in the points of the other messages
            %BUT BEFORE WE HAVE TO CHOOSE THE POINTS OF other_messages in which we are
            %going to evaluate new_messages
            H = bandwidthMatrixSelector(full_messages{ii},BMS_OPTION);
            other_messages_resampled{ii} = resample(other_messages{ii}, NSAMPLES, 2);
            result1{ii} = multikde(other_messages_resampled{ii},full_messages{ii},H,'gaus');
            output_points = [output_points; other_messages_resampled{ii}(:,1:2)];
            output_result = [output_result; result1{ii}];            
        end
        output_result = normalizeWeights(output_result);
        output = [output_points output_result];
        output = sortrows(output, -3);   
        output = output(1:NSAMPLES,:);
        %figure, plot3(output(:,1), output(:,2),output(:,3),'o'),grid
    end
    
elseif strcmp(SAMPLE_TECHNIQUE, 'Gibbs')&&(anchors==1)
    output = zeros(NSAMPLES,1);
    output(:,3) = 1/NSAMPLES;
    
    index = 1;
    for j = 1:(num_anchors)
        if connections(i,j) == 1
        	full_messages{index} = messages{i,j};
            full_messages_H_FIX{index} = bandwidthMatrixSelector(full_messages{index},BMS_OPTION);
            index = index + 1;
        end
    end
    for index_out = 1:NSAMPLES
        index = 1;
        for j = 1:(num_anchors)
            if connections(i,j) == 1
                %Have to choose a starting point for each message
                y = resample(full_messages{index},1,2);
                Label{index} = y(1:2)';
                %Restart the covariance matrices:
                full_messages_H{index} = full_messages_H_FIX{index};
                index = index + 1;
            end
        end
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
    %                 mean_ = [full_messages{j}(jj,1:2)', Mu_{jj}, Mu_ast];
    %                 mean_ = mean(mean_,2);
    %                 x = mean_';
                    x = Mu_{jj}';

                    N_i = multiGaussian(x, full_messages{j}(jj,1:2), full_messages_H{j});
                    N_ = multiGaussian(x, Mu_{jj}', Cov_{jj});
                    N_ast = multiGaussian(x, Mu_ast', Cov_ast);
    %                 log10(full_messages{j}(jj,3)) + log10(N_i) + log10(N_ast) - log10(N_)
    %                 Weight(jj) = log10(full_messages{j}(jj,3)) + log10(N_i) + log10(N_ast) - log10(N_);
                    Weight(jj) =  full_messages{j}(jj,3)*(N_i*N_ast)/N_;

                    %% Plot for all xx
    %                 vx = 0:1:100;
    %                 vy = 0:1:100;
    %                 index=1;
    %                 for ii=vx  %X axes
    %                     for i=vy  %Y axes
    %                         X(index,:) = [ii,i];
    %                         index=index+1;
    %                     end
    %                 end
    %                 AllxN_i = multiGaussian(X, full_messages{j}(jj,1:2), full_messages_H{j});
    %                 AllxN_ = multiGaussian(X, Mu_{jj}', Cov_{jj});
    %                 AllxN_ast = multiGaussian(X, Mu_ast', Cov_ast);
    %                 AllxN_i = vectortomatrix(length(vx),length(vy),AllxN_i);
    %                 AllxN_ = vectortomatrix(length(vx),length(vy),AllxN_);
    %                 AllxN_ast = vectortomatrix(length(vx),length(vy),AllxN_ast);
    %                 figure, surf(vx, vy, AllxN_i)
    %                 figure, surf(vx, vy, AllxN_)
    %                 figure, surf(vx, vy, AllxN_ast)
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
                    %j
                    %jjj
                    %Weight'
                    %Weight2
                    %y
                else
                    %Only update the label if there is not NaN problem (due
                    %to have performed too many iterations)
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

        
        %% Plot for all x
    %     vx = 0:1:80;
    %     vy = 0:1:80;
    %     index=1;
    %     for ii=vx  %X axes
    %         for i=vy  %Y axes
    %             X(index,:) = [ii,i];
    %             index=index+1;
    %         end
    %     end
    %     
    %     estimation = multiGaussian(X, Mu_prod', Cov_prod);
    % 
    %     es = vectortomatrix(length(vx),length(vy),estimation);
    %     figure
    %     surf(vx, vy, es)
    %     xlabel('Horizontal Distance (m)')
    %     ylabel('Vertical Distance (m)')
    %     title('Kde estimation')
        %
    end
elseif strcmp(SAMPLE_TECHNIQUE, 'Gibbs')&&(anchors==0)
    output = zeros(NSAMPLES,1);
    output(:,3) = 1/NSAMPLES;
    
    index = 1;
    for j = (1+num_anchors):(num_anchors+num_devices)
        if connections(i,j) == 1
            full_messages{index} = messages{i,j};
            full_messages_H_FIX{index} = bandwidthMatrixSelector(full_messages{index},BMS_OPTION);
            index = index + 1;
        end
    end   
    full_messages{index} = message(:,:);
    full_messages_H{index} = bandwidthMatrixSelector(full_messages{index},BMS_OPTION);
  
    
    for index_out = 1:NSAMPLES
        index = 1;
        for j = (1+num_anchors):(num_anchors+num_devices)
            if connections(i,j) == 1
                %Have to choose a starting point for each message
                y = resample(full_messages{index},1,2);
                Label{index} = y(1:2)';
                %Restart the covariance matrices:
                full_messages_H{index} = full_messages_H_FIX{index};
                index = index + 1;
            end
        end
        y = resample(full_messages{index},1,2);
        Label{index} = y(1:2)';
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
                    %j
                    %jjj
                    %Weight'
                    %Weight2
                    %y
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

