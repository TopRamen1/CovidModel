classdef Person < handle
    %GRID Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id_number;
        pos_x;
        pos_y;
        state_q1;
        state_q2;
        movement_prob;
        is_tourist;
        r;
        h;
        s;
        q;
        test_result;
        was_tested;

        w;
        volcano;
    end
    
    methods
        function obj = Person(pos_x_,pos_y_,q1,q2,id_number_,is_tourist_)
            if nargin > 0
                obj.pos_x=pos_x_;
                obj.pos_y=pos_y_;
                obj.state_q1=q1;
                obj.state_q2=q2;
                obj.is_tourist=is_tourist_;
                obj.id_number=id_number_;
                obj.r=MD_constant_values.R;
                obj.h=MD_constant_values.H;
                obj.w=MD_constant_values.W;
                obj.volcano=MD_constant_values.volcano_;
                obj.s=MD_constant_values.S;
                obj.movement_prob=MD_constant_values.initial_movement_prob;
                obj.test_result = 0;
                obj.was_tested = 0;
            end
        end
        
        function GetInfected(obj,i,j,GridPrev)
            if GridPrev(i,j)==MD_constant_values.infecting || GridPrev(i,j)==MD_constant_values.tested_positive
                if obj.state_q2==MD_constant_values.healthy && rand<=MD_constant_values.infection_prob
                    disp(['Got infected ' num2str(obj.id_number)]);
                    obj.state_q1=MD_constant_values.infecting;
                    obj.state_q2=MD_constant_values.infected;
                    obj.r=MD_constant_values.R;
                end
            end
        end
               
        function [in_quarantine_out] = GetQarantine(obj,i,j,GridPrev, in_quarantine_nr)
            in_quarantine_out=in_quarantine_nr;
            if in_quarantine_nr < MD_constant_values.quarantine_capacity
                if GridPrev(i,j)==MD_constant_values.tested_positive
                    if obj.state_q2==MD_constant_values.healthy && rand<=MD_constant_values.quarantine_prob
                        disp(['Got Qarantine ' num2str(obj.id_number)]);
                        obj.state_q1=MD_constant_values.protecting_others;
                        obj.state_q2=MD_constant_values.in_quarantine;
                        obj.q=MD_constant_values.Q;
                        in_quarantine_out=in_quarantine_nr+1;
                    end
                end
            end
        end
        
        function GetHealthy(obj)
            if obj.state_q1==MD_constant_values.infecting && obj.state_q2==MD_constant_values.infected;
               if obj.r > 0
                   obj.r = obj.r-1;
               end
               if obj.r == 0
                   rn = rand;
                   %disp(['rand' num2str(rn)])
                   if rn<=MD_constant_values.infected_sick_prob
                       obj.state_q1=MD_constant_values.infecting;
                       obj.state_q2=MD_constant_values.infected_and_sick;
                       disp(['Got sick and infected ' num2str(obj.id_number)]);
                   else
                       obj.state_q1=MD_constant_values.no_security_measures;
                       obj.state_q2=MD_constant_values.recovered;
                       disp(['Recovered ' num2str(obj.id_number)]);
                   end
               end   
            end
            
            if obj.state_q2==MD_constant_values.sick
                if obj.s > 0
                    obj.s = obj.s - 1;
                else
                   rn = rand;
                   %disp(['rand' num2str(rn)])
                   if rn<=MD_constant_values.sick_hosp_prob
                       obj.state_q1=MD_constant_values.protecting_others;
                       obj.state_q2=MD_constant_values.in_hospital;
                       disp(['Got hospitalized ' num2str(obj.id_number)]);
                   else
                       obj.state_q1=MD_constant_values.no_security_measures;
                       obj.state_q2=MD_constant_values.healthy;
                       disp(['Got healthy ' num2str(obj.id_number)]);
                   end
                end
            end
            
            if obj.state_q2==MD_constant_values.in_quarantine
                if obj.q > 0
                   obj.q = obj.q - 1;
                else
                   obj.state_q1=MD_constant_values.no_security_measures;
                   obj.state_q2=MD_constant_values.healthy;
                   disp(['Got hospitalized ' num2str(obj.id_number)]);
                end
            end
        end
        
        function [in_hospital_out] = GetHospitalized(obj, in_hospital_nr)
            in_hospital_out=in_hospital_nr;
            if in_hospital_nr < MD_constant_values.hospital_capacity
                if (obj.state_q2==MD_constant_values.infected_and_sick || obj.state_q1==MD_constant_values.tested_positive) 
                    rn = rand;
                    %disp(['rand' num2str(rn)])
                    if rn<=MD_constant_values.hosp_prob
                        if (obj.state_q1~=MD_constant_values.tested_positive)
                            obj.state_q1=MD_constant_values.protecting_others;
                            obj.state_q2=MD_constant_values.in_hospital;
                            in_hospital_out=in_hospital_nr+1;
                        end
                        disp(['Got hospitalized ' num2str(obj.id_number)]);
                    end
                end
            end
        end
        
        function GetOutOfHospital(obj)
            if obj.state_q1==MD_constant_values.protecting_others && obj.state_q2==MD_constant_values.in_hospital
                if obj.h > 0
                    obj.h = obj.h - 1;
                else
                   rn = rand;
                   %disp(['rand' num2str(rn)])
                   if rn<=MD_constant_values.dead_prob
                       obj.state_q1=MD_constant_values.protecting_others;
                       obj.state_q2=MD_constant_values.dead;
                       disp(['DIE ' num2str(obj.id_number)]);
                   else
                       obj.state_q1=MD_constant_values.no_security_measures;
                       obj.state_q2=MD_constant_values.recovered;
                       disp(['Recovered ' num2str(obj.id_number)]);
                   end
                end
            end
        end
        
        function GetSick(obj)
            if obj.state_q2==MD_constant_values.healthy && rand<=MD_constant_values.sick_prob
                disp(['Got sick ' num2str(obj.id_number)]);
                obj.state_q1=MD_constant_values.no_security_measures;
                obj.state_q2=MD_constant_values.sick;
                obj.s=MD_constant_values.S;
            end
        end
        
        function DoTest(obj)
            if obj.state_q2==MD_constant_values.infected_and_sick || obj.state_q2==MD_constant_values.infected
                if rand<= MD_constant_values.test_prob && ~(obj.was_tested)
                    obj.was_tested = 1;
                    rn = rand;
                    %disp(['rand' num2str(rn)])
                    if rn<=MD_constant_values.test_accuracy
                        obj.test_result = 1;
                        obj.state_q1 = MD_constant_values.tested_positive;
                    end
                    disp(['Tested ' num2str(obj.id_number) ' result ' num2str(obj.test_result)]);
                end
            end
        end
        
        function [in_hospital_out, in_quarantine_out] = DefineState(obj, GridPrev, in_hospital_nr, in_quarantine_nr)
            %disp('----------------------------------------------------------')
            in_quarantine_out = in_quarantine_nr;
            for i=max(obj.pos_x-1,1):min(obj.pos_x+1,MD_constant_values.grid_size)
                for j=max(obj.pos_y-1,1):min(obj.pos_y+1,MD_constant_values.grid_size)
                    if ~(i==obj.pos_x && j==obj.pos_y)
                        GetInfected(obj,i,j,GridPrev)
                        in_quarantine_out = GetQarantine(obj,i,j,GridPrev, in_quarantine_nr);
                    end
                end
            end
            GetHealthy(obj)
            in_hospital_out = GetHospitalized(obj, in_hospital_nr);
            GetOutOfHospital(obj)
            GetSick(obj)
            DoTest(obj)
        end
        
        
        
        function GridPrev=Move(obj,GridPrev)
            if obj.is_tourist == 1
                obj.movement_prob = 1
                obj.w = obj.w + 1
                if rem(obj.w,30) == 0 
                    obj.volcano = ~(obj.volcano)
                end
            else
                obj.volcano = 0
            end
            
            if rand<=obj.movement_prob
                %disp('----------------------------------------------------------')
                %disp(['Person ' num2str(obj.id_number) ' pos ' num2str(obj.pos_x) ' ' num2str(obj.pos_y)]);
                new_positions=[];
                if obj.is_tourist==1
                    for i=max(obj.pos_x-4,1):min(obj.pos_x+4,MD_constant_values.grid_size)
                        for j=max(obj.pos_y-4,1):min(obj.pos_y+4,MD_constant_values.grid_size)
                            if ~(i==obj.pos_x && j==obj.pos_y)
                                if GridPrev(i,j)==-1
                                    %disp(['i ' num2str(i) ' j ' num2str(j)]);
                                    new_positions=[new_positions; [i j]];
                                end
                            end
                        end
                    end
                else
                    for i=max(obj.pos_x-1,1):min(obj.pos_x+1,MD_constant_values.grid_size)
                        for j=max(obj.pos_y-1,1):min(obj.pos_y+1,MD_constant_values.grid_size)
                            if ~(i==obj.pos_x && j==obj.pos_y)
                                if GridPrev(i,j)==-1
                                    %disp(['i ' num2str(i) ' j ' num2str(j)]);
                                    new_positions=[new_positions; [i j]];
                                end
                            end
                        end
                    end
                end
                if ~isempty(new_positions)
                    GridPrev(obj.pos_x,obj.pos_y)=-1;
                    if obj.volcano==1
                        obj.movement_prob=1;
                        minimum_x = 1;
                        minimum_y = 1;
                        for z = 1:length(new_positions)
                            if new_positions(z,1)<=new_positions(minimum_x,1) && new_positions(z,2)<=obj.pos_y
                                minimum_x = z
                            end
                        end
                        for c = 1:length(new_positions)
                            if new_positions(c,2)<=new_positions(minimum_y,2) && new_positions(c,1)<=obj.pos_x
                                minimum_y = c
                            end
                        end 
                        if rem(obj.w,2) == 0 
                            minimum = minimum_x
                        else
                            minimum = minimum_y
                        end
                        obj.pos_x=new_positions(minimum,1)
                        obj.pos_y=new_positions(minimum,2)
                        GridPrev(obj.pos_x,obj.pos_y)=1;
                    else
                        GridPrev(obj.pos_x,obj.pos_y)=-1;
                        if ~isempty(new_positions) 
                            new_position=randi(length(new_positions)); %%ttt
                            obj.pos_x=new_positions(new_position,1);
                            obj.pos_y=new_positions(new_position,2);
                            GridPrev(obj.pos_x,obj.pos_y)=1;
                        end
                    end
                end
            end
        end
        
        function Plot(obj) 
            if obj.state_q2==MD_constant_values.healthy
                colour='.b';         
            elseif obj.state_q2==MD_constant_values.infected || obj.state_q2==MD_constant_values.infected_and_sick
                colour='.y';
            elseif obj.state_q2==MD_constant_values.recovered
                colour='.g';
            elseif obj.state_q1==MD_constant_values.tested_positive
                colour='.r';
            elseif obj.state_q2==MD_constant_values.in_hospital
                colour='.w';
            elseif obj.state_q2==MD_constant_values.dead
                colour='.w';
            elseif obj.state_q2==MD_constant_values.in_quarantine
                colour='.w';
            elseif obj.state_q2==MD_constant_values.sick
                colour='.c';
            end           
            plot(obj.pos_x,obj.pos_y,colour,'MarkerSize',20);
        end
        
    end
    
end
