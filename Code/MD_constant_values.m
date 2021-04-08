classdef MD_constant_values
    properties (Constant)
        
    grid_size=10;
    people_nr=20;    
    initial_infected_number=10;
    
    initial_movement_prob=0.5;
    
    % Variables - Additional plot with hospital and cemetery visualisation 
    % percentage value of the number of people (people_nr)
    hospital_size = 0.25;
    cemetery_size = 0.25;
    
    %infected

    infection_prob=0.01;
    sick_prob = 0.015;
    infected_sick_prob = 0.9;

    dead_prob = 0.2;
    hosp_prob = 0.03;
    sick_hosp_prob = 0.02;
    test_accuracy = 0.8;
    test_prob = 0.2;
    quarantine_prob = 0.2
    R = 15;
    H = 5;
    S = 5;
    Q = 10;

    W = 0;
    volcano_ = 1;
 
    simulation_delay=0.5;
    simulation_steps=400;
    
    % states Q1
    no_security_measures=0;
    infecting=1;
    protecting_others=2;
    self_protecting=3;
    organizing_protection=4;
    tested_positive = 5;
    
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