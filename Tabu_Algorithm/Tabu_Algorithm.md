# IMS: Tabu Search Algorithm #
*POLab*
<br>
*2017/09/18*

[【Homepage】](https://github.com/PO-LAB/Intelligent-Manufacturing-Systems/blob/master/README.md)

## Tabu Search ##
Tabu Search is a meta-heuristic that guides the search procedure to explore the solution space beyond local optimal. In Tabu Search, the moving is based on neighborhood search mechanism, and Tabu list is used to avoid performing a move returning to a recently visited region and trapping into local optimal. The flowchart of Tabu Search algorithm procedure is shown below.


<div align=center>
<img src="https://github.com/PO-LAB/Intelligent-Manufacturing-Systems/blob/master/Tabu_Algorithm/Tabu_flowchart.jpg" alt="GitHub" width="300" height="400"/>
</div>

## Example ##
The example in Lecture 3 page 25-27 is used to explain how to implement the algorithm using MATLAB.
<br>
The problem is about a single-machine total weighted tardiness problem.

 Jobs | Processing time | Due Date | Weights 
 :--: | :-------------: | :------: | :-----: 
   1  |        10       |     4    |    14   
   2  |        10       |     2    |    12   
   3  |        13       |     1    |     1   
   4  |         4       |    12    |    12   

In this simple problem, there only exists 4^4 possible cases using exhaustive enumeration method.
<br>
But as job counts increase, problem may become more complex and imposible to find out the solution in polynomial-time.
<br>
Thus, we use this case to show the step by step guide to coding. Notice that algorithm design still may be a little different.

### Problem Definition and Parameters Setting ###
Input the information according to problem definition.
```matlab
Num_Jobs = 4;  % job counts
p = [10,10,13,4];  % process time
d = [4,2,1,12];  % due date
w = [14,12,1,12];  % weight
```

Let user decide the Tabu size and iteration times.
```matlab
tabusize = input('Please input the tabusize: ');  % Ask user to input the tabu size.
if isempty (tabusize)  % Set the default value (it works if user doesn't input anything to tabusize).
    tabusize = 2;  % Default value for tabu size is equal to 2
end

Num_Iteration = input('Please input the times of iteration: '); 
if isempty (Num_Iteration)
    Num_Iteration = 100;
end
```

Construct the Tabu list and best objective value.
```matlab
tabulist = zeros(tabusize, 2);  % Construct the Tabu list, "2" represents two jobs (attributes) in each Tabu.
Tbest = 9999999999;  % "Tbest" is to recod the best result of all iterations. Initially, this value is large.
```

### Executive Time ###
Calculate executive time.
```matlab
tic  % Start stopwatch timer
…
toc  % Read elapsed time from stopwatch
```

### Initialize the Solution ###
Generate initial solution and calculate its objective value.
<br>
In this example, objective value is the total weighted tardiness:
<br>
<img src="https://github.com/PO-LAB/Intelligent-Manufacturing-Systems/blob/master/Tabu_Algorithm/Tabu_Obj.png" alt="GitHub" width="224.91" height="41.37"/>
<br>
*w: weight*
<br>
*C: completion time*
<br>
*d: due date*
```matlab
x_now = randperm(Num_Jobs);  % Randomly generate initial solution
Ptime = 0;  % Initialize the processing time.
Tardiness = 0;  % Initialize the objective value: total weighted tardiness.   
for j = 1:Num_Jobs  % There are 4 jobs, thus we need to calculate each total weighted tardiness and add them together. 
    Ptime = Ptime + p(x_now(j));
    Tardiness = Tardiness + w(x_now(j))*max(Ptime-d(x_now(j)),0);
end
T_now_best = Tardiness;  % Record the best result in this iteration. 
```

### Neighborhood Search ###
Below shows the neighborhood search for one iteration. **In practice, it will repeat many times.**

```matlab
T_now_best = 9999999999;  % "T_now_best" is to record the best result in this iteration. Initially, this value is large.

for k = 1:(Num_Jobs-1) % Obtain schedules by pairwise interchanges. (In this case, three schedules exist.)
    istabu = 0;  % "istabu" equal to 0 represents non-tabu; otherwise, its value is 1. (Initially, we suppose it is a non-tabu result.)
    x_next = x_now;  % Generate the schedule by interchange.
    x_next(k) = x_now(k+1);
    x_next(k+1) = x_now(k);
    
    % Find out wheter the schedule is tabu or not.
    for n = 1:tabusize 
        if (x_next(k) == tabulist(n,1) && x_next(k+1) == tabulist(n,2))
            istabu = 1;
        end 
        if (x_next(k) == tabulist(n,2) && x_next(k+1) == tabulist(n,1))
            istabu = 1;
        end
    end
    
    % If it is non-tabu results, the schedule is admissible. Then we can calculate its objective value.
    if (istabu == 0)
        Ptime = 0;
        Tardiness = 0;
        for j = 1:4
            Ptime = Ptime + p(x_next(j));
            Tardiness = Tardiness + w(x_next(j))*max(Ptime-d(x_next(j)),0);
        end
        
        % Record the result if objective value obtained from this schedule is better than best result in this iteration.
        if (Tardiness < T_now_best) 
            T_now_best = Tardiness;  % Update the result as the best result in this iteration.
            jobsequence = x_next;  % Record the schedule.
            t1 = x_next(k);  % "t1" and "t2" are used to remenber the tabu attributes.
            t2 = x_next(k+1); 
        end
    end
end

x_now = jobsequence; % We can get the best non-tabu results after we run one iteration.
```

### Update the Tabu List ###
Move the attributes' positions in Tabu list, and delete the oldest pairwise tabu attributes.
<br>
Let pairwise tabu attributes from recently visited schedules to be tabu-active.
```matlab
for n = tabusize : -1 : 2  % Change the position in Tabu list. (Update from the last row to the second row in Tabu list.)
    tabulist(n,1) = tabulist ((n-1),1);
    tabulist(n,2) = tabulist ((n-1),2);
end

tabulist(1,1) = t1;  % Record the tabu attributes in the first row of the Tabu list.
tabulist(1,2) = t2; 
```

### Update the Best Result of All Iterations ###
Under the Tabu mechanism, we may choose the non-tabu solution with poor value in some iteration.
<br>
But we still want to export the best result from all iterations after we run the algorithm.
<br>
Thus, the best result should be check and update after each iteration.
```matlab
% Record the result if the best result in this iteration better than the best result from all iterations.
if (T_now_best <= Tbest) 
    Tbest = T_now_best;
    x_best = x_now;
end
```

So far, Tabu algorithm implementation is introduced.



### Calculate the Tardy Job Counts ###
In real world, we may more concern with the number of tardy jobs.
<br>
After we find out the best solution, we can also calculate tardy job counts.
```matlab
jobsequence_ptime = 0;  % Record the processing time.
num_tardy = 0;  % Record number of tardy job.
for l = 1:Num_Jobs  % Consider all the jobs in schedule.
    jobsequence_ptime = jobsequence_ptime + p(x_best(l));  % Calculate the processing time.
    if (jobsequence_ptime > d(x_best(l)))  % Increase the Tardy Job counts if the job is tardy.
        num_tardy = num_tardy + 1;
    end
end
```

### Report the Results ###
At last, we can give report to show our final solution.
```matlab
disp('--- Final Report ---');
disp('Optimal Solution = '); 
    disp(x_best);
fprintf('Optimal_Value : %d\n',Tbest);
fprintf('Number of Tardy : %d\n',num_tardy);
```

<br>
So far, the Tabu algorithm is introduced. 
<br>
Noticed that implement the above code still needs to add something (e.g., considering iterations) and make it complete.
<br>
<br>

Sample code is [HERE](https://github.com/PO-LAB/Intelligent-Manufacturing-Systems/blob/master/Tabu_Algorithm/Tabu_Algorithm.m).
