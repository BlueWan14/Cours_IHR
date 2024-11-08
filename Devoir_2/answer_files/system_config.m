clear;
clc;

%Temps de simulation
sim_time = 10;  % s


% Modèle humain
Kh = 550;       % N/m       Coefficient de rigité de l'humain
Ch = 23.45;     % N*s/m     Coefficient d'amortissement de l'humain

% Admittance
c = 20;         % N*s/m
m = 20;         % kg        Masse virutelle

% Imperfections
T = 0.1;        % s         Temps d'échantillonage

% Gain
Kp = 0.1;

mR = 50;        % kg        Masse des rotors
MR = 500;       % kg        Masse du système
CR = 100;       % N*s/m     Coefficients de frottements du système
Cb = 40;        % N*s/m     Amortissement des courroies
Kb = 40000;     % N/m       Ressort des courroies


Kh_min = Kh/2;
Kh_max = Kh*2;

[A, B, C, D] = calcIAD(Kb, Cb, CR, m, MR);
