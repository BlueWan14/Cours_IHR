#= 
Title: 2.1-STFT
Authors: Erwan MAWART 
Documentation: Benjamin PELLIEUx 
Date: 28/10/2024
Status: DONE 
Description:
Ce script effectue une analyse temporelle-fréquentielle d'un signal non filtré en utilisant la Transformée de Fourier à court terme (STFT). 
Le signal est segmenté en différentes phases et affiché avec des couleurs distinctes pour faciliter l'interprétation. 
La STFT permet d'observer la distribution des fréquences dans le temps, utile pour analyser les dynamiques du signal, 
comme les vibrations et les mouvements humains.
=#

# Inclusion des fonctions utilitaires
include("devoir1_lib.jl")

# Paramètres de fréquence et de segmentation
fs = 500         # Fréquence d'échantillonnage (Hz)
seg_l = 128      # Longueur de la fenêtre pour la STFT

# Initialisation du signal et segmentation
# La fonction `init` retourne les indices de fin des segments (parts_end), le vecteur temps (t), et le signal brut (signal).
parts_end, t, signal = init(fs, [35.4, 57, 70])

# Calcul et affichage de la STFT (Transformée de Fourier à court terme)
# La fonction `plotSFTF` affiche la STFT du signal non filtré, segmenté par couleurs pour chaque phase définie.
# - `signal` : Signal à analyser.
# - `t` : Vecteur de temps correspondant au signal.
# - `fs` : Fréquence d'échantillonnage du signal.
# - `seg_l` : Taille de la fenêtre pour la STFT.
# - `segment` : Indices de fin des segments, permettant de colorer chaque phase du signal différemment.
# - `p_colors` : Liste des couleurs à utiliser pour chaque segment.
# - `p_title` : Titre du graphique de la STFT.
plotSFTF(signal, t, fs, seg_l;
         segment    = parts_end,
         p_colors   = [:yellow, :green, :blue, :red],
         p_title    = "STFT du signal non filtré"
)
