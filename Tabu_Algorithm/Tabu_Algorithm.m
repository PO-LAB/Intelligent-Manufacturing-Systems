% Problem Definition and Parameters Setting
Num_Jobs = 4;
p = [10,10,13,4];
d = [4,2,1,12];  
w = [14,12,1,12]; 

tabusize = input('Please input the tabusize: ');  
if isempty (tabusize)  
    tabusize = 2;
end
Num_Iteration = input('Please input the times of iteration: '); 
if isempty (Num_Iteration)
    Num_Iteration = 100;
end

tabulist = zeros(tabusize, 2);  
Tbest = 9999999999;

tic  % Start stopwatch timer

for Iteration = 1:Num_Iteration
    if (Iteration == 1) % Initialize the Solution
        x_now = randperm(Num_Jobs); 
        Ptime = 0;  
        Tardiness = 0;
        for j = 1:Num_Jobs  
            Ptime = Ptime + p(x_now(j));
            Tardiness = Tardiness + w(x_now(j))*max(Ptime-d(x_now(j)),0);
        end
        T_now_best = Tardiness; 
    
    else % Neighborhood Search
        T_now_best = 9999999999;  

        for k = 1:(Num_Jobs-1) 
            istabu = 0;  
            x_next = x_now;  
            x_next(k) = x_now(k+1);
            x_next(k+1) = x_now(k);
            for n = 1:tabusize 
                if (x_next(k) == tabulist(n,1) && x_next(k+1) == tabulist(n,2))
                    istabu = 1;
                end 
                if (x_next(k) == tabulist(n,2) && x_next(k+1) == tabulist(n,1))
                    istabu = 1;
                end
            end
            if (istabu == 0)
                Ptime = 0;
                Tardiness = 0;
                for j = 1:4
                    Ptime = Ptime + p(x_next(j));
                    Tardiness = Tardiness + w(x_next(j))*max(Ptime-d(x_next(j)),0);
                end
                if (Tardiness < T_now_best) 
                    T_now_best = Tardiness;  
                    jobsequence = x_next;  
                    t1 = x_next(k); 
                    t2 = x_next(k+1); 
                end
            end
        end
        x_now = jobsequence;
        
        % Update the Tabu List
        for n = tabusize : -1 : 2  
            tabulist(n,1) = tabulist ((n-1),1);
            tabulist(n,2) = tabulist ((n-1),2);
        end
        tabulist(1,1) = t1; 
        tabulist(1,2) = t2; 
        
        % Update the Best Result of All Iterations
        if (T_now_best <= Tbest) 
            Tbest = T_now_best;
            x_best = x_now;
        end
    end
end

% Calculate the Tardy Job Counts
jobsequence_ptime = 0;  
num_tardy = 0;  
for l = 1:Num_Jobs 
    jobsequence_ptime = jobsequence_ptime + p(x_best(l));  
    if (jobsequence_ptime > d(x_best(l)))  
        num_tardy = num_tardy + 1;
    end
end

% Report the Results
disp('--- Final Report ---');
disp('Optimal Solution = '); 
    disp(x_best);
fprintf('Optimal_Value : %d\n',Tbest);
fprintf('Number of Tardy : %d\n',num_tardy);

toc  % Read elapsed time from stopwatch