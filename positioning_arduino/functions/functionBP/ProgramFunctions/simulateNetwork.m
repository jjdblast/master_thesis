function [simOutput] = simulateNetwork(simTopology, simData)
%SIMULATENETWORK Summary of this function goes here
%   Detailed explanation goes here

NSAMPLES = simData.NSAMPLES;
% SIGMA = simData.SIGMA;
% ERROR_TYPE = simData.ERROR_TYPE;
% NUM_ITERATIONS = simData.NUM_ITERATIONS;
SAMPLE_TECHNIQUE = simData.SAMPLE_TECHNIQUE;
K_MIXTURE_PARAMETER = simData.K_MIXTURE_PARAMETER;
RESAMPLE_OPTION = simData.RESAMPLE_OPTION;
MULTIPLICATION_OPTION = simData.MULTIPLICATION_OPTION;
BMS_OPTION = simData.BMS_OPTION;
SIMULATION_ITERATIONS = simData.SIMULATION_ITERATIONS;

Nagents = simTopology.Nagents;
Nanchors = simTopology.Nanchors;
x_i_pos = simTopology.x_i_pos;
% dist = simTopology.dist;
msg = simTopology.msg;
connections = simTopology.connections;
max_values = simTopology.max_values;


%Compatibility 
Nodes = x_i_pos;
num_devices = Nagents;
num_anchors = Nanchors;
Devices = Nodes(num_anchors+1:num_anchors+num_devices,:);
Anchors = Nodes(1:num_anchors,:);

SHOW_FIGURE = 0;

for i_sim = 1:SIMULATION_ITERATIONS
    disp('Creating messages between anchors and devices.');
    t_ini = tic;
%   Creation of messages between anchors and devices
    messages = cell(num_devices, num_anchors+num_devices);
    for i = 1:num_devices
        for j = 1:(num_anchors+num_devices)
            if connections(i,j) == 1
                %Message to NodeA from NodeB: createMessage(NodeA, NodeB)
                %NodeB --> NodeA
                if j <= num_anchors
                    %From an anchor:
                    messages{i, j} = createMessage(msg(:,j),Nodes(j,:) ,NSAMPLES);
                else
                    %From another device can not be calculated yet (the device does not know its own location)
                end
            else
                messages{i, j} = 1;
            end
        end
    end
    
    t_1 = toc(t_ini);
    sprintf('Done in %f seconds', t_1) 
    
    disp('Interchange of messages between anchors and devices.');
t_2 = tic;
    
    
     if (MULTIPLICATION_OPTION == 0)
        % IV.1 Initialization of devices, just take the messages from anchors
        messages_result = cell(num_devices,1);
        for i = 1: num_devices
            for j = 1:(num_anchors)
                if connections(i,j) == 1
                    if isempty(messages_result{i})
                        %If it is the first message we have to take them:
                        messages_result{i} = messages{i,j};
                    else
                        %If it is not the first message we have to multiplicate them
                        messages_result{i} = multiplicateMessages(messages_result{i}, messages{i,j},SAMPLE_TECHNIQUE,K_MIXTURE_PARAMETER,1,RESAMPLE_OPTION,BMS_OPTION);
                    end
                end
            end
        end

        if SHOW_FIGURE == 1
            %Plot of the location of the devices:
            figure
            if (RESAMPLE_OPTION == 0)
                plot(messages_result{1}(:,1), messages_result{1}(:,2),'*')
                hold all
                for i = 2:num_devices
                    plot(messages_result{i}(:,1), messages_result{i}(:,2),'*')
                end
                axis([0 max_values(1) 0 max_values(2)])
            elseif (RESAMPLE_OPTION == 1)
                max_weight = max(max(messages_result{1}(:,3)), max(messages_result{1}(:,3)));
                plot3(messages_result{1}(:,1), messages_result{1}(:,2), messages_result{1}(:,3),'*')
                hold all
                for i = 2:num_devices
                    plot3(messages_result{i}(:,1), messages_result{i}(:,2), messages_result{i}(:,3),'*')
                end
                axis([0 max_values(1) 0 max_values(2) 0 max_weight])
            end
            title('Initialization of the network')
            grid
        end
        t_3 = toc(t_2);
        sprintf('Network initialized in %f seconds', t_3)
        
        %Calculation of the error
        if (RESAMPLE_OPTION == 0)
            for i = 1:num_devices    
                %sprintf('Device %d', i)
                i_ = num_devices*(i_sim-1) + i;
                simulation_errors(1,i_) = norm(Devices(i,:) -  mean(messages_result{i}(:,1:2)));
            end
        elseif (RESAMPLE_OPTION == 1)
            for i = 1:num_devices    
                %sprintf('Device %d', i)
                i_ = num_devices*(i_sim-1) + i;
                simulation_errors(1,i_) = norm(Devices(i,:) - calculateMean(messages_result{i}) );
            end
        end
    end
    

%% IV.2 Mixture Sampling/Gibbs with all messages together multiplications

    if(MULTIPLICATION_OPTION == 1)
        % IV.1 Initialization of devices, just take the messages from anchors
        messages_result = cell(num_devices,1);
        for i = 1: num_devices
%             check{i} = multiplicateAllMessages(messages,0 ,connections, i, num_devices, num_anchors, NSAMPLES,SAMPLE_TECHNIQUE,K_MIXTURE_PARAMETER,1,RESAMPLE_OPTION,BMS_OPTION);
%             if check{i}(1) == 0
%                 disp('para');
%             end
%             if std(check{i}(:,1)) == 0
%                 disp('para');
%             end
            %tic
            messages_result{i} = multiplicateAllMessages(messages, 0,connections, i, num_devices,num_anchors, NSAMPLES,SAMPLE_TECHNIQUE,K_MIXTURE_PARAMETER,1,RESAMPLE_OPTION,BMS_OPTION);
            %toc
        end

        if SHOW_FIGURE == 1
            %Plot of the location of the devices:
            figure
            if (RESAMPLE_OPTION == 0)
                plot(messages_result{1}(:,1), messages_result{1}(:,2),'*')
                hold all
                for i = 2:num_devices
                    plot(messages_result{i}(:,1), messages_result{i}(:,2),'*')
                end
                axis([0 max_values(1) 0 max_values(2)])
            elseif (RESAMPLE_OPTION == 1)
                max_weight = max(max(messages_result{1}(:,3)), max(messages_result{2}(:,3)));
                plot3(messages_result{1}(:,1), messages_result{1}(:,2), messages_result{1}(:,3),'*')
                hold all
                for i = 2:num_devices
                    plot3(messages_result{i}(:,1), messages_result{i}(:,2), messages_result{i}(:,3),'*')
                end
                axis([0 max_values(1) 0 max_values(2) 0 max_weight])
            end
            title('Initialization of the network')
            grid
        end

        t_3 = toc(t_2);
        sprintf('Network initialized in %f seconds', t_3)
        
        %Calculation of the error
        if (RESAMPLE_OPTION == 0)
            for i = 1:num_devices    
                %sprintf('Device %d', i)
                i_ = num_devices*(i_sim-1) + i;
                simulation_errors(1,i_) = norm(Devices(i,:) -  mean(messages_result{i}(:,1:2)));
            end
        elseif (RESAMPLE_OPTION == 1)
            for i = 1:num_devices    
                %sprintf('Device %d', i)
                i_ = num_devices*(i_sim-1) + i;
                simulation_errors(1,i_) = norm(Devices(i,:) - calculateMean(messages_result{i}) );
            end
        end       
    end


    %% V. Results

    t_6 = toc(t_ini);
    sprintf('Simulation finished, total time: %f seconds', t_6)


%     Devices
    for i = 1:num_devices    
%         sprintf('Device %d', i)
%         mean(messages_result{i}(:,1))
%         mean(messages_result{i}(:,2))
        agent_pos(i,1) = mean(messages_result{i}(:,1));
        agent_pos(i,2) = mean(messages_result{i}(:,2));
    end

    simulation_errors(:,:);

    simulation_times(i_sim) = t_6;

    if SIMULATION_ITERATIONS > 1
        close all
    end   


disp('Localization error: ')
mean(simulation_errors')


disp('Localization time: ')
mean(simulation_times)

    
    
end

simOutput.simulation_errors = simulation_errors;
simOutput.simulation_times = simulation_times;
simOutput.agent_pos = agent_pos;

end

