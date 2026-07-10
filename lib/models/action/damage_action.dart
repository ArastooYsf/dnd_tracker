import '../combatant.dart';
import 'base_action.dart';

class DamageAction extends BaseAction {
  final int amount;
  final String? note; // اختیاری: نوع آسیب یا توضیح

  DamageAction({
    super.id,
    super.timestamp,
    required super.targetCombatantId,
    required this.amount,
    this.note,
  }) : super(type: ActionType.damage);

  @override
  Combatant execute(Combatant target) {
    int remainingDamage = amount;
    int newTemporaryHp = target.temporaryHp ?? 0;

    // اول از temporaryHp کم می‌شه
    if (newTemporaryHp > 0) {
      if (newTemporaryHp >= remainingDamage) {
        newTemporaryHp -= remainingDamage;
        remainingDamage = 0;
      } else {
        remainingDamage -= newTemporaryHp;
        newTemporaryHp = 0;
      }
    }

    final newHp = (target.hp - remainingDamage).clamp(0, target.maxHp);

    return target.copyWith(
      hp: newHp,
      temporaryHp: newTemporaryHp,
    );
  }

  @override
  Combatant undo(Combatant target) {
    // نسخه‌ی ساده‌شده: فقط hp رو برمی‌گردونیم (temporaryHp دست‌نخورده باقی می‌مونه)
    final restoredHp = (target.hp + amount).clamp(0, target.maxHp);
    return target.copyWith(hp: restoredHp);
  }

  @override
  Map<String, dynamic> get data => {
        'amount': amount,
        if (note != null) 'note': note,
      };

  factory DamageAction.fromJson(Map<String, dynamic> json) {
    return DamageAction(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      targetCombatantId: json['targetCombatantId'] as String,
      amount: json['data']['amount'] as int,
      note: json['data']['note'] as String?,
    );
  }
}
