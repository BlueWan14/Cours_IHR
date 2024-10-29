#= 
Title: 1.4-PlotStats
Authors: Erwan MAWART 
Documentation: Benjamin PELLIEUX
Status: DONE 
Description:
Ce script analyse un signal en utilisant des métriques statistiques pour segmenter et classer les phases de mouvement humain et de vibrations. 
Il génère un graphique 3D illustrant les statistiques calculées (kurtosis, RMS, énergie) pour chaque segment et applique des seuils pour classifier les segments. 
La fonction `plotIndice` est ensuite utilisée pour visualiser la catégorisation des segments dans le temps, 
et une matrice de confusion est tracée pour évaluer la précision de la classification.
=#

# Inclusion des fonctions utilitaires
include("devoir1_lib.jl")

# Paramètres de fréquence et de segmentation
fs = 500         # Fréquence d'échantillonnage (Hz)
seg_l = 128      # Longueur de la fenêtre de segmentation pour l'analyse statistique

# Initialisation et segmentation du signal
# `init` charge le signal et génère les indices de fin de segment (parts_end) en fonction des durées spécifiées.
parts_end, t, signal = init(fs, [3.7, 23.7, 24.8, 35.1, 56.5, 70.1, 96.7])

# Fonctions statistiques pour l'analyse
# - `kurtosis` : Mesure de la concentration des données autour de la moyenne.
# - `rms` : Amplitude moyenne en valeur quadratique moyenne (m/s).
# - `energy` : Énergie du signal, convertie en dB pour un meilleur contraste.
fct = [kurtosis, rms, (x -> pow2db(energy(x, fs=fs)))]

# Visualisation 3D des statistiques par segment de signal
# Chaque segment est coloré différemment pour permettre une comparaison visuelle.
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
# Les seuils sont établis pour chaque fonction statistique afin d'identifier les segments de mouvement humain.
human = Dict(
    fct[1] => Dict(:supperiorTo => 1.0),       # Kurtosis supérieur à 1.0
    fct[2] => Dict(:inferiorTo  => 0.045),     # RMS inférieur à 0.045
    fct[3] => Dict(:inferiorTo  => -40.0)      # Énergie inférieure à -40 dB
)

# Définition des seuils de classification pour les vibrations
# Les seuils sont configurés pour chaque fonction statistique afin d'identifier les segments de vibration.
vibration = Dict(
    fct[1] => Dict(:supperiorTo => 1.0),       # Kurtosis supérieur à 1.0
    fct[2] => Dict(:supperiorTo => 0.12),      # RMS supérieur à 0.12
    fct[3] => Dict(:inferiorTo  => -55.0)      # Énergie inférieure à -55 dB
)

# Catégorisation des segments de signal en fonction des seuils
# `isOutOfRange` applique les seuils définis pour chaque statistique et génère un tableau de catégorisation.
# - 1 : Signal humain détecté
# - 2 : Vibrations détectées
cat_sig_temp = isOutOfRange(human, signal, seg_l) .+ 2 .* isOutOfRange(vibration, signal, seg_l)

# Affichage de la catégorisation du signal dans le temps
# `plotIndice` visualise l'évolution des catégories de segments, facilitant ainsi l'identification des phases de mouvement humain et de vibration.
display(plotIndice(cat_sig_temp; t_max=t[end]))

# Calcul des indices de segments pour la matrice de confusion
# `map!` divise chaque index de `parts_end` par la demi-longueur du segment pour ajuster la segmentation,
# et les indices de début et de fin sont ajoutés pour couvrir tout le signal.
map!(x -> div(x, Int(seg_l/2)), parts_end, parts_end)
pushfirst!(parts_end, 1)
push!(parts_end, length(cat_sig_temp)+1)

# Affichage de la matrice de confusion pour évaluer la précision de la classification
# `plotConfMatrix` génère une matrice de confusion pour comparer la catégorisation calculée avec les valeurs réelles.
plotConfMatrix(cat_sig_temp, parts_end, [0, 1, 0, 1, 2, 0, 3, 0])
