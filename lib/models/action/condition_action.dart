import 'base_action.dart';
import '../combatant.dart';
import '../condition/condition.dart';

class ConditionAction extends BaseAction {
  final Condition condition;
  final bool isApply; // true = افزودن، false = حذف

  ConditionAction({
    super.id,
    super.timestamp,
    required super.targetCombatantId,
    required this.condition,
    required this.isApply,
  }) : super(type: ActionType.condition);

  @override
  Combatant execute(Combatant target) {
    if (isApply) {
      return target.copyWith(
        conditions: [...target.conditions, condition],
      );
    } else {
      return target.copyWith(
        conditions:
            target.conditions.where((c) => c.id != condition.id).toList(),
      );
    }
  }

  @override
  Combatant undo(Combatant target) {
    if (isApply) {
      return target.copyWith(
        conditions:
            target.conditions.where((c) => c.id != condition.id).toList(),
      );
    } else {
      return target.copyWith(
        conditions: [...target.conditions, condition],
      );
    }
  }

  @override
  Map<String, dynamic> get data => {
        'condition': condition.toJson(),
        'isApply': isApply,
      };

  factory ConditionAction.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return ConditionAction(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      targetCombatantId: json['targetCombatantId'] as String,
      condition: Condition.fromJson(data['condition'] as Map<String, dynamic>),
      isApply: data['isApply'] as bool,
    );
  }
}
