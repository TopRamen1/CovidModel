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
            
            healthy_nr=0;
            recovered_nr=0;
            inf_and_s_nr=0;
            
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
                
             end
            
             disp(['Healthy ' num2str(healthy_nr) ' revovered ' num2str(recovered_nr) ' infected and sick ' num2str(inf_and_s_nr) ' infected ' num2str(obj.people_number-healthy_nr-inf_and_s_nr-recovered_nr)]);
             
    
             figure(1);
             x1=0; x2=round(sqrt(MD_constant_values.people_nr))+1; y1=0; y2 = x2;
             x = [x1, x2, x2, x1, x1];
             y = [y1, y1, y2, y2, y1];
             txt = '\downarrow Recovered people ';
             text(x1+2, x2+1, txt)
             plot(x, y, 'b-', 'LineWidth', 3);
             hold on;
             temp = recovered_nr/(x2-1)
             temp2 = fix(temp)
             pozostali = (temp*10)-(temp2*10)
             for i=1:temp2
                 for j=1:10
                     plot(i, j, 'r*')
                     hold on
                 end               
             end
             
             for i=1:pozostali
                 plot(temp2+1, i, 'r*')
             end
             
             
             
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
