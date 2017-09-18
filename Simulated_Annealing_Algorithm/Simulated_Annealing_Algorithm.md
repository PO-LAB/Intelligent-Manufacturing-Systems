# IMS: Simulated Annealing Algorithm #
*POLab*
<br>
*2017/09/18*

[【Homepage】](https://github.com/PO-LAB/Intelligent-Manufacturing-Systems/blob/master/README.md)

## Simulated Annealing ##
Simulated annealing is a metaheuristic using probabilistic technique of a given function to approximate global optimization. It calculated the probability to determine whether jump out of local optimum or not. As iterations go on, the temperature decreases by cooling rate, and we become less possible to accept the new poor solution. This algorithm is often used in the problem with discrete search space (e.g., TSP). Below shows the flowchart of simulated annealling algorithm.


<div align=center>
<img src="https://github.com/PO-LAB/Intelligent-Manufacturing-Systems/blob/master/Simulated_Annealing_Algorithm/SA_flowchart.jpg" alt="GitHub" width="199" height="497"/>
</div>

## Example ##
The example in Lecture 3 page 45-49 is used to explain how to implement the algorithm using MATLAB. 
<br>
This is a travel salesman problem (TSP) which want to find out the shortest possible loop that connects all the nodes.
<br>
Below is the network distance matrix.
<br>

 Nodes |  1 |  2 |  3 |  4 |  5 |  6 |  7 |
 :--:  |:--:|:--:|:--:|:--:|:--:|:--:|:--:|
 **1** |  0 | 19 | 92 | 29 | 49 | 78 |  6 |
 **2** | 19 |  0 | 21 | 85 | 45 | 16 | 26 |
 **3** | 92 | 21 |  0 | 24 | 26 | 87 | 47 |
 **4** | 29 | 85 | 24 |  0 | 76 | 17 |  8 |
 **5** | 49 | 45 | 26 | 76 |  0 | 90 | 27 |
 **6** | 78 | 16 | 87 | 17 | 90 |  0 | 55 |
 **7** |  6 | 26 | 47 |  8 | 27 | 55 |  0 |

Then, we use this case to show the step by step guide to coding.
<br>
Notice that we can modify algorithm design, this make algorithms may not always be the same.

### Problem Definition and Parameters Setting ###
Input the information according to problem definition.
```matlab
Num_Nodes =  7; % Node Counts
% Network Distance Matrix
Distance = [ 0, 19, 92, 29, 49, 78,  6;
            19,  0, 21, 85, 45, 16, 26; 
            92, 21,  0, 24, 26, 87, 47;
            29, 85, 24,  0, 76, 17,  8;
            49, 45, 26, 76,  0, 90, 27;
            78, 16, 87, 17, 90,  0, 55;
             6, 26, 47,  8, 27, 55,  0];
```

Let user decide the temperature, cooling rate and iteration times.
```matlab
Temperature = input('Please input the temperature: ');  % Ask user to input the initial temperature.
if isempty (Temperature)  % Set the default value (it works if user doesn't input anything to Temperature).
    Temperature = 300;  % Default value for Temperature is equal to 300.
end

CoolingRate = input('Please input the cooling rate: ');  
if isempty (CoolingRate)  
    CoolingRate = 0.95;
end

Num_Iteration = input('Please input the times of iteration: '); 
if isempty (Num_Iteration)
    Num_Iteration = 100;
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
Generate initial solution and calculate its objective value (travel distance).
```matlab
x_now = randperm(Num_Nodes);  % Randomly generate initial solution (route).
Obj_now = 0;  % Calculate the objective value.
for i = 1:(Num_Nodes -1)
    Obj_now = Obj_now + Distance(x_now(i),x_now(i+1));
end
Obj_now = Obj_now + Distance(x_now(i+1),x_now(1));
Obj = Obj_now;  % Record the objective value
```

### Neighborhood Search ###
Below shows the neighborhood search for one iteration. **In practice, it will repeat many times.**
```matlab
tmp = randperm(Num_Nodes);  % Randomly choose two points.
tmp = tmp(1:2);

x_next = x_now;  % Swap their positions.
x_next(x_now==tmp(1)) = tmp(2);
x_next(x_now==tmp(2)) = tmp(1);

Obj_now = 0;  % Calculate the objective value
for i = 1:(Num_Nodes -1)
    Obj_now = Obj_now + Distance(x_next(i),x_next(i+1));
end
Obj_now = Obj_now + Distance(x_next(i+1),x_next(1));
        
if (Obj_now <= Obj)  % If the result is better than before, update the objective value and route.
    Obj = Obj_now;
    x_now = x_next;
end
        
if (Obj_now > Obj)  % If the result is worse than before, calculate the Boltzmann Function and decide whether update or not.
    Boltzmann = min(1, exp(-(Obj_now-Obj)/Temperature));  % Boltzmann Function
    rand = rand();  % Random Probability
    if (rand < Boltzmann)  % If Random Probability < Boltzmann Function, we accept the worse result.
        Obj = Obj_now;
        x_now = x_next;
    end
end
```

### Cool Down Process ###
Implement the cool down process to decrease the temperature.
```matlab
Temperature = CoolingRate*Temperature;
```

### Report the Results ###
At last, we can give report to show our final solution.
```matlab
% Report the Results
disp('--- Final Report ---');
disp('Optimal Solution = '); 
    disp(x_now);
fprintf('Optimal_Value : %d\n',Obj);
```
<br>
So far, the simulated annealing algorithm is introduced. 
<br>
Noticed that implement the above code still needs to add something (E.g., considering iterations) and make it complete. 
<br>
<br>

Sample code is [HERE](https://github.com/PO-LAB/Intelligent-Manufacturing-Systems/blob/master/Simulated_Annealing_Algorithm/Simulated_Annealing_Algorithm.m).
