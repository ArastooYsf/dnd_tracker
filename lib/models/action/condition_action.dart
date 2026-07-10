class ConditionAction extends BaseAction {
  final condition condition;
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
        conditions: target.conditions
            .where((c) => c.id != condition.id)
            .toList(),
      );
    }
  }

  @override
  Combatant undo(Combatant target) {
    // برعکس execute
    if (isApply) {
      return target.copyWith(
        conditions: target.conditions
            .where((c) => c.id != condition.id)
            .toList(),
      );
    } else {
      return target.copyWith(
        conditions: [...target.conditions, condition],
      );
    }
  }
  
  // ... data, fromJson
}
