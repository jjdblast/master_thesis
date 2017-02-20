function [] = plotTopologyAfter(handles, simTopology, simOutput)
%PLOTTOPOLOGY Function which plots a topology


Nagents = simTopology.Nagents;
Nanchors = simTopology.Nanchors;
% com_range = simTopology.com_range;
x_i_pos = simTopology.x_i_pos;
% connections = simTopology.connections;
max_values = simTopology.max_values;

agent_pos = simOutput.agent_pos;

hold (handles.axes_algo, 'on')
% for i = 1:Nanchors
%     p1=plot(handles.axes_algo, x_i_pos(i,1), x_i_pos(i,2), 'o','Color',[0.7529  0 0], 'MarkerFaceColor', [0.7529  0 0], 'MarkerSize', 10);
%     hold (handles.axes_algo, 'on');
% end
% for i = 1+Nanchors:Nanchors+Nagents
%     p2=plot(handles.axes_algo, x_i_pos(i,1), x_i_pos(i,2), 'x','Color',[0.098 0.4784 0.5176], 'MarkerFaceColor', [0.098 0.4784 0.5176], 'MarkerSize', 10, 'LineWidth', 3);
%     hold (handles.axes_algo, 'on');
% end
for i = 1:Nagents
    plot(handles.axes_algo, agent_pos(i,1), agent_pos(i,2), 'x','Color',[0.9255 0.4313 0], 'MarkerFaceColor', [0.098 0.4784 0.5176], 'MarkerSize', 10, 'LineWidth', 3,'DisplayName','BP');
    hold (handles.axes_algo, 'on');
end

legend(handles.axes_algo, '-DynamicLegend');

% grid
% axis([0 max_values(1) 0 max_values(2)])
% xlabel('Horizontal Distance in m','FontSize',12,'FontWeight','bold')
% ylabel('Vertical Distance in m','FontSize',12,'FontWeight','bold')
% title('Network Topology','FontSize',12,'FontWeight','bold')
% set(gca,'FontSize',12)
% legend([p1 p2 p3],'Anchors', 'Agents real', 'Agents estimated')

end

