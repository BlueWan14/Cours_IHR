clear;
clc;

%Temps de simulation
sim_time = 200;     % s
% Taille de la memoire tampon de l'observateur
buffer_size = 128;

% Bloc "Modele humain" ================================
Kh = 550;           % N/m
Ch = 23.45;         % N*s/m

% Admittance ==========================================
cv = 20;            % N*s/m
mv = 20;            % kg

% Imperfections =======================================
T = .1;             % s

% Mecanisme ===========================================
mR = 50;            % kg
MR = 500;           % kg
CR = 100;           % N*s/m
Cb = 40;            % N*s/m
Kb = 40000;         % N/m
[A, B, C, D] = calcIAD(Kb, Cb, CR, mR, MR);

% Observateur =========================================
% Ecart-type limite avant vibrations
ec_max = 1e-3;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parametres :                                        %
%   - K : ici Kb                                      %
%   - C1 : ici Cb                                     %
%   - C2 : ici CR                                     %
%   - m : ici mR                                      %
%   - M : ici MR                                      %
% Sortie :                                            %
%   - A : la matrice d'etat                           %
%   - B : la matrice de commande                      %
%   - C : la matrice d'observation                    %
%   - D : la matrice d'action directe                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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