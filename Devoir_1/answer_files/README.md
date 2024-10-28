# Projet d'Analyse des Signaux pour l'Interaction Humain-Robot

## Auteurs
- **Erwan MAWART**
- **Date** : 28/10/2024

## Description
Ce projet réalise une analyse temporelle-fréquentielle de signaux enregistrés lors d'une interaction humain-robot. Les scripts permettent de filtrer, segmenter et analyser statistiquement des signaux représentant les dynamiques humaines et vibratoires.

Le projet est structuré en plusieurs fichiers principaux :
- **`install.jl`** : Installe automatiquement les bibliothèques nécessaires.
- **`devoir1_lib.jl`** : Contient toutes les fonctions d'analyse et de visualisation utilisées pour le traitement des signaux.
- **Scripts d'analyse** : Différents scripts exploitent la bibliothèque `devoir1_lib.jl` pour effectuer les analyses demandées.

## Prérequis
- **Julia** : Version 1.6 ou supérieure.
- **Fichier de données** : Le projet utilise un fichier `.mat` nommé `poignee1ddl_4.mat`, contenant les signaux à analyser.

## Installation des bibliothèques
Avant de lancer les scripts d’analyse, il est important d'installer toutes les dépendances nécessaires. Cela peut être fait en exécutant `install.jl`.

### Étapes pour exécuter `install.jl`
1. Ouvrez un terminal ou une console Julia.
2. Naviguez jusqu’au répertoire du projet.
3. Exécutez la commande suivante :
   ```julia
   julia install.jl
   ```
   Ce script vérifiera si les bibliothèques nécessaires sont installées. Si elles ne le sont pas, elles seront téléchargées et installées automatiquement.

## Utilisation des scripts d'analyse
Une fois les bibliothèques installées, vous pouvez utiliser les différents scripts d'analyse. Voici un exemple de flux de travail :

1. **Importer la bibliothèque `devoir1_lib.jl`** :
   Inclure la bibliothèque dans le script principal pour accéder aux fonctions d’analyse des signaux.

   ```julia
   include("devoir1_lib.jl")
   ```

2. **Chargement et segmentation du signal** :
   Utilisez la fonction `init` pour charger et segmenter le signal selon les paramètres de fréquence d’échantillonnage et de filtre souhaités. Exemple :
   ```julia
   parts_end, t, filtered_humansignal, filtered_vibsignal = init(500, [35.4, 57, 70]; filtered=true, fc_human=3.91, fc_vib=24.1)
   ```

3. **Analyse temporelle-fréquentielle** :
   Exécutez la fonction `plotSFTF` pour visualiser la Transformée de Fourier à court terme du signal humain ou vibratoire :
   ```julia
   plotSFTF(filtered_humansignal, t, 500; segment=parts_end, p_colors=[:yellow, :green, :blue, :red], p_title="STFT du signal humain")
   ```

4. **Génération de statistiques** :
   Pour analyser les caractéristiques statistiques des segments, utilisez `printStatisticTab` pour afficher un tableau des statistiques :
   ```julia
   printStatisticTab(filtered_humansignal, parts_end; p_title="Statistiques du signal humain", fs=500)
   ```

5. **Visualisation** :
   Pour visualiser des analyses 3D ou afficher les bandes passantes, exploitez les fonctions `plot_stats3D` ou `obw`.

## Arborescence des fichiers
- `install.jl` : Script d'installation des bibliothèques.
- `devoir1_lib.jl` : Bibliothèque principale contenant les fonctions de traitement de signal.
- `poignee1ddl_4.mat` : Fichier de données `.mat` contenant les signaux à analyser.
- `README.md` : Guide d'utilisation du projet.

## Notes supplémentaires
- **Dépendances** : Assurez-vous que le fichier `poignee1ddl_4.mat` est présent dans le même répertoire que les scripts.
- **Personnalisation** : Les paramètres de fréquence d’échantillonnage et de coupure peuvent être modifiés dans les appels de fonction selon vos besoins.

## Support
Pour toute question ou problème, veuillez contacter l'auteur du projet.

---

Ce projet permet de réaliser des analyses précises des signaux pour l'interaction humain-robot en combinant segmentation, filtrage, et statistiques avancées. Assurez-vous que toutes les étapes sont suivies pour obtenir les meilleurs résultats.
```