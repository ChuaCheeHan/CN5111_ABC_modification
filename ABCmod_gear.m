function ABCmod_gear
%ABCMOD_GEAR Summary of this function goes here
%   Detailed explanation goes here
x_lo = 12;
x_up = 60;
iter = 0;

f = @(x1,x2, x3, x4) (1/6.931 - (x1*x2/(x3*x4)))^2;

%Generation of initial population (2 bees per variable)
var1 = zeros(2,5);
var2 = zeros(2,5);
var3 = zeros(2,5);
var4 = zeros(2,5);
for (a = 1:2)
    for (b = 1:5)
        var1(a,b) = round(x_lo + rand*(x_up - x_lo));
        var2(a,b) = round(x_lo + rand*(x_up - x_lo));
        var3(a,b) = round(x_lo + rand*(x_up - x_lo));
        var4(a,b) = round(x_lo + rand*(x_up - x_lo));
    end
end

%Evaluation of food sources
for (a = 1:2)
    for (b = 1:5)
        var1_fit(a,b) = f(var1(a,b),var2(1),var3(1),var4(1));
        var2_fit(a,b) = f(var1(1),var2(a,b),var3(1),var4(1));
        var3_fit(a,b) = f(var1(1),var2(1),var3(a,b),var4(1));
        var4_fit(a,b) = f(var1(1),var2(1),var3(1),var4(a,b));
    end
end

bestvar1_min = var1(1);
bestvar2_min = var2(1);
bestvar3_min = var3(1);
bestvar4_min = var4(1);

while (iter < 2000)
%%min value for each variable
%%min value for var 1
min_v1_fit = min(min(var1_fit'));
min_v1_idx = find(var1_fit == min_v1_fit);
var1_min = var1(min_v1_idx(1));
%%min value for var 2
min_v2_fit = min(min(var2_fit'));
min_v2_idx = find(var2_fit == min_v2_fit);
var2_min = var2(min_v2_idx(1));
%%min value for var 3
min_v3_fit = min(min(var3_fit'));
min_v3_idx = find(var3_fit == min_v3_fit);
var3_min = var3(min_v3_idx(1));
%%min value for var 4
min_v4_fit = min(min(var4_fit'));
min_v4_idx = find(var4_fit == min_v4_fit);
var4_min = var4(min_v4_idx(1));

%Produce new food sources for employed bees
%%Determining scale factor golden section search
if (iter == 0)
    v1_a = [-1, -1, -1, -1 -1; -1,-1,-1,-1,-1];
    v1_b = [1 1 1 1 1;1 1 1 1 1];
    v2_a = [-1, -1, -1, -1 -1; -1,-1,-1,-1,-1];
    v2_b = [1 1 1 1 1;1 1 1 1 1];
    v3_a = [-1, -1, -1, -1 -1; -1,-1,-1,-1,-1];
    v3_b = [1 1 1 1 1;1 1 1 1 1];
    v4_a = [-1, -1, -1, -1 -1; -1,-1,-1,-1,-1];
    v4_b = [1 1 1 1 1;1 1 1 1 1];
end
for (a = 1:2)
    for (b = 1:5)
        v1_Fz1(a,b) = v1_b(a,b) - (v1_b(a,b)-v1_a(a,b))/((1+sqrt(5))/2);
        v1_Fz2(a,b) = v1_a(a,b) + (v1_b(a,b)-v1_a(a,b))/((1+sqrt(5))/2);
        v2_Fz1(a,b) = v2_b(a,b) - (v2_b(a,b)-v2_a(a,b))/((1+sqrt(5))/2);
        v2_Fz2(a,b) = v2_a(a,b) + (v2_b(a,b)-v2_a(a,b))/((1+sqrt(5))/2);
        v3_Fz1(a,b) = v3_b(a,b) - (v3_b(a,b)-v3_a(a,b))/((1+sqrt(5))/2);
        v3_Fz2(a,b) = v3_a(a,b) + (v3_b(a,b)-v3_a(a,b))/((1+sqrt(5))/2);
        v4_Fz1(a,b) = v4_b(a,b) - (v4_b(a,b)-v4_a(a,b))/((1+sqrt(5))/2);
        v4_Fz2(a,b) = v4_a(a,b) + (v4_b(a,b)-v4_a(a,b))/((1+sqrt(5))/2);

    end
end


%%Employed bees stage
for (a = 1:2)
    for (b = 1:5)
    %for variable 1
    x_randomval = randi(5);
    while (x_randomval == b)
        x_randomval = randi(5);
    end
    v1 = round(var1(a,b) + v1_Fz1(a,b)*(var1(a,b) - var1(a,x_randomval)));
    v2 = round(var1(a,b) + v1_Fz2(a,b)*(var1(a,b) - var1(a,x_randomval)));

    if (f(v1, var2_min, var3_min, var4_min) < f(v2, var2_min, var3_min, var4_min))
        newv = v1;
        v1_b(a,b) = v1_Fz2(a,b);
    else newv = v2;
        v1_a(a,b) = v1_Fz1(a,b);
    end
 
    if (f(newv, var2_min, var3_min, var4_min) < f(var1(a,b), var2_min, var3_min, var4_min))
        var1(a,b) = newv;
    end
    if (var1(a,b) < x_lo)
        var1(a,b) = x_lo;
    end
    if (var1(a,b) > x_up)
        var1(a,b) = x_up;
    end
    
    %for variable 2
    x_randomval = randi(5);
    while (x_randomval == b)
        x_randomval = randi(5);
    end
    v1 = round(var2(a,b) + v2_Fz1(a,b)*(var2(a,b) - var2(a,x_randomval)));
    v2 = round(var2(a,b) + v2_Fz2(a,b)*(var2(a,b) - var2(a,x_randomval)));

    if (f(var1_min, v1, var3_min, var4_min) < f(var1_min, v2, var3_min, var4_min))
        newv = v1;
        v2_b(a,b) = v2_Fz2(a,b);
    else newv = v2;
        v2_a(a,b) = v2_Fz1(a,b);
    end
 
    if (f(var1_min, newv, var3_min, var4_min) < f(var1_min, var2(a,b), var3_min, var4_min))
        var2(a,b) = newv;
    end
    if (var2(a,b) < x_lo)
        var2(a,b) = x_lo;
    end
    if (var2(a,b) > x_up)
        var2(a,b) = x_up;
    end
    
    %for variable 3
    x_randomval = randi(5);
    while (x_randomval == b)
        x_randomval = randi(5);
    end
    v1 = round(var3(a,b) + v3_Fz1(a,b)*(var3(a,b) - var3(a,x_randomval)));
    v2 = round(var3(a,b) + v3_Fz2(a,b)*(var3(a,b) - var3(a,x_randomval)));

    if (f(var1_min, var2_min, v1, var4_min) < f(var1_min, var2_min, v2, var4_min))
        newv = v1;
        v3_b(a,b) = v3_Fz2(a,b);
    else newv = v2;
        v3_a(a,b) = v3_Fz1(a,b);
    end
 
    if (f(var1_min, var2_min, newv, var4_min) < f(var1_min, var2_min, var3(a,b), var4_min))
        var3(a,b) = newv;
    end
    if (var3(a,b) < x_lo)
        var3(a,b) = x_lo;
    end
    if (var3(a,b) > x_up)
        var3(a,b) = x_up;
    end
    
    %for variable 4
    x_randomval = randi(5);
    while (x_randomval == b)
        x_randomval = randi(5);
    end
    v1 = round(var4(a,b) + v4_Fz1(a,b)*(var4(a,b) - var4(a,x_randomval)));
    v2 = round(var4(a,b) + v4_Fz2(a,b)*(var4(a,b) - var4(a,x_randomval)));

    if (f(var1_min, var2_min, var3_min, v1) < f(var1_min, var2_min, var3_min, v2))
        newv = v1;
        v4_b(a,b) = v4_Fz2(a,b);
    else newv = v2;
        v4_a(a,b) = v4_Fz1(a,b);
    end
 
    if (f(var1_min, var2_min, var3_min, newv) < f(var1_min, var2_min, var3_min, var4(a,b)))
        var4(a,b) = newv;
    end
    if (var4(a,b) < x_lo)
        var4(a,b) = x_lo;
    end
    if (var4(a,b) > x_up)
        var4(a,b) = x_up;
    end
    
    end
end

%Calculate the probability values for Onlookers
%%min value for each variable
%%min value for var 1
min_v1_fit = min(min(var1_fit'));
min_v1_idx = find(var1_fit == min_v1_fit);
var1_min = var1(min_v1_idx(1));
%%min value for var 2
min_v2_fit = min(min(var2_fit'));
min_v2_idx = find(var2_fit == min_v2_fit);
var2_min = var2(min_v2_idx(1));
%%min value for var 3
min_v3_fit = min(min(var3_fit'));
min_v3_idx = find(var3_fit == min_v3_fit);
var3_min = var3(min_v3_idx(1));
%%min value for var 4
min_v4_fit = min(min(var4_fit'));
min_v4_idx = find(var4_fit == min_v4_fit);
var4_min = var4(min_v4_idx(1));

%Evaluation of food sources
for (a = 1:2)
    for (b = 1:5)
        var1_fit(a,b) = f(var1(a,b),var2(1),var3(1),var4(1));
        var2_fit(a,b) = f(var1(1),var2(a,b),var3(1),var4(1));
        var3_fit(a,b) = f(var1(1),var2(1),var3(a,b),var4(1));
        var4_fit(a,b) = f(var1(1),var2(1),var3(1),var4(a,b));
    end
end

%%change values of fitness for probability
v1_totalf = [0;0];
v2_totalf = [0;0];
v3_totalf = [0;0];
v4_totalf = [0;0];
for (a = 1:2)
    for (b = 1:5)
        v1_totalf(a) = v1_totalf(a) + var1_fit(a,b);
        v2_totalf(a) = v2_totalf(a) + var2_fit(a,b);
        v3_totalf(a) = v3_totalf(a) + var3_fit(a,b);
        v4_totalf(a) = v4_totalf(a) + var4_fit(a,b);
    end
end

inverse_v1 = zeros(2,5);
inverse_v2 = zeros(2,5);
inverse_v3 = zeros(2,5);
inverse_v4 = zeros(2,5);

for (a = 1:2)
    for (b = 1:5)
        inverse_v1(a,b) = v1_totalf(a)/var1_fit(a,b);
        inverse_v2(a,b) = v2_totalf(a)/var2_fit(a,b);
        inverse_v3(a,b) = v3_totalf(a)/var3_fit(a,b);
        inverse_v4(a,b) = v4_totalf(a)/var4_fit(a,b);
    end
end
probability_v1 = zeros(2,5);
probability_v2 = zeros(2,5);
probability_v3 = zeros(2,5);
probability_v4 = zeros(2,5);
for (a = 1:2)
    for (b = 1:5)
        probability_v1(a,b) = inverse_v1(a,b)/sum(inverse_v1(a,:));
        probability_v2(a,b) = inverse_v2(a,b)/sum(inverse_v2(a,:));
        probability_v3(a,b) = inverse_v3(a,b)/sum(inverse_v3(a,:));
        probability_v4(a,b) = inverse_v4(a,b)/sum(inverse_v4(a,:));
    end
end


%%Onlooker finds the index and possibly swaps the value
%%for var 1
for (a = 1:2)
    x = cumsum([0 probability_v1(a,:)'.'/sum(probability_v1(a,:)')]);
    x(end) = 1e3*eps + x(end);
    [p_val p_idx] = histc(rand,x);
    v1_Fz1(a,p_idx) = v1_b(a,p_idx) - (v1_b(a,p_idx)-v1_a(a,p_idx))/((1+sqrt(5))/2);
    v1_Fz2(a,p_idx) = v1_a(a,p_idx) + (v1_b(a,p_idx)-v1_a(a,p_idx))/((1+sqrt(5))/2);
    x_randomval = randi(5);
    while (x_randomval == p_idx)
        x_randomval = randi(5);
    end
    v1 = round(var1(a,p_idx) + v1_Fz1(a,p_idx)*(var1(a,p_idx) - var1(a,x_randomval)));
    v2 = round(var1(a,p_idx) + v1_Fz2(a,p_idx)*(var1(a,p_idx) - var1(a,x_randomval)));
    if (f(v1, var2_min, var3_min, var4_min) < f(v2, var2_min, var3_min, var4_min))
        newv = v1;
        v1_b(a,p_idx) = v1_Fz2(a,p_idx);
    else newv = v2;
        v1_a(a,p_idx) = v1_Fz1(a,p_idx);    
    end
    if (f(newv, var2_min, var3_min, var4_min) < f(var1(a,p_idx), var2_min, var3_min, var4_min))
        var1(a,p_idx) = newv;
    end
    if (var1(a,p_idx) < x_lo)
        var1(a,p_idx) = x_lo;
    end
    if (var1(a,p_idx) > x_up)
        var1(a,p_idx) = x_up;
    end
end

%%for var 2
for (a = 1:2)
    x = cumsum([0 probability_v2(a,:)'.'/sum(probability_v2(a,:)')]);
    x(end) = 1e3*eps + x(end);
    [p_val p_idx] = histc(rand,x);
    v2_Fz1(a,p_idx) = v2_b(a,p_idx) - (v2_b(a,p_idx)-v2_a(a,p_idx))/((1+sqrt(5))/2);
    v2_Fz2(a,p_idx) = v2_a(a,p_idx) + (v2_b(a,p_idx)-v2_a(a,p_idx))/((1+sqrt(5))/2);
    x_randomval = randi(5);
    while (x_randomval == p_idx)
        x_randomval = randi(5);
    end
    v1 = round(var2(a,p_idx) + v2_Fz1(a,p_idx)*(var2(a,p_idx) - var2(a,x_randomval)));
    v2 = round(var2(a,p_idx) + v2_Fz2(a,p_idx)*(var2(a,p_idx) - var2(a,x_randomval)));
    if (f(var1_min, v1, var3_min, var4_min) < f(var1_min, v2, var3_min, var4_min))
        newv = v1;
        v2_b(a,p_idx) = v2_Fz2(a,p_idx);
    else newv = v2;
        v2_a(a,p_idx) = v2_Fz1(a,p_idx);    
    end
    if (f(var1_min, newv, var3_min, var4_min) < f(var1_min, var2(a,p_idx), var3_min, var4_min))
        var2(a,p_idx) = newv;
    end
    if (var2(a,p_idx) < x_lo)
        var2(a,p_idx) = x_lo;
    end
    if (var2(a,p_idx) > x_up)
        var2(a,p_idx) = x_up;
    end
end

%%for var 3
for (a = 1:2)
    x = cumsum([0 probability_v3(a,:)'.'/sum(probability_v3(a,:)')]);
    x(end) = 1e3*eps + x(end);
    [p_val p_idx] = histc(rand,x);
    v3_Fz1(a,p_idx) = v3_b(a,p_idx) - (v3_b(a,p_idx)-v3_a(a,p_idx))/((1+sqrt(5))/2);
    v3_Fz2(a,p_idx) = v3_a(a,p_idx) + (v3_b(a,p_idx)-v3_a(a,p_idx))/((1+sqrt(5))/2);
    x_randomval = randi(5);
    while (x_randomval == p_idx)
        x_randomval = randi(5);
    end
    v1 = round(var3(a,p_idx) + v3_Fz1(a,p_idx)*(var3(a,p_idx) - var3(a,x_randomval)));
    v2 = round(var3(a,p_idx) + v3_Fz2(a,p_idx)*(var3(a,p_idx) - var3(a,x_randomval)));
    if (f(var1_min, var2_min, v1, var4_min) < f(var1_min, var2_min, v2, var4_min))
        newv = v1;
        v3_b(a,p_idx) = v3_Fz2(a,p_idx);
    else newv = v2;
        v3_a(a,p_idx) = v3_Fz1(a,p_idx);    
    end
    if (f(var1_min, var2_min, newv, var4_min) < f(var1_min, var2_min, var3(a,p_idx), var4_min))
        var3(a,p_idx) = newv;
    end
    if (var3(a,p_idx) < x_lo)
        var3(a,p_idx) = x_lo;
    end
    if (var3(a,p_idx) > x_up)
        var3(a,p_idx) = x_up;
    end
end

%%for var 4
for (a = 1:2)
    x = cumsum([0 probability_v4(a,:)'.'/sum(probability_v4(a,:)')]);
    x(end) = 1e3*eps + x(end);
    [p_val p_idx] = histc(rand,x);
    v4_Fz1(a,p_idx) = v4_b(a,p_idx) - (v4_b(a,p_idx)-v4_a(a,p_idx))/((1+sqrt(5))/2);
    v4_Fz2(a,p_idx) = v4_a(a,p_idx) + (v4_b(a,p_idx)-v4_a(a,p_idx))/((1+sqrt(5))/2);
    x_randomval = randi(5);
    while (x_randomval == p_idx)
        x_randomval = randi(5);
    end
    v1 = round(var4(a,p_idx) + v4_Fz1(a,p_idx)*(var4(a,p_idx) - var4(a,x_randomval)));
    v2 = round(var4(a,p_idx) + v4_Fz2(a,p_idx)*(var4(a,p_idx) - var4(a,x_randomval)));
    if (f(var1_min, var2_min, var3_min, v1) < f(var1_min, var2_min, var3_min, v2))
        newv = v1;
        v4_b(a,p_idx) = v4_Fz2(a,p_idx);
    else newv = v2;
        v4_a(a,p_idx) = v4_Fz1(a,p_idx);    
    end
    if (f(var1_min, var2_min, var3_min, newv) < f(var1_min, var2_min, var3_min, var4(a,p_idx)))
        var4(a,p_idx) = newv;
    end
    if (var4(a,p_idx) < x_lo)
        var4(a,p_idx) = x_lo;
    end
    if (var4(a,p_idx) > x_up)
        var4(a,p_idx) = x_up;
    end
end

%find the current best solution
%Evaluation of food sources
for (a = 1:2)
    for (b = 1:5)
        var1_fit(a,b) = f(var1(a,b),var2(1),var3(1),var4(1));
        var2_fit(a,b) = f(var1(1),var2(a,b),var3(1),var4(1));
        var3_fit(a,b) = f(var1(1),var2(1),var3(a,b),var4(1));
        var4_fit(a,b) = f(var1(1),var2(1),var3(1),var4(a,b));
    end
end

%%min value for each variable
%%min value for var 1
min_v1_fit = min(min(var1_fit'));
min_v1_idx = find(var1_fit == min_v1_fit);
var1_min = var1(min_v1_idx(1));
%%min value for var 2
min_v2_fit = min(min(var2_fit'));
min_v2_idx = find(var2_fit == min_v2_fit);
var2_min = var2(min_v2_idx(1));
%%min value for var 3
min_v3_fit = min(min(var3_fit'));
min_v3_idx = find(var3_fit == min_v3_fit);
var3_min = var3(min_v3_idx(1));
%%min value for var 4
min_v4_fit = min(min(var4_fit'));
min_v4_idx = find(var4_fit == min_v4_fit);
var4_min = var4(min_v4_idx(1));

if (abs(f(var1_min, var2_min, var3_min, var4_min) - f(bestvar1_min, bestvar2_min, bestvar3_min, bestvar4_min)) < 1e-15)
    break;
end

%if fitness stagnates, replace with new scout bee
if (iter == 0)
    newvar1_fit = zeros(2,5);
    newvar2_fit = zeros(2,5);
    newvar3_fit = zeros(2,5);
    newvar4_fit = zeros(2,5);
end
for (a = 1:2)
    for (b = 1:5)
        if (iter == 0)
            newvar1_fit(a,b) = var1_fit(a,b);
            newvar2_fit(a,b) = var2_fit(a,b);
            newvar3_fit(a,b) = var3_fit(a,b);
            newvar4_fit(a,b) = var4_fit(a,b);
        else
            %for var 1
            if (abs(newvar1_fit(a,b) - var1_fit(a,b)) < 1e-15)
                var1(a,b) = round(x_lo + rand*(x_up - x_lo));
                v1_a(a) = 1;
                v1_b(a) = -1;
            else
                newvar1_fit = var1_fit;
            end
            
            %for var 2
            if (abs(newvar2_fit(a,b) - var2_fit(a,b)) < 1e-15)
                var2(a,b) = round(x_lo + rand*(x_up - x_lo));
                v2_a(a) = 1;
                v2_b(a) = -1;
            else
                newvar2_fit = var2_fit;
            end
            
             %for var 3
            if (abs(newvar3_fit(a,b) - var3_fit(a,b)) < 1e-15)
                var3(a,b) = round(x_lo + rand*(x_up - x_lo));
                v3_a(a) = 1;
                v3_b(a) = -1;
            else
                newvar3_fit = var3_fit;
            end
            
             %for var 4
            if (abs(newvar4_fit(a,b) - var4_fit(a,b)) < 1e-15)
                var4(a,b) = round(x_lo + rand*(x_up - x_lo));
                v4_a(a) = 1;
                v4_b(a) = -1;
            else
                newvar4_fit = var4_fit;
            end
        end
    end
end

bestvar1_min = var1_min;
bestvar2_min = var2_min;
bestvar3_min = var3_min;
bestvar4_min = var4_min;
iter = iter + 1;
end
var1_min
var2_min
var3_min
var4_min
iter
