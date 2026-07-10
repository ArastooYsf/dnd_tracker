import 'base_action.dart';
import 'damage_action.dart';
import 'heal_action.dart';

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
        throw UnimplementedError('ConditionAction قابل deserialize نیست هنوز');
      case ActionType.initiative:
        throw UnimplementedError('InitiativeAction قابل deserialize نیست هنوز');
    }
  }
}
