$title Optimal Capacity of Gas Production Facilities

$ontext

Determing the optimal capacity of production facilities
that combine to make an oxygen producing and storing system.

$offtext

Variable
    F
    x1
    x2;

Equation
    e1;

e1.. F =e= 61.8 + 5.72*x1 + 0.2623*((40-x1)*log(x2/200))**(-0.85) + (0.087*(40 - x1))*log(x2/200) + 700.23*(x2**(-0.75));

x1.lo = 17.5; x1.up = 40;
x2.lo = 300; x2.up = 600;


Model m /all/;

solve m using nlp minimizing F;

