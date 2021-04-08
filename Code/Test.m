clear all
close all

Map=Grid(MD_constant_values.grid_size,MD_constant_values.people_nr);
Map.InitGrid(MD_constant_values.initial_infected_number);

for i=1:MD_constant_values.simulation_steps
    disp('----------------------------------------------------------');
    disp(['Iteration ' num2str(i)]);
    Map.SimIteration();
    Map.PlotGrid();
    pause(MD_constant_values.simulation_delay);
end