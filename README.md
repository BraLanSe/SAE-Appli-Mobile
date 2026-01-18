📚 BookWise – Application mobile de recommandation de livres
📌 Présentation du projet

BookWise est une application mobile développée dans le cadre de la SAÉ 5.01 – Développement avancé.
Elle a pour objectif de proposer des recommandations de livres personnalisées en fonction des goûts et des habitudes de lecture de l’utilisateur, tout en garantissant une confidentialité totale.

Contrairement à de nombreuses applications existantes, BookWise :

ne nécessite aucun compte utilisateur,

fonctionne entièrement en local,

ne collecte aucune donnée personnelle externe.

🎯 Objectifs de l’application

Aider l’utilisateur à trouver des livres adaptés à ses goûts

Proposer une expérience de lecture simple, fluide et personnalisée

Mettre en avant la confidentialité et l’autonomie de l’utilisateur

Exploiter les habitudes de lecture pour améliorer les recommandations

🚀 Fonctionnalités principales
🏠 Page de bienvenue

Affichage du logo et du slogan

Accès à l’application via un bouton de démarrage

📖 Catalogue de livres (page d’accueil)

Liste complète des livres disponibles

Barre de recherche (par titre ou auteur)

Systèmes de tri :

A → Z

Z → A

Popularité

Date d’ajout

Filtres par genres :

Romantique

Science-fiction

Policier

etc.

⭐ Page de recommandations

Suggestions personnalisées basées sur :

les livres consultés

les favoris

le temps de lecture

les genres préférés

❤️ Favoris

Ajout et suppression de livres favoris

Accès rapide aux coups de cœur de l’utilisateur

🕘 Historique de lecture

Suivi des livres consultés

Utilisé pour affiner les recommandations

📊 Statistiques de lecture

Temps total de lecture

Temps moyen par livre

Genres préférés

Nombre de livres consultés

Nombre de favoris

Livres enregistrés localement

🧠 Fonctionnement des données

Les données des livres sont stockées localement (SQLite)

Les statistiques et comportements de lecture sont calculés sur l’appareil

Aucun appel à une API externe

Aucune donnée envoyée sur Internet

🛠️ Technologies utilisées

Flutter (Dart)

SQLite (stockage local)

Provider (gestion d’état)

Git / GitHub (versioning et collaboration)

🗂️ Structure du projet
lib/
├── models/        # Modèles de données (Book, etc.)
├── providers/     # Gestion de l’état (Provider)
├── screens/       # Écrans de l’application
├── services/      # Accès aux données et logique métier
├── utils/         # Fonctions utilitaires
└── widgets/       # Widgets réutilisables


Les ressources graphiques sont stockées dans :

assets/images/

⚙️ Installation et lancement
Prérequis

Flutter installé

Android Studio ou VS Code

Un émulateur ou un appareil Android

Lancer le projet
flutter pub get
flutter run

🔍 Axes d’amélioration

Modernisation de l’interface graphique

Ajout d’un système de notifications de recommandations

Enrichissement de la base de données de livres

Optimisation de l’algorithme de recommandation

👥 Équipe – Groupe MakeMake

Tassadit Ouzia

Bradley Landim

Anouar Rouibi

Hocine Zared

Hichem Zenaini

Mohammed Essaoudi

Yacine Sellaoui

🎓 Contexte universitaire

Projet réalisé dans le cadre de la
SAÉ 5.01 – Développement avancé
Encadrante : Mme Marie-Eva Lesaunier
