#= 
Title: 1.1-OccupiedBandWidth
Authors: Erwan MAWART 
Date: 28/10/2024
Status: DONE 
Description:
Ce script analyse un signal de déplacement dans le temps, représentant différentes phases de mouvement et de vibrations dans un système humain-robot. 
Le signal est segmenté en trois parties : mouvement humain sans vibrations, vibrations sans mouvement humain, et mouvement humain avec vibrations.
Chaque segment est affiché avec une couleur différente pour une meilleure visualisation. 
Une analyse de la bande passante (occupied bandwidth) est effectuée pour chaque segment en utilisant la fonction `obw`.
=#

# Inclusion des fonctions utilitaires
include("devoir1_lib.jl")

# Fréquence d'échantillonnage du signal
fs = 500  # Hz

# Initialisation du signal et segmentation en trois parties
# La fonction `init` renvoie les indices de fin des segments (parts_end),
# le vecteur temps (t) et le signal de déplacement (signal).
parts_end, t, signal = init(fs, [35.4, 57, 70])

# Plot du signal temporel avec segmentation par couleur
# Segment 1 : Mouvement humain sans vibrations (en jaune)
plot(t[begin:parts_end[1]], signal[begin:parts_end[1]], label=false, color=:yellow)

# Segment 2 : Vibrations sans mouvement humain (en vert)
plot!(t[parts_end[1]:parts_end[2]], signal[parts_end[1]:parts_end[2]], label=false, color=:green)

# Segment 3 : Mouvement humain avec vibrations (en bleu)
plot!(t[parts_end[2]:parts_end[3]], signal[parts_end[2]:parts_end[3]], label=false, color=:blue)

# Segment 4 : Fin du signal (en rouge)
plot!(t[parts_end[3]:end], signal[parts_end[3]:end], label=false, color=:red)

# Configuration de l'affichage des limites de l'axe des x et ajout du titre de l'axe
xlims!(0, t[end])
xaxis!("Temps (s)")
display(yaxis!("Déplacement (m)"))

# Analyse de la bande passante pour chaque segment avec `obw` (Occupied Bandwidth)
# Cette fonction calcule la bande de fréquences occupée pour chaque segment du signal

# Bande passante pour le segment 1 (Mouvements Humain sans Vibrations)
obw(signal[begin:parts_end[1]], fs; t=t[begin:parts_end[1]], p_title="Mouvements Humain sans Vibrations", p_color=:yellow)

# Bande passante pour le segment 2 (Vibrations sans mouvements Humain)
obw(signal[parts_end[1]:parts_end[2]], fs; t=t[parts_end[1]:parts_end[2]], p_title="Vibrations sans mouvements Humain", p_color=:green)

# Bande passante pour le segment 3 (Mouvements Humain avec Vibrations)
obw(signal[parts_end[3]:end], fs; t=t[parts_end[3]:end], p_title="Mouvements Humain avec Vibrations", p_color=:red)
