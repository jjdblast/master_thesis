function [] = plotSimOutput(handles, simOutput)
%PLOTSIMOUTPUT Function which analuze the output of the simulation and
%analize the errors

simulation_errors = simOutput.simulation_errors;
%Each row represents an iteration

[Niterations, Nvalues] = size(simulation_errors);
steps = 0:0.5:20;

cdf_int = zeros(Niterations,length(steps));

for i=1:Niterations
    for k=1:length(steps)
        for j=1:Nvalues
            if simulation_errors(i,j) >= steps(k);
                cdf_int(i,k) = cdf_int(i,k) + 1;
            end
        end
    end
end

cdf_int = cdf_int./Nvalues;

hold (handles.axes_algo, 'on')
newleg = {};
for i=1:Niterations
    plot(handles.axes_algo, steps,cdf_int(i,:),'linewidth',3)
    hold (handles.axes_algo, 'on')
    newleg{length(newleg)+1} = sprintf('Iteration %d', i);
end
grid
% axis([0 steps(end) 0 1])
% legend(newleg);

end

