#= 
Title: 2.4-Calculindice
Authors: Erwan MAWART 
Date: 28/10/2024
Status: DONE 
Description:
Ce script réalise une analyse temporelle-fréquentielle de signaux filtrés, représentant respectivement le mouvement humain et les vibrations. 
La Transformée de Fourier à court terme (STFT) est appliquée sur chaque signal pour observer la distribution fréquentielle dans le temps.
Chaque segment du signal est affiché avec une couleur différente pour faciliter l’interprétation des phases, 
et un indice est calculé pour catégoriser les phases de mouvement et de vibrations.
=#

# Inclusion de la bibliothèque contenant les fonctions d'analyse de signal
include("devoir1_lib.jl")

# Paramètres d'analyse
fs = 500                 # Fréquence d'échantillonnage (Hz)
fc_human = 3.91          # Fréquence de coupure pour le signal humain (Hz)
fc_vib = 24.1            # Fréquence de coupure pour le signal vibratoire (Hz)
seg_l = 128              # Longueur de la fenêtre pour l'analyse en segments
lim_e_human = 0.0108     # Seuil d'énergie pour détecter la présence de signal humain
lim_e_vib = 0.000438     # Seuil d'énergie pour détecter les vibrations

fs = 500
fc_human = 3.91
fc_vib = 24.1
seg_l = 128
lim_e_human = -19
lim_e_vib = -38

parts_end, t, filtered_humansignal, filtered_vibsignal = init(fs, [35.4, 57, 70]; filtered=true, fc_human=fc_human, fc_vib=fc_vib)

# Calcul de l'énergie du signal humain
# `plotEnergy` affiche l'énergie du signal humain filtré par segment.
# Le seuil d'énergie est ajouté en pointillé pour permettre la comparaison visuelle.
pE1 = plotEnergy(filtered_humansignal, seg_l;
                 ending    = Int(round(fc_vib)),
                 t_max     = t[end],
                 p_title   = "Energie signal humain"
)
plot!([t[1], t[end]], fill(lim_e_human, 2), ls=:dash, lw=2, label=false)

# Calcul de l'énergie du signal vibratoire
# `plotEnergy` affiche l'énergie du signal vibratoire filtré par segment.
# Un seuil est également ajouté pour faciliter l'interprétation visuelle des segments présentant des vibrations.
pE2 = plotEnergy(filtered_vibsignal, seg_l;
                 beginning = Int(round(fc_human)),
                 ending    = Int(round(fc_vib)),
                 t_max     = t[end],
                 p_title   = "Energie signal vibratoire"
)
plot!([t[1], t[end]], fill(lim_e_vib, 2), ls=:dash, lw=2, label=false)

# Affichage des deux graphiques d'énergie en disposition verticale
display(plot(pE1, pE2, layout=(2, 1)))

# Détection de segments humains et vibratoires selon les seuils d'énergie
# `correspondTo` génère un vecteur indiquant si chaque segment du signal humain dépasse le seuil défini (lim_e_human).
human = correspondTo(filtered_humansignal, seg_l, lim_e_human;
                     ending=Int(round(fc_human))
)

# Détection de segments vibratoires selon les seuils d'énergie
# `correspondTo` génère un vecteur pour indiquer si chaque segment du signal vibratoire dépasse le seuil (lim_e_vib).
vibration = correspondTo(filtered_vibsignal, seg_l, lim_e_vib;
                         beginning=Int(round(fc_human)), ending=Int(round(fc_vib))
)

# Catégorisation des segments de signal
# `cat_sig_freq` est un vecteur où chaque segment est codé en fonction de la présence de mouvement humain ou de vibrations.
# - 1 : Signal humain détecté
# - 2 : Vibrations détectées
# - 3 : Les deux présents simultanément
cat_sig_freq = human .+ 2 .* vibration

# Visualisation de l'indice de catégorisation du signal au cours du temps
# `plotIndice` affiche l'évolution de la catégorisation dans le temps, facilitant l'analyse de chaque phase.
plotIndice(cat_sig_freq; t_max=t[end])
