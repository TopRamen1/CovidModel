classdef Grid < handle
    %GRID Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        size;
        people_number;
        people;
        Infected;
        Healthy;
        Recovered;
        InHospital;
        Dead;
        v;
        in_hospital_nr = 0;
        in_quarantine_nr = 0;

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
                tourism=rand;
                if tourism<0.90
                    tour=0
                else
                    tour=1
                end
                if i<= infected_number
                    People(i)=Person(pos(1),pos(2),MD_constant_values.infecting,MD_constant_values.infected,i, tour);
                else
                    People(i)=Person(pos(1),pos(2),MD_constant_values.no_security_measures,MD_constant_values.healthy,i, tour);
                end
                %obj.people(i)=Person(pos(1),pos(2));
            end
            
            obj.people=People;
        end
        
        function SimIteration(obj,it)
            
            GridPrev=-ones(obj.size);
            
            for i=1:obj.people_number
                GridPrev(obj.people(i).pos_x,obj.people(i).pos_y)=obj.people(i).state_q1;
            end
            
            for i=1:obj.people_number
                [obj.in_hospital_nr, obj.in_quarantine_nr] = obj.people(i).DefineState(GridPrev, obj.in_hospital_nr, obj.in_quarantine_nr);
            end
            
            for i=1:obj.people_number
                GridPrev=obj.people(i).Move(GridPrev);
            end
            
            % Variables to count number of specific type of people
            healthy_nr=0;
            recovered_nr=0;
            inf_and_s_nr=0;
            dead_nr = 0;
            hospital_nr = 0;
            quarantine_nr = 0;
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
                    hospital_nr=hospital_nr+1;
                end
                if obj.people(i).state_q2==MD_constant_values.dead;
                    dead_nr=dead_nr+1;
                end
            end
            
            infected_nr = obj.people_number - (hospital_nr + dead_nr + recovered_nr + healthy_nr);
            

            if obj.people(i).state_q2==MD_constant_values.in_quarantine;
                quarantine_nr=quarantine_nr+1;
            end                
            
            disp(['In hospital: ' num2str(hospital_nr) ', Dead: ' num2str(dead_nr) ', Quarantine: ' num2str(quarantine_nr) ', Healthy: ' num2str(healthy_nr) ', Infected and sick: ' num2str(inf_and_s_nr)]);
            obj.in_hospital_nr = hospital_nr;
            obj.in_quarantine_nr = quarantine_nr;

            % Display additional window with chart of dead and hospitalized people
            f1 = figure(1);
            movegui(f1,'northeast');
             
            % Hospital
            hos_size = MD_constant_values.hospital_size;

            x1_1=0; x1_2=hos_size; y1_1=0; y1_2 = x1_2;
            pos1 = [x1_1, x1_2, y1_1, y1_2];
            text = 'Hospital';
            color = 'p-';
            text_pos1 = [x1_1, y1_2+1.5];
            PlotPlace(hospital_nr, pos1, sprintf('%s', text), text_pos1, color, hos_size, MD_constant_values.hospital_capacity);
            hold on;
            
            % Cemetery

            cem_size = MD_constant_values.cemetery_size;

            shift = 1;
            x2_1 = x1_2+shift; x2_2 = x2_1+cem_size; y2_1 = x2_1; y2_2 = x2_2;
            pos2 = [x2_1, x2_2, y2_1, y2_2];
            text = 'Cemetery';
            color = 'b-';
            text_pos2 = [x2_1, y2_2+1.5];
            PlotPlace(dead_nr, pos2, sprintf('%s', text), text_pos2, color, cem_size, MD_constant_values.cemetery_capacity);
            hold on;
            
            % Quarantine place
            quar_size = MD_constant_values.quarantine_size;
            x3_1=x2_2+shift; x3_2=x3_1+quar_size; y3_1=x3_1; y3_2 = x3_2;
            pos3 = [x3_1, x3_2, y3_1, y3_2];
            text = 'Quarantine place';
            color = 'm-';
            text_pos3 = [x3_1, y3_2+1.5];
            PlotPlace(quarantine_nr, pos3, sprintf('%s', text), text_pos3, color, quar_size, MD_constant_values.quarantine_capacity);           
            
            xlim([0 hos_size+cem_size+quar_size+4*shift]);
            ylim([0 hos_size+cem_size+quar_size+4*shift]);
            
            % Plot live data
            
            f3 = figure(3);
            movegui(f3,'northwest');
            
            obj.Infected=[obj.Infected; infected_nr];
            obj.Healthy=[obj.Healthy; healthy_nr];
            obj.Recovered=[obj.Recovered; recovered_nr];
            obj.InHospital = [obj.InHospital; hospital_nr];
            obj.Dead = [obj.Dead; dead_nr];
            
            x = 1:it;
            
            plot(x,obj.Infected ,x,obj.Healthy ,x,obj.Recovered ,x,obj.InHospital ,x,obj.Dead);
            legend({'Infected','Healthy','Recovered','In Hospital','Dead'},'Location','best')
            disp(['len ' num2str(length(obj.Infected)) ' result ' num2str(length(1:it))]);

        end
        
       function PlotGrid(obj)
            
            figure(2);
            clf
            set(gcf,'color','w');
            xlim([0 obj.size]);
            ylim([0 obj.size]);
            plot(0.3,0.3,'*r')
            hold on;
            
           for i=1:obj.people_number
               obj.people(i).Plot();
           end
       end
       
    end
    
end


%-------------------------------------------------------------------------------------------------------%
% Additional function to plot a visualisation of dead and hospitalized people

function PlotPlace(people_nr, pos, txt, pos_text, color, plot_size, capacity) 
% people_nr - people number, pos - square position, txt - text above a square, pos_text - text position
% color - plot (people) color, plot_size - size of square, capacity - square capacity (hosp or ceme)
    x = [pos(1), pos(2)+1, pos(2)+1, pos(1), pos(1)];
    y = [pos(3), pos(3), pos(4)+1, pos(4)+1, pos(1)];
    plot(x, y, color, 'LineWidth', 3);
    text(pos_text(1), pos_text(2), txt)
    hold on;
    
    a = people_nr/plot_size;
    floor_a = fix(a);
    rest = people_nr - (floor_a*plot_size);
    
    if people_nr <= capacity
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
    else 
        for i=1:plot_size
            for j=1:plot_size
                plot(pos(1)+i, pos(3)+j, 'r*');
                hold on;
            end
         end
    end
    
    hold off  
end


