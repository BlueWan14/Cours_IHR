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

fs = 500
seg_l = 128

parts_end, t, signal = init(fs, [3.7, 23.7, 24.8, 35.1, 56.5, 70.1, 96.7])

fct = [kurtosis, rms, (x -> pow2db(energy(x, fs=fs)))]

p1 = plot_stats3D(fct, signal[parts_end[1]:parts_end[4]], seg_l; p_color=:yellow)
plot_stats3D!(fct, signal[parts_end[4]:parts_end[5]], seg_l; p_color=:green)
plot_stats3D!(fct, signal[parts_end[5]:parts_end[6]], seg_l)
plot_stats3D!(fct, signal[parts_end[6]:parts_end[7]], seg_l;
              p_color = :red,
              p_alpha = .4,
              p_title = "Répartition du signal"
)
plot!(camera = (-50, 25))
xaxis!("Kurtosis")
yaxis!("RMS (m/s)")
zaxis!("Energie (dB)")
zlims!(-200, 0)
display(plot!(size = (500, 500)))

# Définition des seuils de classification pour le signal humain
# Chaque fonction est associée à une condition supérieure ou inférieure pour définir les caractéristiques du signal humain.
human = Dict(
    fct[1] => Dict(:supperiorTo => 1.0),
    fct[2] => Dict(:inferiorTo  => 0.045),
    fct[3] => Dict(:inferiorTo  => -40.0)
)

# Définition des seuils de classification pour les vibrations
# Chaque fonction est associée à une condition supérieure pour identifier les caractéristiques des vibrations.
vibration = Dict(
    fct[1] => Dict(:supperiorTo => 1.0),
    fct[2] => Dict(:supperiorTo => 0.12),
    fct[3] => Dict(:inferiorTo  => -55.0)
)

# Catégorisation du signal en fonction des seuils définis
# `isOutOfRange` applique les seuils aux segments et génère un tableau de catégorisation.
# - Les segments correspondant au signal humain reçoivent une valeur de 1.
# - Les segments correspondant aux vibrations reçoivent une valeur de 2.
cat_sig_temp = isOutOfRange(human, signal, seg_l) .+ 2 .* isOutOfRange(vibration, signal, seg_l)

display(plotIndice(cat_sig_temp; t_max=t[end]))


map!(x -> div(x, Int(seg_l/2)), parts_end, parts_end)
pushfirst!(parts_end, 1)
push!(parts_end, length(cat_sig_temp)+1)
plotConfMatrix(cat_sig_temp, parts_end, [0, 1, 0, 1, 2, 0, 3, 0])
