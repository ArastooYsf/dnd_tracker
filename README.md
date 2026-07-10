# 🎲 D&D Tracker

A cross-platform **Dungeons & Dragons** campaign and encounter management app built with Flutter. Track campaigns, manage encounters, browse monsters, and customize your game — all stored locally on your device.

---

## ✨ Features

- **Campaign Management** — Create and manage multiple D&D campaigns
- **Encounter Tracker** — Run combat encounters with initiative, HP, and conditions
- **Monster Library** — Browse and reference monsters during sessions
- **Custom Fields** — Add custom attributes to characters and creatures
- **Condition Tracking** — Track status conditions (poisoned, stunned, etc.)
- **Action Management** — Manage creature and character actions per turn
- **Offline-first** — All data stored locally via SQLite, no internet required

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | [Flutter](https://flutter.dev) (Dart) |
| State Management | [Riverpod](https://riverpod.dev) |
| Database | [sqflite](https://pub.dev/packages/sqflite) (SQLite) |
| Serialization | `json_serializable` + `json_annotation` |
| ID Generation | `uuid` |

---

## 📁 Project Structure

```
lib/
├── models/
│   ├── action/          # Action models (creature/character actions)
│   ├── condition/       # Status condition models
│   └── custom_field/    # Custom field models
├── providers/           # Riverpod providers
├── repositories/        # Data access layer (SQLite)
├── screens/
│   ├── home/            # Home screen
│   ├── campaign/        # Campaign management screens
│   ├── encounter/       # Encounter tracker screens
│   └── monster_library/ # Monster browsing screens
├── services/            # Business logic services
├── utils/               # Utility functions and helpers
└── widgets/             # Reusable UI components
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.12.2`
- Dart SDK (included with Flutter)

### Installation

```bash
# Clone the repository
git clone https://github.com/ArastooYsf/dnd_tracker.git
cd dnd_tracker

# Install dependencies
flutter pub get

# Run code generation (for JSON serialization)
dart run build_runner build

# Run the app
flutter run
```

### Supported Platforms

- Android
- Linux
- Windows

---

## 🧪 Running Tests

```bash
flutter test
```

Unit tests are located under `test/models/`.

---

## 📦 Dependencies

```yaml
flutter_riverpod: ^2.6.1   # State management
sqflite: ^2.4.1            # SQLite database
path_provider: ^2.1.5      # File system paths
uuid: ^4.5.1               # Unique ID generation
json_annotation: ^4.9.0    # JSON serialization annotations
```

---

## 🤝 Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-feature`)
5. Open a Pull Request

---

## 📄 License

This project is open source. See the repository for details.