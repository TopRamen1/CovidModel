clear all
close all
clc

Map=Grid(MD_constant_values.grid_size,MD_constant_values.people_nr);
Map.InitGrid(MD_constant_values.initial_infected_number);

for i=1:MD_constant_values.simulation_steps
    disp('----------------------------------------------------------');
    disp(['Iteration ' num2str(i)]);
    Map.SimIteration(i);
    Map.PlotGrid();
    pause(MD_constant_values.simulation_delay);
end