clear;
clc;

%Temps de simulation
sim_time = 30;  % s


% Modèle humain
Kh = 550;       % N/m       Coefficient de raideur de l'humain
Ch = 23.45;     % N*s/m     Coefficient d'amortissement de l'humain

% Admittance
c = 20;         % N*s/m
m = 20;         % kg        Masse virutelle

% Imperfections
T = .1;         % s         Temps d'échantillonage

% Gain
Kp = -100;

mR = 50;        % kg        Masse des moteurs
MR = 500;       % kg        Masse de la charge
CR = 100;       % N*s/m     Coefficient de frottement du système
Cb = 40;        % N*s/m     Coefficient d'amortissement des courroies
Kb = 40000;     % N/m       Constante de raideur des courroies


Kh_init = Kh/2;

[A, B, C, D] = calcIAD(Kb, Cb, CR, m, MR);

%Gx1 = tf([MR (Cb+CR) Kb], [MR*mR (Cb*mR+CR*mR+Cb*MR) (Kb*mR+Cb*CR+Kb*MR) CR*Kb]);
%Gx2 = tf([Cb Kb], [MR*mR (Cb*mR+CR*mR+Cb*MR) (Kb*mR+Cb*CR+Kb*MR) CR*Kb]);
%[A_x1, B_x1, C_x1, D_x1] = tf2ss(Gx1.num{1}, Gx1.den{1})
%[A_x2, B_x2, C_x2, D_x2] = tf2ss(Gx2.num{1}, Gx2.den{1})
