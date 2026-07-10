import 'package:uuid/uuid.dart';
import 'custom_field/custom_field.dart';

enum CombatantType {
  player,
  monster,
  npc,
  summon,
  hazard,
  lairAction,
  custom,
}

class Combatant {
  final String id;
  final String name;
  final int hp;
  final int maxHp;
  final int? temporaryHp;
  final int initiative;
  final int armorClass;
  final CombatantType type;
  final List<CustomField> customFields;
  final bool isActive; // آیا در نوبت فعلی است
  final String? notes; // یادداشت‌های DM (مخصوص DM)

  const Combatant({
    required this.id,
    required this.name,
    required this.hp,
    required this.maxHp,
    this.temporaryHp,
    required this.initiative,
    required this.armorClass,
    required this.type,
    this.customFields = const [],
    this.isActive = false,
    this.notes,
  });

  /// سازنده کمکی برای ساخت یک Combatant جدید با id خودکار
  factory Combatant.create({
    required String name,
    required int hp,
    required int maxHp,
    int? temporaryHp,
    required int initiative,
    required int armorClass,
    required CombatantType type,
    List<CustomField> customFields = const [],
    bool isActive = false,
    String? notes,
  }) {
    return Combatant(
      id: const Uuid().v4(),
      name: name,
      hp: hp,
      maxHp: maxHp,
      temporaryHp: temporaryHp,
      initiative: initiative,
      armorClass: armorClass,
      type: type,
      customFields: customFields,
      isActive: isActive,
      notes: notes,
    );
  }

  Combatant copyWith({
    String? id,
    String? name,
    int? hp,
    int? maxHp,
    int? temporaryHp,
    int? initiative,
    int? armorClass,
    CombatantType? type,
    List<CustomField>? customFields,
    bool? isActive,
    String? notes,
  }) {
    return Combatant(
      id: id ?? this.id,
      name: name ?? this.name,
      hp: hp ?? this.hp,
      maxHp: maxHp ?? this.maxHp,
      temporaryHp: temporaryHp ?? this.temporaryHp,
      initiative: initiative ?? this.initiative,
      armorClass: armorClass ?? this.armorClass,
      type: type ?? this.type,
      customFields: customFields ?? this.customFields,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hp': hp,
      'maxHp': maxHp,
      'temporaryHp': temporaryHp,
      'initiative': initiative,
      'armorClass': armorClass,
      'type': type.name,
      'customFields': customFields.map((f) => f.toJson()).toList(),
      'isActive': isActive,
      'notes': notes,
    };
  }

  factory Combatant.fromJson(Map<String, dynamic> json) {
    return Combatant(
      id: json['id'] as String,
      name: json['name'] as String,
      hp: json['hp'] as int,
      maxHp: json['maxHp'] as int,
      temporaryHp: json['temporaryHp'] as int?,
      initiative: json['initiative'] as int,
      armorClass: json['armorClass'] as int,
      type: CombatantType.values.byName(json['type'] as String),
      customFields: (json['customFields'] as List<dynamic>? ?? [])
          .map((f) => CustomField.fromJson(f as Map<String, dynamic>))
          .toList(),
      isActive: json['isActive'] as bool? ?? false,
      notes: json['notes'] as String?,
    );
  }
}
