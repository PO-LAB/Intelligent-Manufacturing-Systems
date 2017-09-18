# IMS: Genetic Algorithm #
*POLab*
<br>
*2017/09/18*

[【Homepage】](https://github.com/PO-LAB/Intelligent-Manufacturing-Systems/blob/master/README.md)

## Genetic Algorithm ##
Genetic algorithm is a metaheuristic inspired by the process of natural evolution. The main operations include crossover, mutation, evaluation and selection. Of course, chromosomes encoding is also important. Genetic algorithms are commonly used to generate high-quality solutions. Below is the flowchart of genetic algorithm.


<div align=center>
<img src="https://github.com/PO-LAB/Intelligent-Manufacturing-Systems/blob/master/Genetic_Algorithm/GA_flowchart.jpg" alt="GitHub" width="202" height="401"/>
</div>

## Example ##
The example in Lecture 4 page 28-48 is used to explain how to implement the algorithm using MATLAB. 
<br>
This is an unconstrained optimization problem, mumerical example is given as follows:


<div align=center>
<img src="https://github.com/PO-LAB/Intelligent-Manufacturing-Systems/blob/master/Genetic_Algorithm/GA_Obj.png" alt="GitHub" width="425" height="69"/>
</div>

Then, we use this case to show the step by step guide to coding.
<br>
Notice that algorithm design still may be a little different.

### Encoding and Decoding ###
For solving this numerical problem, chromosomes are encoded using binary string.
<br>
Binary string encoding and decoding are shown as follows:


<img src="https://github.com/PO-LAB/Intelligent-Manufacturing-Systems/blob/master/Genetic_Algorithm/GA_Encoding_Decoding.png" alt="GitHub" width="393" height="299"/>

### Problem Definition and Parameters Setting ###
Input the information according to problem definition.
```matlab
bits = 33;  % Binary string (each chromosome) has 33 bits.
bits_x1 = 18;  % Former 18 bits in each chromosome represents x1.
bits_x2 = 15;  % Latter 15 bits in each chromosome represents x2.
a1 = -3.0;  % Constraint parameters.
b1 = 12.1;  % Constraint parameters.
a2 = 4.1;  % Constraint parameters.
b2 = 5.8;  % Constraint parameters.
```

Let user decide the populationsize, crossover rate, mutation rate and iteration times.
```matlab
population_size = input('Please input the size of population: ');  % Ask user to input the population size.
if isempty (population_size)  % Set the default value (it works if user doesn't input anything to population_size).
    population_size = 10;  % Default value for population_size is equal to 10
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
population_list = zeros(population_size, bits); % Record population (includes all chromosomes).

for i = 1:population_size % Randomly generates initial population.
    population_list(i,1:bits) = randi(2,1,33)-1; % randi(a,b,c) returns a b-by-c array of pseudorandomness integers between 1 and 2. Minus 1 let then become binary variables.
end
```

Initialize the best fitness value, x1 and x2.
```matlab
Tbest = 0;  % Record the best fitness value.
x1_best = 0;  % Record the x1 of the best fitness value.
x2_best = 0;  % Record the x2 of the best fitness value.
```

### Crossover ###
Common crossover methods are one-point crossover, two-point crossover, uniform crossover methods, etc.
Here, pairs of parent solutions are selected for one-cut point crossover, which random selects one cut point.
```matlab
S = randperm(population_size);  % Decide pairs of parent chromosomes.

for m = 1:(population_size/2)
    crossover_prob = rand();  % Generate the random probability.
    if (crossover_rate >= crossover_prob)  % Chromosomes do crossover only if crossover rate is larger than random probability.
    	parent_1 = population_list(S(-1+2*m),1:bits);  % Parent chromosome 1
	parent_2 = population_list(S(2*m),1:bits);  % Parent chromosome 2
	
	child_1 = zeros(1,bits);  % Record offspring chromosome 1
	child_2 = zeros(1,bits);  % Record offspring chromosome 2
	
	cutposition = randperm(bits,1);  % Randomly choose one cut point.
	
	% Combine the genes of two parents in offspring.
	child_1(1:cutposition) = parent_1(1:cutposition); 
	child_1((cutposition+1):bits) = parent_2((cutposition+1):bits);
	child_2(1:cutposition) = parent_2(1:cutposition);
	child_2((cutposition+1):bits) = parent_1((cutposition+1):bits);
	
	% Save the results of crossover.
	population_list(S(-1+2*m),1:bits) = child_1;
	population_list(S(2*m),1:bits) = child_2;
    end
end
```

### Mutation ###
For mutaion, one gene in each chromosome alters if the probability is less than mutation rate.
If the gene is 0, it would be flipped into 1; otherwise, the gene would flipped into 0 from 1.
```matlab
for m = 1:population_size
    mutation_prob = rand();  % Generate the random probability.
    if (mutation_rate >= mutation_prob  % Chromosomes do mutation only if mutation rate is larger than random probability.
    	m_rand = randperm(bits,1);  % Randomly choose one mutation point.
	
        if (population_list(m,m_rand) == 0)  % Mutation: 0→1 or 1→0
            population_list(m,m_rand) = 1
	else
            population_list(m,m_rand) = 0;
        end
    end
end
```

### Evaluation ###
After we generate the offsprings, fitness values are calculated.
Check the results, and record it if the result in this iteration is better than previous iterations.
```matlab
fitness = zeros(population_size,3);  % Record x1, x2, and fitness value (objective value). 

for m = 1:population_size
    % Decoding: Convert x1 binary string to decimal number.
    for j = 1:bits_x1
        fitness(m,1) = fitness(m,1) + population_list(m,j)*(2^(bits_x1-j));
    end
    
    % Decoding: Convert x2 binary string to decimal number.
    for j = (bits_x1+1):bits
        fitness(m,2) = fitness(m,2) + population_list(m,j)*(2^(bits-j));
    end
    
    fitness(m,1) = a1 + fitness(m,1)*((b1-a1)/((2^bits_x1)-1));  % Calculate x1 value.
    fitness(m,2) = a2 + fitness(m,2)*((b2-a2)/(2^bits_x2-1));  % Calculate xx value.
    fitness(m,3) = 21.5 + fitness(m,1)*sin(4*pi*fitness(m,1)) + fitness(m,2)*sin(20*pi*fitness(m,2));  % Calculate fitness value.
end

Tbest_now = max(fitness(:,3));  % Find out the best fitness value from offsprings population in this iteration.
if (Tbest_now > Tbest)  % If the fitness value is better than best fitness value, update the fitness value, x1 and x2.
    Tbest = Tbest_now;
    x1_best = fitness(find(fitness == Tbest)-population_size*2,1);
    x2_best = fitness(find(fitness == Tbest)-population_size*2,2);
end
```

### Selection ###
Calculate the total fitness for the offsprings.
```matlab
Totalfitness = 0;
for m = 1:population_size
    Totalfitness = Totalfitness + fitness(m,3);
end
```

Calculate selection probability for each chromosome.
```matlab
pk = zeros(population_size,1);  % Record selection probability of offspring population.

for m = 1:population_size
    pk(m) = fitness(m,3) / Totalfitness;
end
```

Calculate cumulative probability for each chromosome.
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
population_list = zeros(population_size, bits);  % Used to record new population.
```

Generate a random number from the range [0,1].
```matlab
selection_rand = zeros(1,population_size);  % Record the random number.

for i = 1:population_size
    selection_rand(i) = rand();
end
```

Use roulette wheel and select the chromosome to be included in new population.
```matlab
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
```

### Report the Results ###
At last, we can give report to show our final solution.
```matlab
disp('--- Final Report ---');
fprintf('Optimal_Value : %d\n',Tbest);
fprintf('x1 : %d\n',x1_best);
fprintf('x2 : %d\n',x2_best);
```
<br>
So far, the genetic algorithm is introduced. 
<br>
Noticed that implement the above code still needs to add something (E.g., considering iterations) and make it complete. 
<br><br>

Sample code is [HERE](https://github.com/PO-LAB/Intelligent-Manufacturing-Systems/blob/master/Genetic_Algorithm/Genetic_Algorithm.m).
