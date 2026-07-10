import 'package:uuid/uuid.dart';

enum ConditionType {
  blinded,
  charmed,
  deafened,
  frightened,
  grappled,
  incapacitated,
  invisible,
  paralyzed,
  petrified,
  poisoned,
  prone,
  restrained,
  stunned,
  unconscious,
  exhaustion,
  concentration,
  custom,
}

class Condition {
  final String id;
  final ConditionType type;
  final String? name; // برای custom conditions
  final int? duration; // تعداد roundها، null = نامحدود
  final String? source; // منبع (spell name, monster ability)
  final String? note;

  Condition({
    String? id,
    required this.type,
    this.name,
    this.duration,
    this.source,
    this.note,
  }) : id = id ?? const Uuid().v4();

  Condition copyWith({
    String? id,
    ConditionType? type,
    String? name,
    int? duration,
    String? source,
    String? note,
  }) {
    return Condition(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      source: source ?? this.source,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'name': name,
      'duration': duration,
      'source': source,
      'note': note,
    };
  }

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      id: json['id'] as String,
      type: ConditionType.values.byName(json['type'] as String),
      name: json['name'] as String?,
      duration: json['duration'] as int?,
      source: json['source'] as String?,
      note: json['note'] as String?,
    );
  }
}
