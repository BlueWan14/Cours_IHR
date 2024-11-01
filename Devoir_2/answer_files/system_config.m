clear;
clc;

%Temps de simulation
sim_time = 10;  % s


% Modèle humain
Kh = 550;       % N/m
Ch = 23.45;     % N*s/m

% Admittance
c = 20;         % N*s/m
m = 50;         % kg

% Imperfections
T = 0.1;        % s

% Gain
Kp = 10000;

%MR = 500;       % kg
%CR = 100;       % N*s/m
%Kb = 40000;     % N/m
%Cb = 40;        % N*s/m 


Kh_min = Kh/2;
Kh_max = Kh*2;
