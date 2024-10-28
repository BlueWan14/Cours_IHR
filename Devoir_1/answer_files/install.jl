#= 
Title: Script d'installation des bibliothèques
Authors: Erwan MAWART 
Date: 28/10/2024
Status: DONE 
Description:
Ce script vérifie et installe les bibliothèques nécessaires pour l'exécution du projet. 
Il utilise le package manager de Julia (Pkg) pour installer les dépendances si elles ne sont pas déjà présentes sur le système. 
Cette automatisation garantit que toutes les bibliothèques requises sont disponibles avant d'exécuter le code principal.
=#

using Pkg

# Liste des bibliothèques nécessaires au projet
Pkg_tab = ["MAT",                 # Pour manipuler des fichiers .mat (MATLAB)
           "Plots",               # Pour la création de graphiques
           "StatsPlots",          # Pour les graphiques statistiques
           "PrettyTables",        # Pour l'affichage de tables de données
           "SignalAnalysis",      # Pour les analyses de signal
           "DSP",                 # Pour le traitement du signal numérique
           "ControlSystemsBase",  # Pour les systèmes de contrôle
           "Distributions"        # Pour la manipulation de distributions statistiques
]

# Boucle pour vérifier et installer chaque package si nécessaire
for name in Pkg_tab
    if !in(name, keys(Pkg.installed()))
        Pkg.add(name)  # Installation du package si non présent
    end
end
