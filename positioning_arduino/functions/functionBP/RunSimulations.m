%% Script to run a set of simulations
% clc, clear all, close all
addpath ProgramFunctions NetworkTopologies
addpath BMS_functions additional_functions program_functions



%Datos sobre la topologia

simTopology.Nagents = 1;
simTopology.Nanchors = 3;

%Matriz de conexiones, indica como estan conectados los agents con los
%anchors y otros agents, en tu caso de 1 agent conectado a 3 anchors sería
%esta:
simTopology.connections = [1 1 1 0];

%Maximos valores en el eje x, y, z; no se como es tu red en distancias
%pero para 100x100 metros. z siempre es 0.
simTopology.max_values = [100,100,0];

%Posiciones x y de los agents y anchorsprimero anchors y luego agents
%en tu caso:
%SI HAY QUE METER LA POSICION EXACTA DEL AGENT PERO ES PARA CALCULAR EL
%ERROR EN LA MEDIDA, SI NO QUIERES CALCULARLO PON QUE LA POSICION ES 0 E
%IGNORA EL ERROR
%ESO SI LAS DE LOS ANCHORS SON OBLIGATORIAS
% posiciones = [Anchor1_x Anchor1_y; Anchor2_x Anchor2_y; Anchor3_x Anchor3_y; ...
%      Agent1_x Angent1_y];
posiciones = [10 10; 50 50; 50 10; 25 25];
simTopology.x_i_pos = posiciones;

%Los mensajes enviados de los anchor a los agents, si envia 100 mensajes
%cada anchor, tendremos una matriz de 100 filas x 3 columnas
MsgAnchor1ToAgent1 = [23 21 22 25 22 21 23 21];
MsgAnchor2ToAgent1 = [43 42 44 41 42 48 39 42];
MsgAnchor3ToAgent1 = [23 22 28 24 19 23 22 21];
mensajes = [MsgAnchor1ToAgent1' MsgAnchor2ToAgent1' MsgAnchor3ToAgent1'];
simTopology.msg = mensajes;


%Datos sobre la simulacion

%Esto ya te lo explicare con detalle, lo unico que te interesa por ahora es
%el numero de muestras NSAMPLES, para que sea acorde con los mensajes
%trasmitidos tomamos el siguiente valor

[simData.NSAMPLES, ~] = size(simTopology.msg);

simData.SIGMA = 0.1;
simData.ERROR_TYPE = 'Gaussian'; % 'Gaussian', 'Exponential', 'Uniform'
simData.NUM_ITERATIONS = 3;
simData.SAMPLE_TECHNIQUE = 'Importance'; % 'Importance', 'Mixture', 'Gibbs'
simData.K_MIXTURE_PARAMETER = 300; % Only in mixture: Max value is the number of devices + 1 is connected a device
simData.RESAMPLE_OPTION = 0; % Only in Importance: 0-yes, 1-no
simData.MULTIPLICATION_OPTION = 0; % 0-2on2 1-all together
simData.BMS_OPTION = 0; %Bandwidth Matrix Selector from 0 to 16
simData.SIMULATION_ITERATIONS = 1;



% Plot de la topologia REAL ANTES DE LA SIMULACION
plotTopology(simTopology)

% La simulacion
simOutput = simulateNetwork(simTopology, simData);

% Plot de los errores
plotSimOutput(simOutput);

% Plot de la topologia ESTIMAADA DESPUES DE LA SIMULACION
plotTopologyAfter(simTopology, simOutput)

