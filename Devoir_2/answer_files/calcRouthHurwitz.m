close all
system_config
clear Kp Kh

[Boucle_ouverte, Boucle] = Calc_Sys();

syms Kp Kh s
S_boucle = calcTabRH(Boucle, [sym('MR') sym('mR') sym('Kb') sym('Cb') sym('CR') sym('T') sym('m') sym('c')], [MR mR Kb Cb CR T m c], s);


Kp = 0:3000;
Kh = 100;
for i = 1:length(S_boucle(:,1))
    S_boucle(i,1) = subs(S_boucle(i,1), sym('Kh'), Kh);
    S_calc = eval(subs(S_boucle(i,1), sym('Kp'), Kp));

    %figure;
    %plot(Kp, S_calc)
end

TF = subs( ...
    Boucle_ouverte, ...
    [sym('MR') sym('mR') sym('Kb') sym('Cb') sym('CR') sym('T') sym('m') sym('c') sym('Kp')], ...
    [MR mR Kb Cb CR T m c 25] ...
);
TFFun = matlabFunction(TF);
TFFun = str2func(regexprep(func2str(TFFun), '\.([/^\\*])', '$1'));
figure;
rlocus(tf(TFFun(tf('s'))))
xlim([-0.5, 0.5])
ylim([-2,2])
rlocfind(tf(TFFun(tf('s'))))



function S = calcTabRH(TF, Oldvars,  Newvars, s)
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
    S = simplify(subs(S, Oldvars, Newvars));

    disp("Tableau du critère de Routh-Hurwitz :")
    disp(S)
end