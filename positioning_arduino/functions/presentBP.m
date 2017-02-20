function [ ] = presentBP( handles, positions, tag, list_of_distances, nSamples )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
        % Set the scenario
        simTopology.Nagents = 1;
        simTopology.Nanchors = size(positions,1);

        % Connection matrix
        % As only one tag is in the scenario, it is composed by a vector
        % Nanchors ones and a zero (for the agent)
        connections_aux = ones(1, simTopology.Nanchors);
        simTopology.connections = horzcat(connections_aux, 0);

        % Maximun axis values
        x_str_coords = positions(:,2);
        x_coords = str2double(x_str_coords);
        x_max = max(x_coords);
        y_str_coords = positions(:,3);
        y_coords = str2double(y_str_coords);
        y_max = max(y_coords);
        simTopology.max_values = [x_max,y_max,0];

        % posiciones = [Anchor1_x Anchor1_y; Anchor2_x Anchor2_y; Anchor3_x Anchor3_y; ...
        %      Agent1_x Angent1_y];
        agent_x_pos = tag(:,1);
        agent_x = mean (agent_x_pos);
        agent_y_pos = tag(:,2);
        agent_y = mean (agent_y_pos);
        
        posiciones = zeros (simTopology.Nanchors+1,2);
        
        for row = 1:simTopology.Nanchors
            posiciones(row,1) = x_coords(row);
            posiciones(row,2) = y_coords(row);
        end
        posiciones(simTopology.Nanchors+1,1) = agent_x;
        posiciones(simTopology.Nanchors+1,2) = agent_y;
        simTopology.x_i_pos = posiciones;

        % Mensajes is messages sent from anchors to agent. As there is
        % only one agent, the matrix is nSamples rows x nAnchors columns
        mensajes = str2double(list_of_distances(1:nSamples,3));
        for column = 2:simTopology.Nanchors
            mensajes_aux = str2double(list_of_distances((column-1)*nSamples+1:column*nSamples,3));
            mensajes = horzcat(mensajes, mensajes_aux);
        end
        
        simTopology.msg = mensajes;


        % Sim Data -- Not my work
        [simData.NSAMPLES, ~] = size(simTopology.msg);

        % simData.SIGMA = 0;
        % simData.ERROR_TYPE = 'Gaussian'; % 'Gaussian', 'Exponential', 'Uniform'
        % simData.NUM_ITERATIONS = 3;
        simData.SAMPLE_TECHNIQUE = 'Importance'; % 'Importance', 'Mixture', 'Gibbs'
        simData.K_MIXTURE_PARAMETER = 300; % Only in mixture: Max value is the number of devices + 1 is connected a device
        simData.RESAMPLE_OPTION = 0; % Only in Importance: 0-yes, 1-no
        simData.MULTIPLICATION_OPTION = 0; % 0-2on2 1-all together
        simData.BMS_OPTION = 0; %Bandwidth Matrix Selector from 0 to 16
        simData.SIMULATION_ITERATIONS = 1;

        % Top before simulation, already done
        % plotTopology(handles, simTopology);

        % Simulation
        simOutput = simulateNetwork(simTopology, simData);
        info_aux = simOutput.agent_pos
        info = strcat ('Estimator: (', num2str(round(info_aux(1),0)), ',', num2str(round(info_aux(2),0)), ')');
        set(handles.text_algo_estimator, 'String', info);
        % Error plot
        % plotSimOutput(handles, simOutput);

        % Plot after simulation
        plotTopologyAfter(handles, simTopology, simOutput);
        
        

end

