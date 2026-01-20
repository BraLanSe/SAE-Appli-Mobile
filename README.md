# BookWise

Application mobile de recommandation de livres  
SAÉ 5.01 – Développement avancé



## Présentation du projet

BookWise est une application mobile développée dans le cadre de la SAÉ 5.01 – Développement avancé.
Elle a pour objectif de proposer des recommandations de livres personnalisées en fonction des goûts et des habitudes de lecture de l’utilisateur, tout en garantissant une confidentialité totale.

Contrairement à de nombreuses applications existantes, BookWise :

* ne nécessite aucun compte utilisateur,

* fonctionne entièrement en local,

* ne collecte aucune donnée personnelle externe.



## Objectifs

* Aider l’utilisateur à trouver des livres adaptés à ses goûts

* Proposer une expérience de lecture simple, fluide et personnalisée

* Mettre en avant la confidentialité et l’autonomie de l’utilisateur

* Exploiter les habitudes de lecture pour améliorer les recommandations



## Fonctionnalités principales
🏠 Page de bienvenue

* Affichage du logo et du slogan

* Accès à l’application via un bouton de démarrage

📖 Catalogue de livres (page d’accueil)

* Liste complète des livres disponibles

* Barre de recherche (par titre ou auteur)

* Filtres par genres :

  * Romantique

  * Science-fiction

  * Policier

etc.

⭐ Page de recommandations

* Suggestions personnalisées basées sur :

  * les livres que tu as favoris
 
  * les livres que tu as lus (historique)

  * les genres que tu aimes

  * les auteurs que tu préfères

  * les mots-clés dans les descriptions

❤️ Favoris

* Ajout et suppression de livres favoris

* Accès rapide aux coups de cœur de l’utilisateur

🕘 Historique de lecture

* Suivi des livres consultés

* Utilisé pour affiner les recommandations

📊 Statistiques de lecture

* Montre combien de livres tu as consultés

* Montre combien de livres tu as mis en favoris

* Montre le temps total que tu as passé à lire

* Montre le temps moyen de lecture par livre

* Indique ton genre préféré

* Montre le total de livres que tu as explorés

* Affiche les genres que tu as lus

* Affiche un top 3 des genres avec le nombre de livres



## Structure du projet
```
lib/
├── models/        # Modèles de données (Book, etc.)
├── providers/     # Gestion de l’état (Provider)
├── screens/       # Écrans de l’application
├── services/      # Accès aux données et logique métier
├── utils/         # Fonctions utilitaires
└── widgets/       # Widgets réutilisables

```

## Technologies utilisées

* Flutter (Dart)

* SQLite (stockage local)

* Provider (gestion d’état)

* Git / GitHub



## Installation et exécution

Prérequis

* Flutter installé

* Android Studio ou VS Code

* Émulateur ou appareil Android



## Lancer le projet

* flutter pub get
* flutter run



## Axes d’amélioration

* Amélioration de l’interface graphique

* Ajout de notifications de recommandations

* Enrichissement de la base de données de livres



## Équipe

Groupe MakeMake :

* Tassadit Ouzia

* Bradley Landim

* Anouar Rouibi

* Hocine Zared

* Hichem Zenaini

* Mohammed Essaoudi

* Yacine Sellaoui


## Contexte universitaire

Projet réalisé dans le cadre de la
SAÉ 5.01 – Développement avancé



