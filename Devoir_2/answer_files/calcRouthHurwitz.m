close all
system_config
clear Kp Kh

[BoucleVitesse, Boucle] = Calc_Sys();

syms Kp Kh s
disp("<strong>Boucle de vitesse</strong>")
BoucleVitesse = subs(BoucleVitesse, [sym('MR') sym('mR') sym('Kb') sym('Cb') sym('CR') sym('T')], [MR mR Kb Cb CR T]);
S_vitesse = calcTabRH(BoucleVitesse, s);
disp("<strong>Boucle complete</strong>")
Boucle = subs(Boucle, [sym('MR') sym('mR') sym('Kb') sym('Cb') sym('CR') sym('T') sym('m') sym('c')], [MR mR Kb Cb CR T m c]);
S_boucle = calcTabRH(Boucle, s);

eqs = [S_vitesse(symvar(S_vitesse(:, 1)) == Kp, 1), S_boucle(find(symvar(S_boucle(:, 1)) == Kp) || find(symvar(S_boucle(:, 1)) == Kh), 1)];
assume(Kh > 0)      % car la rigidité de l'humain ne peux pas être négative
cond = solve(eqs > 0, Kp, ReturnConditions=true);
disp("<strong>" + string(subs(cond.conditions, sym('x'), Kp)) + "</strong>")


K_test = [1e-6 1e-6];

%disp(subs(S_boucle, [Kh Kp], K_test))

TF = subs(Boucle, [Kh Kp], K_test);
TFFun = matlabFunction(TF);
TFFun = str2func(regexprep(func2str(TFFun), '\.([/^\\*])', '$1'));
figure;
rlocus(tf(TFFun(tf('s'))))



function S = calcTabRH(TF, s)
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
end