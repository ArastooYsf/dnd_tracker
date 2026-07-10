import '../models/combatant.dart';

class CombatantRepository {
  final Map<String, Combatant> _combatants = {};

  List<Combatant> getAll() => _combatants.values.toList();

  Combatant? getById(String id) => _combatants[id];

  void add(Combatant combatant) {
    _combatants[combatant.id] = combatant;
  }

  void update(Combatant combatant) {
    _combatants[combatant.id] = combatant;
  }

  void remove(String id) {
    _combatants.remove(id);
  }

  void clear() {
    _combatants.clear();
  }
}
