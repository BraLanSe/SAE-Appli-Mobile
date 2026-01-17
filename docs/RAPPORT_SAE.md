# Rapport de Projet - BookWise (SAÉ 5.Real.01)

## 1. Contexte & Objectifs

**BookWise** est une application mobile de recommandation de livres conçue pour aider les lecteurs à découvrir leur prochaine lecture coup de cœur.  
Développée en **Flutter**, elle répond à la problématique de la "paralysie du choix" face à la masse de livres disponibles, en proposant une expérience adaptative et personnalisée.

L'objectif principal est de fournir une interface fluide, esthétique ("Premium") et fonctionnelle, capable de s'adapter aux goûts de l'utilisateur.

## 2. Stratégie UX/UI

### Personas
*   **Camille (22 ans, Étudiante)** : Lit beaucoup mais a un budget limité. Cherche des avis fiables et des recommandations précises pour ne pas perdre de temps.
*   **Marc (45 ans, Cadre)** : Lit occasionnellement (vacances). Veut une app simple qui lui dit "quoi lire" sans configuration complexe.

### Identité Visuelle
*   **Slogan** : "Votre boussole littéraire".
*   **Typographie** : *Playfair Display* pour les titres (élégance, classique) et *Roboto* pour le corps (lisibilité).
*   **Palette** :
    *   *Violet Profond* (Primary) : Évoque l'imaginaire et le mystère.
    *   *Dark Mode* : Soigné pour une lecture nocturne confortable (contraste AA respecté).

### Parcours Utilisateur (User Journey)
1.  **Onboarding** : Découverte de la valeur ajoutée (3 slides).
2.  **Accueil** : Salutation personnalisée + "Livre du moment".
3.  **Discovery** : Navigation par tags rapides ou recherche avancée (Explorer).
4.  **Action** : Lecture des détails, ajout aux favoris/historique.
5.  **Re-engagement** : L'algorithme affine les suggestions sur l'accueil.

## 3. Architecture Technique

### Choix de la Stack
*   **Framework** : Flutter (Cross-platform, Hot Reload, UI native haute performance).
*   **Langage** : Dart (Null safety, Typage fort).
*   **Architecture** : MVVM (Model-View-ViewModel) via le pattern **Provider**.

### Gestion d'État (State Management)
Utilisation du package `provider` pour une injection de dépendance légère et réactive.
*   `HistoryProvider` : Gère la liste des lectures.
*   `FavoritesProvider` : Gère les favoris (persistance simulée/disque).
*   `FilterProvider` : Synchronise les filtres entre l'Accueil et l'Explorateur.

### Algorithme de Recommandation (`RecommendationEngine`)
Un moteur de recommandation "zéro-dépendance" a été implémenté en pur Dart.
*   **Scoring** :
    *   Genre présent dans Favoris : **+5 points**.
    *   Genre présent dans Historique : **+2 points**.
*   Les livres non lus sont triés par ce score de pertinence pour générer la liste "Recommandé pour vous".

### Persistance
*   `shared_preferences` : Pour sauvegarder si l'utilisateur a déjà vu l'Onboarding.
*   (Prévu) `sqflite` : Pour une persistance locale robuste des livres (si passage hors-ligne complet).

## 4. Modèle Économique (Business Model)

L'application suit un modèle **Freemium** :
1.  **Gratuit** :
    *   Accès illimité au catalogue.
    *   Recommandations de base.
    *   Publicité discrète dans les listes.
2.  **Premium (BookWise+) - 2.99€/mois** :
    *   Statistiques de lecture avancées (graphiques, temps de lecture).
    *   Badge "Grand Lecteur".
    *   Suppression des publicités.
    *   Mode "Lecture hors-ligne" (sauvegarde des fiches).

## 5. Conclusion & Perspectives

Le projet BookWise remplit les objectifs de la SAÉ en fournissant une application complète, documentée et évolutive.
**Améliorations futures possibles** :
*   Intégration d'une vraie API (Google Books API).
*   Fonctionnalités sociales (partage de listes).
*   Mode sombre automatique selon le capteur de luminosité.

---
*Développé par Mohammed pour la SAÉ BUT3.*
