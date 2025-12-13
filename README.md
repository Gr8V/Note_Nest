# Note Nest

Note Nest is a clean, lightweight note-taking application built with Flutter. It implements a complete CRUD workflow with local persistence, theming, and cross-platform support across mobile, web, and desktop.

---

## Key Features
- Create, read, update, and delete notes
- Local persistent storage using a lightweight wrapper (see `lib/local_storage.dart`)
- Provider-based state management for simplicity (`lib/notes_provider.dart`)
- Clean UI with theme support (`lib/theme/`)
- Cross-platform builds (mobile, web and desktop)

---

## Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites
- Flutter SDK (2.0 or later recommended). Follow the official guide: https://flutter.dev/docs/get-started/install
- For Android: Android SDK, Android Studio, or a configured device/emulator
- For iOS: Xcode installed and configured (macOS only)
- For Desktop (optional): Visual Studio (Windows), appropriate CMake toolchain for Linux/macOS

### Clone the Repository
```bash
git clone https://github.com/Gr8V/Note_Nest.git
cd Note_Nest
```

### Install Dependencies
```bash
flutter pub get
```

### Run the App
Run on an attached device/emulator:
```bash
flutter run
```

Run using a specific device (e.g., Android, Windows, or web):
```bash
flutter run -d chrome   # Run on Web
flutter run -d windows  # Run on Windows desktop
flutter run -d emulator-5554  # Run on an Android emulator via device id
```

### Build Release
Android (APK):
```bash
flutter build apk --release
```
iOS (Xcode project):
```bash
flutter build ios --release
```
Web (production build):
```bash
flutter build web
```
Windows (64-bit):
```bash
flutter build windows --release
```

---

## Project Structure
The repository follows a conventional Flutter structure:
- `lib/` — Core app source code
  - `main.dart` — App entry point
  - `notes_model.dart` — Data models used by the app
  - `notes_provider.dart` — Provider-based state management
  - `local_storage.dart` — Local persistence layer
  - `utils.dart` — Helper utilities
  - `pages/` — Screens and UI
  - `theme/` — App theme and colors
- `assets/` — App assets (images, icons)

Refer to the key files:
- [lib/main.dart](lib/main.dart) — app entry
- [lib/notes_model.dart](lib/notes_model.dart) — model definitions
- [lib/notes_provider.dart](lib/notes_provider.dart) — state management
- [lib/local_storage.dart](lib/local_storage.dart) — persistence layer

---

## Local Storage & Data
Notes_App stores data locally so users can maintain their notes without a backend. See `lib/local_storage.dart` for how notes are serialized and deserialized, and how the storage lifecycle is managed.

---

## Screenshots

**Theme used:** Dark Mode (Forest Green)

<p align="center">
  <img src="screenshots/home_page.jpg" width="30%" alt="Home Page – Dark Mode" />
  <img src="screenshots/add_note.jpg" width="30%" alt="Add Note Page – Dark Mode" />
  <img src="screenshots/trash_bin.jpg" width="30%" alt="Trash Page – Dark Mode" />
</p>

**From left to right:** Home page, Add Note page, Trash page.

---


## Issues & Support
If you encounter bugs or have feature requests, open an issue in the repository. Include: device, Flutter version, OS, reproduction steps, and logs if possible.

---

## License
This project is licensed under the terms in the `LICENSE` file in the repository root.

---

## Acknowledgements
- Built with Flutter by Vansh.
- Thanks to the Flutter community for tools and examples.

---
