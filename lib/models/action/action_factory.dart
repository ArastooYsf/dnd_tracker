import 'base_action.dart';
import 'damage_action.dart';
import 'heal_action.dart';
import 'condition_action.dart';

class ActionFactory {
  static BaseAction fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String;
    final type = ActionType.values.firstWhere((e) => e.name == typeStr);

    switch (type) {
      case ActionType.damage:
        return DamageAction.fromJson(json);
      case ActionType.heal:
        return HealAction.fromJson(json);
      case ActionType.condition:
        return ConditionAction.fromJson(json);
      case ActionType.initiative:
        throw UnimplementedError('InitiativeAction قابل deserialize نیست هنوز');
    }
  }
}
