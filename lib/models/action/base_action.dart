import 'package:uuid/uuid.dart';
import '../combatant.dart';

/// نوع اکشن‌ها برای شناسایی و serialize/deserialize
enum ActionType {
  damage,
  heal,
  condition,
  initiative,
}

/// کلاس پایه برای تمام اکشن‌ها (Command Pattern)
abstract class BaseAction {
  final String id;
  final DateTime timestamp;
  final ActionType type;
  final String targetCombatantId;

  BaseAction({
    String? id,
    DateTime? timestamp,
    required this.type,
    required this.targetCombatantId,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  /// اعمال اکشن روی Combatant و برگشت نسخه‌ی جدید
  Combatant execute(Combatant target);

  /// خنثی‌سازی اکشن و برگشت نسخه‌ی قبلی
  Combatant undo(Combatant target);

  /// برای ذخیره‌سازی JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'targetCombatantId': targetCombatantId,
      'data': data,
    };
  }

  /// داده‌های اختصاصی هر اکشن (override در فرزندان)
  Map<String, dynamic> get data;
}
