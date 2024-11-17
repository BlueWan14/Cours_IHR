clear;
clc;

%Temps de simulation
sim_time = 200;     % s
buffer_size = 128;  % Taille de la mémoire tempon de l'observeur


% Modèle humain
Kh = 550;           % N/m       Coefficient de raideur de l'humain
Ch = 23.45;         % N*s/m     Coefficient d'amortissement de l'humain

% Admittance
cv = 20;            % N*s/m
mv = 20;            % kg        Masse virutelle

% Imperfections
T = .1;             % s         Temps d'échantillonage

mR = 50;            % kg        Masse des moteurs
MR = 500;           % kg        Masse de la charge
CR = 100;           % N*s/m     Coefficient de frottement du système
Cb = 40;            % N*s/m     Coefficient d'amortissement des courroies
Kb = 40000;         % N/m       Constante de raideur des courroies


[A, B, C, D] = calcIAD(Kb, Cb, CR, mR, MR);
ec_max = 1e-3;      % Écart-type limite avant vibrations



function [A, B, C, D] = calcIAD(K, C1, C2, m, M)
    mK = K / m;
    mC = C1 / m;
    MK = K / M;

    A = [
         0      0       1       0;
         0      0       0       1;
        -mK     mK      -mC     mC;
         MK     -MK     C1/M    -(C1+C2)/M
        ];

    B = [
         0;
         0;
         1/m;
         0
        ];

    C = [
         0      1       0       0;
         0      0       1       0;
        ];

    D = zeros(2, 1);
end
