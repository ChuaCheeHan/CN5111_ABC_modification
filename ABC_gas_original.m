function  ABC_gas_original

x_lo(1) = 17.5;
x_up(1) = 40;
x_lo(2) = 300;
x_up(2) = 600;
iter = 0;

f = @(x1,x2) 61.8 + 5.72*x1 + 0.2623*((40-x1)*log(x2/200))^(-0.85) + 0.087*(40-x1)*log(x2/200) + 700.23*(x2^(-0.75));

%Generation of initial population (10 bees)
bees = zeros(10,2);

for (a = 1:2)
    for (b = 1:10)
        bees(b,a) = x_lo(a) + rand*(x_up(a) - x_lo(a));
    end
end

%Evaluation of food sources

for (b = 1:10)
    bees_fit(b) = f(bees(b,1),bees(b,2));
end
bestvar1_min = min(bees(:,1));
bestvar2_min = min(bees(:,2));

while (iter < 200)
%Produce new food sources for employed bees

%%Employed bees stage
for (b = 1:10)
    a = randi(2);
    x_randomval = randi(10);
    while (x_randomval == b)
        x_randomval = randi(10);
    end
    newv = bees(b,:);
    newv(a) = bees(b, a) + (rand*2-1)*(bees(b,a) - bees(x_randomval, a));
    if (f(newv(1), newv(2)) < f(bees(b,1), bees(b,2)))
        bees(b,1) = newv(1);
        bees(b,2) = newv(2);
    end
    if (bees(b,a) < x_lo(a))
        bees(b,a) = x_lo(a);
    end
    if (bees(b,a) > x_up(a))
        bees(b,a) = x_up(a);
    end
end

%Calculate the probability values for Onlookers

%%Evaluation of food sources
for (b = 1:10)
    bees_fit(b) = f(bees(b,1),bees(b,2));
end

%%change values of fitness for probability
v_totalf = sum(bees_fit);
inverse_bees_fit = zeros(1,10);
for (b = 1:10)
    inverse_bees_fit(b) = v_totalf/bees_fit(b);
end
bees_probability = zeros(1,10);
for (b = 1:10)
    bees_probability(b) = inverse_bees_fit(b)/sum(inverse_bees_fit);
end

%%Onlooker finds the index and possibly swaps the value
x = cumsum([0 bees_probability(:).'/sum(bees_probability(:))]);
x(end) = 1e3*eps + x(end);
[p_val p_idx] = histc(rand,x);
a = randi(2);
x_randomval = randi(10);
while (x_randomval == p_idx)
    x_randomval = randi(10);
end
newv = bees(p_idx,:);
newv(a) = bees(p_idx,a) + (rand*2-1)*(bees(p_idx,a) - bees(x_randomval,a));
if (f(newv(1),newv(2)) < f(bees(p_idx,1), bees(p_idx,2)))
    bees(p_idx,1) = newv(1);
    bees(p_idx,2) = newv(2);
end
for (a = 1:2)
    if (bees(p_idx,a) < x_lo(a))
        bees(p_idx,a) = x_lo(a);
    end
end

if (bees(p_idx,a) > x_up(a))
    bees(p_idx,a) = x_up(a);
end

%find the current best solution
%%Evaluation of food sources
for (b = 1:10)
    bees_fit(b) = f(bees(b,1),bees(b,2));
end

%%min value (best bee)
[val, b] = min(bees_fit);
var1_min = bees(b,1);
var2_min = bees(b,2);

%if (abs(f(var1_min, var2_min) - f(bestvar1_min, bestvar2_min)) < 0.000001)
%    break;
%end

%if fitness stagnates, replace with new scout bee
if (iter == 0)
    new_bees_fit = bees_fit;
    stagnant_count = zeros(1,10);
else
    for (b = 1:10)
        if (abs(new_bees_fit(b) - bees_fit(b)) < 0.0001)
            if (stagnant_count(b) < 3)
                stagnant_count(b) = stagnant_count(b) + 1;
            else
            bees(b,1) = x_lo(1) + rand*(x_up(1) - x_lo(1));
            bees(b,2) = x_lo(2) + rand*(x_up(2) - x_lo(2));
            stagnant_count(b) = 0;
            end
        else
            new_bees_fit(b) = bees_fit(b);
            stagnant_count(b) = 0;
        end
        
    end
            
end

if (f(var1_min, var2_min) < f(bestvar1_min,bestvar2_min))
    bestvar1_min = var1_min;
    bestvar2_min = var2_min;
end

iter = iter + 1;
end
bestvar1_min
bestvar2_min
iter
