% Problem Definition and Parameters Setting
bits = 33;
bits_x1 = 18;
bits_x2 = 15;
a1 = -3;
b1 = 12.1;
a2 = 4.1;
b2 = 5.8;
population_size = input('Please input the size of population: '); 
if isempty (population_size)
    population_size = 10;
end
crossover_rate = input('Please input the Crossover Rate: '); 
if isempty (crossover_rate) 
    crossover_rate = 0.8;
end
mutation_rate = input('Please input the Mutation Rate: ');
if isempty (mutation_rate) 
    mutation_rate = 0.1;
end
Num_Iteration = input('Please input the Iteration Times: '); 
if isempty (Num_Iteration)
    Num_Iteration = 1000;
end

tic % Start stopwatch timer

% Initialize the Solution
population_list = zeros(population_size, bits);
for i = 1:population_size 
    population_list(i,1:bits) = randi(2,1,33)-1;
end

Tbest = 0;  
x1_best = 0; 
x2_best = 0; 

for Iteration = 1:Num_Iteration
    
    % Corssover
    S = randperm(population_size);
    for m = 1:(population_size/2)
        crossover_prob = rand();
        if (crossover_rate >= crossover_prob)
            parent_1 = population_list(S(-1+2*m),1:bits); % 親代
            parent_2 = population_list(S(2*m),1:bits);
            child_1 = zeros(1,bits); % 子代
            child_2 = zeros(1,bits);
            cutposition = randperm(bits,1);
            child_1(1:cutposition) = parent_1(1:cutposition);
            child_1((cutposition+1):bits) = parent_2((cutposition+1):bits);
            child_2(1:cutposition) = parent_2(1:cutposition);
            child_2((cutposition+1):bits) = parent_1((cutposition+1):bits);
            population_list(S(-1+2*m),1:bits) = child_1;
            population_list(S(2*m),1:bits) = child_2;
        end
    end
    
    % Mutation
    for m = 1:population_size
        mutation_prob = rand();
        if (mutation_rate >= mutation_prob)
            m_rand = randperm(bits,1); 
            if (population_list(m,m_rand) == 0)
                population_list(m,m_rand) = 1;
            else
                population_list(m,m_rand) = 0;
            end 
        end
    end
    
    % Evaluation
    fitness = zeros(population_size,3);
    for m = 1:population_size
        for j = 1:bits_x1
            fitness(m,1) = fitness(m,1) + population_list(m,j)*(2^(bits_x1-j));
        end
        for j = (bits_x1+1):bits
            fitness(m,2) = fitness(m,2) + population_list(m,j)*(2^(bits-j));
        end
        fitness(m,1) = a1 + fitness(m,1)*((b1-a1)/((2^bits_x1)-1));
        fitness(m,2) = a2 + fitness(m,2)*((b2-a2)/(2^bits_x2-1));
        fitness(m,3) = 21.5 + fitness(m,1)*sin(4*pi*fitness(m,1)) + fitness(m,2)*sin(20*pi*fitness(m,2));
    end
    
    Tbest_now = max(fitness(:,3));
    if (Tbest_now > Tbest)
        Tbest = Tbest_now;
        x1_best = fitness(find(fitness == Tbest)-population_size*2,1);
        x2_best = fitness(find(fitness == Tbest)-population_size*2,2);
    end
    
    % Selection
    Totalfitness = 0;
    for m = 1:population_size
        Totalfitness = Totalfitness + fitness(m,3);
    end
    
    pk = zeros(population_size,1);
    for m = 1:population_size
        pk(m) = fitness(m,3) / Totalfitness;
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
    population_list = zeros(population_size, bits);
    
    selection_rand = zeros(1,population_size);
    for i = 1:population_size
        selection_rand(i) = rand();
    end
    for i = 1:population_size
        if (selection_rand(i) <= qk(1))
            population_list(i, 1:bits) = last_population_list(i, 1:bits);
        else
            for j = 1:(population_size-1)
                if (selection_rand(i) > qk(j) && selection_rand(i) <= qk(j+1))
                    population_list(i, 1:bits) = last_population_list((j+1), 1:bits);
                    break;
                end
            end
        end
    end
end

% Report the Results
disp('--- Final Report ---');
fprintf('Optimal_Value : %d\n',Tbest);
fprintf('x1 : %d\n',x1_best);
fprintf('x2 : %d\n',x2_best);

toc % Read elapsed time from stopwatch
