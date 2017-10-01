# IMS: Job Shop Scheduling Problem #
*POLab*
<br>
*2017/09/2X*

[【Homepage】](https://github.com/PO-LAB/Intelligent-Manufacturing-Systems/blob/master/README.md)

## Job Shop Scheduling Problem ##
After we got the basic concepts of the Genetic Algorithm (GA), we might desire to solve different applications using GA.
<br/>
<br/>
✿ If we want to review the Genetic Algorithm, please check [HERE](https://github.com/PO-LAB/Intelligent-Manufacturing-Systems/blob/master/Genetic_Algorithm/Genetic_Algorithm.md)!
<br/>
<br/>
In this article, we will introduce how to implement the genetic algorithm on the scheduling problem. We use a job shop problem (JSP) as an example. In the job shop problem, multiple jobs are processed on several machines. Each job consists of several operations (tasks) with predefined sequence, that is, operations (tasks) must be performed in a given order and on a specific machine. The problem solution indicates the ideal jobs which are assigned to machines at particular times. Common scheduling objective is to minimize the maximum length of the schedule which is also called makespan. Of course, we can consider other objectives such as minimize tardy jobs, minimize total weighted earliness and tardiness (TWET), and so on.
<br/>
<br/>
Below is the simple example of JSP. There are four jobs (J1-J4) and four machines (M1-M4). There exist a certain fixed route (sequence of machines) which may not be the same for each job, as Figure 1 shows. Then, we can reorganize the routes and get the Table 1 which shows the machines sequence. And we may also know the processing time dataset, as shown in the Table 2. At last, we can follow the rules of JSP and find out feasible solutions. In Figure 2, the Gantt Chart is used to show our result.

<div align=center>
<img src="https://github.com/ChinYiTseng/IMS/blob/master/JSP_GA/JSP_simplecase.png" alt="GitHub" width="614" height="356"/>
</div>
<br/>

So now let's learn and try to implement the GA on the 10×10 Job Shop Scheduling Problem! 

## Example: 10×10 Job Shop Scheduling Problem ##
This example is a job shop scheduling problem from Lawrence (1984).<br/>
This test is also known as LA19 in the literature, and its optimal makespan is known to be 842 (Applegate and Cook, 1991). <br/><br/>
There are 10 jobs (J1-J10) and 10 machines (M1-M10).<br/>
Each job must be processed on each of the 10 machines in a predefined sequence (O1-O10).<br/>
Our objective is to minimize the completion time of the last job to be processed, known as the makespan. <br/><br/>
The dataset is given as follows:
<br/><br/>
▸ Processing Time 

 Time |  O1  |  O2  |  O3  |  O4  |  O5  |  O6  |  O7  |  O8  |  O9  |  O10 |
 :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: |
  J1  |  44  |   5  |  47  |  97  |   9  |  84  |  77  |  96  |  58  |  89  |
  J2  |  15  |  31  |  87  |  57  |  77  |  85  |  81  |  39  |  73  |  21  |
  J3  |  82  |  22  |  10  |  70  |  49  |  40  |  34  |  48  |  80  |  71  |
  J4  |  91  |  17  |  62  |  75  |  47  |  11  |   7  |  72  |  35  |  55  |
  J5  |  71  |  90  |  75  |  64  |  94  |  15  |  12  |  67  |  20  |  50  |
  J6  |  70  |  93  |  77  |  29  |  58  |  93  |  68  |  57  |   7  |  52  |
  J7  |  87  |  63  |  26  |   6  |  82  |  27  |  56  |  48  |  36  |  95  |
  J8  |  36  |  15  |  41  |  78  |  76  |  84  |  30  |  76  |  36  |   8  |
  J9  |  88  |  81  |  13  |  82  |  54  |  13  |  29  |  40  |  78  |  75  |
  J10 |  88  |  54  |  64  |  32  |  52  |   6  |  54  |  82  |   6  |  26  |
 

▸ Machines Sequence

Machine |  O1  |  O2  |  O3  |  O4  |  O5  |  O6  |  O7  |  O8  |  O9  |  O10 |
 :--:   | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: |
  J1    |   3  |   4  |   6  |   5  |   1  |   8  |   9  |  10  |   2  |   7  |
  J2    |   5  |   8  |   2  |   9  |   1  |   4  |   3  |   6  |  10  |   7  |
  J3    |  10  |   7  |   5  |   4  |   2  |   1  |   9  |   3  |   8  |   6  |
  J4    |   2  |   3  |   8  |   6  |   9  |   5  |   4  |   7  |  10  |   1  |
  J5    |   7  |   2  |   4  |   1  |   3  |   9  |   5  |   8  |  10  |   6  |
  J6    |   8  |   6  |   9  |   3  |   5  |   7  |   4  |   2  |  10  |   1  |
  J7    |   7  |   2  |   5  |   6  |   3  |   4  |   8  |   9  |  10  |   1  |
  J8    |   1  |   6  |   9  |  10  |   4  |   7  |   5  |   8  |   3  |   2  |
  J9    |   6  |   3  |   4  |   7  |   5  |   8  |   9  |  10  |   2  |   1  |
  J10   |  10  |   5  |   7  |   8  |   1  |   3  |   9  |   6  |   4  |   2  |
  
### Encoding and Decoding ###
For solving the JSP, we use operation-based representation to encode a schedule. The schedule is represented as a sequence of operations and each gene stand for one operation. For a *n*-job and *m*-machine problem,a chromosome contains *n*×*m* genes. Each job appears in the chromosome exactly *m* times. A simple explaination is as follow:

<div align=center>
<img src="https://github.com/ChinYiTseng/IMS/blob/master/JSP_GA/JSP_endode_decode.png" alt="GitHub", width="626" height="341"/>
</div>
<br/>

### Problem Definition and Parameters Setting ###
Input the information according to problem definition. <br/>
Here, we will read Microsoft Excel spreadsheet file ([download](https://github.com/ChinYiTseng/IMS/raw/master/JSP_GA/JSP_dataset.xlsx)) instead of directly giving a value in the code.
```matlab
% xlsread(filename,sheet,xlRange): use Excel range syntax in "xlRange".
j_num = xlsread('JSP_dataset.xlsx','Parameters','B2'); % Job Counts
ma_num = xlsread('JSP_dataset.xlsx','Parameters','B3'); % Machine Counts
PT = xlsread('JSP_dataset.xlsx','ProcessingTime','B2:K11'); % Processing Time
Ma = xlsread('JSP_dataset.xlsx','MachineSequence','B2:K11'); % Machine Sequence
```

Let user decide the populationsize, crossover rate, mutation rate and iteration times.
```matlab
population_size = input('Please input the size of population: ');  % Ask user to input the population size.
if isempty (population_size)  % Set the default value (it works if user doesn't input anything to population_size).
    population_size = 20;  % Default value for population_size is equal to 10
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
    Num_Iteration = 50000;
end
```

### Executive Time ###
Calculate executive time.
```matlab
tic  % Start stopwatch timer
…
toc  % Read elapsed time from stopwatch
```

### Initialize the Solution ###
Generate initial population (solution).
```matlab
population_list = zeros(population_size, j_num*ma_num); % Record population (includes all chromosomes).

for i = 1:population_size 
    population_list(i,1:j_num*ma_num) = randperm(j_num*ma_num); % Random permutation of the integers from 1 to j_num*ma_num inclusive.
    for j = 1:j_num*ma_num % cluster each gene as one operation. For example, k*ma_num < gene value < (k+1)*ma_num, then this gene value is job (k+1).  
        for k = 0:(j_num-1)
            if population_list(i,j) > k*ma_num && population_list(i,j) <= (k+1)*ma_num
                population_list(i,j) = k+1;
            end
        end
    end
end
```

Initialize the best fitness value and scheduling solution.
```matlab
Makespan_best = 9999999999;  % Record the best fitness value..
Scheduling_best = zeros(1, j_num*ma_num);  % Record the scheduling with best fitness value.
```

### Crossover ###
Here, pairs of parent solutions are selected for two-point crossover, which calls for two points to be selected. Everything between the two points is swapped between the chormosomes, rendering two offspring chromosomes.
```matlab
population_list_tmp = population_list;  % Record the parent chromosomes.

S = randperm(population_size); % Decide pairs of parent chromosomes.

for m = 1:(population_size/2)
    crossover_prob = rand(); % Generate the random probability.
    if (crossover_rate >= crossover_prob) % Crossover is happened only if crossover rate is larger than random probability.
        parent_1 = population_list(S(-1+2*m),1:j_num*ma_num); % Parent chromosome 1
        parent_2 = population_list(S(2*m),1:j_num*ma_num); % Parent chromosome 2
        
        child_1 = parent_1; % Record offspring chromosome 1
        child_2 = parent_2; % Record offspring chromosome 2
        
        cutpoint = randperm(j_num*ma_num); % Randomly choose two cut points.
        
        % two-point crossover
        cutpoint = sort(cutpoint(1:2)); % Sort the two cut points in ascending order.
        for k = cutpoint(1):cutpoint(2) 
            child_1(k) = parent_2(k);
            child_2(k) = parent_1(k);
        end
        
        % Save the results of crossover.
        population_list(S(-1+2*m),1:j_num*ma_num) = child_1;
        population_list(S(2*m),1:j_num*ma_num) = child_2;
    end
end
```

### Mutation ###
For mutaion, each gene in each chromosome alters if the probability is less than mutation rate. The gene which needs mutation is changed to another value. This may cause some jobs appear in the chromosome more than *m* times. Thus, we will have one step to repair it in the later. 

```matlab
for m = 1:population_size
    for j = 1:j_num*ma_num
        mutation_prob = rand();  % Generate the random probability.
        if mutation_rate >= mutation_prob  % Chromosomes mutate only if mutation rate is larger than random probability.
            ran_num = rand();  % Generate the random probability, and this probability will be clustered to one value which represents tha mutation result.
            for k = 0:(j_num-1)
                if ran_num > k*(1/j_num) && ran_num <= (k+1)*(1/j_num)
                    population_list(m,j) = k+1;
                end
            end
        end
    end
end
```

### Repairment ###
The crossover and mutation may break up the chromosome rules and give us one unfeasible solution, so repairing our chromosomes is an important step. Here, we repair the chromosomes and let them become feasible solutions.

```matlab
for m = 1:population_size 
    % Calculate the job occurance counts in the chromosome.
    repair_or_not = zeros(1, j_num); % Record the occurance counts of each job.
    for j = 1:j_num*ma_num
        for k = 1:j_num
            if population_list(m,j) == k
                repair_or_not(k) = repair_or_not(k) + 1;
            end
        end
    end
    
    % Deal with the jobs with occurance counts larger than machine counts.
    for k = 1:j_num
        if repair_or_not(k) > ma_num
            r_ran_num = randperm(repair_or_not(k));  % Randomly choose certain number of genes at certain positions to be repaired.
            r_ran_num = sort(r_ran_num(1:(repair_or_not(k)-ma_num)));
            appeartime = 0;  
            for j = 1:j_num*ma_num
                if population_list(m,j) == k
                    appeartime = appeartime + 1;
                    for n = 1:(repair_or_not(k)-ma_num)
                        if appeartime == r_ran_num(n)
                            population_list(m,j) = 0;   % The selected gene will be substitued by 0.
                        end
                    end
                end
            end
        end
    end
    
    % Deal with the jobs with occurance counts less than machine counts.
    for k = 1:j_num 
        if repair_or_not(k) < ma_num
            zeroappeartime = 0;
            appeartime = 0;      
            for j = 1:j_num*ma_num  % Calculate the occurance times of 0.
                if population_list(m,j) == 0
                    zeroappeartime = zeroappeartime + 1;
                end
            end
            r_ran_num = randperm(zeroappeartime);  % Randomly choose certain number of genes at certain positions to be repaired.
            r_ran_num = sort(r_ran_num(1:ma_num-(repair_or_not(k))));
            for j = 1:j_num*ma_num
                if population_list(m,j) == 0
                    appeartime = appeartime + 1;
                    for n = 1:(ma_num-repair_or_not(k))
                        if appeartime == r_ran_num(n)
                            population_list(m,j) = k;  % The selected gene will be substitued by the jobs value which occurance counts less than machine counts.
                        end
                    end
                end
            end
        end
    end
end
```

### Evaluation ###
After we generate the offsprings, fitness values are calculated. <br/><br/>
Initialize the setting.
<br/>
```matlab
population_list = [population_list_tmp; population_list]; % Include parent and offspring chromosomes.

fitness = zeros(population_size*2, 1+j_num*ma_num); % Record fitness value (objective value) and its chromosome. 
Gen = zeros(population_size*2,j_num*ma_num); % Record the job of each gene.
Gen_m = zeros(population_size*2,j_num*ma_num); % Record the machine of each gene.
Gen_t = zeros(population_size*2,j_num*ma_num); % Record the processing time of each gene.
MachineJob = zeros(population_size*2,j_num*ma_num); % Record the job sequence of each machine.
MachineTimeBegin = zeros(population_size*2,j_num*ma_num); % Record the starting time of each operation on the machine.
MachineTimeEnd = zeros(population_size*2,j_num*ma_num); % Record the completion time of each operation on the machine.
```

Decoding
```matlab
for m = 1:population_size*2 
    Gen(m,1:j_num*ma_num) = population_list(m,1:j_num*ma_num); % Record the job of each gene.
    
    % Record that the job "Gen" is processed on machine "Gen_m" with processing time "Gen_t".
    Ma2 = Ma;
    PT2 = PT;
    for j = 1:j_num*ma_num
       for k = 1:ma_num
            if Ma2(Gen(m,j),k) ~= 0
                Gen_m(m,j) = Ma2(Gen(m,j),k); % Record the machine of each gene.
                Gen_t(m,j) = PT2(Gen(m,j),k); % Record the processing time of each gene.
                Ma2(Gen(m,j),k) = 0; % After the operation is recorded, change the machine sequence value to 0. 
                break;
            end
        end
    end
    
    % Record the job sequence of each machine.
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
```

Calculate the fitness value. <br/>
Here, we have to check whether there exists idle time between two operations on the machine or not. <br/>
If there exists idle, we arragne the job to be processed earlier.
```matlab
for m = 1:population_size*2 
    j_count = zeros(1,j_num); % Record the completion time of the job.
    m_count = zeros(1,ma_num); % Record the completion time of the machine.
    t_count = zeros(1,ma_num); % Record the process counts of the machine.
    for j = 1:j_num*ma_num
        revise = 0; % Used to check whether there exists idle time or not.
        t_count(Gen_m(m,j)) = t_count(Gen_m(m,j)) + 1;
	
        if t_count(Gen_m(m,j)) <= 2 % If operations on the machine are less than or equal to 2, we don't need to check whether there exists idle time or not.
            j_count(Gen(m,j)) = j_count(Gen(m,j)) + Gen_t(m,j);
            m_count(Gen_m(m,j)) = m_count(Gen_m(m,j)) + Gen_t(m,j);
            if m_count(Gen_m(m,j)) < j_count(Gen(m,j))
                m_count(Gen_m(m,j)) = j_count(Gen(m,j));
            elseif m_count(Gen_m(m,j)) > j_count(Gen(m,j))
                j_count(Gen(m,j)) = m_count(Gen_m(m,j));
            end
            MachineTimeBegin(m,Gen_m(m,j)*j_num-j_num+t_count(Gen_m(m,j))) = m_count(Gen_m(m,j)) - Gen_t(m,j);
            MachineTimeEnd(m,Gen_m(m,j)*j_num-j_num+t_count(Gen_m(m,j))) = m_count(Gen_m(m,j));
	    
        elseif t_count(Gen_m(m,j)) >= 3 % If operations on the machine are more than or equal to 3, we need to consider the existense of idle time. 
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
    
    fitness(m,1) = max(j_count); % Record the fitness value.
    fitness(m,2:1+j_num*ma_num) = Gen(m,1:j_num*ma_num); % Record the chromosome.
end
```

Check the result, and record it if the result in this iteration is better than previous iterations.
```matlab
fitness_now = min(fitness(:,1));  % Find out the best fitness value from offsprings population in this iteration.
if (fitness_now < Makespan_best)  % If the fitness value is better than best fitness value, update the Makespan_best and Scheduling_best.
    Makespan_best = fitness_now;
    Scheduling_best = fitness((find(fitness == Makespan_best)),2:1+j_num*ma_num);
end
```

### Selection ###
In this example, we only consider the chromosomes with better performances from both parents and offsprings.
```matlab
fitness = sortrows(fitness,1); % Sort the chromosomes by theirs fitness values.
population_list = fitness(1:population_size,2:1+j_num*ma_num); % Remain the chromosomes with better performaces.
```

Calculate the total fitness for the both parents and offsprings.
Because our objective is to minimize the makespan, we should consider reciprocal of the fitness.
```matlab
Totalfitness = 0;
for m = 1:population_size
    Totalfitness = Totalfitness + 1/fitness(m,1)
end
```

Calculate the selection probability for each chromosome.
```matlab
pk = zeros(population_size,1);
for m = 1:population_size
    pk(m) = (1/fitness(m,1)) / Totalfitness;
end
```

Calculate the cumulative probability for each chromosome.
```matlab
qk = zeros(population_size,1); % Record cumulative probability of offspring population.
for m = 1:population_size
    cumulative = 0;
    for j = 1:m
        cumulative = cumulative + pk(j);
    end
    qk(m) = cumulative;
end
```

Memorize the population, and prepare to generate new population.
```matlab
last_population_list = population_list;  % Memorize the population.
population_list = zeros(population_size, j_num*ma_num);  % Used to record new population.
```

Generate a random number from the range [0,1].
```matlab
selection_rand = zeros(1,population_size);  % Record the random number.

for m = 1:population_size
    selection_rand(m) = rand();
end
```

Use the roulette wheel and select the chromosome to be included in new population.
```matlab
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
```

### Report the Results ###
At last, we can give report to show our final solution.
```matlab
disp('--- Final Report ---');
fprintf('Optimal_Value : %d\n',Makespan_best);
```
<br>
So far, the JSP using genetic algorithm is introduced. 
<br>
Noticed that implement the above code still needs to add something (E.g., considering iterations) and make it complete. 
<br><br>

Sample code is [HERE](https://github.com/PO-LAB/Intelligent-Manufacturing-Systems/blob/master/Genetic_Algorithm/Genetic_Algorithm.m).
