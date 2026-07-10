import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/combatant.dart';
import '../models/action/damage_action.dart';
import '../models/action/heal_action.dart';
import '../providers/combatant_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final hpController = TextEditingController(text: '10');
    final initiativeController = TextEditingController(text: '10');
    final acController = TextEditingController(text: '10');
    CombatantType selectedType = CombatantType.player;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('افزودن Combatant'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'نام'),
                    ),
                    TextField(
                      controller: hpController,
                      decoration: const InputDecoration(labelText: 'HP'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: initiativeController,
                      decoration: const InputDecoration(labelText: 'Initiative'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: acController,
                      decoration: const InputDecoration(labelText: 'Armor Class'),
                      keyboardType: TextInputType.number,
                    ),
                    DropdownButton<CombatantType>(
                      value: selectedType,
                      items: CombatantType.values
                          .map((t) => DropdownMenuItem(
                                value: t,
                                child: Text(t.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => selectedType = value);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('انصراف'),
                ),
                FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final hp = int.tryParse(hpController.text) ?? 10;
                    final initiative = int.tryParse(initiativeController.text) ?? 10;
                    final ac = int.tryParse(acController.text) ?? 10;
                    if (name.isEmpty) return;

                    final combatant = Combatant.create(
                      name: name,
                      hp: hp,
                      maxHp: hp,
                      initiative: initiative,
                      armorClass: ac,
                      type: selectedType,
                    );
                    ref.read(combatantListProvider.notifier).add(combatant);
                    Navigator.pop(context);
                  },
                  child: const Text('افزودن'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _applyDamage(WidgetRef ref, Combatant combatant, int amount) {
    final action = DamageAction(targetCombatantId: combatant.id, amount: amount);
    ref.read(combatantListProvider.notifier).update(action.execute(combatant));
  }

  void _applyHeal(WidgetRef ref, Combatant combatant, int amount) {
    final action = HealAction(targetCombatantId: combatant.id, amount: amount);
    ref.read(combatantListProvider.notifier).update(action.execute(combatant));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final combatants = ref.watch(combatantListProvider);
    final sorted = [...combatants]
      ..sort((a, b) => b.initiative.compareTo(a.initiative));

    return Scaffold(
      appBar: AppBar(title: const Text('DnD Tracker')),
      body: sorted.isEmpty
          ? const Center(child: Text('هنوز هیچ combatant اضافه نشده'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: sorted.length,
              itemBuilder: (context, index) {
                final c = sorted[index];
                final hpRatio = c.maxHp == 0 ? 0.0 : c.hp / c.maxHp;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(child: Text('${c.initiative}')),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                c.name,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () =>
                                  ref.read(combatantListProvider.notifier).remove(c.id),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: hpRatio.clamp(0, 1),
                          color: hpRatio > 0.5
                              ? Colors.green
                              : hpRatio > 0.2
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'HP: ${c.hp}/${c.maxHp}'
                          '${c.temporaryHp != null && c.temporaryHp! > 0 ? ' (+${c.temporaryHp})' : ''}'
                          '   AC: ${c.armorClass}',
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _applyDamage(ref, c, 5),
                              icon: const Icon(Icons.flash_on, size: 18),
                              label: const Text('-5'),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: () => _applyHeal(ref, c, 5),
                              icon: const Icon(Icons.favorite, size: 18),
                              label: const Text('+5'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
