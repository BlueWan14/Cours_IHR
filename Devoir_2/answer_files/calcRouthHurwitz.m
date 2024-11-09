system_config
clear Kp Kh

syms s Kp Kh
Den = MR*T*m*mR*s^6 + ...
      (MR*m*mR + Cb*MR*T*m + CR*T*m*mR + MR*T*c*mR + Cb*T*m*mR)*s^5 + ...
      (Cb*MR*m + Kp*MR*m + CR*m*mR + MR*c*mR + Cb*m*mR + CR*Cb*T*m + Cb*MR*T*c + Kb*MR*T*m + CR*T*c*mR + Cb*T*c*mR + Kb*T*m*mR)*s^4 + ...
      (CR*Cb*m + Cb*MR*c + CR*Kp*m + Kp*MR*c + Cb*Kp*m + Kb*MR*m + CR*c*mR + Cb*c*mR + Kb*m*mR + CR*Cb*T*c + CR*Kb*T*m + Kb*MR*T*c + Kb*T*c*mR)*s^3 + ...
      (CR*Cb*c + CR*Kp*c + Cb*Kp*c + CR*Kb*m + Kb*MR*c + Kb*Kp*m + Kb*c*mR + CR*Kb*T*c)*s^2 + ...
      (Cb*Kh*Kp + CR*Kb*c + Kb*Kp*c)*s + ...
      Kb*Kh*Kp;
[an, terms] = coeffs(Den, s);
l_terms = length(terms);
l = round(l_terms/2);

s = sym(zeros(l_terms, l));
for n=1:l
    i = n*2;
    s(l_terms, n) = an(i-1);
    if i < l_terms
        s(l_terms-1, n) = an(i);
    end
end
for k=l_terms-2:-1:1
    for n=1:l-1
        s(k, n) = (s(k+1, 1)*s(k+2, n+1)-s(k+2, 1)*s(k+1, n+1))/s(k+1, 1);
    end
end
disp("Tableau du critère de Routh-Hurwitz :")
disp(s)

Kh_max = 0;
Kh_min = Inf;
Kp_max = 0;
Kp_min = Inf;
for i = 1:l_terms
    sol = solve(s(i, 1) == 0, [Kp Kh]);

    disp("Kh :")
    disp(sol.Kh)
    if max(sol.Kh) > Kh_max
        Kh_max = max(sol.Kh);
    end
    if min(sol.Kh) < Kh_min
        if min(sol.Kh) > 0
            Kh_min = min(sol.Kh);
        else
            Kh_min = 0;
        end
    end

    disp("Kp :")
    disp(sol.Kp)
    if max(sol.Kp) > Kp_max
        Kp_max = max(sol.Kp);
    end
    if min(sol.Kp) < Kp_min
        if min(sol.Kp) > 0
            Kp_min = min(sol.Kp);
        else
            Kp_min = 0;
        end
    end
end

clear s Kp Kh
