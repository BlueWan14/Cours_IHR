#= 
Title: 1.4-PlotStats
Authors: Erwan MAWART 
Date: 28/10/2024
Status: DONE 
Description:
Ce script analyse un signal en utilisant des métriques statistiques pour segmenter et classer les phases de mouvement humain et de vibrations. 
Il génère un graphique 3D montrant les statistiques calculées (kurtosis, RMS, énergie) pour chaque segment et applique des seuils pour catégoriser le signal. 
La fonction `plotIndice` est utilisée pour visualiser la catégorisation dans le temps.
=#

# Inclusion des fonctions utilitaires
include("devoir1_lib.jl")

# Paramètres de fréquence et de segmentation
fs = 500         # Fréquence d'échantillonnage (Hz)
seg_l = 128      # Longueur de la fenêtre de segmentation pour l'analyse statistique

# Initialisation du signal et segmentation
# La fonction `init` retourne les indices de fin des segments (parts_end), le vecteur temps (t) et le signal de déplacement (signal).
parts_end, t, signal = init(fs, [35.4, 57, 70])

# Fonctions statistiques utilisées pour l'analyse des segments
# - `kurtosis` : Mesure de la pointe (peakedness) de la distribution.
# - `rms` : Valeur quadratique moyenne, indiquant l'amplitude moyenne.
# - `energy` : Quantité d'énergie du signal sur une fenêtre donnée.
fct = [kurtosis, rms, (x -> energy(x, fs=fs))]

# Fonctions statistiques spécifiques pour l'analyse des vibrations
# - `std` : Écart-type, indiquant la dispersion.
# - `energy` et `kurtosis` sont également utilisés pour les vibrations.
fctVib = [std, (x -> energy(x, fs=fs)), kurtosis]

# Visualisation 3D des statistiques pour chaque segment du signal
# Chaque segment est coloré différemment : jaune, vert, bleu (par défaut), et rouge.
p1 = plot_stats3D(fct, signal[1:parts_end[1]], seg_l, p_color=:yellow)
plot_stats3D!(fct, signal[parts_end[1]:parts_end[2]], seg_l, p_color=:green)
plot_stats3D!(fct, signal[parts_end[2]:parts_end[3]], seg_l)
plot_stats3D!(fct, signal[parts_end[3]:end], seg_l, p_title="Variable statistics", p_color=:red)
plot!(camera = (-60, 30))
xaxis!("Kurtosis")
yaxis!("RMS")
zaxis!("Energie")
display(plot!(size = (600, 600)))

# Définition des seuils de classification pour le signal humain
# Chaque fonction est associée à une condition supérieure ou inférieure pour définir les caractéristiques du signal humain.
human = Dict(
    fct[1] => Dict(:supperiorTo => 13.0),    # Kurtosis supérieur à 13.0
    fct[2] => Dict(:inferiorTo  => 0.001),   # RMS inférieur à 0.001
    fct[3] => Dict(:inferiorTo  => 4.8e-4)   # Énergie inférieure à 4.8e-4
)

# Définition des seuils de classification pour les vibrations
# Chaque fonction est associée à une condition supérieure pour identifier les caractéristiques des vibrations.
vibration = Dict(
    fct[1] => Dict(:supperiorTo => 1.0),     # Kurtosis supérieur à 1.0
    fct[2] => Dict(:supperiorTo => 0.4),     # RMS supérieur à 0.4
    fct[3] => Dict(:supperiorTo => 4.48e-3)  # Énergie supérieur à 4.48e-3
)

# Catégorisation du signal en fonction des seuils définis
# `isOutOfRange` applique les seuils aux segments et génère un tableau de catégorisation.
# - Les segments correspondant au signal humain reçoivent une valeur de 1.
# - Les segments correspondant aux vibrations reçoivent une valeur de 2.
cat_sig_temp = isOutOfRange(human, signal, seg_l) .+ 2 .* isOutOfRange(vibration, signal, seg_l)

# Visualisation de l'indice de catégorisation sur le temps
# `plotIndice` affiche la catégorisation des segments du signal dans le temps.
plotIndice(cat_sig_temp; t_max=t[end])
