#=
Title: 2.2-FreqFilter 
Authors: Erwan MAWART 
Date: 28/10/2024
Status: DONE 
Description:
Ce script effectue une analyse temporelle-fréquentielle de deux signaux filtrés représentant respectivement le mouvement humain et les vibrations. 
La Transformée de Fourier à court terme (STFT) est appliquée sur chaque signal filtré pour observer la distribution des fréquences dans le temps. 
Chaque segment du signal est affiché avec une couleur différente pour faciliter l'interprétation des phases. 
Les deux STFT sont ensuite affichées côte à côte pour comparaison.
=#

# Inclusion des fonctions utilitaires
include("devoir1_lib.jl")

# Paramètres de fréquence et de segmentation
fs = 500         # Fréquence d'échantillonnage (Hz)
fc_human = 3.91  # Fréquence de coupure pour le signal humain (Hz)
fc_vib = 24.1    # Fréquence de coupure pour le signal vibratoire (Hz)
seg_l = 128      # Longueur de la fenêtre pour la STFT

# Initialisation des signaux filtrés et segmentation
# La fonction `init` retourne les indices de fin des segments (parts_end), le vecteur temps (t),
# le signal humain filtré (filtered_humansignal), et le signal vibratoire filtré (filtered_vibsignal).
# Les filtres sont appliqués à l'initialisation pour isoler les fréquences spécifiques aux mouvements humains et aux vibrations.
parts_end, t, filtered_humansignal, filtered_vibsignal = init(fs, [35.4, 57, 70]; filtered=true, fc_human=fc_human, fc_vib=fc_vib)

# Analyse STFT pour le signal humain filtré
# La fonction `plotSFTF` calcule et affiche la STFT du signal humain filtré.
# - `filtered_humansignal` : Signal humain filtré à analyser.
# - `t` : Vecteur de temps correspondant au signal.
# - `fs` : Fréquence d'échantillonnage du signal.
# - `seg_l` : Taille de la fenêtre pour la STFT.
# - `segment` : Indices de fin des segments, permettant de colorer chaque phase différemment.
# - `p_colors` : Couleurs pour chaque segment du signal.
# - `p_title` : Titre du graphique de la STFT pour le signal humain.
htm1 = plotSFTF(filtered_humansignal, t, fs, seg_l;
                segment    = parts_end,
                p_colors   = [:yellow, :green, :blue, :red],
                p_title    = "STFT du signal humain"
)

# Analyse STFT pour le signal vibratoire filtré
# La fonction `plotSFTF` est appliquée ici pour afficher la STFT du signal vibratoire filtré.
# - `filtered_vibsignal` : Signal vibratoire filtré à analyser.
# - Les autres paramètres sont similaires à ceux utilisés pour `filtered_humansignal`.
htm2 = plotSFTF(filtered_vibsignal, t, fs, seg_l;
                segment    = parts_end,
                p_colors   = [:yellow, :green, :blue, :red],
                p_title    = "STFT du signal vibratoire"
)

# Affichage des deux graphiques STFT côte à côte pour comparaison
# `plot(htm1, htm2, ...)` permet d'afficher les STFT du signal humain et vibratoire l'une à côté de l'autre.
# Cela facilite la comparaison des caractéristiques fréquentielles des deux signaux.
plot(htm1, htm2, size=(900, 500), left_margin=5mm, right_margin=5mm, top_margin=0mm, bottom_margin=5mm)
