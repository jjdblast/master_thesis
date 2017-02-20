function [ simTopology ] = topologyRico()
%TOPOLOGYRICO Function which creates a topology for simulation


step_length=1;
xmin=0;
xmax=100;
ymin=0;
ymax=100;
zmin=0;
zmax=0;
max_values=[xmax,ymax,zmax];
dimensions=2;
com_range=20;
Nagents=100;
Nanchors=25;

x_i_CELL=cell(1,Nanchors+Nagents);
%Creations of anchors
xy_pair=[];
x_mat=repmat([0:25:100]',1,5);
y_mat=repmat(0:25:100,5,1);
for i=1:5
    xy_pair=[xy_pair [x_mat(i,:); y_mat(i,:)]];
end       
for i=1:Nanchors
    x_i_CELL{1,i}=xy_pair(:,i);
end
%Creation of agents
for i=1:Nagents
    x_i_CELL{1,i+Nanchors}=[xmax;ymax].*rand(2,1);
end
%Creation of the communication matrix
connections = zeros(Nagents, Nagents+Nanchors);
for i=(1+Nanchors):(Nanchors+Nagents)
    for j=1:(Nanchors+Nagents)
        if (norm(x_i_CELL{i} - x_i_CELL{j}) <= com_range)&&(i ~= j)
            connections(i-Nanchors,j) = 1;
        end
    end
end

simTopology.Nagents = Nagents;
simTopology.Nanchors = Nanchors;
simTopology.com_range = com_range;
simTopology.x_i_CELL = x_i_CELL;
simTopology.connections = connections;
simTopology.max_values = max_values;

%Plot of the topology
%plotTopology(simTopology)



end

