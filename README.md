# Mastermind - bash
2024  

## Description  
Ce script Bash implémente une version du jeu *Mastermind*, où les joueurs doivent deviner une séquence secrète de chiffres. Le jeu propose trois modes : solo, versus (2 joueurs) et multijoueur (N joueurs). 

## Fonctionnalités  
- **Modes de jeu variés** :  
  - **Solo** : Devinez un code généré aléatoirement.  
  - **Versus** : Deux joueurs s'affrontent en cachant mutuellement leur code.  
  - **Multijoueur** : Plusieurs joueurs tentent de deviner le même code à tour de rôle.  
- **Personnalisation** :  
  - Choix de la difficulté (longueur du code).  
  - Nombre de tentatives limité (5 en mode solo).  
- **Feedback clair** :  
  - Indication des chiffres *bien placés* et *mal placés*.  
  - Messages de victoire/défaite.  

## Installation  
1. Téléchargez le script `mast.sh`.  
2. Rendez-le exécutable avec la commande :  
   `chmod +x mast.sh`  

## Utilisation  
1. Lancez le jeu :  
   `./mast.sh`  

2. Choisissez un mode :  
   - `0` pour le mode solo.  
   - `1` pour le mode versus.  
   - Un entier `N > 1` pour le mode multijoueur (N joueurs).  

3. Sélectionnez la difficulté :  
   Entrez la longueur du code souhaitée (ex: `4` pour un code à 4 chiffres).  

### Exemple de partie (mode solo)  
- Le code secret est généré (ex: `1234`).  
- Entrez une séquence de même longueur (ex: `1324`).  
- Recevez un feedback : *"bien placé: 1 | mal placé: 2"*.  
- Répétez jusqu'à trouver le code ou épuiser les tentatives.  

### Mode Versus  
- Les joueurs saisissent alternativement leur code secret.  
- À chaque tour, le joueur actuel tente de deviner le code de l'adversaire.  
- La partie continue jusqu'à ce qu'un joueur devine correctement.  

### Mode Multijoueur  
- Tous les joueurs tentent de deviner le même code secret.  
- Le premier à trouver le code gagne.  

## Licence  
Ce projet est distribué sous licence [MIT](https://fr.wikipedia.org/wiki/Licence_MIT).  

## Auteurs  
- **Louis de Domingo**  
