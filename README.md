# DnD Tracker

A Flutter application for tracking initiative, HP, and combat state in
Dungeons & Dragons (and similar tabletop RPG) encounters. Built with a
domain-driven architecture using immutable models, a command-style action
system (with undo support), and Riverpod for state management.

> ⚠️ **Status: early development.** Core domain models, actions, and
> state management are implemented and tested; the UI is currently a
> placeholder screen.

## Features

### Implemented

- **Combatant model** — tracks name, current/max/temporary HP, initiative,
  armor class, combatant type (`player`, `monster`, `npc`, `summon`,
  `hazard`, `lairAction`, `custom`), active-turn flag, DM notes, and
  extensible custom fields. Fully immutable with `copyWith` and JSON
  (de)serialization.
- **Custom fields** — arbitrary per-combatant metadata
  (`number`, `text`, `boolean`, `longText`) for homebrew stats/tags.
- **Action system** — a command-pattern abstraction (`BaseAction`) where
  every action has an `execute()`, `undo()`, and JSON representation.
  - `DamageAction` — applies damage, drains temporary HP first, clamps
    HP at zero, fully undoable.
  - `HealAction` — restores HP up to max HP, preserves temporary HP,
    fully undoable.
  - `ConditionAction` / `InitiativeAction` — reserved action types
    (defined in the `ActionType` enum) — **not implemented yet**.
- **In-memory repository** — CRUD operations for combatants
  (`CombatantRepository`).
- **Riverpod state management** — `combatantListProvider` exposes a
  reactive combatant list backed by the repository.
- **Unit tests** — coverage for combatants, custom fields, damage
  actions, and heal actions.

### Planned / Not yet implemented

- Functional initiative tracker & encounter management UI
- Condition tracking (`ConditionAction`) and status effects
- Initiative rolling/reordering (`InitiativeAction`)
- Persistent storage via `sqflite` (currently in-memory only)
- Campaign, encounter, and monster-library screens
- Full CRUD workflows in the UI

## Project structure
lib/

├── models/

│ ├── action/ # BaseAction, DamageAction, HealAction, ActionFactory

│ ├── combatant/ # Combatant model

│ ├── condition/ # (reserved) condition tracking

│ └── custom_field/ # CustomField model

├── providers/ # Riverpod providers

├── repositories/ # Data access (in-memory, sqflite planned)

├── screens/

│ ├── campaign/

│ ├── encounter/

│ ├── home/

│ └── monster_library/

├── services/

├── utils/

└── widgets/

test/

└── models/

└── action/
Requirements

    Flutter SDK compatible with Dart ^3.12.2
    A configured platform toolchain for whichever target you build for(Android Studio / Xcode / desktop toolchain)

Getting started

bash
1. Install dependencies

flutter pub get
2. Run the app (pick a connected device/emulator, or a desktop target)

flutter run
Running tests

bash

flutter test
Code generation

This project uses json_serializable for JSON (de)serialization.

Whenever a model with @JsonSerializable annotations changes, regenerate

the *.g.dart files:

bash

dart run build_runner build --delete-conflicting-outputs
Tech stack
Purpose 	Package
State management 	flutter_riverpod
Local database 	sqflite (planned)
File paths 	path_provider, path
Unique IDs 	uuid
JSON serialization 	json_annotation / json_serializable
Linting 	flutter_lints
Contributing

This is an actively evolving personal/learning project. Issues and PRs

are welcome, but expect the architecture (especially around conditions

and initiative handling) to change as those features are built out.
License

Add a license of your choice (e.g. MIT) — none is currently specified.