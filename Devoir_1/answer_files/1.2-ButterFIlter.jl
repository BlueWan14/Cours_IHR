#= 
Title: 1.2-ButterFilter
Authors: Erwan MAWART 
Date: 28/10/2024
Status: DONE 
Description:
Ce script utilise des filtres passe-haut, passe-bas, 
et passe-bande pour analyser les composantes fréquentielles d'un signal en éliminant successivement les valeurs DC (0 Hz), 
le bruit des capteurs, et les mouvements humains. 
La fonction `Butteranalyse` est utilisée pour appliquer différents filtres Butterworth et visualiser les résultats. 
Plusieurs ordres de filtres sont également testés pour observer leur effet sur le signal.
=#

# Inclusion des fonctions utilitaires
include("devoir1_lib.jl")

# Paramètres de fréquence
fs = 500         # Fréquence d'échantillonnage (Hz)
fc_0Hz = 0.1     # Fréquence de coupure pour supprimer le 0 Hz (biais DC)
fc_human = 6     # Fréquence de coupure pour isoler le signal humain
fc_vib = 24.1    # Fréquence de coupure pour isoler les vibrations (en atténuant le bruit de capteur)

# Initialisation du signal et segmentation en trois parties
# La fonction `init` retourne les indices de fin des segments (parts_end), le vecteur temps (t) et le signal de déplacement (signal).
parts_end, t, signal = init(fs, [35.4, 57, 70])

## No 0Hz value ========================================================================
Butteranalyse(signal, fc_0Hz, fs, :highpass; p_title="Sans composante continue")

# ## No human signal ===================================================================
Butteranalyse(signal, fc_human, fs, :highpass; p_title="Sans signal humain")

## Suppression du bruit des capteurs =====================================================
# Application d'un filtre passe-bas pour atténuer le bruit de capteur en supprimant les fréquences supérieures à 24.1 Hz.
# Cela permet de conserver les mouvements et vibrations utiles tout en éliminant les hautes fréquences indésirables.
Butteranalyse(signal, fc_vib, fs, :lowpass; p_title="Sans le bruit des capteurs")

## Filtrage passe-bande pour réduire le bruit ============================================
# Application de filtres passe-bande de différents ordres pour isoler les composantes du signal.
# Chaque ordre de filtre est appliqué pour observer son impact sur la séparation des signaux humain et vibratoire.
for ord in [1, 2, 3, 5, 10]
    Butteranalyse(signal, fc_0Hz, fc2=fc_human, fs, :bandpass, order=ord; p_title="Signal humain uniquement")
    Butteranalyse(signal, fc_human, fc2=fc_vib, fs, :bandpass, order=ord; p_title="Vibrations uniquement")
end
