import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/combatant.dart';
import '../repositories/combatant_repository.dart';

// Repository singleton
final combatantRepositoryProvider = Provider<CombatantRepository>((ref) {
  return CombatantRepository();
});

// State notifier برای لیست combatant ها (برای بازسازی خودکار UI)
final combatantListProvider =
    StateNotifierProvider<CombatantListNotifier, List<Combatant>>((ref) {
  final repository = ref.watch(combatantRepositoryProvider);
  return CombatantListNotifier(repository);
});

class CombatantListNotifier extends StateNotifier<List<Combatant>> {
  final CombatantRepository _repository;

  CombatantListNotifier(this._repository) : super(_repository.getAll());

  void add(Combatant combatant) {
    _repository.add(combatant);
    state = _repository.getAll();
  }

  void update(Combatant combatant) {
    _repository.update(combatant);
    state = _repository.getAll();
  }

  void remove(String id) {
    _repository.remove(id);
    state = _repository.getAll();
  }

  void refresh() {
    state = _repository.getAll();
  }
}
