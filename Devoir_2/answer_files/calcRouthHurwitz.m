close all
system_config
clear Kp Kh

[BoucleVitesse, Boucle] = Calc_Sys();

syms Kp Kh s
disp("<strong>Boucle de vitesse</strong>")
BoucleVitesse = subs(BoucleVitesse, [sym('MR') sym('mR') sym('Kb') sym('Cb') sym('CR') sym('T')], [MR mR Kb Cb CR T]);
Kp_min = calcGain(BoucleVitesse, Kp, s);
TF = subs(BoucleVitesse, Kp, Kp_min);
TFFun = matlabFunction(TF);
TFFun = str2func(regexprep(func2str(TFFun), '\.([/^\\*])', '$1'));
figure;
rlocus(tf(TFFun(tf('s'))))
disp(" ")

assume(Kh > 0)
assumeAlso(Kp > 0)
disp("<strong>Boucle complete</strong>")
Boucle = subs(Boucle, [sym('MR') sym('mR') sym('Kb') sym('Cb') sym('CR') sym('T') sym('m') sym('c')], [MR mR Kb Cb CR T m c]);
Kh_max = calcGain(Boucle, Kh, s);
TF = subs(Boucle, [Kh Kp], [1e-6 1e-6]);
TFFun = matlabFunction(TF);
TFFun = str2func(regexprep(func2str(TFFun), '\.([/^\\*])', '$1'));
figure;
rlocus(tf(TFFun(tf('s'))))



function K = calcGain(TF, var, s)
    [~, Den] = numden(TF);
    [an, terms] = coeffs(Den, s);
    l_terms = length(terms);
    l = round(l_terms/2);
    
    S = sym(zeros(l_terms, l));
    for n=1:l
        i = n*2;
        S(l_terms, n) = an(i-1);
        if i < l_terms
            S(l_terms-1, n) = an(i);
        end
    end
    for k=l_terms-2:-1:1
        for n=1:l-1
            S(k, n) = (S(k+1, 1)*S(k+2, n+1)-S(k+2, 1)*S(k+1, n+1))/S(k+1, 1);
        end
    end
    disp("Tableau du critère de Routh-Hurwitz :")
    disp(S)
    
    cond = solve(S(symvar(S(:, 1)) == var, 1) > 0, var, ReturnConditions=true);
    disp("<strong>" + string(subs(cond.conditions, sym('x'), var)) + "</strong>")
    K = solve(S(symvar(S(:, 1)) == var, 1) == 0, var);
end