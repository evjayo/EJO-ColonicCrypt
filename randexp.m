function x = randexp(lam)
p = rand(1);
x = (1/lam)*log(1/(1-p));