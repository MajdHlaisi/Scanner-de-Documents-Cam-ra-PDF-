#📄 Scanner de Documents (Caméra → PDF) – MVP

A new Flutter project.

## Présentation
Cette application mobile & web a été développée dans le cadre du test technique (Candidat 6).
Elle permet de :

Scanner des documents via la caméra (mobile) ou la galerie (web)

Réorganiser et supprimer des pages avant export

Générer un fichier PDF à partir des images sélectionnées

Protéger l’accès à l’application via une clé d’activation obligatoire
## 🛠️ Fonctionnalités principales
✅ Activation par clé (obligatoire, stockée localement avec SharedPreferences)
✅ Ajout d’images :

Mobile → Caméra
Web → Galerie

✅ Miniatures des images importées
✅ Suppression d’images
✅ Réorganisation des pages (drag & drop)
✅ Génération PDF :

Mobile → Sauvegarde locale (dossier temporaire)
Web → Téléchargement automatique du fichier
## 📂 Structure du projet
lib/
 ├─ main.dart                # Point d’entrée
 ├─ pages/
 │   ├─ activation_page.dart # Page d’activation
 │   └─ scanner_page.dart    # Page principale (scanner + PDF)
 ├─ services/
 │   └─ activation_service.dart # Service de gestion d’activation
 
## ⚙️ Installation 
1. Cloner le dépôt
git clone https://github.com/MajdHlaisi/scanner_mvp.git
cd scanner_mvp

2. Installer les dépendances
flutter pub get

3. Lancer en debug

Mobile (Android/iOS) :
flutter run
Web :
flutter run -d chrome

4. Générer un APK (Android)
flutter build apk --release
## 🔑 Activation
Au premier lancement, l’application demande une clé d’activation.
Saisir n’importe quelle valeur pour activer (stockée en local).
Une fois activée, l’utilisateur accède à la page principale.

## 📸 Utilisation
Lancer l’application → saisir la clé d’activation.

Ajouter une ou plusieurs photos :
Mobile → prise via caméra
Web → import via galerie
Réorganiser les pages si nécessaire.

Générer le PDF :
Mobile → fichier sauvegardé en local.
Web → fichier téléchargé automatiquement.

## 🔒 Sécurité basique

Vérification par clé d’activation obligatoire au premier lancement.
Persistance de l’état activé via SharedPreferences.

## 🧑‍💻 Technologies utilisées

Flutter 3.x
Dart
image_picker (images caméra/galerie)
pdf (génération de PDF)
path_provider (gestion fichiers mobile)
universal_html (téléchargement web)
shared_preferences (système d’activation)
