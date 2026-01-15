# BookWise (Livrable 1)
# Bookwise

Bookwise est une application mobile Flutter pour gérer, consulter et suivre vos livres préférés. Elle propose des fonctionnalités de recommandation, un historique de lecture et la gestion de favoris. L'application est multi-plateformes (Android, iOS, Web, Windows, macOS, Linux).

---

## Fonctionnalités

* **Accueil** : Page principale présentant les livres et catégories.
* **Détails d'un livre** : Informations complètes sur chaque livre.
* **Recommandations** : Suggestions basées sur les préférences de l'utilisateur.
* **Favoris** : Ajouter et consulter les livres favoris.
* **Historique** : Suivi des livres consultés ou lus.
* **Multi-plateformes** : Android, iOS, Web, Windows, macOS et Linux.
* **Gestion des assets** : Couvertures de livres et icônes.

---

## Arborescence du projet

```

├── android/         # Code et configurations Android
├── ios/             # Code et configurations iOS
├── lib/             # Code Dart principal
│   ├── models/      # Modèles de données
│   ├── providers/   # Providers pour gestion d'état
│   ├── screens/     # Écrans de l'application
│   ├── services/    # Services, par ex. recommandations
│   ├── utils/       # Fonctions utilitaires
│   └── widgets/     # Widgets réutilisables
├── assets/          # Images et autres ressources
├── web/             # Configuration et assets Web
├── windows/         # Configuration Windows
├── macos/           # Configuration macOS
├── linux/           # Configuration Linux
└── test/            # Tests unitaires et widgets
```

---

## Installation

1. **Cloner le dépôt :**

```bash
git clone https://github.com/BraLanSe/SAE-Appli-Mobile.git
cd SAE-Appli-Mobile
```

2. **Installer les dépendances Flutter :**

```bash
flutter pub get
```

3. **Exécuter l'application :**

* Sur mobile Android :

```bash
flutter run
```
4. **Pour construire une version release :**

```bash
flutter build apk       # Android
flutter build ios       # iOS
flutter build web       # Web
flutter build windows   # Windows
flutter build macos     # macOS
flutter build linux     # Linux
```

---

## Dépendances principales

* Flutter SDK
* `provider` pour la gestion d'état
* `shared_preferences` pour le stockage léger
* `fl_chart` pour les graphiques (si nécessaire)
* `google_fonts` pour les polices

---


👤 Auteur

Projet réalisé par Tassadit, Bradley, Hocine, Hichem, Yacine, Mohamad, Anouar


BUT 3 INFO
