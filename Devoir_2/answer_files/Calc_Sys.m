function Boucle1 = Calc_Sys()
    syms MR mR x2 x1 Kb Cb CR F s
    a = MR*s^2*x2 == Kb*x1-Kb*x2+Cb*x1*s-Cb*x2*s-CR*x2*s;
    b = mR*s^2*x1 == F-Kb*x1+Kb*x2-Cb*x1*s+Cb*x2*s;
    
    sol = solve([a b], [x1 x2]);
    
    x1 = collect(simplify(sol.x1*(s/F)), s)*(F/s)
    x2 = collect(simplify(sol.x2*(s/F)), s)*(F/s)


    syms Kh Kp T m c
    
    BoucleVitesse0 = Kp*(MR*s^2+Kb+Cb*s+CR*s)*s*1/(s*(mR*s^3*MR+mR*s*Kb+mR*s^2*Cb+mR*s^2*CR+Kb*MR*s+Kb*CR+Cb*s^2*MR+Cb*s*CR)*(T*s+1));
    BoucleVitesse1 = collect(simplify(BoucleVitesse0/(1+BoucleVitesse0)), s)
    Humain = Kh;
    Admittance = 1/(m*s+c);
    
    Boucle0 = Humain*Admittance*BoucleVitesse1*((MR*s^2+Kb+Cb*s+CR*s)*s)^(-1)*(Kb+Cb*s);
    Boucle1 = collect(simplify(Boucle0*(1+Boucle0)^(-1)), s)
end