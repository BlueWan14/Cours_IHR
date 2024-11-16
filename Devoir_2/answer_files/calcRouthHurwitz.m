close all
system_config
clear Kp Kh

[Boucle_ouverte, Boucle] = Calc_Sys();

syms Kp Kh s
S_boucle = calcTabRH(Boucle, [sym('MR') sym('mR') sym('Kb') sym('Cb') sym('CR') sym('T') sym('m') sym('c')], [MR mR Kb Cb CR T m c], s);

Kp = 0:1500;
Kh = 50;
figure;
hold on
for i = 1:length(S_boucle(:,1))
    if ~isempty(find(symvar(S_boucle(i,1)) == sym('Kp'), 1))
        S_boucle(i,1) = subs(S_boucle(i,1), sym('Kh'), Kh);
        S_calc = eval(subs(S_boucle(i,1), sym('Kp'), Kp));

        subplot(3, 2, i)
        plot(Kp, S_calc, 'LineWidth', 2)
        yline(0, '--')
        xlabel("Kp")
        ylabel("Critère de Routh-Hurwitz S^" + i)
    end
end
hold off


TF = subs( ...
    Boucle_ouverte, ...
    [sym('MR') sym('mR') sym('Kb') sym('Cb') sym('CR') sym('T') sym('m') sym('c') sym('Kp')], ...
    [MR mR Kb Cb CR T m c 90] ...
);
TFFun = matlabFunction(TF);
TFFun = str2func(regexprep(func2str(TFFun), '\.([/^\\*])', '$1'));
figure;
rlocus(tf(TFFun(tf('s'))))
xlim([-0.5, 0.5])
ylim([-2,2])
rlocfind(tf(TFFun(tf('s'))))



function [Boucle_NoKh, Boucle1] = Calc_Sys()
    syms MR mR Kb Cb CR Kh Kp T m c s
    
    BoucleVitesse0 = Kp*(MR*s^2+Kb+Cb*s+CR*s)*s*1/(s*(mR*s^3*MR+mR*s*Kb+mR*s^2*Cb+mR*s^2*CR+Kb*MR*s+Kb*CR+Cb*s^2*MR+Cb*s*CR)*(T*s+1));
    BoucleVitesse1 = collect(simplify(BoucleVitesse0/(1+BoucleVitesse0)), s);
    Humain = Kh;
    Admittance = 1/(m*s+c);
    
    Boucle0 = Humain*Admittance*BoucleVitesse1*((MR*s^2+Kb+Cb*s+CR*s)*s)^(-1)*(Kb+Cb*s);
    Boucle_NoKh = Admittance*BoucleVitesse1*((MR*s^2+Kb+Cb*s+CR*s)*s)^(-1)*(Kb+Cb*s);
    Boucle1 = collect(simplify(Boucle0*(1+Boucle0)^(-1)), s);
end

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