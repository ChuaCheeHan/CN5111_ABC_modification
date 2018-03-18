$title Design of Gear Train

$ontext

Optimizing the gear ratio for the compound gear train.
Gear ratio is designed to be as close to 1/6.931.

$offtext

Variable
         F;

Integer Variable
         x1
         x2
         x3
         x4;

Equation
         e1;

e1.. F =e= (1/6.931 - x1*x2/(x3*x4))*(1/6.931 - x1*x2/(x3*x4));

x1.lo = 12; x1.up = 60;
x2.lo = 12; x2.up = 60;
x3.lo = 12; x3.up = 60;
x4.lo = 12; x4.up = 60;

Model m /all/;

solve m using minlp minimizing F;