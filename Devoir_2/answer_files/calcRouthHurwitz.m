system_config
clear Kp

sys = Calc_Sys();

syms Kp s
TF = subs(sys, [sym('MR') sym('mR') sym('Kb') sym('Cb') sym('CR') sym('T') sym('m') sym('c') sym('Kh')], [MR mR Kb Cb CR T m c Kh]);
[Num, Den] = numden(TF)
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

Kp_range = struct('max', -Inf, 'min', 0);
assume(Kp > 0)          % car s0 = Kp*55000 = 0
for i = 1:l_terms
    if ~isempty(find(symvar(s(i, 1)) == Kp)) || ~isempty(find(symvar(s(i, 1)) == Kh))
        sol = solve(s(i, 1) == 0, Kp);

        Kp_sol = double(sol);
        if max(Kp_sol) > Kp_range.max
            Kp_range.max = max(Kp_sol);
        end
    end
end

disp("<strong>" + Kp_range.min + " < Kp < " + Kp_range.max + "</strong>")

disp(subs(s, Kp, Kp_range.max))

%hold on;
TF_max = subs(TF, Kp, Kp_range.max);
TFFun_max = matlabFunction(TF_max);
TFFun_max = str2func(regexprep(func2str(TFFun_max), '\.([/^\\*])', '$1'));
rlocus(tf(TFFun_max(tf('s'))))
%hold off;
