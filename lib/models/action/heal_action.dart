import '../combatant.dart';
import 'base_action.dart';

class HealAction extends BaseAction {
  final int amount;
  final String? note; // اختیاری: منبع heal (spell, potion, etc.)

  HealAction({
    super.id,
    super.timestamp,
    required super.targetCombatantId,
    required this.amount,
    this.note,
  }) : super(type: ActionType.heal);

  @override
  Combatant execute(Combatant target) {
    // Healing فقط hp رو افزایش می‌ده، تا سقف maxHp
    final newHp = (target.hp + amount).clamp(0, target.maxHp);

    return target.copyWith(hp: newHp);
  }

  @override
  Combatant undo(Combatant target) {
    // برگردوندن hp به حالت قبل از heal
    final restoredHp = (target.hp - amount).clamp(0, target.maxHp);
    return target.copyWith(hp: restoredHp);
  }

  @override
  Map<String, dynamic> get data => {
        'amount': amount,
        if (note != null) 'note': note,
      };

  factory HealAction.fromJson(Map<String, dynamic> json) {
    return HealAction(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      targetCombatantId: json['targetCombatantId'] as String,
      amount: json['data']['amount'] as int,
      note: json['data']['note'] as String?,
    );
  }
}
