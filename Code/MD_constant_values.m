classdef MD_constant_values
    properties (Constant)
        
    grid_size=40;
    people_nr=100;    
    initial_infected_number=50;
    
    initial_movement_prob=0.5;
    
    % Variables - Additional plot with hospital and cemetery visualisation 
    % percentage value of the number of people (people_nr)
    hospital_size = 0.25;
    cemetery_size = 0.25;
    
    %infected
    infection_prob=0.8;
    sick_prob = 0.99;
    dead_prob = 0.2;
    hosp_prob = 0.1;
    R = 8;
    H = 5;
    S = 5;
    
    simulation_delay=0.5;
    simulation_steps=100;
    
    % states Q1
    no_security_measures=0;
    infecting=1;
    protecting_others=2;
    self_protecting=3;
    organizing_protection=4;
    
    % states Q2
    healthy=0;
    in_quarantine=1;
    infected=2;
    sick=3;
    infected_and_sick=4;
    in_hospital=5;
    recovered=6;
    dead=7;
    
    
    end
end