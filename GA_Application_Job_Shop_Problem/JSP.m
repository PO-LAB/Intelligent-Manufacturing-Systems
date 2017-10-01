clear;
% Problem Definition and Parameters Setting
j_num = xlsread('JSP_dataset.xlsx','Parameters','B2'); 
ma_num = xlsread('JSP_dataset.xlsx','Parameters','B3'); 
PT = xlsread('JSP_dataset.xlsx','ProcessingTime','B2:K11'); 
Ma = xlsread('JSP_dataset.xlsx','MachineSequence','B2:K11'); 

population_size = input('Please input the size of population: '); 
if isempty (population_size) 
    population_size = 30;
end
crossover_rate = input('Please input the Crossover Rate: ');
if isempty (crossover_rate) 
    crossover_rate = 0.9;
end
mutation_rate = input('Please input the Mutation Rate: '); 
if isempty (mutation_rate) 
    mutation_rate = 0.1;
end
Num_Iteration = input('Please input the Iteration Times: '); 
if isempty (Num_Iteration) 
    Num_Iteration = 50000;
end

tic % Start stopwatch timer


population_list = zeros(population_size, j_num*ma_num); % Record population (includes all chromosomes).

% Initialize the Solution
for m = 1:population_size 
    population_list(m,1:j_num*ma_num) = randperm(j_num*ma_num);
    for j = 1:j_num*ma_num 
        for k = 0:(j_num-1)
            if population_list(m,j) > k*ma_num && population_list(m,j) <= (k+1)*ma_num
                population_list(m,j) = k+1;
            end
        end
    end
end

Makespan_best = 9999999999; 
Scheduling_best = zeros(1, j_num*ma_num);  

for i = 1:Num_Iteration
    % Crossover
    population_list_tmp = population_list;
    S = randperm(population_size); 
    for m = 1:(population_size/2)
        crossover_prob = rand();
        if (crossover_rate >= crossover_prob) 
            parent_1 = population_list(S(-1+2*m),1:j_num*ma_num); 
            parent_2 = population_list(S(2*m),1:j_num*ma_num); 
            child_1 = parent_1; 
            child_2 = parent_2; 
            cutpoint = randperm(j_num*ma_num); 
            cutpoint = sort(cutpoint(1:2)); 
            for k = cutpoint(1):cutpoint(2) 
                child_1(k) = parent_2(k);
                child_2(k) = parent_1(k);
            end
            population_list(S(-1+2*m),1:j_num*ma_num) = child_1;
            population_list(S(2*m),1:j_num*ma_num) = child_2;
        end
    end
    
    % Mutation
    for m = 1:population_size
        for j = 1:j_num*ma_num
            mutation_prob = rand();  
            if mutation_rate >= mutation_prob  
                ran_num = rand(); 
                for k = 0:(j_num-1)
                    if ran_num > k*(1/j_num) && ran_num <= (k+1)*(1/j_num)
                        population_list(m,j) = k+1;
                    end
                end
            end
        end
    end
    
    % Repairment
    for m = 1:population_size 
        repair_or_not = zeros(1, j_num);
        for j = 1:j_num*ma_num
            for k = 1:j_num
                if population_list(m,j) == k
                    repair_or_not(k) = repair_or_not(k) + 1;
                end
            end
        end
        
        for k = 1:j_num
            if repair_or_not(k) > ma_num
                r_ran_num = randperm(repair_or_not(k)); 
                r_ran_num = sort(r_ran_num(1:(repair_or_not(k)-ma_num)));
                appeartime = 0;  
                for j = 1:j_num*ma_num
                    if population_list(m,j) == k
                        appeartime = appeartime + 1;
                        for n = 1:(repair_or_not(k)-ma_num)
                            if appeartime == r_ran_num(n)
                                population_list(m,j) = 0;   
                            end
                        end
                    end
                end
            end
        end
        
        for k = 1:j_num 
            if repair_or_not(k) < ma_num
                zeroappeartime = 0;
                appeartime = 0;      
                for j = 1:j_num*ma_num  
                    if population_list(m,j) == 0
                        zeroappeartime = zeroappeartime + 1;
                    end
                end
                r_ran_num = randperm(zeroappeartime);  
                r_ran_num = sort(r_ran_num(1:ma_num-(repair_or_not(k))));
                for j = 1:j_num*ma_num
                    if population_list(m,j) == 0
                        appeartime = appeartime + 1;
                        for n = 1:(ma_num-repair_or_not(k))
                            if appeartime == r_ran_num(n)
                                population_list(m,j) = k;
                            end
                        end
                    end
                end
            end
        end
    end
    
    % Evaluation
    population_list = [population_list_tmp; population_list];
    
    fitness = zeros(population_size*2, 1+j_num*ma_num);
    Gen = zeros(population_size*2,j_num*ma_num);
    Gen_m = zeros(population_size*2,j_num*ma_num);
    Gen_t = zeros(population_size*2,j_num*ma_num);  
    MachineJob = zeros(population_size*2,j_num*ma_num);
    MachineTimeBegin = zeros(population_size*2,j_num*ma_num); 
    MachineTimeEnd = zeros(population_size*2,j_num*ma_num); 
    
    for m = 1:population_size*2 
        Gen(m,1:j_num*ma_num) = population_list(m,1:j_num*ma_num);
        Ma2 = Ma;
        PT2 = PT;
        for j = 1:j_num*ma_num
            for k = 1:ma_num
                if Ma2(Gen(m,j),k) ~= 0
                    Gen_m(m,j) = Ma2(Gen(m,j),k);
                    Gen_t(m,j) = PT2(Gen(m,j),k);
                    Ma2(Gen(m,j),k) = 0;
                    break;
                end
            end
        end
    
        t = 1; 
        for k = 1:ma_num
            for j = 1:j_num*ma_num
                if Gen_m(m,j) == k
                    MachineJob(m,t) = Gen(m,j); 
                    t = t + 1;
                end
            end
        end
    end
    
    for m = 1:population_size*2 
        j_count = zeros(1,j_num); 
        m_count = zeros(1,ma_num);
        t_count = zeros(1,ma_num);
        for j = 1:j_num*ma_num
            revise = 0; 
            t_count(Gen_m(m,j)) = t_count(Gen_m(m,j)) + 1;
            if t_count(Gen_m(m,j)) <= 2
                j_count(Gen(m,j)) = j_count(Gen(m,j)) + Gen_t(m,j);
                m_count(Gen_m(m,j)) = m_count(Gen_m(m,j)) + Gen_t(m,j);
                if m_count(Gen_m(m,j)) < j_count(Gen(m,j))
                    m_count(Gen_m(m,j)) = j_count(Gen(m,j));
                elseif m_count(Gen_m(m,j)) > j_count(Gen(m,j))
                    j_count(Gen(m,j)) = m_count(Gen_m(m,j));
                end
                MachineTimeBegin(m,Gen_m(m,j)*j_num-j_num+t_count(Gen_m(m,j))) = m_count(Gen_m(m,j)) - Gen_t(m,j);
                MachineTimeEnd(m,Gen_m(m,j)*j_num-j_num+t_count(Gen_m(m,j))) = m_count(Gen_m(m,j));
            elseif t_count(Gen_m(m,j)) >= 3
                temBeginEnd = zeros(2,t_count(Gen_m(m,j)));
                for k = 1:(t_count(Gen_m(m,j))-1)
                    temBeginEnd(1,1:t_count(Gen_m(m,j))-1) = MachineTimeBegin(m,Gen_m(m,j)*j_num-j_num+1:Gen_m(m,j)*j_num-j_num+t_count(Gen_m(m,j))-1);
                    temBeginEnd(2,1:t_count(Gen_m(m,j))-1) = MachineTimeEnd(m,Gen_m(m,j)*j_num-j_num+1:Gen_m(m,j)*j_num-j_num+t_count(Gen_m(m,j))-1);
                    temBeginEnd = sortrows(temBeginEnd');
                    temBeginEnd = temBeginEnd';
                    if j_count(Gen(m,j)) <= temBeginEnd(1,k+1)
                        if j_count(Gen(m,j)) >= temBeginEnd(2,k)
                            if temBeginEnd(1,k+1) - j_count(Gen(m,j)) >= Gen_t(m,j)
                                MachineTimeBegin(m,Gen_m(m,j)*j_num-j_num+t_count(Gen_m(m,j))) = j_count(Gen(m,j));
                                MachineTimeEnd(m,Gen_m(m,j)*j_num-j_num+t_count(Gen_m(m,j))) = j_count(Gen(m,j)) + Gen_t(m,j);
                                break;
                            end
                        elseif j_count(Gen(m,j)) < temBeginEnd(2,k)
                            if temBeginEnd(1,k+1) - temBeginEnd(2,k) >= Gen_t(m,j)
                                revise = 1;
                                MachineTimeBegin(m,Gen_m(m,j)*j_num-j_num+t_count(Gen_m(m,j))) = MachineTimeEnd(m,Gen_m(m,j)*j_num-j_num+k);
                                MachineTimeEnd(m,Gen_m(m,j)*j_num-j_num+t_count(Gen_m(m,j))) = MachineTimeEnd(m,Gen_m(m,j)*j_num-j_num+k) + Gen_t(m,j);
                                break;
                            end
                        end
                    end                
                end
                if revise == 0
                    j_count(Gen(m,j)) = j_count(Gen(m,j)) + Gen_t(m,j);
                    m_count(Gen_m(m,j)) = m_count(Gen_m(m,j)) + Gen_t(m,j);
                    if m_count(Gen_m(m,j)) < j_count(Gen(m,j))
                        m_count(Gen_m(m,j)) = j_count(Gen(m,j));
                    elseif m_count(Gen_m(m,j)) > j_count(Gen(m,j))
                        j_count(Gen(m,j)) = m_count(Gen_m(m,j));
                    end
                    MachineTimeBegin(m,Gen_m(m,j)*j_num-j_num+t_count(Gen_m(m,j))) = m_count(Gen_m(m,j)) - Gen_t(m,j);
                    MachineTimeEnd(m,Gen_m(m,j)*j_num-j_num+t_count(Gen_m(m,j))) = m_count(Gen_m(m,j));                
                elseif revise == 1
                    j_count(Gen(m,j)) = MachineTimeEnd(m,Gen_m(m,j)*j_num-j_num+t_count(Gen_m(m,j)));
                end
            end          
        end
        fitness(m,1) = max(j_count);
        fitness(m,2:1+j_num*ma_num) = Gen(m,1:j_num*ma_num);
    end
    
    fitness_now = min(fitness(:,1));
    if (fitness_now < Makespan_best)
        Makespan_best = fitness_now;
        Scheduling_best = fitness((find(fitness == Makespan_best)),2:1+j_num*ma_num);
    end
    
    fitness = sortrows(fitness,1);
    population_list = fitness(1:population_size,2:1+j_num*ma_num);
    
    % Selection
    Totalfitness = 0;
    for m = 1:population_size
        Totalfitness = Totalfitness + 1/fitness(m,1);
    end
    
    pk = zeros(population_size,1);
    for m = 1:population_size
        pk(m) = (1/fitness(m,1)) / Totalfitness;
    end
    
    qk = zeros(population_size,1); 
    for m = 1:population_size 
        cumulative = 0;
        for j = 1:m
            cumulative = cumulative + pk(j);
        end
        qk(m) = cumulative;
    end
    
    last_population_list = population_list;
    population_list = zeros(population_size, j_num*ma_num);
    
    selection_rand = zeros(1,population_size);
    for m = 1:population_size
        selection_rand(m) = rand();
    end
    
    for m = 1:population_size
        if (selection_rand(m) <= qk(1))
            population_list(m, 1:j_num*ma_num) = last_population_list(m, 1:j_num*ma_num);
        else
            for j = 1:(population_size-1)
                if (selection_rand(m) > qk(j) && selection_rand(m) <= qk(j+1))
                    population_list(m, 1:j_num*ma_num) = last_population_list((j+1), 1:j_num*ma_num);
                    break;
                end
            end
        end
    end
end

% Report the Results
disp('--- Final Report ---');
fprintf('Optimal_Value : %d\n',Makespan_best);

toc % Read elapsed time from stopwatch