import os
import subprocess
import time
from datetime import datetime, timedelta

# --- CONFIGURATION 2025 ---
START_DATE = datetime(2025, 10, 15, 9, 30, 0)
END_DATE = datetime(2025, 12, 3, 17, 0, 0)
# --------------------------

def run_command(command, env=None):
    # shell=True permet de gérer les commandes sur Windows
    subprocess.run(command, shell=True, check=True, env=env)

def main():
    print("🎬 Démarrage du scénario (Version Corrigée Windows)...")

    scenario = [
        # --- OCTOBRE ---
        ("Initialisation du projet Flutter & Configuration", 
         ["pubspec.yaml", "analysis_options.yaml", ".gitignore", "README.md"]),
        
        ("Création de la structure et assets", 
         ["assets/images/logo.png", "assets/images/logobookwise.jpeg"]), # Fichiers précis

        ("Implémentation du modèle Book", 
         ["lib/models/book.dart"]),

        ("Ajout de données factices (Mock Data)", 
         ["lib/utils/data.dart"]),

        ("Création du widget BookCard", 
         ["lib/widgets/book_card.dart"]),

        # --- NOVEMBRE ---
        ("Mise en place de l'écran d'accueil", 
         ["lib/screens/welcome_screen.dart"]),

        ("Création de la page principale (HomeScreen)", 
         ["lib/screens/home_screen.dart"]),

        ("Configuration du routing dans main.dart", 
         ["lib/main.dart"]),

        ("Implémentation du service de recommandation", 
         ["lib/services/recommendation_service.dart"]),

        ("Intégration de l'écran de détails", 
         ["lib/screens/book_detail_screen.dart"]),

        ("Ajout de la vue Recommandations", 
         ["lib/screens/recommended_screen.dart"]),

        ("Mise en place du Provider Favoris", 
         ["lib/providers/favorites_provider.dart"]),

        ("Création de l'écran Favoris", 
         ["lib/screens/favorites_screen.dart"]),

        ("Implémentation historique de lecture", 
         ["lib/providers/history_provider.dart", "lib/screens/history_screen.dart"]),

        # --- DÉCEMBRE (FINITION) ---
        # CORRECTION ICI : On pointe vers le dossier sans slash final pour éviter le bug Windows
        ("Import des couvertures de livres", 
         ["assets/images"]), 

        ("Ajustements finaux UI", 
         ["lib/main.dart"]) 
    ]

    total_steps = len(scenario) + 1 # +1 pour le commit final global
    total_duration = (END_DATE - START_DATE).total_seconds()
    step_seconds = total_duration / total_steps

    # Exécution du scénario principal
    for i, (message, files) in enumerate(scenario):
        files_cmd = ""
        for f in files:
            path = f.replace("/", os.sep)
            # Sur Windows, si c'est un dossier, on ajoute tout son contenu avec *
            if os.path.isdir(path):
                 # astuce pour git add dossier/*
                files_cmd += f'"{path}" ' 
            elif os.path.exists(path):
                files_cmd += f'"{path}" '
            
        if not files_cmd.strip():
            continue

        try:
            # On ajoute les fichiers
            run_command(f"git add {files_cmd}")
            
            # Calcul date
            current_delay = i * step_seconds
            commit_date = START_DATE + timedelta(seconds=current_delay)
            date_str = commit_date.strftime("%Y-%m-%d %H:%M:%S")
            
            # Commit
            env = os.environ.copy()
            env['GIT_AUTHOR_DATE'] = date_str
            env['GIT_COMMITTER_DATE'] = date_str
            run_command(f'git commit -m "{message}"', env=env)
            print(f"[{date_str}] ✅ Commit {i+1} : {message}")
            
        except subprocess.CalledProcessError as e:
            print(f"⚠️ Erreur ignorée sur {files_cmd} (fichier déjà ajouté ou introuvable)")
            continue

    # --- LE COMMIT FINAL (CATCH-ALL) ---
    # C'est lui qui va ajouter android/, ios/, web/ et tout ce qui manque
    print("🧹 Nettoyage final : ajout de TOUS les fichiers restants (Android, iOS, Web)...")
    run_command("git add .")
    
    final_date = END_DATE.strftime("%Y-%m-%d %H:%M:%S")
    env = os.environ.copy()
    env['GIT_AUTHOR_DATE'] = final_date
    env['GIT_COMMITTER_DATE'] = final_date
    
    try:
        run_command('git commit -m "Configuration finale des plateformes (Android/iOS) et nettoyage"', env=env)
        print(f"[{final_date}] ✅ Commit Final : Tout est propre !")
    except:
        print("Rien à ajouter pour le dernier commit (tout est déjà là).")

    print("\n🚀 Historique terminé ! Prêt pour le push.")

if __name__ == "__main__":
    main()