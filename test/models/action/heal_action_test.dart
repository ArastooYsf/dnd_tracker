import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_tracker/models/combatant.dart';
import 'package:dnd_tracker/models/action/heal_action.dart';

void main() {
  group('HealAction Tests', () {
    late Combatant damagedCombatant;

    setUp(() {
      damagedCombatant = Combatant.create(
        name: 'Fighter',
        hp: 15,
        maxHp: 30,
        armorClass: 18,
        initiative: 10,
        type: CombatantType.player,
      );
    });

    test('execute باید HP رو افزایش بده', () {
      final action = HealAction(
        targetCombatantId: damagedCombatant.id,
        amount: 10,
      );

      final result = action.execute(damagedCombatant);

      expect(result.hp, 25); // 15 + 10
      expect(result.id, damagedCombatant.id);
    });

    test('execute نباید HP رو از maxHp بیشتر کنه', () {
      final action = HealAction(
        targetCombatantId: damagedCombatant.id,
        amount: 20,
      );

      final result = action.execute(damagedCombatant);

      expect(result.hp, 30); // maxHp
    });

    test('execute نباید temporaryHp رو عوض کنه', () {
      final combatantWithTempHp = damagedCombatant.copyWith(temporaryHp: 5);

      final action = HealAction(
        targetCombatantId: combatantWithTempHp.id,
        amount: 8,
      );

      final result = action.execute(combatantWithTempHp);

      expect(result.hp, 23); // 15 + 8
      expect(result.temporaryHp, 5); // دست‌نخورده
    });

    test('undo باید HP رو برگردونه', () {
      final action = HealAction(
        targetCombatantId: damagedCombatant.id,
        amount: 10,
      );

      final healed = action.execute(damagedCombatant);
      expect(healed.hp, 25);

      final restored = action.undo(healed);
      expect(restored.hp, 15); // برگشت به حالت اول
    });

    test('heal روی combatant با full HP اثری نداره', () {
      final fullHpCombatant = damagedCombatant.copyWith(hp: 30);

      final action = HealAction(
        targetCombatantId: fullHpCombatant.id,
        amount: 5,
      );

      final result = action.execute(fullHpCombatant);

      expect(result.hp, 30); // بدون تغییر
    });

    test('toJson و fromJson باید صحیح کار کنن', () {
      final action = HealAction(
        targetCombatantId: damagedCombatant.id,
        amount: 12,
        note: 'Cure Wounds (2nd level)',
      );

      final json = action.toJson();
      final deserialized = HealAction.fromJson(json);

      expect(deserialized.id, action.id);
      expect(deserialized.amount, 12);
      expect(deserialized.note, 'Cure Wounds (2nd level)');
      expect(deserialized.targetCombatantId, damagedCombatant.id);
    });
  });
}
