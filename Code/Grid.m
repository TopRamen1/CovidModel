classdef Grid < handle
    %GRID Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        size;
        people_number;
        people;
    end
    
    methods
        function obj = Grid(size_,people_nr_)
            if nargin > 0
                obj.size=size_;
                obj.people_number=people_nr_;
            end
        end
        
        function InitGrid(obj,infected_number)
                
            for i=1:obj.people_number
                pos = randi([1 obj.size],1,2);
                
                if i<= infected_number
                    People(i)=Person(pos(1),pos(2),MD_constant_values.infecting,MD_constant_values.infected,i);
                else
                    People(i)=Person(pos(1),pos(2),MD_constant_values.no_security_measures,MD_constant_values.healthy,i);
                end
                %obj.people(i)=Person(pos(1),pos(2));
            end
            
            obj.people=People;
        end
        
        function SimIteration(obj)
            
            GridPrev=-ones(obj.size);
            
            for i=1:obj.people_number
                GridPrev(obj.people(i).pos_x,obj.people(i).pos_y)=obj.people(i).state_q1;
            end
            
            for i=1:obj.people_number
                obj.people(i).DefineState(GridPrev);
            end
            
            for i=1:obj.people_number
                GridPrev=obj.people(i).Move(GridPrev);
            end
            
            % Variables to count number of specific type of people
            healthy_nr=0;
            recovered_nr=0;
            inf_and_s_nr=0;
            dead_nr = 0;
            
            for i=1:obj.people_number
                if obj.people(i).state_q2==MD_constant_values.healthy;
                    healthy_nr=healthy_nr+1;
                end
                if obj.people(i).state_q2==MD_constant_values.recovered;
                    recovered_nr=recovered_nr+1;
                end
                if obj.people(i).state_q2==MD_constant_values.infected_and_sick;
                    inf_and_s_nr=inf_and_s_nr+1;
                end
                if obj.people(i).state_q2==MD_constant_values.in_hospital;
                    MD_constant_values.in_hospital_nr=MD_constant_values.in_hospital_nr+1;
                end
                if obj.people(i).state_q2==MD_constant_values.dead;
                    dead_nr=dead_nr+1;
                end
                
            end
            
            disp(['In hospital: ' num2str(in_hospital_nr) ', Dead: ' num2str(dead_nr) ', Recovered: ' num2str(recovered_nr) ', Healthy: ' num2str(healthy_nr) ', Infected and sick: ' num2str(inf_and_s_nr)]);
             
            % Display additional window with chart of dead and hospitalized people
            f1 = figure(1);
            movegui(f1,'northeast');
             
            % Hospital
            hos_size = MD_constant_values.hospital_size;
            x1_1=0; x1_2=hos_size; y1_1=0; y1_2 = x1_2;
            pos1 = [x1_1, x1_2, y1_1, y1_2];
            text = 'Hospital';
            color = 'r-';
            text_pos1 = [x1_1, y1_2+2];
            PlotPlace(in_hospital_nr, pos1, sprintf('%s', text), text_pos1, color, hos_size);
            hold on;
            % Cemetery
            cem_size = MD_constant_values.cemetery_size;
            shift = 1;
            x2_1=x1_2+shift; x2_2=x2_1+cem_size; y2_1=x2_1; y2_2 = x2_2;
            pos2 = [x2_1, x2_2, y2_1, y2_2];
            text = 'Cemetery';
            color = 'b-';
            text_pos2 = [x2_1, y2_2+2];
            PlotPlace(dead_nr, pos2, sprintf('%s', text), text_pos2, color, cem_size);
            
            xlim([0 obj.size]);
            ylim([0 obj.size]);
        end
        
       function PlotGrid(obj)
            
           figure(2);
           clf
           set(gcf,'color','w');
           xlim([0 obj.size]);
           ylim([0 obj.size]);
           hold on;
            
           for i=1:obj.people_number
               obj.people(i).Plot();
           end
       end
       
    end
    
end


%-------------------------------------------------------------------------------------------------------%
% Additional function to plot a visualisation of dead and hospitalized people

function PlotPlace(people_nr, pos, txt, pos_text, color, plot_size) 
% people_nr - people number, pos - square position, txt - text above a square, pos_text - text position
% color - plot (people) color, plot_size - size of square
    x = [pos(1), pos(2)+1, pos(2)+1, pos(1), pos(1)];
    y = [pos(3), pos(3), pos(4)+1, pos(4)+1, pos(1)];
    plot(x, y, color, 'LineWidth', 3);
    text(pos_text(1), pos_text(2), txt)
    hold on;
    
    a = people_nr/plot_size;
    floor_a = fix(a);
    rest = people_nr - (floor_a*plot_size);
    
    if floor_a ~= 0
        for i=1:floor_a
            for j=1:plot_size
                plot(pos(1)+i, pos(3)+j, 'r*');
                hold on;
            end
        end

        for i=1:rest
            plot(pos(1)+floor_a+1, pos(3)+i, 'r*');
            hold on;
        end
    else
        for i=1:rest
            plot(pos(1)+1, pos(3)+i, 'r*');
            hold on;
        end
    end
    
    hold off  
end


