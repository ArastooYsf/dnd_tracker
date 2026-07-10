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

  Condition copyWith({...}) {...}
  Map<String, dynamic> toJson() {...}
  factory Condition.fromJson(Map<String, dynamic> json) {...}
}
