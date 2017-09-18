% Problem Definition and Parameters Setting
Num_Nodes =  7;
Distance = [ 0, 19, 92, 29, 49, 78,  6;
            19,  0, 21, 85, 45, 16, 26; 
            92, 21,  0, 24, 26, 87, 47;
            29, 85, 24,  0, 76, 17,  8;
            49, 45, 26, 76,  0, 90, 27;
            78, 16, 87, 17, 90,  0, 55;
             6, 26, 47,  8, 27, 55,  0];
         
Temperature = input('Please input the temperature: ');  
if isempty (Temperature)  
    Temperature = 300;
end
CoolingRate = input('Please input the cooling rate: ');  
if isempty (CoolingRate) 
    CoolingRate = 0.95;
end
Num_Iteration = input('Please input the times of iteration: '); 
if isempty (Num_Iteration)
    Num_Iteration = 500;
end

tic  % Start stopwatch timer

for Iteration = 1:Num_Iteration
    if (Iteration == 1) % Initialize the Solution
        x_now = randperm(Num_Nodes); 
        Obj_now = 0;
        for i = 1:(Num_Nodes -1)
            Obj_now = Obj_now + Distance(x_now(i),x_now(i+1));
        end
        Obj_now = Obj_now + Distance(x_now(i+1),x_now(1));
        Obj = Obj_now;
        
    else % Neighborhood Search
        tmp = randperm(Num_Nodes);
        tmp = tmp(1:2);
        x_next = x_now;
        x_next(x_now==tmp(1)) = tmp(2);
        x_next(x_now==tmp(2)) = tmp(1);
        Obj_now = 0;
        for i = 1:(Num_Nodes -1)
            Obj_now = Obj_now + Distance(x_next(i),x_next(i+1));
        end
        Obj_now = Obj_now + Distance(x_next(i+1),x_next(1));
        
        if (Obj_now <= Obj)
            Obj = Obj_now;
            x_now = x_next;
        end
        
        if (Obj_now > Obj)
            Boltzmann = min(1, exp(-(Obj_now-Obj)/Temperature));
            rand = rand();
            if (rand < Boltzmann)
                Obj = Obj_now;
                x_now = x_next;
            end
        end
        
        % Cool Down Process
        Temperature = CoolingRate*Temperature;
    end
end

% Report the Results
disp('--- Final Report ---');
disp('Optimal Solution = '); 
    disp(x_now);
fprintf('Optimal_Value : %d\n',Obj);

toc  % Read elapsed time from stopwatch
