import '../combatant.dart';
import 'base_action.dart';

class InitiativeAction extends BaseAction {
  final int newInitiative;
  final int previousInitiative;
  final String? note; // اختیاری: دلیل تغییر (مثلاً اثر یک اسپل)

  InitiativeAction({
    super.id,
    super.timestamp,
    required super.targetCombatantId,
    required this.newInitiative,
    required this.previousInitiative,
    this.note,
  }) : super(type: ActionType.initiative);

  @override
  Combatant execute(Combatant target) {
    return target.copyWith(initiative: newInitiative);
  }

  @override
  Combatant undo(Combatant target) {
    return target.copyWith(initiative: previousInitiative);
  }

  @override
  Map<String, dynamic> get data => {
        'newInitiative': newInitiative,
        'previousInitiative': previousInitiative,
        if (note != null) 'note': note,
      };

  factory InitiativeAction.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return InitiativeAction(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      targetCombatantId: json['targetCombatantId'] as String,
      newInitiative: data['newInitiative'] as int,
      previousInitiative: data['previousInitiative'] as int,
      note: data['note'] as String?,
    );
  }
}
