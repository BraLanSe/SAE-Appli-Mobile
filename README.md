# BookWise (Livrable 1)

## Présentation du projet

**BookWise** est une application Flutter permettant aux utilisateurs de découvrir des livres, consulter leurs détails, enregistrer des favoris, et recevoir des recommandations personnalisées basées sur leurs interactions.

Ce premier livrable se concentre sur :

La structure du projet Flutter qui se présente avec : 

- L’affichage de la liste de livres

- L’écran de détails d’un livre

- Le système de favoris

- La base de la page dédiée aux recommandations

- L’intégration d’un design simple et fonctionnel

### Fonctionnalités incluses dans ce livrable ###

✔️ **1. Home Screen**

Affichage des livres

- Barre de recherche (placeholder)

- Navigation vers les détails d’un livre

✔️ **2. Book Detail Screen**

- Présentation du livre (titre, auteur, description, genre…)

- Bouton Ajouter/Retirer des favoris

✔️ **3. Favoris**

- Système utilisant Provider

-Stockage temporaire en mémoire (pas encore persistant)

✔️ **4. Recommandations**

- Page dédiée

Logique de recommandation basée sur :

- Le genre du livre ouvert

- Les livres mis en favoris

(La logique est basique pour ce livrable, mais fonctionnelle.)

✔️ **5. Navigation** 

- Configuration propre avec MaterialPageRoute



📁 Architecture de l'application
```bash
lib/
 ├── models/           # Modèles (Book, User…)
 ├── screens/          # Écrans : Home, Details, Favorites, Recommendations...
 ├── providers/        # Gestion d’état (FavoritesProvider)
 ├── widgets/          # Widgets réutilisables
 ├── services/         # Logique métier (recommandations, API futur)
 └── utils/            # Styles, helpers, constantes...
```
### Installation ###

1️⃣ Cloner le projet

```bash
git clone https://github.com/BraLanSe/SAE-Appli-Mobile.git

cd bookwise
```

2️⃣ Installer les dépendances

```bash
flutter pub get
```

3️⃣ Lancer l’application

Chrome :
```bash
flutter run -d chrome
```

Android :
```bash
flutter run
```
### Gestion des assets ###

Ce livrable inclut :

- assets/images/

- assets/fonts/

Les assets doivent être déclarés dans pubspec.yaml :

assets:
  - assets/images/
  - assets/fonts/

### Technologies utilisées ###

- Flutter 3.x

- Dart

- Provider (gestion d’état)

- Material Design

### Livrable conforme aux attentes ###

Ce livrable constitue la base fonctionnelle de l’application, avec une architecture claire permettant :

- d’ajouter une base de données,

- d’intégrer une API réelle,

- d’améliorer les recommandations avec des algorithmes plus poussés,

- d’implanter un système d’authentification.


👤 Auteur

Projet réalisé par Tassadit, Bradley, Hocine, Hichem, Yacine, Mohamad, Anouar


BUT 3 INFO
