function [ output_args ] = ABCmod_orginal( input_args )
%ABCMOD Summary of this function goes here
%   Detailed explanation goes here
x1_lo = 17.5;
x1_up = 40;
x2_lo = 300;
x2_up = 600;
iter = 0;

f = @(x1,x2) 61.8 + 5.72*x1 + 0.2623*((40-x1)*log(x2/200))^(-0.85) + 0.087*(40-x1)*log(x2/200) + 700.23*(x2^(-0.75));

%Generation of initial population (2 bees per variable)
var1_bee1 = zeros(1,5);
var1_bee2 = zeros(1,5);
var2_bee1 = zeros(1,5);
var2_bee2 = zeros(1,5);
for (a = 1:5)
    var1_bee1(a) = x1_lo + rand*(x1_up - x1_lo);
    var1_bee2(a) = x1_lo + rand*(x1_up - x1_lo);
    var2_bee1(a) = x2_lo + rand*(x2_up - x2_lo);
    var2_bee2(a) = x2_lo + rand*(x2_up - x2_lo);
end

%Evaluation of food sources
for (a = 1:5)
    var1_bee1_fit(a) = f(var1_bee1(a),var2_bee1(1));
    var1_bee2_fit(a) = f(var1_bee2(a),var2_bee1(1));
    var2_bee1_fit(a) = f(var1_bee1(1),var2_bee1(a));
    var2_bee2_fit(a) = f(var1_bee1(1),var2_bee2(a));
end

bestvar1_min = var1_bee1(1);
bestvar2_min = var2_bee2(1);
while (iter < 2000)
%%min value for each variable
[val_v1b1, idx_v1b1] = min(var1_bee1_fit);
[val_v1b2, idx_v1b2] = min(var1_bee2_fit);
if (val_v1b1 < val_v1b2)
    var1_min = var1_bee1(idx_v1b1);
else var1_min = var1_bee2(idx_v1b2);
end

[val_v2b1, idx_v2b1] = min(var2_bee1_fit);
[val_v2b2, idx_v2b2] = min(var2_bee2_fit);
if (val_v2b1 < val_v2b2)
    var2_min = var2_bee1(idx_v2b1);
else var2_min = var2_bee2(idx_v2b2);
end

%Produce new food sources for employed bees

for (i = 1:5)
    v1b1_Fz(i) = rand*2-1;
    v1b2_Fz(i) = rand*2-1;
    v2b1_Fz(i) = rand*2-1;
    v2b2_Fz(i) = rand*2-1;
end

%%Employed bees stage
for (i = 1:5)
    %for variable 1 bee 1
    x_randomval = randi(5);
    while (x_randomval == i)
        x_randomval = randi(5);
    end
    newv = var1_bee1(i) + v1b1_Fz(i)*(var1_bee1(i) - var1_bee1(x_randomval));
    if (f(newv, var2_min) < f(var1_bee1(i), var2_min))
        var1_bee1(i) = newv;
    end
    if (var1_bee1(i) < x1_lo)
        var1_bee1(i) = x1_lo;
    end
    if (var1_bee1(i) > x1_up)
        var1_bee1(i) = x1_up;
    end
    
    %for variable 1 bee 2
     x_randomval = randi(5);
    while (x_randomval == i)
        x_randomval = randi(5);
    end
    newv = var1_bee2(i) + v1b2_Fz(i)*(var1_bee2(i) - var1_bee2(x_randomval));
    if (f(newv, var2_min) < f(var1_bee2(i), var2_min))
        var1_bee2(i) = newv;
    end
    if (var1_bee2(i) < x1_lo)
        var1_bee2(i) = x1_lo;
    end
    if (var1_bee2(i) > x1_up)
        var1_bee2(i) = x1_up;
    end
    
    %for variable 2 bee 1
    x_randomval = randi(5);
    while (x_randomval == i)
        x_randomval = randi(5);
    end
    newv = var2_bee1(i) + v2b1_Fz(i)*(var2_bee1(i) - var2_bee1(x_randomval));
    if (f(var1_min, newv) < f(var1_min, var2_bee1(i)))
        var2_bee1(i) = newv;
    end
    if (var2_bee1(i) < x1_lo)
        var2_bee1(i) = x1_lo;
    end
    if (var2_bee1(i) > x2_up)
        var2_bee1(i) = x2_up;
    end
    
    %for variable 2 bee 2
    x_randomval = randi(5);
    while (x_randomval == i)
        x_randomval = randi(5);
    end
    newv = var2_bee2(i) + v2b2_Fz(i)*(var2_bee2(i) - var2_bee2(x_randomval));
    if (f(var1_min, newv) < f(var1_min, var2_bee2(i)))
        var2_bee2(i) = newv;
    end
    if (var2_bee2(i) < x1_lo)
        var2_bee2(i) = x1_lo;
    end
    if (var2_bee2(i) > x2_up)
        var2_bee2(i) = x2_up;
    end
    
end
%Calculate the probability values for Onlookers

%%min value for each variable
[val_v1b1, idx_v1b1] = min(var1_bee1_fit);
[val_v1b2, idx_v1b2] = min(var1_bee2_fit);
if (val_v1b1 < val_v1b2)
    var1_min = var1_bee1(idx_v1b1);
else var1_min = var1_bee2(idx_v1b2);
end

[val_v2b1, idx_v2b1] = min(var2_bee1_fit);
[val_v2b2, idx_v2b2] = min(var2_bee2_fit);
if (val_v2b1 < val_v2b2)
    var2_min = var2_bee1(idx_v2b1);
else var2_min = var2_bee2(idx_v2b2);
end

%%Evaluation of food sources
for (a = 1:5)
    var1_bee1_fit(a) = f(var1_bee1(a),var2_min);
    var1_bee2_fit(a) = f(var1_bee2(a),var2_min);
    var2_bee1_fit(a) = f(var1_min,var2_bee1(a));
    var2_bee2_fit(a) = f(var1_min,var2_bee2(a));
end

%%change values of fitness for probability
v1b1_totalf = 0;
v1b2_totalf = 0;
v2b1_totalf = 0;
v2b2_totalf = 0;
for (a = 1:5)
     v1b1_totalf = v1b1_totalf + var1_bee1_fit(a);
     v1b2_totalf = v1b2_totalf + var1_bee2_fit(a);
     v2b1_totalf = v2b1_totalf + var2_bee1_fit(a);
     v2b2_totalf = v2b2_totalf + var2_bee2_fit(a);
end
inverse_v1b1 = zeros(1,5);
inverse_v1b2 = zeros(1,5);
inverse_v2b1 = zeros(1,5);
inverse_v2b2 = zeros(1,5);

for (a = 1:5)
    inverse_v1b1(a) = v1b1_totalf/var1_bee1_fit(a);
    inverse_v1b2(a) = v1b2_totalf/var1_bee2_fit(a);
    inverse_v2b1(a) = v2b1_totalf/var2_bee1_fit(a);
    inverse_v2b2(a) = v2b2_totalf/var2_bee2_fit(a);
end
probability_v1b1 = zeros(1,5);
probability_v1b2 = zeros(1,5);
probability_v2b1 = zeros(1,5);
probability_v2b2 = zeros(1,5);
for (a = 1:5)
    probability_v1b1(a) = inverse_v1b1(a)/sum(inverse_v1b1);
    probability_v1b2(a) = inverse_v1b2(a)/sum(inverse_v1b2);
    probability_v2b1(a) = inverse_v2b1(a)/sum(inverse_v2b1);
    probability_v2b2(a) = inverse_v2b2(a)/sum(inverse_v2b2);
end

%%Onlooker finds the index and possibly swaps the value

%%for var1 bee1
x = cumsum([0 probability_v1b1(:).'/sum(probability_v1b1(:))]);
x(end) = 1e3*eps + x(end);
[p_val p_idx] = histc(rand,x);
v1b1_Fz(p_idx) = rand*2-1;
x_randomval = randi(5);
while (x_randomval == p_idx)
    x_randomval = randi(5);
end
newv = var1_bee1(p_idx) + v1b1_Fz(p_idx)*(var1_bee1(p_idx) - var1_bee1(x_randomval));
if (f(newv, var2_min) < f(var1_bee1(p_idx), var2_min))
    var1_bee1(p_idx) = newv;
end
if (var1_bee1(p_idx) < x1_lo)
    var1_bee1(p_idx) = x1_lo;
end
if (var1_bee1(p_idx) > x1_up)
    var1_bee1(p_idx) = x1_up;
end

%%for var1 bee 2
x = cumsum([0 probability_v1b2(:).'/sum(probability_v1b2(:))]);
x(end) = 1e3*eps + x(end);
[p_val p_idx] = histc(rand,x);
v1b2_Fz(p_idx) = rand*2-1;
x_randomval = randi(5);
while (x_randomval == p_idx)
    x_randomval = randi(5);
end
newv = var1_bee2(p_idx) + v1b2_Fz(p_idx)*(var1_bee2(p_idx) - var1_bee2(x_randomval));
if (f(newv, var2_min) < f(var1_bee2(p_idx), var2_min))
    var1_bee2(p_idx) = newv;
end
if (var1_bee2(p_idx) < x1_lo)
    var1_bee2(p_idx) = x1_lo;
end
if (var1_bee2(p_idx) > x1_up)
    var1_bee2(p_idx) = x1_up;
end

%%for var 2 bee 1
x = cumsum([0 probability_v2b1(:).'/sum(probability_v2b1(:))]);
x(end) = 1e3*eps + x(end);
[p_val p_idx] = histc(rand,x);
v2b1_Fz(p_idx) = rand*2-1;
x_randomval = randi(5);
while (x_randomval == p_idx)
    x_randomval = randi(5);
end
newv = var2_bee1(p_idx) + v2b1_Fz(p_idx)*(var2_bee1(p_idx) - var2_bee1(x_randomval));
if (f(var1_min, newv) < f(var1_min, var2_bee1(p_idx)))
    var2_bee1(p_idx) = newv;
end
if (var2_bee1(p_idx) < x2_lo)
    var2_bee1(p_idx) = x2_lo;
end
if (var2_bee1(p_idx) > x2_up)
    var2_bee1(p_idx) = x2_up;
end

%%for var 2 bee 2
x = cumsum([0 probability_v2b2(:).'/sum(probability_v2b2(:))]);
x(end) = 1e3*eps + x(end);
[p_val p_idx] = histc(rand,x);
v2b2_Fz(p_idx) = rand*2-1;
x_randomval = randi(5);
while (x_randomval == p_idx)
    x_randomval = randi(5);
end
newv = var2_bee2(p_idx) + v2b2_Fz(p_idx)*(var2_bee2(p_idx) - var2_bee2(x_randomval));
if (f(var1_min, newv) < f(var1_min, var2_bee2(p_idx)))
    var2_bee2(p_idx) = newv;
end
if (var2_bee2(p_idx) < x2_lo)
    var2_bee2(p_idx) = x2_lo;
end
if (var2_bee2(p_idx) > x2_up)
    var2_bee2(p_idx) = x2_up;
end

%find the current best solution
%%Evaluation of food sources
for (a = 1:5)
    var1_bee1_fit(a) = f(var1_bee1(a),var2_min);
    var1_bee2_fit(a) = f(var1_bee2(a),var2_min);
    var2_bee1_fit(a) = f(var1_min,var2_bee1(a));
    var2_bee2_fit(a) = f(var1_min,var2_bee2(a));
end

%%min value for each variable
[val_v1b1, idx_v1b1] = min(var1_bee1_fit);
[val_v1b2, idx_v1b2] = min(var1_bee2_fit);
if (val_v1b1 < val_v1b2)
    var1_min = var1_bee1(idx_v1b1);
else var1_min = var1_bee2(idx_v1b2);
end

[val_v2b1, idx_v2b1] = min(var2_bee1_fit);
[val_v2b2, idx_v2b2] = min(var2_bee2_fit);
if (val_v2b1 < val_v2b2)
    var2_min = var2_bee1(idx_v2b1);
else var2_min = var2_bee2(idx_v2b2);
end
if (abs(f(var1_min, var2_min) - f(bestvar1_min, bestvar2_min)) < 0.0001)
    break;
end

%if fitness stagnates, replace with new scout bee
if (iter == 0)
    newvar1_bee1_fit = var1_bee1_fit;
    newvar1_bee2_fit = var1_bee2_fit;
    newvar2_bee1_fit = var2_bee1_fit;
    newvar2_bee2_fit = var2_bee2_fit;
else
    for (a = 1:5)
        %for var 1 bee 1
        if (abs(newvar1_bee1_fit(a) - var1_bee1_fit(a)) < 0.0001)
            var1_bee1(a) = x1_lo + rand*(x1_up - x1_lo);
        else
            newvar1_bee1_fit = var1_bee1_fit;
        end
        %for var 1 bee 2
        if (abs(newvar1_bee2_fit(a) - var1_bee2_fit(a)) < 0.0001)
            var1_bee2(a) = x1_lo + rand*(x1_up - x1_lo);
        else
            newvar1_bee2_fit = var1_bee2_fit;
        end
        %for var 2 bee 1
        if (abs(newvar2_bee1_fit(a) - var2_bee1_fit(a)) < 0.0001)
            var2_bee1(a) = x2_lo + rand*(x2_up - x2_lo);
        else
            newvar2_bee1_fit = var2_bee1_fit;
        end
        %for var 2 bee 2
        if (abs(newvar2_bee2_fit(a) - var2_bee2_fit(a)) < 0.0001)
            var2_bee2(a) = x2_lo + rand*(x2_up - x2_lo);
        else
            newvar2_bee2_fit = var2_bee2_fit;
        end
    end
            
end

bestvar1_min = var1_min;
bestvar2_min = var2_min;
iter = iter + 1;
end
var1_min
var2_min
iter



