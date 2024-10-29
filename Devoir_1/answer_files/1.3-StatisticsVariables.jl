#= 
Title: 1.3-statisticsVariables
Authors: Erwan MAWART
Documentation: Benjamin PELLIEUx  
Date: 28/10/2024
Status: DONE 
Description:
Ce script analyse statistiquement deux signaux filtrés représentant le mouvement humain et les vibrations. 
Les signaux sont segmentés, et un tableau de statistiques (RMS, énergie, kurtosis, etc.) est généré pour chaque segment. 
Les filtres sont appliqués pour isoler les composantes spécifiques au signal humain et au signal vibratoire, 
facilitant ainsi l'analyse des caractéristiques dynamiques de chaque phase.
=#

# Inclusion des fonctions utilitaires
include("devoir1_lib.jl")

# Paramètres de fréquence
fs = 500         # Fréquence d'échantillonnage (Hz)
fc_human = 3.91  # Fréquence de coupure pour le signal humain (Hz)
fc_vib = 24.1    # Fréquence de coupure pour le signal vibratoire (Hz)
seg_l = 128      # Longueur de la fenêtre pour l’analyse segmentée (si applicable dans printStatisticTab)

# Initialisation du signal filtré et segmentation en trois parties
# La fonction `init` retourne les indices de fin des segments (parts_end), le vecteur temps (t),
# le signal filtré pour le mouvement humain (filtered_humansignal), et le signal filtré pour les vibrations (filtered_vibsignal).
# Les filtres sont appliqués à l'initialisation avec les fréquences de coupure définies.
parts_end, t, filtered_humansignal, filtered_vibsignal = init(fs, [35.4, 57, 70]; filtered=true, fc_human=fc_human, fc_vib=fc_vib)

# Affichage des statistiques pour le signal humain filtré
# `printStatisticTab` génère un tableau de statistiques (RMS, énergie, kurtosis, skewness, etc.)
# pour chaque segment du signal humain, fournissant une analyse détaillée de ses caractéristiques.
printStatisticTab(filtered_humansignal, parts_end; p_title="Statistique du signal Humain", fs=fs)

# Affichage des statistiques pour le signal vibratoire filtré
# `printStatisticTab` génère un tableau de statistiques pour chaque segment du signal vibratoire.
# Cette analyse statistique est utile pour caractériser les vibrations et leur distribution fréquentielle.
printStatisticTab(filtered_vibsignal, parts_end; p_title="Statistique du signal vibratoire", fs=fs)
