# 📚 BookWise

> **Application mobile de recommandation de livres**


## Présentation

**BookWise** est une application mobile développée en Flutter. Son objectif principal est d'offrir des recommandations de livres personnalisées basées sur les goûts et habitudes de lecture de l'utilisateur.

* ❌ **Aucun compte utilisateur** n'est nécessaire.
* 🔒 Fonctionne **entièrement en local**.

##  Fonctionnalités Principales

* **Catalogue complet :** Accès à une large bibliothèque de livres.
* **Recherche avancée :** Recherche par titre ou par auteur.
* **Filtrage intelligent :** Tri des livres par genres (Romantique, Science-fiction, Policier, etc.).

###  Moteur de Recommandation
Suggestions sur mesure calculées localement en fonction de :
* Vos **favoris**.
* Votre **historique** de lecture.
* Vos **auteurs et genres** préférés.
* L'analyse des **mots-clés** descriptifs.

###  Statistiques de Lecture (Dashboard)
Suivez vos habitudes avec précision :
* Nombre total de livres consultés et explorés.
* Nombre de livres en favoris.
* Temps total passé à lire.
* Temps moyen de lecture par livre.
* Classement de vos genres préférés.

---

##  Stack Technique

| Catégorie | Technologie | Rôle / Usage |
| :--- | :--- | :--- |
| **Framework Mobile** | ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white) | Développement de l'interface utilisateur multiplateforme (Dart). |
| **Langage** | ![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white) | Logique métier et algorithmes de recommandation. |
| **Gestion d'état** | **Provider** | Gestion réactive des données (favoris, historique, thème). |
| **Base de données** | **SQLite** | Stockage local et persistant des données (sans serveur). |


---

##  Structure du Projet

```text
lib/
├── models/          # Définition des modèles de données (Book, Review, etc.)
├── providers/       # Gestionnaires d'état (Logique de l'application)
├── screens/         # Les différentes interfaces (Vues)
├── services/        # Logique métier et algorithmes
└── widgets/         # Composants graphiques réutilisables (BookCard, etc.)
```
## Installation et Lancement

Suivez ces étapes pour exécuter le projet sur votre machine locale.

### Prérequis
* [Flutter SDK](https://docs.flutter.dev/get-started/install) installé .
* Un émulateur Android/iOS ou un appareil physique connecté.

### Étapes

1.  **Récupérer le projet :**
    ```bash
    # Clonez ce dépôt 
    git clone https://github.com/BraLanSe/SAE-Appli-Mobile.git
    cd SAE-Appli-Mobile
    ```

2.  **Installer les dépendances :**
    ```bash
    flutter pub get
    ```

3.  **Lancer l'application :**
    ```bash
    flutter run
    ```
    ---
*Ce projet a été réalisé dans le cadre de la SAÉ BUT3 INFO : Tassadit Ouzia, Bradley Landim, Anouar Rouibi, Hocine Zared, Hichem Zenaini, Mohammed Essaoudi et Yacine Sellaoui.*
