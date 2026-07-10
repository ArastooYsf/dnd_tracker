import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_tracker/models/combatant.dart';
import 'package:dnd_tracker/models/custom_field/custom_field.dart';

void main() {
  group('Combatant', () {
    test('Combatant.create generates a unique id automatically', () {
      final c1 = Combatant.create(
        name: 'Goblin',
        hp: 7,
        maxHp: 7,
        initiative: 12,
        armorClass: 15,
        type: CombatantType.monster,
      );

      final c2 = Combatant.create(
        name: 'Goblin',
        hp: 7,
        maxHp: 7,
        initiative: 12,
        armorClass: 15,
        type: CombatantType.monster,
      );

      // هر Combatant باید id یکتای خودش رو داشته باشه
      expect(c1.id, isNotEmpty);
      expect(c2.id, isNotEmpty);
      expect(c1.id == c2.id, false);
    });

    test('copyWith updates hp without mutating the original', () {
      final original = Combatant.create(
        name: 'Fighter',
        hp: 20,
        maxHp: 20,
        initiative: 15,
        armorClass: 18,
        type: CombatantType.player,
      );

      final damaged = original.copyWith(hp: 12);

      expect(damaged.hp, 12);
      // نسخه‌ی اصلی نباید تغییر کرده باشه
      expect(original.hp, 20);
      // بقیه فیلدها باید دست‌نخورده کپی بشن
      expect(damaged.name, original.name);
      expect(damaged.id, original.id);
    });

    test('toJson / fromJson round trip preserves all fields including customFields', () {
      final combatant = Combatant.create(
        name: 'Ancient Red Dragon',
        hp: 546,
        maxHp: 546,
        temporaryHp: 10,
        initiative: 8,
        armorClass: 22,
        type: CombatantType.monster,
        notes: 'Boss fight - be careful',
        customFields: const [
          CustomField(
            key: 'legendary_resistance',
            label: 'Legendary Resistance',
            type: CustomFieldType.number,
            value: 3,
          ),
        ],
      );

      final json = combatant.toJson();
      final restored = Combatant.fromJson(json);

      expect(restored.id, combatant.id);
      expect(restored.name, combatant.name);
      expect(restored.hp, combatant.hp);
      expect(restored.maxHp, combatant.maxHp);
      expect(restored.temporaryHp, combatant.temporaryHp);
      expect(restored.initiative, combatant.initiative);
      expect(restored.armorClass, combatant.armorClass);
      expect(restored.type, combatant.type);
      expect(restored.notes, combatant.notes);
      expect(restored.customFields.length, 1);
      expect(restored.customFields.first.key, 'legendary_resistance');
      expect(restored.customFields.first.value, 3);
    });
  });
}
